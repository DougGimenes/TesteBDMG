unit View.Busca.Geral;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Controller.Connection, StrUtils;

type
  TFrmBuscaGeral = class(TForm)
    QryBusca: TFDQuery;
    DsBusca: TDataSource;
    DbgBusca: TDBGrid;
    EdtFiltro: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EdtFiltroKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DbgBuscaDblClick(Sender: TObject);
    procedure DbgBuscaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FTabela: String;
    FCamposExibidos: String;
    FCampoFiltro: String;
    FSomenteAtivos: Boolean;

    procedure AbrirConsulta(AFiltrar: Boolean = False);
    procedure FinalizarConsulta();
  public
    { Public declarations }
    CodigoConsultado: Integer;
    constructor Create(AOwner: TComponent; ATabela, ACampoFiltro: String; ASomenteAtivos: Boolean = False; ACamposExibidos: String = ''); overload;
  end;

var
  FrmBuscaGeral: TFrmBuscaGeral;

implementation

{$R *.dfm}

constructor TFrmBuscaGeral.Create(AOwner: TComponent; ATabela, ACampoFiltro: String; ASomenteAtivos: Boolean = False; ACamposExibidos: String = '');
var
  Conexao: TConexao;
begin
  inherited Create(AOwner);

  if (ATabela = '') or (ACampoFiltro = '') then
  begin
    raise Exception.Create('Impossivel abrir busca');
  end;

  Self.FTabela := ATabela;
  Self.FCampoFiltro := ACampoFiltro;

  if ContainsText(ACamposExibidos, 'Codigo')  then
  begin
    Self.FCamposExibidos := ACamposExibidos;
  end
  else
  begin
    Self.FCamposExibidos := ACamposExibidos + ', Codigo';
  end;

  Self.FSomenteAtivos := ASomenteAtivos;

  Conexao := TConexao.ObterInstancia;
  Conexao.Conectar();
  Self.QryBusca.Connection := Conexao;
end;

procedure TFrmBuscaGeral.DbgBuscaDblClick(Sender: TObject);
begin
  Self.FinalizarConsulta();
end;

procedure TFrmBuscaGeral.DbgBuscaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Self.FinalizarConsulta();
  end;
end;

procedure TFrmBuscaGeral.EdtFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Length(Self.EdtFiltro.Text) > 3) then
  begin
    Self.AbrirConsulta(True);
  end
  else if (Length(Self.EdtFiltro.Text) = 0) then
  begin
    Self.AbrirConsulta(False);
  end;
end;

procedure TFrmBuscaGeral.FormCreate(Sender: TObject);
begin
  Self.AbrirConsulta();
  Self.Caption := 'Buscando ' + Self.FTabela;
end;

procedure TFrmBuscaGeral.AbrirConsulta(AFiltrar: Boolean = False);
begin
  Self.QryBusca.Close();

  Self.QryBusca.SQL.Clear();
  Self.QryBusca.SQL.Add('SELECT');

  if Self.FCamposExibidos <> '' then
  begin
    Self.QryBusca.SQL.Add(Self.FCamposExibidos);
  end
  else
  begin
    Self.QryBusca.SQL.Add('*');
  end;

  Self.QryBusca.SQL.Add('FROM ' + Self.FTabela);

  if AFiltrar then
  begin
    Self.QryBusca.SQL.Add('WHERE ' + Self.FCampoFiltro + ' LIKE ' + QuotedStr(Self.EdtFiltro.Text + '%'));
  end;

  if Self.FSomenteAtivos then
  begin
    if AFiltrar then
    begin
      Self.QryBusca.SQL.Add('AND Status = 1');
    end
    else
    begin
      Self.QryBusca.SQL.Add('WHERE Status = 1');
    end;
  end;

  Self.QryBusca.Open();

  for var I := 0 to Self.DbgBusca.Columns.Count - 1 do
  begin
    Self.DbgBusca.Columns[I].Width := (Self.DbgBusca.Width - 30) div Self.DbgBusca.Columns.Count;
  end;
end;

procedure TFrmBuscaGeral.FinalizarConsulta();
begin
  Self.CodigoConsultado := Self.QryBusca.FieldByName('Codigo').AsInteger;
  Self.Close();
end;

end.
