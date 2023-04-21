object frmIList: TfrmIList
  Left = 0
  Top = 0
  Caption = 'IList<T>'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ListBox1: TListBox
    Left = 160
    Top = 8
    Width = 460
    Height = 426
    ItemHeight = 15
    TabOrder = 0
  end
  object btnList: TButton
    Left = 8
    Top = 16
    Width = 137
    Height = 25
    Caption = 'List'
    TabOrder = 1
    OnClick = btnListClick
  end
  object btnIList: TButton
    Left = 8
    Top = 56
    Width = 137
    Height = 25
    Caption = 'IList'
    TabOrder = 2
    OnClick = btnIListClick
  end
  object btnOnChange: TButton
    Left = 8
    Top = 96
    Width = 137
    Height = 25
    Caption = 'OnChange'
    TabOrder = 3
    OnClick = btnOnChangeClick
  end
end
