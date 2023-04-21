object frmTrees: TfrmTrees
  Left = 0
  Top = 0
  Caption = 'Trees'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    624
    441)
  TextHeight = 15
  object btnRBTree1: TButton
    Left = 16
    Top = 16
    Width = 184
    Height = 25
    Caption = 'RB tree depth-first'
    TabOrder = 0
    OnClick = btnRBTree1Click
  end
  object ListBox1: TListBox
    Left = 216
    Top = 8
    Width = 400
    Height = 425
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 1
  end
  object btnRBTree2: TButton
    Left = 16
    Top = 56
    Width = 184
    Height = 25
    Caption = 'RB tree breadth-first'
    TabOrder = 2
    OnClick = btnRBTree2Click
  end
  object btnRBTree3: TButton
    Left = 16
    Top = 96
    Width = 184
    Height = 25
    Caption = 'RB tree <Key, Value>'
    TabOrder = 3
    OnClick = btnRBTree3Click
  end
end
