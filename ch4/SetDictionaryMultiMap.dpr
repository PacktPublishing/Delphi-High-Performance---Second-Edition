program SetDictionaryMultiMap;

uses
  Vcl.Forms,
  SetDictionaryMultiMapMain in 'SetDictionaryMultiMapMain.pas' {frmSetMultiMap};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSetMultiMap, frmSetMultiMap);
  Application.Run;
end.
