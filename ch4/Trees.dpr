program Trees;

uses
  Vcl.Forms,
  TreesMain in 'TreesMain.pas' {frmTrees};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTrees, frmTrees);
  Application.Run;
end.
