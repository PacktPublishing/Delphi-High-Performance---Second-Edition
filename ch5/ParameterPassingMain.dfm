object frmParamPassing: TfrmParamPassing
  Left = 0
  Top = 0
  Caption = 'Parameter passing'
  ClientHeight = 443
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    471
    443)
  TextHeight = 13
  object btnArray: TButton
    Left = 24
    Top = 24
    Width = 105
    Height = 25
    Caption = 'array'
    TabOrder = 0
    OnClick = btnArrayClick
  end
  object btnConstArray: TButton
    Left = 24
    Top = 55
    Width = 105
    Height = 25
    Caption = 'const array'
    TabOrder = 1
    OnClick = btnConstArrayClick
  end
  object ListBox1: TListBox
    Left = 152
    Top = 24
    Width = 287
    Height = 396
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 14
  end
  object btnDynArray: TButton
    Left = 24
    Top = 86
    Width = 105
    Height = 25
    Caption = 'dyn array'
    TabOrder = 2
    OnClick = btnDynArrayClick
  end
  object btnConstDynArray: TButton
    Left = 24
    Top = 148
    Width = 105
    Height = 25
    Caption = 'const dyn array'
    TabOrder = 5
    OnClick = btnConstDynArrayClick
  end
  object btnRecord: TButton
    Left = 24
    Top = 302
    Width = 105
    Height = 25
    Caption = 'record'
    TabOrder = 10
    OnClick = btnRecordClick
  end
  object btnConstRecord: TButton
    Left = 24
    Top = 333
    Width = 105
    Height = 25
    Caption = 'const record'
    TabOrder = 11
    OnClick = btnConstRecordClick
  end
  object btnString: TButton
    Left = 24
    Top = 240
    Width = 105
    Height = 25
    Caption = 'string'
    TabOrder = 8
    OnClick = btnStringClick
  end
  object btnConstString: TButton
    Left = 24
    Top = 271
    Width = 105
    Height = 25
    Caption = 'const string'
    TabOrder = 9
    OnClick = btnConstStringClick
  end
  object btnConstInterface: TButton
    Left = 24
    Top = 395
    Width = 105
    Height = 25
    Caption = 'const interface'
    TabOrder = 13
    OnClick = btnConstInterfaceClick
  end
  object btnInterface: TButton
    Left = 24
    Top = 364
    Width = 105
    Height = 25
    Caption = 'interface'
    TabOrder = 12
    OnClick = btnInterfaceClick
  end
  object btnDynArray2: TButton
    Left = 24
    Top = 117
    Width = 50
    Height = 25
    Caption = '2'
    TabOrder = 3
    OnClick = btnDynArray2Click
  end
  object btnDynArray3: TButton
    Left = 79
    Top = 117
    Width = 50
    Height = 25
    Caption = '3'
    TabOrder = 4
    OnClick = btnDynArray3Click
  end
  object btnConstDynArray2: TButton
    Left = 24
    Top = 179
    Width = 50
    Height = 25
    Caption = '2'
    TabOrder = 6
    OnClick = btnConstDynArray2Click
  end
  object btnConstDynArray3: TButton
    Left = 79
    Top = 179
    Width = 50
    Height = 25
    Caption = '3'
    TabOrder = 7
    OnClick = btnConstDynArray3Click
  end
  object btnArraySlice: TButton
    Left = 24
    Top = 209
    Width = 105
    Height = 25
    Caption = 'array slice'
    TabOrder = 15
    OnClick = btnArraySliceClick
  end
end
