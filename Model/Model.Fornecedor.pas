unit Model.Fornecedor;

interface

uses
  Controller.Connection,
  FireDAC.Comp.Client,
  SysUtils,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  StrUtils,
  FireDAC.Stan.Async;

type
  TFornecedor = class(TObject)
  private
    FCodigo: Integer;
    FNomeFantasia: String;
    FCNPJ: String;
    FRazaoSocial: String;
    FStatus: Boolean;

    procedure Alterar();
    procedure Inserir();

    function ValidarCNPJ(ACNPJ: String): Boolean;
    procedure SetCNPJ(ACNPJ: String);
  public
    property Codigo: Integer read FCodigo;
    property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
    property CNPJ: String read FCNPJ write SetCNPJ;
    property RazaoSocial: String read FRazaoSocial write FRazaoSocial;
    property Status: Boolean read FStatus write FStatus;

    constructor Create(ACodigo : Integer); overload;

    procedure Gravar();
  end;

implementation

{ TProduto }


constructor TFornecedor.Create(ACodigo : Integer);
var
  TbFornecedor: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbFornecedor := Conexao.GerarQuery();
  Conexao.Conectar();

  TbFornecedor.SQL.Text := 'SELECT * FROM Fornecedores WHERE Codigo = ' + IntToStr(ACodigo);
  TbFornecedor.Open();

  Self.FCodigo       := TbFornecedor.FieldByName('Codigo').AsInteger;
  Self.FNomeFantasia := TbFornecedor.FieldByName('NomeFantasia').AsString;
  Self.FCNPJ         := TbFornecedor.FieldByName('CNPJ').AsString;
  Self.FRazaoSocial  := TbFornecedor.FieldByName('RazaoSocial').AsString;
  Self.Status        := TbFornecedor.FieldByName('Status').AsBoolean;

  FreeAndNil(TbFornecedor);
end;

procedure TFornecedor.Gravar;
begin
  if Self.Codigo > 0 then
  begin
    Self.Alterar();
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TFornecedor.Alterar;
var
  TbFornecedor: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbFornecedor := Conexao.GerarQuery();
  Conexao.Conectar();

  TbFornecedor.SQL.Clear();
  TbFornecedor.SQL.Add('UPDATE Fornecedores SET');
  TbFornecedor.SQL.Add('  NomeFantasia = :NomeFantasia,');
  TbFornecedor.SQL.Add('  RazaoSocial = :RazaoSocial,');
  TbFornecedor.SQL.Add('  Status = :Status');
  TbFornecedor.SQL.Add('WHERE Codigo = :Codigo;');

  TbFornecedor.ParamByName('NomeFantasia').AsString := Self.NomeFantasia;
  TbFornecedor.ParamByName('RazaoSocial').AsString  := Self.RazaoSocial;
  TbFornecedor.ParamByName('Status').AsBoolean      := Self.Status;
  TbFornecedor.ParamByName('Codigo').AsInteger      := Self.Codigo;

  TbFornecedor.ExecSQL();

  FreeAndNil(TbFornecedor);
end;

procedure TFornecedor.Inserir;
var
  TbFornecedor: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbFornecedor := Conexao.GerarQuery();
  Conexao.Conectar();

  TbFornecedor.SQL.Clear();
  TbFornecedor.SQL.Add('SELECT * FROM Fornecedores WHERE CNPJ = ' + QuotedStr(Self.CNPJ));
  TbFornecedor.Open();

  if (TbFornecedor.RecordCount > 0) then
  begin
    raise Exception.Create('CNPJ já cadastrado!');
  end;

  TbFornecedor.Close();
  TbFornecedor.SQL.Clear();
  TbFornecedor.SQL.Add('INSERT INTO Fornecedores (NomeFantasia, RazaoSocial, CNPJ, Status) ');
  TbFornecedor.SQL.Add('OUTPUT Inserted.Codigo');
  TbFornecedor.SQL.Add('Values (');
  TbFornecedor.SQL.Add('  :NomeFantasia,');
  TbFornecedor.SQL.Add('  :RazaoSocial,');
  TbFornecedor.SQL.Add('  :CNPJ,');
  TbFornecedor.SQL.Add('  :Status)');

  TbFornecedor.ParamByName('NomeFantasia').AsString := Self.NomeFantasia;
  TbFornecedor.ParamByName('RazaoSocial').AsString  := Self.RazaoSocial;
  TbFornecedor.ParamByName('CNPJ').AsString         := Self.CNPJ;
  TbFornecedor.ParamByName('Status').AsBoolean      := True;

  TbFornecedor.Open();

  Self.FCodigo := TbFornecedor.FieldByName('Codigo').AsInteger;
  Self.FStatus := True;

  FreeAndNil(TbFornecedor);
end;

function TFornecedor.ValidarCNPJ(ACNPJ: String): Boolean;
const
  VALORES: TArray<Integer> = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
var
  Digito13, Digito14: String;
  Soma: Integer;
begin
  Soma := 0;
  for var I := 1 to 12 do
  begin
    Soma := Soma + (StrToInt(ACNPJ[I]) * (VALORES[I]));
  end;

  Digito13 := IntToStr(11 - (Soma mod 11));
  Digito13 := IfThen(((Digito13 = '10') or (Digito13 = '11')), '0', Digito13);

  Soma := 0;
  for var I := 1 to 13 do
  begin
    Soma := Soma + (StrToInt(ACNPJ[I]) * (VALORES[I - 1]));
  end;

  Digito14 := IntToStr(11 - (Soma mod 11));
  Digito14 := IfThen(((Digito14 = '10') or (Digito14 = '11')), '0', Digito14);

  Result := ((Digito13 = ACNPJ[13]) and (Digito14 = ACNPJ[14]));
end;

procedure TFornecedor.SetCNPJ(ACNPJ: String);
begin
  if ((Self.FCNPJ <> '') or (not Self.ValidarCNPJ(ACNPJ))) then
  begin
    Exit;
  end;

 Self.FCNPJ := ACNPJ;
end;

end.

