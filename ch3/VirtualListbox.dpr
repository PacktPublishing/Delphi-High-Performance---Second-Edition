program VirtualListbox;

uses
  Vcl.Forms,
  VirtualListboxMain in 'VirtualListboxMain.pas' {frmVirtualListbox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmVirtualListbox, frmVirtualListbox);
  Application.Run;
end.
