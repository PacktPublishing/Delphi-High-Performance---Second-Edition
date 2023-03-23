object frmSetMultiMap: TfrmSetMultiMap
  Left = 0
  Top = 0
  Caption = 'Set, MultiSet, MultiMap'
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
    Left = 192
    Top = 8
    Width = 428
    Height = 426
    ItemHeight = 15
    TabOrder = 0
  end
  object btnSet: TButton
    Left = 8
    Top = 16
    Width = 169
    Height = 25
    Caption = 'Set'
    TabOrder = 1
    OnClick = btnSetClick
  end
  object btnTestMultimap: TButton
    Left = 8
    Top = 136
    Width = 169
    Height = 25
    Caption = 'MultiMap'
    TabOrder = 2
    OnClick = btnTestMultimapClick
  end
  object btnDictionary: TButton
    Left = 8
    Top = 56
    Width = 169
    Height = 25
    Caption = 'Dictionary'
    TabOrder = 3
    OnClick = btnDictionaryClick
  end
  object btnBidiDict: TButton
    Left = 8
    Top = 97
    Width = 169
    Height = 25
    Caption = 'Bidirectional dictionary'
    TabOrder = 4
    OnClick = btnBidiDictClick
  end
end
