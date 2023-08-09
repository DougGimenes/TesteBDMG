unit View.Cliente.Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Model.Cliente, View.Busca.Geral, StrUtils;

type
  TFrmCadastroCliente = class(TForm)
    BtnInserir: TButton;
    BtnBuscar: TButton;
    BtnAlterar: TButton;
    BtnStatus: TButton;
    BtnGravar: TButton;
    BtnCancelar: TButton;
    LedCPF: TLabeledEdit;
    LedDatanascimento: TLabeledEdit;
    LedCodigo: TLabeledEdit;
    LedNome: TLabeledEdit;
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnStatusClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCliente: TCliente;
    procedure LerTela();
    procedure PreencherTela();
    procedure TratarEdicao(AEditando: Boolean);
  public
    { Public declarations }
  end;

var
  FrmCadastroCliente: TFrmCadastroCliente;

implementation

{$R *.dfm}

procedure TFrmCadastroCliente.BtnAlterarClick(Sender: TObject);
begin
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroCliente.BtnBuscarClick(Sender: TObject);
var
  FrmBusca: TFrmBuscaGeral;
begin
  FrmBusca := TFrmBuscaGeral.Create(Self,'Clientes', 'Nome', False, 'Nome, CPF, DataNascimento');
  try
    FrmBusca.ShowModal();
    if FrmBusca.CodigoConsultado > 0 then
    begin
      Self.FCliente := TCliente.Create(FrmBusca.CodigoConsultado);
    end;
  finally
    FreeAndNil(FrmBusca);
  end;
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroCliente.BtnCancelarClick(Sender: TObject);
begin
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroCliente.BtnGravarClick(Sender: TObject);
begin
  Self.LerTela();
  Self.FCliente.Gravar();
  Self.PreencherTela();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroCliente.BtnInserirClick(Sender: TObject);
begin
  FreeAndNil(Self.FCliente);
  Self.FCliente := TCliente.Create();
  Self.PreencherTela();
  Self.TratarEdicao(True);
end;

procedure TFrmCadastroCliente.BtnStatusClick(Sender: TObject);
begin
  Self.FCliente.Status := not Self.FCliente.Status;
  Self.FCliente.Gravar();
  Self.TratarEdicao(False);
end;

procedure TFrmCadastroCliente.FormCreate(Sender: TObject);
begin
  Self.FCliente := TCliente.Create();
  Self.PreencherTela();
end;

procedure TFrmCadastroCliente.LerTela();
begin
  Self.FCliente.Nome           := Self.LedNome.Text;
  Self.FCliente.DataNascimento := StrToDate(Self.LedDatanascimento.Text);

  try
    Self.FCliente.CPF := Self.LedCPF.Text;
  except
    raise Exception.Create('CPF Invalido');
  end;
end;

procedure TFrmCadastroCliente.PreencherTela();
begin
  Self.LedCodigo.Text         := Self.FCliente.Codigo.ToString();
  Self.LedCPF.Text            := Self.FCliente.CPF;
  Self.LedNome.Text           := Self.FCliente.Nome;
  Self.LedDatanascimento.Text := DateToStr(Self.FCliente.DataNascimento);
  Self.BtnStatus.Caption      := IfThen(Self.FCliente.Status, 'Desativar', 'Ativar');
end;

procedure TFrmCadastroCliente.TratarEdicao(AEditando: Boolean);
begin
  Self.LedDatanascimento.ReadOnly := not AEditando;
  Self.LedNome.ReadOnly           := not AEditando;
  Self.LedCPF.ReadOnly            := (not AEditando) and (Self.FCliente.CPF = '');

  Self.BtnAlterar.Enabled  := (Self.FCliente.Codigo > 0) and Self.FCliente.Status;
  Self.BtnGravar.Enabled   := AEditando;
  Self.BtnCancelar.Enabled := AEditando;
  Self.BtnInserir.Enabled  := not AEditando;
  Self.BtnBuscar.Enabled   := not AEditando;

  Self.BtnStatus.Enabled := (Self.FCliente.Codigo > 0) and not AEditando;
  Self.BtnStatus.Caption      := IfThen(Self.FCliente.Status, 'Desativar', 'Ativar');
end;

end.
