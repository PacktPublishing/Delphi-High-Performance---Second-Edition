object frmTEnumerable: TfrmTEnumerable
  Left = 0
  Top = 0
  Caption = 'TEnumerable'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    628
    442)
  TextHeight = 15
  object btnTEnumerable2: TButton
    Left = 8
    Top = 56
    Width = 129
    Height = 25
    Caption = 'Intersect, Union'
    TabOrder = 0
    OnClick = btnTEnumerable2Click
  end
  object btnTEnumerable1: TButton
    Left = 8
    Top = 16
    Width = 129
    Height = 25
    Caption = 'Range, From'
    TabOrder = 1
    OnClick = btnTEnumerable1Click
  end
  object ListBox1: TListBox
    Left = 152
    Top = 7
    Width = 474
    Height = 435
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 2
  end
end
