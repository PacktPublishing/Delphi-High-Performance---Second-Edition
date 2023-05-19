object frmParallelJoin: TfrmParallelJoin
  Left = 0
  Top = 0
  Caption = 'TParallel,Join'
  ClientHeight = 281
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    506
    281)
  TextHeight = 13
  object btnJoin3E: TButton
    Left = 16
    Top = 47
    Width = 138
    Height = 25
    Caption = 'Join Exception'
    TabOrder = 0
    OnClick = btnJoin3EClick
  end
  object ListBox1: TListBox
    Left = 176
    Top = 16
    Width = 301
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object btnJoinNoWait: TButton
    Left = 16
    Top = 135
    Width = 138
    Height = 25
    Caption = 'Join.NoWait'
    TabOrder = 1
    OnClick = btnJoinNoWaitClick
  end
  object btnJoinNoWaitE: TButton
    Left = 16
    Top = 166
    Width = 138
    Height = 25
    Caption = 'Join.NoWait Exception'
    TabOrder = 2
    OnClick = btnJoinNoWaitEClick
  end
  object btnJoin2: TButton
    Left = 16
    Top = 16
    Width = 138
    Height = 25
    Caption = 'Join 2 tasks'
    TabOrder = 4
    OnClick = btnJoin2Click
  end
end
