unit TEnumerableMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections, Spring.Collections.Adapters;

type
  TfrmTEnumerable = class(TForm)
    btnTEnumerable2: TButton;
    btnTEnumerable1: TButton;
    ListBox1: TListBox;
    procedure btnTEnumerable1Click(Sender: TObject);
    procedure btnTEnumerable2Click(Sender: TObject);
  private
    function IntToString(const val: integer): string;
    function Join(const delim: string;
      const enum: IEnumerable<integer>): string;
  public
  end;

var
  frmTEnumerable: TfrmTEnumerable;

implementation

{$R *.dfm}

procedure TfrmTEnumerable.btnTEnumerable1Click(Sender: TObject);
var
  list: TList<integer>;
begin
  list := TList<integer>.Create(TEnumerable.Range(11, 9).ToArray);
  ListBox1.Items.Add('Range(11,9): ' +
    Join(' ', TEnumerable.From<integer>(list)));
  list.Free;
end;

procedure TfrmTEnumerable.btnTEnumerable2Click(Sender: TObject);
var
  l1,l2: TList<integer>;
begin
  l1 := TList<integer>.Create;
  l2 := TList<integer>.Create;
  for var i := 1 to 10 do begin
    l1.Add(i*3);
    l2.Add(i*5);
  end;

  ListBox1.Items.Add('Intersect: ' + Join(',',
    TEnumerable.Intersect<integer>(
      TEnumerable.From<integer>(l1),
      TEnumerable.From<integer>(l2))));
  ListBox1.Items.Add('Union: ' + Join(',',
    TEnumerable.Union<integer>(
      TEnumerable.From<integer>(l1),
      TEnumerable.From<integer>(l2)).Ordered));

  l1.Free; l2.Free;
end;

function TfrmTEnumerable.IntToString(const val: integer): string;
begin
  Result := IntToStr(val);
end;

function TfrmTEnumerable.Join(const delim: string; const enum: IEnumerable<integer>): string;
begin
  Result := string.Join(delim, TEnumerable.Select<integer,string>(enum, IntToString).ToArray);
end;

end.
