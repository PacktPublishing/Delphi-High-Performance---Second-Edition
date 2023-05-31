unit IListMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections;

type
  TfrmIList = class(TForm)
    ListBox1: TListBox;
    btnList: TButton;
    btnIList: TButton;
    btnOnChange: TButton;
    procedure btnIListClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure btnOnChangeClick(Sender: TObject);
  private
    function ActionToString(Action: TCollectionChangedAction): string;
    function IntToString(const val: integer): string;
    function Join(const delim: string; const data: TArray<integer>): string;
    procedure LogChange(Sender: TObject; const Item: integer;
      Action: TCollectionChangedAction);
  public
  end;

var
  frmIList: TfrmIList;

implementation

{$R *.dfm}

function TfrmIList.ActionToString(Action: TCollectionChangedAction): string;
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

procedure TfrmIList.btnIListClick(Sender: TObject);
var
  i: integer;
  list: IList<integer>;
  loc: integer;
begin
  list := TCollections.CreateList<integer>;
  for i := 1 to 5 do list.Add(i);
  list.AddRange(list);
  list.Insert(5, 6);
  ListBox1.Items.Add('IList: ' + Join(' ', list.ToArray));
  list.Sort;
  ListBox1.Items.Add('Sorted: ' + Join(' ', list.ToArray));
  ListBox1.Items.Add('Pos(5): ' + IntToStr(list.IndexOf(5)));
  ListBox1.Items.Add('LastPos(5): ' + IntToStr(list.LastIndexOf(5)));
  if TArray.BinarySearch<integer>(list.ToArray, 5, loc) then
    ListBox1.Items.Add('Search(5): ' + IntToStr(loc));
  list.Reverse;
  ListBox1.Items.Add('Reversed: ' + Join(' ', list.ToArray));
end;

procedure TfrmIList.btnListClick(Sender: TObject);
var
  i: integer;
  list: TList<integer>;
  loc: integer;
begin
  list := TList<integer>.Create;
  for i := 1 to 5 do list.Add(i);
  list.AddRange(list);
  list.Insert(5, 6);
  ListBox1.Items.Add('TList: ' + Join(' ', list.ToArray));
  list.Sort;
  ListBox1.Items.Add('Sorted: ' + Join(' ', list.ToArray));
  ListBox1.Items.Add('Pos(5): ' + IntToStr(list.IndexOf(5)));
  if list.BinarySearch(5, loc) then
    ListBox1.Items.Add('Search(5): ' + IntToStr(loc));
  list.Free;
end;

procedure TfrmIList.btnOnChangeClick(Sender: TObject);
var
  list: IList<integer>;
begin
  list := TCollections.CreateList<integer>;
  list.OnChanged.Add(LogChange);
  ListBox1.Items.Add('Add');
  list.Add(1);
  list.Add(2);
  ListBox1.Items.Add('Change');
  list[0] := 42;
  ListBox1.Items.Add('Delete');
  list.Delete(1);
  ListBox1.Items.Add('Destroy');
end;

function TfrmIList.IntToString(const val: integer): string;
begin
  Result := IntToStr(val);
end;

function TfrmIList.Join(const delim: string; const data: TArray<integer>): string;
begin
  Result := string.Join(delim, TEnumerable.Select<integer,string>(
                                 TEnumerable.From(data), IntToString).ToArray);
end;

procedure TfrmIList.LogChange(Sender: TObject; const Item: integer;
  Action: TCollectionChangedAction);
begin
  ListBox1.Items.Add('    ' + ActionToString(Action) + ' ' + IntToStr(Item));
end;

end.
