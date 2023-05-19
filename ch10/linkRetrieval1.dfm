object frmLinkRetrieval: TfrmLinkRetrieval
  Left = 0
  Top = 0
  Caption = 'Link Retrieval'
  ClientHeight = 515
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    681
    515)
  PixelsPerInch = 96
  TextHeight = 13
  object lbLinks: TListBox
    Left = 0
    Top = 0
    Width = 585
    Height = 336
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnStart: TButton
    Left = 598
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 598
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = btnStopClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 336
    Width = 681
    Height = 179
    Align = alBottom
    TabOrder = 3
  end
end
