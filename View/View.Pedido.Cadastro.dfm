object FrmCadastroPedidos: TFrmCadastroPedidos
  Left = 592
  Top = 291
  Caption = 'Cad. de Pedidos'
  ClientHeight = 455
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 15
  object LblQuantidade: TLabel
    Left = 319
    Top = 406
    Width = 62
    Height = 15
    Caption = 'Quantidade'
    Enabled = False
  end
  object DbgProdutos: TDBGrid
    Left = 8
    Top = 88
    Width = 608
    Height = 313
    DataSource = DsProdutos
    Enabled = False
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DbgProdutosDblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Descricao'
        Title.Caption = 'Descri'#231#227'o'
        Width = 270
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantidade'
        Title.Alignment = taCenter
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PrecoUnitario'
        Title.Alignment = taCenter
        Title.Caption = 'Pre'#231'o Unit'#225'rio'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PrecoTotal'
        Title.Alignment = taCenter
        Title.Caption = 'Pre'#231'o Total'
        Width = 100
        Visible = True
      end>
  end
  object LedDescricaoProduto: TLabeledEdit
    Left = 8
    Top = 424
    Width = 233
    Height = 23
    EditLabel.Width = 97
    EditLabel.Height = 15
    EditLabel.Caption = 'Descri'#231#227'o Produto'
    Enabled = False
    ImeName = 'Portuguese (Brazilian ABNT)'
    ReadOnly = True
    TabOrder = 1
    Text = ''
  end
  object SedQuantidade: TSpinEdit
    Left = 319
    Top = 424
    Width = 58
    Height = 24
    Enabled = False
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 2
    Value = 1
    OnChange = SedQuantidadeChange
  end
  object LedPrecoUnitario: TLabeledEdit
    Left = 383
    Top = 424
    Width = 82
    Height = 23
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'Pre'#231'o Unit.'
    Enabled = False
    ReadOnly = True
    TabOrder = 3
    Text = ''
  end
  object LedPrecoTotal: TLabeledEdit
    Left = 471
    Top = 424
    Width = 82
    Height = 23
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'Pre'#231'o Total'
    Enabled = False
    ReadOnly = True
    TabOrder = 4
    Text = ''
  end
  object BtnProduto: TButton
    Left = 247
    Top = 422
    Width = 66
    Height = 25
    Caption = 'Buscar'
    Enabled = False
    TabOrder = 5
    OnClick = BtnProdutoClick
  end
  object BtnAdicionar: TButton
    Left = 559
    Top = 423
    Width = 57
    Height = 25
    Caption = 'Add'
    Enabled = False
    TabOrder = 6
    OnClick = BtnAdicionarClick
  end
  object BtnInserir: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 7
    OnClick = BtnInserirClick
  end
  object BtnBuscar: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 8
    OnClick = BtnBuscarClick
  end
  object BtnAlterar: TButton
    Left = 170
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Alterar'
    Enabled = False
    TabOrder = 9
    OnClick = BtnAlterarClick
  end
  object BtnStatus: TButton
    Left = 251
    Top = 8
    Width = 110
    Height = 25
    Caption = 'Efetivar Venda'
    Enabled = False
    TabOrder = 10
    OnClick = BtnStatusClick
  end
  object BtnGravar: TButton
    Left = 460
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Gravar'
    Enabled = False
    TabOrder = 11
    OnClick = BtnGravarClick
  end
  object BtnCancelar: TButton
    Left = 541
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    Enabled = False
    TabOrder = 12
    OnClick = BtnCancelarClick
  end
  object LedClienteNome: TLabeledEdit
    Left = 8
    Top = 59
    Width = 527
    Height = 23
    EditLabel.Width = 104
    EditLabel.Height = 15
    EditLabel.Caption = 'Cliente Selecionado'
    Enabled = False
    ReadOnly = True
    TabOrder = 13
    Text = ''
  end
  object BtnCliente: TButton
    Left = 541
    Top = 57
    Width = 75
    Height = 25
    Caption = 'Cliente'
    Enabled = False
    TabOrder = 14
    OnClick = BtnClienteClick
  end
  object MtbProdutos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 24
    Top = 128
    object MtbProdutosDescricao: TStringField
      FieldName = 'Descricao'
      Size = 100
    end
    object MtbProdutosCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object MtbProdutosQuantidade: TIntegerField
      FieldName = 'Quantidade'
    end
    object MtbProdutosPrecoUnitario: TCurrencyField
      FieldName = 'PrecoUnitario'
    end
    object MtbProdutosPrecoTotal: TCurrencyField
      FieldName = 'PrecoTotal'
    end
  end
  object DsProdutos: TDataSource
    DataSet = MtbProdutos
    Left = 24
    Top = 184
  end
end
