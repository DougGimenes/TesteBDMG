program TesteBDMG;

uses
  Vcl.Forms,
  Model.Cliente in 'Model\Model.Cliente.pas',
  Controller.Connection in 'Connection\Controller.Connection.pas',
  Model.Fornecedor in 'Model\Model.Fornecedor.pas',
  Model.Produto in 'Model\Model.Produto.pas',
  View.Fornecedor.Cadastro in 'View\View.Fornecedor.Cadastro.pas' {FrmCadastroFornecedor},
  View.Busca.Geral in 'View\View.Busca.Geral.pas' {FrmBuscaGeral},
  Model.Pedido in 'Model\Model.Pedido.pas',
  View.Cliente.Cadastro in 'View\View.Cliente.Cadastro.pas' {FrmCadastroCliente},
  View.Produto.Cadastro in 'View\View.Produto.Cadastro.pas' {FrmCadastroProdutos},
  View.Menu.Geral in 'View\View.Menu.Geral.pas' {FrmMenuGeral};

{$R *.res}

var
  Conexao: TConexao;
begin
  Conexao := TConexao.ObterInstancia();
  Conexao.Conectar('Server=DOUGLAS-PC;OSAuthent=Yes;Database=TesteBDMG;DriverID=MSSQL;');


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMenuGeral, FrmMenuGeral);
  Application.Run;
end.
