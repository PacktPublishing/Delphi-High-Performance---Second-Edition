unit SetDictionaryMultiMapMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections;

type
  TfrmSetMultiMap = class(TForm)
    ListBox1: TListBox;
    btnSet: TButton;
    btnTestMultimap: TButton;
    btnDictionary: TButton;
    btnBidiDict: TButton;
    procedure btnBidiDictClick(Sender: TObject);
    procedure btnDictionaryClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnTestMultimapClick(Sender: TObject);
  private
    function IntToString(const val: integer): string;
    function Join(const delim: string; const enum: IEnumerable<integer>): string;
    procedure TestDictionary(const name: string; const dict: IDictionary<string,integer>);
    procedure TestMultiMap(const name: string; const mmap: IMultiMap<integer,string>);
    procedure TestSet(const name: string; const aset: ICollection<integer>);
  public
  end;

var
  frmSetMultiMap: TfrmSetMultiMap;

implementation

{$R *.dfm}

procedure TfrmSetMultiMap.btnBidiDictClick(Sender: TObject);
var
  bidi: IBidiDictionary<integer, string>;
begin
  bidi := TCollections.CreateBidiDictionary<integer, string>;
  bidi.Add(3, 'three');
  bidi.Add(2, 'two');
  bidi.Add(1, 'one');

  ListBox1.Items.Add('Item[2] = ' + bidi.Items[2]);
  ListBox1.Items.Add('Item[''three''] = ' + IntToStr(bidi.Inverse.Items['three']));

  ListBox1.Items.Add(name + ': ' +
    string.Join(', ', 
                TEnumerable.Select<TPair<string,integer>,string>(
                  bidi.Inverse,
                  function (const kv: TPair<string,integer>): string
                  begin
                    Result := kv.Key + ':' + IntToStr(kv.Value);
                  end){.Ordered}.ToArray));
end;

procedure TfrmSetMultiMap.TestDictionary(const name: string;
  const dict: IDictionary<string, integer>);
begin
  dict.Add('three', 3);
  dict.Add('two', 2);
  dict.Add('one', 1);

  ListBox1.Items.Add(name + ': ' +
    string.Join(', ',
                TEnumerable.Select<TPair<string,integer>,string>(
                  dict,
                  function (const kv: TPair<string,integer>): string
                  begin
                    Result := kv.Key + ':' + IntToStr(kv.Value);
                  end).ToArray));
end;

procedure TfrmSetMultiMap.btnDictionaryClick(Sender: TObject);
begin
  TestDictionary('Dictionary', TCollections.CreateDictionary<string,integer>);
  TestDictionary('SortedDictionary', TCollections.CreateSortedDictionary<string,integer>);
end;

procedure TfrmSetMultiMap.TestSet(const name: string;
  const aset: ICollection<integer>);
var
  i: integer;
begin
  for i := 4 downto 1 do
    aset.Add(i);
  aset.Add(1);
  ListBox1.Items.Add(name + ': ' + Join(' ', aset));
end;

procedure TfrmSetMultiMap.btnSetClick(Sender: TObject);
begin
  TestSet('Set', TCollections.CreateSet<integer>);
  TestSet('SortedSet', TCollections.CreateSortedSet<integer>);
  TestSet('MultiSet', TCollections.CreateMultiSet<integer>);
  TestSet('SortedMultiSet', TCollections.CreateSortedMultiSet<integer>);
end;

procedure TfrmSetMultiMap.TestMultiMap(const name: string;
  const mmap: IMultiMap<integer, string>);
var
  i: integer;
  ch: char;
  sLog,s: string;
begin
  for i := 3 downto 1 do
    for ch := 'c' downto 'a' do begin
      mmap.Add(i, ch);
      mmap.Add(i, ch);
    end;

  sLog := '';
  for i in mmap.Keys do begin
    if sLog <> '' then
      sLog := sLog + ', ';
    sLog := sLog + IntToStr(i) + ':';
    for s in mmap[i] do
      sLog := sLog + s;
  end;
  ListBox1.Items.Add(name + ': ' + sLog);
end;

procedure TfrmSetMultiMap.btnTestMultimapClick(Sender: TObject);
begin
  TestMultiMap('MultiMap', TCollections.CreateMultiMap<integer,string>);
  TestMultiMap('HashMultiMap', TCollections.CreateHashMultiMap<integer,string>);
  TestMultiMap('TreeMultiMap', TCollections.CreateTreeMultiMap<integer,string>);
  TestMultiMap('SortedMultiMap', TCollections.CreateSortedMultiMap<integer,string>);
  TestMultiMap('SortedHashMultiMap', TCollections.CreateSortedHashMultiMap<integer,string>);
  TestMultiMap('SortedTreeMultiMap', TCollections.CreateSortedTreeMultiMap<integer,string>);
end;

function TfrmSetMultiMap.IntToString(const val: integer): string;
begin
  Result := IntToStr(val);
end;

function TfrmSetMultiMap.Join(const delim: string; const enum: IEnumerable<integer>):
  string;
begin
  Result := string.Join(delim, TEnumerable.Select<integer,string>(enum, IntToString).ToArray);
end;

end.
