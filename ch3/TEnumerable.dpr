program TEnumerable;

uses
  Vcl.Forms,
  TEnumerableMain in 'TEnumerableMain.pas' {frmTEnumerable};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTEnumerable, frmTEnumerable);
  Application.Run;
end.
