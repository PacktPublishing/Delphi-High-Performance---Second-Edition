object frmParallelMap: TfrmParallelMap
  Left = 0
  Top = 0
  Caption = 'Parallel Map'
  ClientHeight = 411
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    629
    411)
  TextHeight = 13
  object lbLog: TListBox
    Left = 96
    Top = 16
    Width = 525
    Height = 387
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnSerial: TButton
    Left = 8
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Serial'
    TabOrder = 1
    OnClick = btnSerialClick
  end
  object btnParallel: TButton
    Left = 8
    Top = 47
    Width = 75
    Height = 25
    Caption = 'Parallel'
    TabOrder = 2
    OnClick = btnParallelClick
  end
end
