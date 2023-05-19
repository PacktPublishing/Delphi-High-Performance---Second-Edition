object frmParallelTask: TfrmParallelTask
  Left = 0
  Top = 0
  Caption = 'Parallel task'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    628
    442)
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 50
    Width = 59
    Height = 15
    Caption = 'Num tasks:'
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 153
    Height = 25
    Caption = 'Create random data'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 184
    Top = 16
    Width = 436
    Height = 418
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    TabOrder = 1
  end
  object SpinEdit1: TSpinEdit
    Left = 96
    Top = 47
    Width = 73
    Height = 24
    MaxValue = 0
    MinValue = 1
    TabOrder = 2
    Value = 0
  end
end
