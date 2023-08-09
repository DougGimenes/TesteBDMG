object FrmCadastroCliente: TFrmCadastroCliente
  Left = 797
  Top = 436
  Caption = 'Cad. de Clientes'
  ClientHeight = 265
  ClientWidth = 257
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
    Left = 91
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 1
    OnClick = BtnBuscarClick
  end
  object BtnAlterar: TButton
    Left = 174
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
    Top = 238
    Width = 75
    Height = 25
    Caption = 'BtnStatus'
    Enabled = False
    TabOrder = 3
    OnClick = BtnStatusClick
  end
  object BtnGravar: TButton
    Left = 91
    Top = 238
    Width = 75
    Height = 25
    Caption = 'Gravar'
    Enabled = False
    TabOrder = 4
    OnClick = BtnGravarClick
  end
  object BtnCancelar: TButton
    Left = 174
    Top = 238
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Enabled = False
    TabOrder = 5
    OnClick = BtnCancelarClick
  end
  object LedCPF: TLabeledEdit
    Left = 68
    Top = 142
    Width = 120
    Height = 23
    EditLabel.Width = 40
    EditLabel.Height = 15
    EditLabel.Caption = 'LedCPF'
    EditMask = '###.###.###-##;0;_'
    MaxLength = 14
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 6
    Text = ''
  end
  object LedDatanascimento: TLabeledEdit
    Left = 68
    Top = 184
    Width = 120
    Height = 23
    EditLabel.Width = 88
    EditLabel.Height = 15
    EditLabel.Caption = 'DataNascimento'
    EditMask = '##/##/####;1;_'
    MaxLength = 10
    ReadOnly = True
    TabOrder = 7
    Text = '  /  /    '
  end
  object LedCodigo: TLabeledEdit
    Left = 68
    Top = 56
    Width = 121
    Height = 23
    EditLabel.Width = 39
    EditLabel.Height = 15
    EditLabel.Caption = 'Codigo'
    ReadOnly = True
    TabOrder = 8
    Text = ''
  end
  object LedNome: TLabeledEdit
    Left = 68
    Top = 99
    Width = 121
    Height = 23
    EditLabel.Width = 33
    EditLabel.Height = 15
    EditLabel.Caption = 'Nome'
    ReadOnly = True
    TabOrder = 9
    Text = ''
  end
end
