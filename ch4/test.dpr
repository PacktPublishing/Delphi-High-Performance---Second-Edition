program test;

uses
  Vcl.Forms,
  test1 in 'test1.pas' {Form23};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm23, Form23);
  Application.Run;
end.
