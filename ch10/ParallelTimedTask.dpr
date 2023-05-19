program ParallelTimedTask;

uses
  Vcl.Forms,
  ParallelTimedTaskMain in 'ParallelTimedTaskMain.pas' {frmTimedTask};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTimedTask, frmTimedTask);
  Application.Run;
end.
