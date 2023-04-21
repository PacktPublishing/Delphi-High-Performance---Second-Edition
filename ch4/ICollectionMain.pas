unit ICollectionMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections;

type
  TfrmICollection = class(TForm)
    ListBox1: TListBox;
    btnDemo: TButton;
    procedure btnDemoClick(Sender: TObject);
  private
    function ActionToString(Action: TCollectionChangedAction): string;
    function IntToString(const val: integer): string;
    function Join(const delim: string;
      const enum: IEnumerable<integer>): string;
    procedure LogChange(Sender: TObject; const Item: integer;
      Action: TCollectionChangedAction);
  public
  end;

var
  frmICollection: TfrmICollection;

implementation

{$R *.dfm}

function TfrmICollection.ActionToString(
  Action: TCollectionChangedAction): string;
begin
  case Action of
    caAdded:     Result := 'Added';
    caRemoved:   Result := 'Removed';
    caExtracted: Result := 'Extracted';
    caReplaced:  Result := 'Replaced';
    caMoved:     Result := 'Moved';
    caReset:     Result := 'Reset';
    caChanged:   Result := 'Changed';
    else         Result := '<<unknown>>';
  end;
end;

procedure TfrmICollection.btnDemoClick(Sender: TObject);
var
  coll: ICollection<integer>;
  enum: TArray<integer>;
begin
  coll := TCollections.CreateSet<integer>;
  coll.OnChanged.Add(LogChange);
  ListBox1.Items.Add('Add');
  coll.Add(1);
  ListBox1.Items.Add('AddRange');
  coll.AddRange(TEnumerable.Range(2,7));
  ListBox1.Items.Add('RemoveAll');
  coll.RemoveAll(
    function (const item: integer): boolean
    begin
      Result := Odd(item);
    end);
  ListBox1.Items.Add('ExtractAll');
  enum := coll.ExtractAll(
    function (const item: integer): boolean
    begin
      Result := (item mod 4) = 0;
    end);
  ListBox1.Items.Add('Extracted');
  ListBox1.Items.Add('    ' + Join(' ', TEnumerable.From<integer>(enum)));
  ListBox1.Items.Add('Remaining');
  ListBox1.Items.Add('    ' + Join(' ', coll));
  ListBox1.Items.Add('Exit');
end;

function TfrmICollection.IntToString(const val: integer): string;
begin
  Result := IntToStr(val);
end;

function TfrmICollection.Join(const delim: string; const enum: IEnumerable<integer>): string;
begin
  Result := ''.Join(delim, TEnumerable.Select<integer,string>(enum, IntToString).ToArray);
end;

procedure TfrmICollection.LogChange(Sender: TObject; const Item: integer;
  Action: TCollectionChangedAction);
begin
  ListBox1.Items.Add('    ' + ActionToString(Action) + ' ' + IntToStr(Item));
end;

end.
