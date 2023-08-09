unit Model.Cliente;

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
  TCliente = class(TObject)
  private
    FCodigo: Integer;
    FNome: String;
    FCPF: String;
    FDataNascimento: TDate;
    FStatus: Boolean;

    procedure Alterar();
    procedure Inserir();

    function ValidarCPF(ACPF: String): Boolean;
    procedure SetCPF(ACPF: String);
  public
    property Codigo: Integer read FCodigo;
    property Nome: String read FNome write FNome;
    property CPF: String read FCPF write SetCPF;
    property DataNascimento: TDate read FDataNascimento write FDataNascimento;
    property Status: Boolean read FStatus write FStatus;

    constructor Create(ACodigo : Integer); overload;

    procedure Gravar();
  end;

implementation

{ TProduto }


constructor TCliente.Create(ACodigo : Integer);
var
  TbCliente: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbCliente := Conexao.GerarQuery();
  Conexao.Conectar();

  TbCliente.SQL.Text := 'SELECT * FROM Clientes WHERE Codigo = ' + IntToStr(ACodigo);
  TbCliente.Open();

  Self.FCodigo         := TbCliente.FieldByName('Codigo').AsInteger;
  Self.FNome           := TbCliente.FieldByName('Nome').AsString;
  Self.FCPF            := TbCliente.FieldByName('CPF').AsString;
  Self.FDataNascimento := TbCliente.FieldByName('DataNascimento').AsDateTime;
  Self.Status          := TbCliente.FieldByName('Status').AsBoolean;

  FreeAndNil(TbCliente);
end;

procedure TCliente.Gravar;
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

procedure TCliente.Alterar;
var
  TbCliente: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbCliente := Conexao.GerarQuery();
  Conexao.Conectar();

  TbCliente.SQL.Clear();
  TbCliente.SQL.Add('UPDATE Clientes SET');
  TbCliente.SQL.Add('  Nome = :Nome,');
  TbCliente.SQL.Add('  DataNascimento = :DataNascimento,');
  TbCliente.SQL.Add('  Status = :Status');
  TbCliente.SQL.Add('WHERE Codigo = :Codigo');

  TbCliente.ParamByName('Nome').AsString         := Self.Nome;
  TbCliente.ParamByName('DataNascimento').AsDate := Self.DataNascimento;
  TbCliente.ParamByName('Status').AsBoolean      := Self.Status;
  TbCliente.ParamByName('Codigo').AsInteger      := Self.Codigo;

  TbCliente.ExecSQL();

  FreeAndNil(TbCliente);
end;

procedure TCliente.Inserir;
var
  TbCliente: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbCliente := Conexao.GerarQuery();
  Conexao.Conectar();

  TbCliente.SQL.Clear();
  TbCliente.SQL.Add('SELECT * FROM Clientes WHERE CPF = ' + QuotedStr(Self.CPF));
  TbCliente.Open();

  if (TbCliente.RecordCount > 0) then
  begin
    raise Exception.Create('CPF já cadastrado!');
  end;

  TbCliente.Close();
  TbCliente.SQL.Clear();
  TbCliente.SQL.Add('INSERT INTO Clientes (Nome, DataNascimento, CPF, Status) ');
  TbCliente.SQL.Add('OUTPUT Inserted.Codigo');
  TbCliente.SQL.Add('Values (');
  TbCliente.SQL.Add('  :Nome,');
  TbCliente.SQL.Add('  :DataNascimento,');
  TbCliente.SQL.Add('  :CPF,');
  TbCliente.SQL.Add('  :Status)');

  TbCliente.ParamByName('Nome').AsString         := Self.Nome;
  TbCliente.ParamByName('DataNascimento').AsDate := Self.DataNascimento;
  TbCliente.ParamByName('CPF').AsString          := Self.CPF;
  TbCliente.ParamByName('Status').AsBoolean      := True;

  TbCliente.Open();

  Self.FCodigo := TbCliente.FieldByName('Codigo').AsInteger;
  Self.FStatus := True;

  FreeAndNil(TbCliente);
end;

function TCliente.ValidarCPF(ACPF: String): Boolean;
var
  Digito10, Digito11: String;
  Soma: Integer;
begin
  if ((ACPF = '00000000000') or (ACPF = '11111111111') or
      (ACPF = '22222222222') or (ACPF = '33333333333') or
      (ACPF = '44444444444') or (ACPF = '55555555555') or
      (ACPF = '66666666666') or (ACPF = '77777777777') or
      (ACPF = '88888888888') or (ACPF = '99999999999') or
      (Length(ACPF) <> 11)) then
  begin
    Result := False;
    Exit;
  end;

  try
    Soma := 0;
    for var I := 1 to 9 do
    begin
      Soma := Soma + (StrToInt(ACPF[I]) * (11-I));
    end;

    Digito10 := IntToStr(11 - (Soma mod 11));
    Digito10 := IfThen(((Digito10 = '10') or (Digito10 = '11')), '0', Digito10);

    Soma := 0;
    for var I := 1 to 10 do
    begin
      Soma := Soma + (StrToInt(ACPF[I]) * (12-I));
    end;

    Digito11 := IntToStr(11 - (Soma mod 11));
    Digito11 := IfThen(((Digito11 = '10') or (Digito11 = '11')), '0', Digito11);

    Result := ((Digito10 = ACPF[10]) and (Digito11 = ACPF[11]));
  except
    Result := False;
  end;
end;

procedure TCliente.SetCPF(ACPF: String);
begin
  if ((Self.FCPF <> '') or (not Self.ValidarCPF(ACPF))) then
  begin
    Exit;
  end;

 Self.FCPF := ACPF;
end;

end.

