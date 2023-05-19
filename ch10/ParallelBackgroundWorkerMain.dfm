object frmBackgroundWorker: TfrmBackgroundWorker
  Left = 0
  Top = 0
  Caption = 'Background Worker'
  ClientHeight = 450
  ClientWidth = 980
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    980
    450)
  TextHeight = 15
  object chkSitelist: TCheckListBox
    Left = 16
    Top = 51
    Width = 363
    Height = 386
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 15
    TabOrder = 0
    OnClick = chkSitelistClick
  end
  object btnSearch: TButton
    Left = 206
    Top = 20
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = btnSearchClick
  end
  object inpSearch: TEdit
    Left = 16
    Top = 21
    Width = 184
    Height = 23
    TabOrder = 2
    Text = 'OmniThreadLibrary'
    OnKeyPress = inpSearchKeyPress
  end
  object btnOpen: TButton
    Left = 304
    Top = 20
    Width = 75
    Height = 25
    Action = ActionOpen
    TabOrder = 3
  end
  object ActionList1: TActionList
    Left = 312
    Top = 376
    object ActionOpen: TAction
      Caption = 'Open'
      OnExecute = ActionOpenExecute
      OnUpdate = ActionOpenUpdate
    end
  end
end
