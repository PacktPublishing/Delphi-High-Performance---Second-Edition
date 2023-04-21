object frmICollection: TfrmICollection
  Left = 0
  Top = 0
  Caption = 'ICollection<T>'
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
    Left = 168
    Top = 16
    Width = 452
    Height = 427
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 0
  end
  object btnDemo: TButton
    Left = 8
    Top = 16
    Width = 145
    Height = 25
    Caption = 'Demo'
    TabOrder = 1
    OnClick = btnDemoClick
  end
end
