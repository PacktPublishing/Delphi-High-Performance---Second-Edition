object frmBlockingCollection: TfrmBlockingCollection
  Left = 0
  Top = 0
  Caption = 'Blocking collection'
  ClientHeight = 436
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    622
    436)
  TextHeight = 15
  object btnStart: TButton
    Left = 8
    Top = 16
    Width = 145
    Height = 25
    Caption = 'Producer/Consumer'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object Memo1: TMemo
    Left = 168
    Top = 17
    Width = 446
    Height = 411
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object btnStop: TButton
    Left = 72
    Top = 47
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 2
    OnClick = btnStopClick
  end
end
