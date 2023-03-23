program IEnumerable;

uses
  Vcl.Forms,
  IEnumerableMain in 'IEnumerableMain.pas' {frmEnumerable};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmEnumerable, frmEnumerable);
  Application.Run;
end.
