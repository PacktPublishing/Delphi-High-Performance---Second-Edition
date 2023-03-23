object frmEnumerable: TfrmEnumerable
  Left = 0
  Top = 0
  Caption = 'IEnumerable<T>'
  ClientHeight = 451
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    634
    451)
  TextHeight = 15
  object ListBox1: TListBox
    Left = 152
    Top = 8
    Width = 474
    Height = 435
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 0
  end
  object btnIEnumerable1: TButton
    Left = 8
    Top = 56
    Width = 129
    Height = 25
    Caption = 'Where'
    TabOrder = 1
    OnClick = btnIEnumerable1Click
  end
  object btnIEnumerable2: TButton
    Left = 8
    Top = 96
    Width = 129
    Height = 25
    Caption = 'Chaining'
    TabOrder = 2
    OnClick = btnIEnumerable2Click
  end
  object btnIEnumerable3: TButton
    Left = 8
    Top = 216
    Width = 129
    Height = 25
    Caption = 'Single'
    TabOrder = 3
    OnClick = btnIEnumerable3Click
  end
  object btnIEnumerable4: TButton
    Left = 8
    Top = 136
    Width = 129
    Height = 25
    Caption = 'Deferred execution'
    TabOrder = 4
    OnClick = btnIEnumerable4Click
  end
  object btnForIn: TButton
    Left = 8
    Top = 16
    Width = 129
    Height = 25
    Caption = 'for .. in'
    TabOrder = 5
    OnClick = btnForInClick
  end
  object btnEnumerable5: TButton
    Left = 8
    Top = 176
    Width = 129
    Height = 25
    Caption = 'Deferred execution 2'
    TabOrder = 6
    OnClick = btnEnumerable5Click
  end
end
