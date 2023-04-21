object frmStackQueueMain: TfrmStackQueueMain
  Left = 0
  Top = 0
  Caption = 'Stack, Queue, Deque'
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
  object ListBox1: TListBox
    Left = 208
    Top = 8
    Width = 402
    Height = 425
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 0
  end
  object btnStack: TButton
    Left = 8
    Top = 16
    Width = 185
    Height = 25
    Caption = 'Stack'
    TabOrder = 1
    OnClick = btnStackClick
  end
  object btnQueue: TButton
    Left = 8
    Top = 56
    Width = 185
    Height = 25
    Caption = 'Queue'
    TabOrder = 2
    OnClick = btnQueueClick
  end
  object btnDeque: TButton
    Left = 8
    Top = 160
    Width = 185
    Height = 25
    Caption = 'Double-ended queue'
    TabOrder = 3
    OnClick = btnDequeClick
  end
  object btnBoundedQueue: TButton
    Left = 8
    Top = 87
    Width = 185
    Height = 25
    Caption = 'BoundedQueue'
    TabOrder = 4
    OnClick = btnBoundedQueueClick
  end
  object btnEvictingQueue: TButton
    Left = 8
    Top = 118
    Width = 185
    Height = 25
    Caption = 'EvictingQueue'
    TabOrder = 5
    OnClick = btnEvictingQueueClick
  end
end
