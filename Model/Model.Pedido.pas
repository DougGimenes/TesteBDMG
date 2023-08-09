unit Model.Pedido;

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
  Model.Cliente,
  System.Generics.Collections,
  Model.Produto;

type
  TItem = class(TObject)
  private
    FCodigo: Integer;
    FProduto: TProduto;
    FQuantidade: Integer;
    FCodVenda: Integer;

    procedure Alterar();
    procedure Inserir();
    function  CalcularTotal(): Currency;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Produto: TProduto read FProduto write FProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorTotal: Currency read CalcularTotal;
    property CodVenda: Integer read FCodVenda write FCodVenda;

    constructor Create(ACodigo : Integer); overload;
    constructor Create(); overload;

    procedure RemoverItem();
    procedure Gravar();
  end;

  TPedido = class(TObject)
  private
    FCodigo: Integer;
    FCliente: TCliente;
    FDataHoraVenda: TDateTime;
    FProdutos: TObjectList<TItem>;
    FStatus: Boolean;

    procedure Alterar();
    procedure Inserir();
    function  CalcularTotal(): Currency;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Cliente: TCliente read FCliente write FCliente;
    property DataHoraVenda: TDateTime read FDataHoraVenda write FDataHoraVenda;
    property Produtos: TObjectList<TItem> read FProdutos write FProdutos;
    property ValorTotal: Currency read CalcularTotal;
    property Status: Boolean read FStatus write FStatus;

    constructor Create(ACodigo : Integer); overload;
    constructor Create(); overload;

    procedure Gravar();
  end;

implementation

{ TPedido }

procedure TPedido.Alterar;
var
  TbPedido: TFDQuery;
  TbItens : TFDQuery;
  Conexao : TConexao;
begin
  Conexao  := TConexao.ObterInstancia();
  TbPedido := Conexao.GerarQuery();
  TbItens  := Conexao.GerarQuery();
  Conexao.Conectar();

  TbPedido.SQL.Clear();
  TbPedido.SQL.Add('UPDATE Pedidos SET');
  TbPedido.SQL.Add('  CodCliente = :CodCliente,');
  TbPedido.SQL.Add('  ValorTotal = :ValorTotal,');
  TbPedido.SQL.Add('  DataHoraVenda = :DataHoraVenda,');
  TbPedido.SQL.Add('  Status = :Status');
  TbPedido.SQL.Add('WHERE Codigo = :Codigo');

  TbPedido.ParamByName('CodCliente').AsInteger     := Self.Cliente.Codigo;
  TbPedido.ParamByName('ValorTotal').AsCurrency    := Self.ValorTotal;
  TbPedido.ParamByName('DataHoraVenda').AsDateTime := Self.DataHoraVenda;
  TbPedido.ParamByName('Status').AsBoolean         := Self.Status;
  TbPedido.ParamByName('Codigo').AsInteger         := Self.Codigo;

  TbPedido.ExecSQL();

  for var Item in Self.Produtos do
  begin
    Item.CodVenda := Self.FCodigo;
    Item.Gravar();
  end;

  TbItens.SQL.Text := 'SELECT * FROM Itens WHERE CodVenda = ' + IntToStr(Self.FCodigo);
  TbItens.Open();
  TbItens.First();
  for var I := 0 to TbItens.RecordCount - 1 do
  begin
    var ItemExiste := False;
     
    for var Item in Self.FProdutos do
    begin
      if Item.Codigo = TbItens.FieldByName('Codigo').AsInteger then
      begin
        ItemExiste := True;
        break;
      end;
    end;

    if not ItemExiste then
    begin
      var ItemRemovido := TItem.Create(TbItens.FieldByName('Codigo').AsInteger);
      ItemRemovido.RemoverItem();
    end;
  end;


  FreeAndNil(TbPedido);
end;

constructor TPedido.Create();
begin
  Self.FProdutos := TObjectList<TItem>.Create(True);
  Self.FCliente  := TCliente.Create();
end;

constructor TPedido.Create(ACodigo: Integer);
var
  TbPedido: TFDQuery;
  Conexao : TConexao;
  TbItens : TFDQuery;
begin
  inherited Create();

  Conexao  := TConexao.ObterInstancia();
  TbPedido := Conexao.GerarQuery();
  TbItens  := Conexao.GerarQuery();
  Conexao.Conectar();

  TbPedido.SQL.Text := 'SELECT * FROM Pedidos WHERE Codigo = ' + IntToStr(ACodigo);
  TbPedido.Open();

  Self.FCodigo       := TbPedido.FieldByName('Codigo').AsInteger;
  Self.Cliente       := TCliente.Create(TbPedido.FieldByName('CodCliente').AsInteger);
  Self.DataHoraVenda := TbPedido.FieldByName('DataHoraVenda').AsDateTime;
  Self.Status        := TbPedido.FieldByName('Status').AsBoolean;

  Self.FProdutos := TObjectList<TItem>.Create(True);
  TbItens.SQL.Text := 'SELECT * FROM Itens WHERE CodVenda = ' + IntToStr(ACodigo);
  TbItens.Open();
  TbItens.First();
  for var I := 0 to TbItens.RecordCount - 1 do
  begin
    var Item := TItem.Create(TbItens.FieldByName('Codigo').AsInteger);
    Self.FProdutos.Add(Item);
    TbItens.Next();
  end;

  FreeAndNil(TbItens);
  FreeAndNil(TbPedido);
end;

procedure TPedido.Gravar;
begin
  if not (Self.FCliente.Codigo > 0) or not (Self.FCliente.Status) then
  begin
    raise Exception.Create('Cliente Invalido!');
  end;
  
  if not (Self.ValorTotal > 0) then
  begin
    raise Exception.Create('Pedido sem produtos ou com quantidades zeradas!');
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

procedure TPedido.Inserir;
var
  TbPedido: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbPedido :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbPedido.SQL.Clear();
  TbPedido.SQL.Add('INSERT INTO Pedidos (CodCliente, DataHoraVenda, ValorTotal, Status)');
  TbPedido.SQL.Add('OUTPUT Inserted.Codigo');
  TbPedido.SQL.Add('Values (');
  TbPedido.SQL.Add('  :CodCliente,');
  TbPedido.SQL.Add('  :DataHoraVenda,');
  TbPedido.SQL.Add('  :ValorTotal,');
  TbPedido.SQL.Add('  :Status)');

  TbPedido.ParamByName('CodCliente').AsInteger     := Self.Cliente.Codigo;
  TbPedido.ParamByName('ValorTotal').AsCurrency    := Self.ValorTotal;
  TbPedido.ParamByName('DataHoraVenda').AsDateTime := Self.DataHoraVenda;
  TbPedido.ParamByName('Status').AsBoolean         := False;

  TbPedido.Open();

  Self.FCodigo := TbPedido.FieldByName('Codigo').AsInteger;
  Self.FStatus := False;

  for var Item in Self.Produtos do
  begin
    Item.CodVenda := Self.FCodigo;
    Item.Gravar();
  end;

  FreeAndNil(TbPedido);
end;

function TPedido.CalcularTotal(): Currency;
begin
  Result := 0;
  for var Item in Self.Produtos do
  begin
    Result := Result + Item.CalcularTotal();
  end;
end;

{ TItem }

procedure TItem.Alterar;
var
  TbItem: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItem  :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbItem.SQL.Clear();
  TbItem.SQL.Add('UPDATE Itens SET');
  TbItem.SQL.Add('  Quantidade = :Quantidade,');
  TbItem.SQL.Add('  ValorTotal = :ValorTotal');
  TbItem.SQL.Add('WHERE Codigo = :Codigo');

  TbItem.ParamByName('Quantidade').AsInteger  := Self.Quantidade;
  TbItem.ParamByName('ValorTotal').AsCurrency := Self.ValorTotal;
  TbItem.ParamByName('Codigo').AsInteger      := Self.Codigo;

  TbItem.ExecSQL();

  FreeAndNil(TbItem);
end;

function TItem.CalcularTotal: Currency;
begin
  Result := Self.Produto.PrecoUnitario * Self.Quantidade;
end;

constructor TItem.Create();
begin
  Self.Quantidade := 1;
  Self.FProduto := Tproduto.Create();
end;

constructor TItem.Create(ACodigo: Integer);
var
  TbItem : TFDQuery;
  Conexao: TConexao;
begin
  inherited Create();

  Conexao := TConexao.ObterInstancia();
  TbItem := Conexao.GerarQuery();
  Conexao.Conectar();

  TbItem.SQL.Text := 'SELECT * FROM Itens WHERE Codigo = ' + IntToStr(ACodigo);
  TbItem.Open();

  Self.FCodigo     := TbItem.FieldByName('Codigo').AsInteger;
  Self.Produto     := TProduto.Create(TbItem.FieldByName('CodProduto').AsInteger);
  Self.FQuantidade := TbItem.FieldByName('Quantidade').AsInteger;
  Self.FCodVenda   := TbItem.FieldByName('CodVenda').AsInteger;

  FreeAndNil(TbItem);
end;

procedure TItem.Gravar;
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

procedure TItem.Inserir;
var
  TbItem: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItem :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbItem.SQL.Clear();
  TbItem.SQL.Add('INSERT INTO Itens (CodVenda, PrecoUnitario, ValorTotal, CodProduto, Quantidade)');
  TbItem.SQL.Add('OUTPUT Inserted.Codigo');
  TbItem.SQL.Add('Values (');
  TbItem.SQL.Add('  :CodVenda,');
  TbItem.SQL.Add('  :PrecoUnitario,');
  TbItem.SQL.Add('  :ValorTotal,');
  TbItem.SQL.Add('  :CodProduto,');
  TbItem.SQL.Add('  :Quantidade)');

  TbItem.ParamByName('CodVenda').AsInteger       := Self.CodVenda;
  TbItem.ParamByName('PrecoUnitario').AsCurrency := Self.Produto.PrecoUnitario;
  TbItem.ParamByName('ValorTotal').AsCurrency    := Self.ValorTotal;
  TbItem.ParamByName('CodProduto').AsInteger     := Self.Produto.Codigo;
  TbItem.ParamByName('Quantidade').AsInteger     := Self.Quantidade;

  TbItem.Open();

  Self.FCodigo := TbItem.FieldByName('Codigo').AsInteger;

  FreeAndNil(TbItem);
end;

procedure TItem.RemoverItem();
var
  TbItem: TFDQuery;
  Conexao : TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  TbItem :=  Conexao.GerarQuery();
  Conexao.Conectar();

  TbItem.SQL.Clear();
  TbItem.SQL.Add('DELETE FROM Itens WHERE CODIGO = :CODIGO');
  
  TbItem.ParamByName('Codigo').AsInteger := Self.Codigo;

  TbItem.ExecSQL();
  
  FreeAndNil(TbItem);
  FreeAndNil(Self);
end;

end.
