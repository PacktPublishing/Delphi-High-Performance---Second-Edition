object frmDataTypes: TfrmDataTypes
  Left = 0
  Top = 0
  Caption = 'Data types'
  ClientHeight = 467
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    635
    467)
  TextHeight = 13
  object btnCopyOnWrite: TButton
    Left = 16
    Top = 16
    Width = 161
    Height = 41
    Caption = 'string copy-on-write'
    TabOrder = 0
    OnClick = btnCopyOnWriteClick
  end
  object ListBox1: TListBox
    Left = 192
    Top = 16
    Width = 419
    Height = 433
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
  end
  object btnSharedDynArrays: TButton
    Left = 16
    Top = 72
    Width = 161
    Height = 41
    Caption = 'shared dynamic arrays'
    TabOrder = 2
    OnClick = btnSharedDynArraysClick
  end
  object btnRecordInit: TButton
    Left = 16
    Top = 128
    Width = 161
    Height = 41
    Caption = 'record initialization'
    TabOrder = 3
    OnClick = btnRecordInitClick
  end
  object btnCopyRec: TButton
    Left = 16
    Top = 184
    Width = 161
    Height = 41
    Caption = 'record copying'
    TabOrder = 4
    OnClick = btnCopyRecClick
  end
  object btnCustomManagedRecords: TButton
    Left = 16
    Top = 240
    Width = 161
    Height = 41
    Caption = 'custom managed records'
    TabOrder = 5
    OnClick = btnCustomManagedRecordsClick
  end
  object btnArrayOfRecords: TButton
    Left = 16
    Top = 296
    Width = 161
    Height = 41
    Caption = 'array of custom records'
    TabOrder = 6
    OnClick = btnArrayOfRecordsClick
  end
  object btnRecordConstructors: TButton
    Left = 16
    Top = 352
    Width = 161
    Height = 41
    Caption = 'record constructors'
    TabOrder = 7
    OnClick = btnRecordConstructorsClick
  end
  object btnExceptions: TButton
    Left = 16
    Top = 408
    Width = 161
    Height = 41
    Caption = 'automatic exception handling'
    TabOrder = 8
    OnClick = btnExceptionsClick
  end
end
