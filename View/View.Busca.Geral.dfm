object FrmBuscaGeral: TFrmBuscaGeral
  Left = 613
  Top = 353
  Caption = 'FrmBuscaGeral'
  ClientHeight = 376
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
  object DbgBusca: TDBGrid
    Left = 8
    Top = 8
    Width = 608
    Height = 329
    DataSource = DsBusca
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = DbgBuscaDblClick
    OnKeyDown = DbgBuscaKeyDown
  end
  object EdtFiltro: TEdit
    Left = 8
    Top = 343
    Width = 608
    Height = 23
    TabOrder = 1
    TextHint = 'Busca'
    OnKeyUp = EdtFiltroKeyUp
  end
  object QryBusca: TFDQuery
    Left = 32
    Top = 48
  end
  object DsBusca: TDataSource
    DataSet = QryBusca
    Left = 96
    Top = 48
  end
end
