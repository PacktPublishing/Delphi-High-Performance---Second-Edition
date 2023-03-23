program ICollection;

uses
  Vcl.Forms,
  ICollectionMain in 'ICollectionMain.pas' {frmICollection};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmICollection, frmICollection);
  Application.Run;
end.
