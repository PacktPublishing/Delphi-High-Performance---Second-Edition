object frmParallelTasks: TfrmParallelTasks
  Left = 0
  Top = 0
  Caption = 'Parallel tasks'
  ClientHeight = 311
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  DesignSize = (
    665
    311)
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 152
    Width = 82
    Height = 13
    Caption = 'Number of tasks:'
  end
  object btnCheckPrimes1: TButton
    Left = 24
    Top = 208
    Width = 113
    Height = 25
    Caption = 'Check primes 1'
    TabOrder = 5
    OnClick = btnCheckPrimes1Click
  end
  object inpNumTasks: TSpinEdit
    Left = 24
    Top = 171
    Width = 82
    Height = 22
    MaxValue = 64
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object ListBox1: TListBox
    Left = 152
    Top = 16
    Width = 489
    Height = 278
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 7
  end
  object btnCheckPrimes2: TButton
    Left = 24
    Top = 239
    Width = 113
    Height = 25
    Caption = 'Check primes 2'
    TabOrder = 6
    OnClick = btnCheckPrimes2Click
  end
  object btnRunTasks: TButton
    Left = 24
    Top = 16
    Width = 113
    Height = 25
    Caption = 'Run tasks'
    TabOrder = 0
    OnClick = btnRunTasksClick
  end
  object btnAsyncTask: TButton
    Left = 24
    Top = 47
    Width = 113
    Height = 25
    Caption = 'Async TTask'
    TabOrder = 1
    OnClick = btnAsyncTaskClick
  end
  object btnException2: TButton
    Left = 24
    Top = 110
    Width = 113
    Height = 25
    Caption = 'Exception 2'
    TabOrder = 3
    OnClick = btnException2Click
  end
  object btnException1: TButton
    Left = 24
    Top = 79
    Width = 113
    Height = 25
    Caption = 'Exception 1'
    TabOrder = 2
    OnClick = btnException1Click
  end
  object TimerCheckTask: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerCheckTaskTimer
    Left = 184
    Top = 32
  end
end
