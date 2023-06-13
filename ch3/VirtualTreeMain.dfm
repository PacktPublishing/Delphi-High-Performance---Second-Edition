object frmVTV: TfrmVTV
  Left = 0
  Top = 0
  Caption = 'Virtual TreeView'
  ClientHeight = 456
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 109
    Width = 31
    Height = 13
    Caption = 'listbox'
  end
  object Label2: TLabel
    Left = 192
    Top = 109
    Width = 77
    Height = 13
    Caption = 'virtual TreeView'
  end
  object lblLog10k: TLabel
    Left = 160
    Top = 29
    Width = 44
    Height = 13
    Caption = 'lblLog10k'
    Visible = False
  end
  object lblLogAdd100: TLabel
    Left = 160
    Top = 60
    Width = 64
    Height = 13
    Caption = 'lblLogAdd100'
    Visible = False
  end
  object Label3: TLabel
    Left = 360
    Top = 109
    Width = 125
    Height = 13
    Caption = 'virtual TreeView -autosort'
  end
  object Label4: TLabel
    Left = 527
    Top = 109
    Width = 118
    Height = 13
    Caption = 'virtual TreeView +OnInit'
  end
  object ListBox1: TListBox
    Left = 24
    Top = 128
    Width = 137
    Height = 313
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Add 10,000 lines'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 55
    Width = 121
    Height = 25
    Caption = 'Add 1 line 100 times'
    TabOrder = 2
    OnClick = Button2Click
  end
end
