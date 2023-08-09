unit View.Produto.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Model.Produto, Model.Fornecedor, View.Busca.Geral, StrUtils;

type
  TFrmCadastroProdutos = class(TForm)
    BtnInserir: TButton;
    BtnBuscar: TButton;
    BtnAlterar: TButton;
    BtnStatus: TButton;
    BtnGravar: TButton;
    BtnCancelar: TButton;
    LedCodigo: TLabeledEdit;
    LedPrecoUnitario: TLabeledEdit;
    LedFornecedorCodigo: TLabeledEdit;
    LedFornecedorNome: TLabeledEdit;
    BtnFornecedor: TButton;
    LedDescricao: TLabeledEdit;
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnStatusClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFornecedorClick(Sender: TObject);
    procedure LedPrecoUnitarioExit(Sender: TObject);
  private
    { Private declarations }
    FProduto: TProduto;
    procedure LerTela();
    procedure PreencherTela();
    procedure TratarEdicao(AEditando: Boolean);
  public
    { Public declarations }
  end;

var
  FrmCadastroProdutos: TFrmCadastroProdutos;

implementation

{$R *.dfm}

procedure TFrmCadastroProdutos.BtnAlterarClick(Sender: TObject);
begin
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroProdutos.BtnBuscarClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Produtos', 'Descricao', False, 'Descricao, PrecoUnitario');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FProduto := TProduto.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroProdutos.BtnCancelarClick(Sender: TObject);
begin
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroProdutos.BtnFornecedorClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Fornecedores', 'NomeFantasia', True, 'NomeFantasia, RazaoSocial, CNPJ');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FProduto.Fornecedor := TFornecedor.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;

  Self.LedFornecedorCodigo.Text := Self.FProduto.Fornecedor.Codigo.ToString();
  Self.LedFornecedorNome.Text   := Self.FProduto.Fornecedor.NomeFantasia;
end;

procedure TFrmCadastroProdutos.BtnGravarClick(Sender: TObject);
begin
  Self.LerTela();
  Self.FProduto.Gravar();
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroProdutos.BtnInserirClick(Sender: TObject);
begin
  FreeAndNil(Self.FProduto);
  Self.FProduto := TProduto.Create();
  Self.PreencherTela();
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroProdutos.BtnStatusClick(Sender: TObject);
begin
  Self.FProduto.Status := not Self.FProduto.Status;
  Self.FProduto.Gravar();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroProdutos.FormCreate(Sender: TObject);
begin
  Self.FProduto := TProduto.Create();
  Self.PreencherTela();
end;

procedure TFrmCadastroProdutos.LedPrecoUnitarioExit(Sender: TObject);
begin
  Self.LedPrecoUnitario.Text := FormatFloat('###0.00', StrToCurr(Self.LedPrecoUnitario.Text));
end;

procedure TFrmCadastroProdutos.LerTela;
begin
  Self.FProduto.Descricao     := Self.LedDescricao.Text;
  Self.FProduto.PrecoUnitario := StrToCurr(Self.LedPrecoUnitario.Text);
  Self.FProduto.Fornecedor    := TFornecedor.Create(StrToInt(Self.LedFornecedorCodigo.Text));
end;

procedure TFrmCadastroProdutos.PreencherTela;
begin
  Self.LedCodigo.Text        := Self.FProduto.Codigo.ToString();
  Self.LedDescricao.Text     := Self.FProduto.Descricao;
  Self.LedPrecoUnitario.Text := FormatFloat('###0.00', Self.FProduto.PrecoUnitario);
  Self.LedFornecedorCodigo.Text := Self.FProduto.Fornecedor.Codigo.ToString();
  Self.LedFornecedorNome.Text   := Self.FProduto.Fornecedor.NomeFantasia;
  Self.BtnStatus.Caption := IfThen(Self.FProduto.Status, 'Desativar', 'Ativar');
end;

procedure TFrmCadastroProdutos.TratarEdicao(AEditando: Boolean);
begin
  Self.LedDescricao.ReadOnly        := not AEditando;
  Self.LedPrecoUnitario.ReadOnly    := not AEditando;
  Self.LedFornecedorCodigo.ReadOnly := not AEditando;
  Self.BtnFornecedor.Enabled        := AEditando;

  Self.BtnAlterar.Enabled  := (Self.FProduto.Codigo > 0) and Self.FProduto.Status;
  Self.BtnGravar.Enabled   := AEditando;
  Self.BtnCancelar.Enabled := AEditando;
  Self.BtnInserir.Enabled  := not AEditando;
  Self.BtnBuscar.Enabled   := not AEditando;

  Self.BtnStatus.Enabled := (Self.FProduto.Codigo > 0) and not AEditando;
  Self.BtnStatus.Caption := IfThen(Self.FProduto.Status, 'Desativar', 'Ativar');
end;

end.
