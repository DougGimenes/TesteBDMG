unit View.Menu.Geral;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, View.Cliente.Cadastro,
  View.Fornecedor.Cadastro, View.Produto.Cadastro, View.Pedido.Cadastro;

type
  TFrmMenuGeral = class(TForm)
    BtnClientes: TButton;
    BtnFornecedores: TButton;
    BtnProdutos: TButton;
    BtnPedidos: TButton;
    procedure BtnClientesClick(Sender: TObject);
    procedure BtnFornecedoresClick(Sender: TObject);
    procedure BtnProdutosClick(Sender: TObject);
    procedure BtnPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenuGeral: TFrmMenuGeral;

implementation

{$R *.dfm}

procedure TFrmMenuGeral.BtnClientesClick(Sender: TObject);
var
  FrmCadastro: TFrmCadastroCliente;
begin
  FrmCadastro := TFrmCadastroCliente.Create(Self);
  try
    FrmCadastro.ShowModal();
  finally
    FreeAndNil(FrmCadastro);
  end;
end;

procedure TFrmMenuGeral.BtnFornecedoresClick(Sender: TObject);
var
  FrmCadastro: TFrmCadastroFornecedor;
begin
  FrmCadastro := TFrmCadastroFornecedor.Create(Self);
  try
    FrmCadastro.ShowModal();
  finally
    FreeAndNil(FrmCadastro);
  end;
end;

procedure TFrmMenuGeral.BtnPedidosClick(Sender: TObject);
var
  FrmCadastro: TFrmCadastroPedidos;
begin
  FrmCadastro := TFrmCadastroPedidos.Create(Self);
  try
    FrmCadastro.ShowModal();
  finally
    FreeAndNil(FrmCadastro);
  end;
end;

procedure TFrmMenuGeral.BtnProdutosClick(Sender: TObject);
var
  FrmCadastro: TFrmCadastroProdutos;
begin
  FrmCadastro := TFrmCadastroProdutos.Create(Self);
  try
    FrmCadastro.ShowModal();
  finally
    FreeAndNil(FrmCadastro);
  end;
end;

end.
