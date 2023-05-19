program LinkRetrieval;

uses
  Vcl.Forms,
  linkRetrieval1 in 'linkRetrieval1.pas' {frmLinkRetrieval};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLinkRetrieval, frmLinkRetrieval);
  Application.Run;
end.
