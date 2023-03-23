object frmVirtualListbox: TfrmVirtualListbox
  Left = 0
  Top = 0
  Caption = 'Virtual listbox'
  ClientHeight = 545
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 357
    Height = 57
    Caption = 'Add lines'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 88
    Width = 357
    Height = 421
    Style = lbVirtual
    ItemHeight = 13
    TabOrder = 1
    OnData = ListBox1Data
    OnDataFind = ListBox1DataFind
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 526
    Width = 389
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitWidth = 761
  end
end
