program MultipleWorkers;

uses
  System.StartUpCopy,
  FMX.Forms,
  MultipleWorkersMain in 'MultipleWorkersMain.pas' {frmMultipleWorkers};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMultipleWorkers, frmMultipleWorkers);
  Application.Run;
end.
