program ParallelMap;

uses
  Forms,
  ParallelMapMain in 'ParallelMapMain.pas' {frmParallelMap};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmParallelMap, frmParallelMap);
  Application.Run;
end.
