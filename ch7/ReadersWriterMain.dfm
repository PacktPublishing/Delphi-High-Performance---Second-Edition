object frmReadersWriter: TfrmReadersWriter
  Left = 0
  Top = 0
  Caption = 'Readers-writer locking'
  ClientHeight = 136
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    519
    136)
  TextHeight = 13
  object lbLog: TListBox
    Left = 176
    Top = 16
    Width = 322
    Height = 105
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 2
  end
  object btnCS: TButton
    Left = 17
    Top = 16
    Width = 137
    Height = 49
    Caption = 'TCriticalSection'
    TabOrder = 0
    OnClick = btnCSClick
  end
  object btnMREW: TButton
    Left = 17
    Top = 71
    Width = 137
    Height = 49
    Caption = 'TLightweightMREW'
    TabOrder = 1
    OnClick = btnMREWClick
  end
end
