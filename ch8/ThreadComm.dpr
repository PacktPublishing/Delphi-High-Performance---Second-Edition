program ThreadComm;

uses
  Vcl.Forms,
  ThreadCommMain in 'ThreadCommMain.pas' {frmThreadComm},
  DHPThreads in 'DHPThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmThreadComm, frmThreadComm);
  Application.Run;
end.
