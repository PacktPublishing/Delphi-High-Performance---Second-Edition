program ParallelTask;

uses
  Vcl.Forms,
  ParallelTaskMain in 'ParallelTaskMain.pas' {frmParallelTask};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmParallelTask, frmParallelTask);
  Application.Run;
end.
