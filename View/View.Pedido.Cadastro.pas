unit View.Pedido.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.Samples.Spin, Model.Pedido, Model.Produto, Model.Cliente,
  View.Busca.Geral, StrUtils;

type
  TFrmCadastroPedidos = class(TForm)
    MtbProdutos: TFDMemTable;
    DsProdutos: TDataSource;
    DbgProdutos: TDBGrid;
    MtbProdutosDescricao: TStringField;
    MtbProdutosCodigo: TIntegerField;
    MtbProdutosQuantidade: TIntegerField;
    MtbProdutosPrecoUnitario: TCurrencyField;
    MtbProdutosPrecoTotal: TCurrencyField;
    LedDescricaoProduto: TLabeledEdit;
    SedQuantidade: TSpinEdit;
    LedPrecoUnitario: TLabeledEdit;
    LedPrecoTotal: TLabeledEdit;
    BtnProduto: TButton;
    BtnAdicionar: TButton;
    LblQuantidade: TLabel;
    BtnInserir: TButton;
    BtnBuscar: TButton;
    BtnAlterar: TButton;
    BtnStatus: TButton;
    BtnGravar: TButton;
    BtnCancelar: TButton;
    LedClienteNome: TLabeledEdit;
    BtnCliente: TButton;
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnStatusClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnClienteClick(Sender: TObject);
    procedure BtnProdutoClick(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SedQuantidadeChange(Sender: TObject);
    procedure DbgProdutosDblClick(Sender: TObject);
  private
    { Private declarations }
    FPedido: TPedido;
    FItemEditado: TItem;

    procedure LerTela();
    procedure LerItem();
    procedure PreencherTela();
    procedure PreencherItem();
    procedure TratarEdicao(AEditando: Boolean);
  public
    { Public declarations }
  end;

var
  FrmCadastroPedidos: TFrmCadastroPedidos;

implementation

{$R *.dfm}

procedure TFrmCadastroPedidos.BtnAdicionarClick(Sender: TObject);
begin
  Self.LerItem();

  for var Item in Self.FPedido.Produtos do
  begin
    if Item.Produto.Codigo = Item.Produto.Codigo then
    begin 
      Self.FItemEditado := TItem.Create();
      Self.PreencherTela();
      Self.PreencherItem();
      raise Exception.Create('Produto já consta na venda!');
    end;
  end;

  Self.FPedido.Produtos.Add(Self.FItemEditado);
  Self.FItemEditado := TItem.Create();
  Self.PreencherTela();
  Self.PreencherItem();
end;

procedure TFrmCadastroPedidos.BtnAlterarClick(Sender: TObject);
begin
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroPedidos.BtnBuscarClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Pedidos', 'Codigo', False, 'Codigo, CodCliente, ValorTotal, DataHoraVenda');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FPedido := TPedido.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroPedidos.BtnCancelarClick(Sender: TObject);
begin
  if Self.FPedido.Codigo > 0 then
  begin
    Self.FPedido := TPedido.Create(Self.FPedido.Codigo);
  end
  else
  begin
    Self.FPedido := TPedido.Create();
  end;
  
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroPedidos.BtnClienteClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Clientes', 'Nome', True, 'Nome, CPF, DataNascimento');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FPedido.Cliente := TCliente.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;

  Self.LedClienteNome.Text := Self.FPedido.Cliente.Nome;
end;

procedure TFrmCadastroPedidos.BtnGravarClick(Sender: TObject);
begin
  Self.LerTela();
  Self.FPedido.Gravar();
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroPedidos.BtnInserirClick(Sender: TObject);
begin
  FreeAndNil(Self.FPedido);
  Self.FPedido := TPedido.Create();
  Self.PreencherTela();
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroPedidos.BtnProdutoClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Produtos', 'Descricao', False, 'Descricao, PrecoUnitario');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FItemEditado.Produto := TProduto.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;

  Self.LedDescricaoProduto.Text := Self.FItemEditado.Produto.Descricao;
  Self.LedPrecoUnitario.Text    := FormatFloat('###0.00', Self.FItemEditado.Produto.PrecoUnitario);
  Self.SedQuantidade.Value      := Self.FItemEditado.Quantidade;
  Self.LedPrecoTotal.Text       := FormatFloat('###0.00', Self.FItemEditado.Produto.PrecoUnitario * Self.FItemEditado.Quantidade);
end;

procedure TFrmCadastroPedidos.BtnStatusClick(Sender: TObject);
begin
  Self.FPedido.Status := not Self.FPedido.Status;
  Self.FPedido.Gravar();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroPedidos.DbgProdutosDblClick(Sender: TObject);
begin  
  if MessageDlg('Deseja remover o produto selecionado do pedido?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo then
  begin
    exit;
  end;
  
  Self.FPedido.Produtos.Delete(Self.MtbProdutos.RecNo - 1);
  Self.MtbProdutos.Delete();
end;

procedure TFrmCadastroPedidos.FormCreate(Sender: TObject);
begin
  Self.FPedido := TPedido.Create();
  Self.FItemEditado := TItem.Create();
  Self.PreencherTela();
end;

procedure TFrmCadastroPedidos.LerTela();
begin
  Self.FPedido.DataHoraVenda := Now();
end;

procedure TFrmCadastroPedidos.LerItem();
begin
  Self.FItemEditado.Quantidade := Self.SedQuantidade.Value;
end;

procedure TFrmCadastroPedidos.PreencherTela();
begin
  Self.LedClienteNome.Text := Self.FPedido.Cliente.Nome;

  Self.MtbProdutos.Close();
  Self.MtbProdutos.Open();
  Self.MtbProdutos.EmptyDataSet();
  for var Item in Self.FPedido.Produtos do
  begin
    Self.MtbProdutos.Append();
    Self.MtbProdutosCodigo.AsInteger         := Item.Codigo;
    Self.MtbProdutosDescricao.AsString       := Item.Produto.Descricao;
    Self.MtbProdutosQuantidade.AsInteger     := Item.Quantidade;
    Self.MtbProdutosPrecoUnitario.AsCurrency := Item.Produto.PrecoUnitario;
    Self.MtbProdutosPrecoTotal.AsCurrency    := Item.ValorTotal;
    Self.MtbProdutos.Post();
  end;
end;

procedure TFrmCadastroPedidos.SedQuantidadeChange(Sender: TObject);
begin
  Self.LedPrecoTotal.Text := FormatFloat('###0.00', Self.FItemEditado.Produto.PrecoUnitario * Self.SedQuantidade.Value);
end;

procedure TFrmCadastroPedidos.TratarEdicao(AEditando: Boolean);
begin
  Self.DbgProdutos.Enabled         := AEditando;
  Self.LedClienteNome.Enabled      := AEditando;
  Self.BtnCliente.Enabled          := AEditando;
  Self.LedDescricaoProduto.Enabled := AEditando;
  Self.BtnProduto.Enabled          := AEditando;
  Self.SedQuantidade.Enabled       := AEditando;
  Self.LedPrecoUnitario.Enabled    := AEditando;
  Self.LedPrecoTotal.Enabled       := AEditando;
  Self.BtnAdicionar.Enabled        := AEditando;

  Self.BtnAlterar.Enabled  := (Self.FPedido.Codigo > 0) and not (Self.FPedido.Status);
  Self.BtnGravar.Enabled   := AEditando;
  Self.BtnCancelar.Enabled := AEditando;
  Self.BtnInserir.Enabled  := not AEditando;
  Self.BtnBuscar.Enabled   := not AEditando;
  Self.BtnStatus.Enabled := (Self.FPedido.Codigo > 0) and (not AEditando) and not (Self.FPedido.Status);;
end;

procedure TFrmCadastroPedidos.PreencherItem();
begin
  Self.LedDescricaoProduto.Text := Self.FItemEditado.Produto.Descricao;
  Self.LedPrecoUnitario.Text    := FormatFloat('###0.00', Self.FItemEditado.Produto.PrecoUnitario);
  Self.SedQuantidade.Value      := Self.FItemEditado.Quantidade;
  Self.LedPrecoTotal.Text       := FormatFloat('###0.00', Self.FItemEditado.Produto.PrecoUnitario * Self.FItemEditado.Quantidade);
end;

end.
