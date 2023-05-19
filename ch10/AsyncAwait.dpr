program AsyncAwait;

uses
  Vcl.Forms,
  AsyncAwaitMain in 'AsyncAwaitMain.pas' {frmAsyncAwait};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAsyncAwait, frmAsyncAwait);
  Application.Run;
end.
