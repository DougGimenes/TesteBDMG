object FrmMenuGeral: TFrmMenuGeral
  Left = 878
  Top = 498
  Caption = 'FrmMenuGeral'
  ClientHeight = 136
  ClientWidth = 152
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  TextHeight = 15
  object BtnClientes: TButton
    Left = 8
    Top = 8
    Width = 136
    Height = 25
    Caption = 'BtnClientes'
    TabOrder = 0
    OnClick = BtnClientesClick
  end
  object BtnFornecedores: TButton
    Left = 8
    Top = 39
    Width = 136
    Height = 25
    Caption = 'BtnFornecedores'
    TabOrder = 1
    OnClick = BtnFornecedoresClick
  end
  object BtnProdutos: TButton
    Left = 8
    Top = 70
    Width = 136
    Height = 25
    Caption = 'BtnProdutos'
    TabOrder = 2
    OnClick = BtnProdutosClick
  end
  object BtnPedidos: TButton
    Left = 8
    Top = 101
    Width = 136
    Height = 25
    Caption = 'BtnPedidos'
    TabOrder = 3
    OnClick = BtnPedidosClick
  end
end
