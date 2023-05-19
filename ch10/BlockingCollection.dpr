program BlockingCollection;

uses
  Vcl.Forms,
  BlockingCollectionMain in 'BlockingCollectionMain.pas' {frmBlockingCollection};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmBlockingCollection, frmBlockingCollection);
  Application.Run;
end.
