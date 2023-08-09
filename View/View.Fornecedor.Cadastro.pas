unit View.Fornecedor.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Model.Fornecedor, View.Busca.Geral, StrUtils;

type
  TFrmCadastroFornecedor = class(TForm)
    BtnInserir: TButton;
    BtnBuscar: TButton;
    BtnAlterar: TButton;
    BtnStatus: TButton;
    BtnGravar: TButton;
    BtnCancelar: TButton;
    LedNomeFantasia: TLabeledEdit;
    LedRazaoSocial: TLabeledEdit;
    LedCodigo: TLabeledEdit;
    LedCNPJ: TLabeledEdit;
    procedure BtnGravarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnStatusClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
  private
    { Private declarations }
    FFornecedor: TFornecedor;
    procedure LerTela();
    procedure PreencherTela();
    procedure TratarEdicao(AEditando: Boolean);
  public
    { Public declarations }
  end;

var
  FrmCadastroFornecedor: TFrmCadastroFornecedor;

implementation

{$R *.dfm}


procedure TFrmCadastroFornecedor.BtnAlterarClick(Sender: TObject);
begin
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroFornecedor.BtnBuscarClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Fornecedores', 'NomeFantasia', False, 'NomeFantasia, RazaoSocial, CNPJ');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FFornecedor := TFornecedor.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroFornecedor.BtnCancelarClick(Sender: TObject);
begin
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroFornecedor.BtnGravarClick(Sender: TObject);
begin
  Self.LerTela();
  Self.FFornecedor.Gravar();
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroFornecedor.BtnInserirClick(Sender: TObject);
begin
  FreeAndNil(Self.FFornecedor);
  Self.FFornecedor := TFornecedor.Create();
  Self.PreencherTela();
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroFornecedor.BtnStatusClick(Sender: TObject);
begin
  Self.FFornecedor.Status := not Self.FFornecedor.Status;
  Self.FFornecedor.Gravar();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroFornecedor.FormCreate(Sender: TObject);
begin
  Self.FFornecedor := TFornecedor.Create();
  Self.PreencherTela();
end;

procedure TFrmCadastroFornecedor.LerTela();
begin
  Self.FFornecedor.NomeFantasia := Self.LedNomeFantasia.Text;
  Self.FFornecedor.RazaoSocial  := Self.LedRazaoSocial.Text;

  try
    Self.FFornecedor.CNPJ := Self.LedCNPJ.Text;
  except
    raise Exception.Create('CNPJ Invalido');
  end;
end;

procedure TFrmCadastroFornecedor.PreencherTela();
begin
  Self.LedCodigo.Text := Self.FFornecedor.Codigo.ToString();
  Self.LedNomeFantasia.Text :=  Self.FFornecedor.NomeFantasia;
  Self.LedRazaoSocial.Text := Self.FFornecedor.RazaoSocial;
  Self.LedCNPJ.Text := Self.FFornecedor.CNPJ;
  Self.BtnStatus.Caption := IfThen(Self.FFornecedor.Status, 'Desativar', 'Ativar');
end;

procedure TFrmCadastroFornecedor.TratarEdicao(AEditando: Boolean);
begin
  Self.LedNomeFantasia.ReadOnly := not AEditando;
  Self.LedRazaoSocial.ReadOnly  := not AEditando;
  Self.LedCNPJ.ReadOnly         := (not AEditando) and (Self.FFornecedor.CNPJ = '');

  Self.BtnAlterar.Enabled  := (Self.FFornecedor.Codigo > 0) and Self.FFornecedor.Status;
  Self.BtnGravar.Enabled   := AEditando;
  Self.BtnCancelar.Enabled := AEditando;
  Self.BtnInserir.Enabled  := not AEditando;
  Self.BtnBuscar.Enabled   := not AEditando;

  Self.BtnStatus.Enabled := (Self.FFornecedor.Codigo > 0) and not AEditando;
  Self.BtnStatus.Caption := IfThen(Self.FFornecedor.Status, 'Desativar', 'Ativar');
end;

end.
