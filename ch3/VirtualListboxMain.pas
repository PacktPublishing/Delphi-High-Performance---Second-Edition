unit VirtualListboxMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmVirtualListbox = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1Data(Control: TWinControl; Index: Integer; var Data: string);
    function ListBox1DataFind(Control: TWinControl; FindString: string): Integer;
  private
  public
  end;

var
  frmVirtualListbox: TfrmVirtualListbox;

implementation

uses
  System.Diagnostics;

{$R *.dfm}

const
  CNumLines = 10000;

procedure TfrmVirtualListbox.Button1Click(Sender: TObject);
var
  stopwatch: TStopwatch;
begin
  stopwatch := TStopwatch.Create;
  ListBox1.Count := CNumLines;
  stopwatch.Stop;
  StatusBar1.SimpleText := Format('ListBox: %d ms', [stopwatch.ElapsedMilliseconds]);
end;

procedure TfrmVirtualListbox.ListBox1Data(Control: TWinControl; Index: Integer;
  var Data: string);
begin
  Data := 'Line ' + IntToStr(Index + 1);
end;

function TfrmVirtualListbox.ListBox1DataFind(Control: TWinControl;
  FindString: string): Integer;
begin
  if Copy(FindString, 1, Length('Line ')) <> 'Line ' then
    Exit(-1);
  Delete(FindString, 1, Length('Line '));
  Result := StrToIntDef(FindString, 0) - 1;
end;

end.
