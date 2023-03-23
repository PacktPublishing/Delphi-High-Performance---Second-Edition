object Form23: TForm23
  Left = 0
  Top = 0
  Caption = 'Form23'
  ClientHeight = 471
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 48
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object lbLog: TListBox
    Left = 32
    Top = 120
    Width = 217
    Height = 241
    ItemHeight = 15
    TabOrder = 1
  end
  object Button2: TButton
    Left = 240
    Top = 72
    Width = 75
    Height = 25
    Caption = 'TList'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 48
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Queue grow'
    TabOrder = 3
    OnClick = Button3Click
  end
end
