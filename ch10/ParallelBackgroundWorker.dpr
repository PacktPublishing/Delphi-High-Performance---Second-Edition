program ParallelBackgroundWorker;

uses
  Vcl.Forms,
  ParallelBackgroundWorkerMain in 'ParallelBackgroundWorkerMain.pas' {frmBackgroundWorker};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBackgroundWorker, frmBackgroundWorker);
  Application.Run;
end.
