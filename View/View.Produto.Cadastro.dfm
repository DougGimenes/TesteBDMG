object FrmCadastroProdutos: TFrmCadastroProdutos
  Left = 735
  Top = 415
  Caption = 'Cad. de Produtos'
  ClientHeight = 315
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object BtnInserir: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 0
    OnClick = BtnInserirClick
  end
  object BtnBuscar: TButton
    Left = 112
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 1
    OnClick = BtnBuscarClick
  end
  object BtnAlterar: TButton
    Left = 217
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Alterar'
    Enabled = False
    TabOrder = 2
    OnClick = BtnAlterarClick
  end
  object BtnStatus: TButton
    Left = 8
    Top = 280
    Width = 75
    Height = 25
    Caption = 'BtnStatus'
    Enabled = False
    TabOrder = 3
    OnClick = BtnStatusClick
  end
  object BtnGravar: TButton
    Left = 112
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Gravar'
    Enabled = False
    TabOrder = 4
    OnClick = BtnGravarClick
  end
  object BtnCancelar: TButton
    Left = 217
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Enabled = False
    TabOrder = 5
    OnClick = BtnCancelarClick
  end
  object LedCodigo: TLabeledEdit
    Left = 22
    Top = 72
    Width = 121
    Height = 23
    EditLabel.Width = 39
    EditLabel.Height = 15
    EditLabel.Caption = 'Codigo'
    ReadOnly = True
    TabOrder = 6
    Text = ''
  end
  object LedPrecoUnitario: TLabeledEdit
    Left = 22
    Top = 239
    Width = 111
    Height = 23
    EditLabel.Width = 75
    EditLabel.Height = 15
    EditLabel.Caption = 'Pre'#231'o Unit'#225'rio'
    ReadOnly = True
    TabOrder = 7
    Text = ''
    OnExit = LedPrecoUnitarioExit
  end
  object LedFornecedorCodigo: TLabeledEdit
    Left = 22
    Top = 163
    Width = 62
    Height = 23
    EditLabel.Width = 55
    EditLabel.Height = 15
    EditLabel.Caption = 'C'#243'd. Forn.'
    ReadOnly = True
    TabOrder = 8
    Text = ''
  end
  object LedFornecedorNome: TLabeledEdit
    Left = 89
    Top = 163
    Width = 185
    Height = 23
    EditLabel.Width = 109
    EditLabel.Height = 15
    EditLabel.Caption = 'Nome Fantasia Forn.'
    ReadOnly = True
    TabOrder = 9
    Text = ''
  end
  object BtnFornecedor: TButton
    Left = 22
    Top = 192
    Width = 121
    Height = 25
    Caption = 'Buscar Fornecedor'
    Enabled = False
    TabOrder = 10
    OnClick = BtnFornecedorClick
  end
  object LedDescricao: TLabeledEdit
    Left = 22
    Top = 115
    Width = 121
    Height = 23
    EditLabel.Width = 51
    EditLabel.Height = 15
    EditLabel.Caption = 'Descri'#231#227'o'
    ReadOnly = True
    TabOrder = 11
    Text = ''
  end
end
