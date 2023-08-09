unit Model.Produto;

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
  Model.Fornecedor;

type
  TProduto = class(TObject)
  private
    FCodigo: Integer;
    FDescricao: String;
    FFornecedor: TFornecedor;
    FPrecoUnitario: Currency;
    FStatus: Boolean;

    procedure Alterar();
    procedure Inserir();
  public
    property Codigo: Integer read FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Fornecedor: TFornecedor read FFornecedor write FFornecedor;
    property PrecoUnitario: Currency read FPrecoUnitario write FPrecoUnitario;
    property Status: Boolean read FStatus write FStatus;

    constructor Create(ACodigo : Integer); overload;
    constructor Create(); overload;

    procedure Gravar();
  end;

implementation

{ TProduto }


constructor TProduto.Create();
begin
  Self.FFornecedor := TFornecedor.Create();
end;

constructor TProduto.Create(ACodigo : Integer);
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  inherited Create();

  Conexao := TConexao.ObterInstancia();
  TbProduto := Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.SQL.Text := 'SELECT * FROM Produtos WHERE Codigo = ' + IntToStr(ACodigo);
  TbProduto.Open();

  Self.FCodigo        := TbProduto.FieldByName('Codigo').AsInteger;
  Self.FDescricao     := TbProduto.FieldByName('Descricao').AsString;
  Self.FFornecedor    := TFornecedor.Create(TbProduto.FieldByName('CodFornecedor').AsInteger);
  Self.FPrecoUnitario := TbProduto.FieldByName('PrecoUnitario').AsCurrency;
  Self.Status         := TbProduto.FieldByName('Status').AsBoolean;

  FreeAndNil(TbProduto);
end;

procedure TProduto.Gravar;
begin
  if not (Self.PrecoUnitario > 0) then
  begin
    raise Exception.Create('Preço do produto deve ser maior que 0!');
  end;

  if (not (Self.Fornecedor.Codigo > 0)) or (not Self.Fornecedor.Status) then
  begin
    raise Exception.Create('Fornecedor invalido!');
  end;

  if Self.Codigo > 0 then
  begin
    Self.Alterar();
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TProduto.Alterar;
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.SQL.Clear();
  TbProduto.SQL.Add('UPDATE Produtos SET');
  TbProduto.SQL.Add('  Descricao = :Descricao,');
  TbProduto.SQL.Add('  PrecoUnitario = :PrecoUnitario,');
  TbProduto.SQL.Add('  CodFornecedor = :CodFornecedor,');
  TbProduto.SQL.Add('  Status = :Status');
  TbProduto.SQL.Add('WHERE Codigo = :Codigo');

  TbProduto.ParamByName('Descricao').AsString       := Self.Descricao;
  TbProduto.ParamByName('PrecoUnitario').AsCurrency := Self.PrecoUnitario;
  TbProduto.ParamByName('CodFornecedor').AsInteger  := Self.Fornecedor.Codigo;
  TbProduto.ParamByName('Status').AsBoolean         := Self.Status;
  TbProduto.ParamByName('Codigo').AsInteger         := Self.Codigo;

  TbProduto.ExecSQL();

  FreeAndNil(TbProduto);
end;

procedure TProduto.Inserir;
var
  TbProduto: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbProduto :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbProduto.SQL.Clear();
  TbProduto.SQL.Add('INSERT INTO Produtos (Descricao, PrecoUnitario, CodFornecedor, Status)');
  TbProduto.SQL.Add('OUTPUT Inserted.Codigo');
  TbProduto.SQL.Add(' Values (');
  TbProduto.SQL.Add('  :Descricao,');
  TbProduto.SQL.Add('  :PrecoUnitario,');
  TbProduto.SQL.Add('  :CodFornecedor,');
  TbProduto.SQL.Add('  :Status)');

  TbProduto.ParamByName('Descricao').AsString       := Self.Descricao;
  TbProduto.ParamByName('PrecoUnitario').AsCurrency := Self.PrecoUnitario;
  TbProduto.ParamByName('CodFornecedor').AsInteger  := Self.Fornecedor.Codigo;
  TbProduto.ParamByName('Status').AsBoolean         := Self.Status;

  TbProduto.Open();

  Self.FCodigo := TbProduto.FieldByName('Codigo').AsInteger;
  Self.FStatus := True;

  FreeAndNil(TbProduto);
end;


end.

