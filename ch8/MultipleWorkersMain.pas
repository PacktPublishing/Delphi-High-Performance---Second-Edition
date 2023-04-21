unit MultipleWorkersMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMultipleWorkers = class(TForm)
    btnWaitForMultiple: TButton;
    lblOutput: TLabel;
    btnCondVar: TButton;
    procedure btnCondVarClick(Sender: TObject);
    procedure btnWaitForMultipleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AsyncLogger(msg: string);
  public
  end;

var
  frmMultipleWorkers: TfrmMultipleWorkers;

implementation

{$IFDEF MSWINDOWS}
uses
  MultipleWorkers.WaitForMultiple,
{$ENDIF}
  MultipleWorkers.CondVar;

{$R *.fmx}

procedure TfrmMultipleWorkers.AsyncLogger(msg: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      lblOutput.Text := lblOutput.Text + msg;
    end);
end;

procedure TfrmMultipleWorkers.btnCondVarClick(Sender: TObject);
var
  test: TCondVarTest;
begin
  btnCondVar.Enabled := false;
  lblOutput.Text := 'Output: ';
  test := TCondVarTest.Create(10, AsyncLogger,
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          btnCondVar.Enabled := true;
        end);
    end);
  test.Run;
end;

procedure TfrmMultipleWorkers.btnWaitForMultipleClick(Sender: TObject);
{$IFDEF MSWINDOWS}
var
  test: TWaitForMultipleTest;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  btnWaitForMultiple.Enabled := false;
  lblOutput.Text := 'Output: ';
  test := TWaitForMultipleTest.Create(10, AsyncLogger,
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          btnWaitForMultiple.Enabled := true;
        end);
    end);
  test.Run;
  {$ENDIF}
end;

procedure TfrmMultipleWorkers.FormCreate(Sender: TObject);
begin
  btnWaitForMultiple.Enabled := {$IFDEF MSWINDOWS}true{$ELSE}false{$ENDIF};
  lblOutput.Text := '';
end;

end.
