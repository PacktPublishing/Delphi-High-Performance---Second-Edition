program StackQueue;

uses
  Vcl.Forms,
  StackQueueMain in 'StackQueueMain.pas' {frmStackQueueMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmStackQueueMain, frmStackQueueMain);
  Application.Run;
end.
