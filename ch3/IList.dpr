program IList;

uses
  Vcl.Forms,
  IListMain in 'IListMain.pas' {frmIList};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmIList, frmIList);
  Application.Run;
end.
