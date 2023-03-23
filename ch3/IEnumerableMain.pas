unit IEnumerableMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring, Spring.Collections, Spring.Collections.Adapters;

type
  TfrmEnumerable = class(TForm)
    ListBox1: TListBox;
    btnIEnumerable1: TButton;
    btnIEnumerable2: TButton;
    btnIEnumerable3: TButton;
    btnIEnumerable4: TButton;
    btnForIn: TButton;
    btnEnumerable5: TButton;
    procedure btnEnumerable5Click(Sender: TObject);
    procedure btnForInClick(Sender: TObject);
    procedure btnTEnumerable1Click(Sender: TObject);
    procedure btnTEnumerable2Click(Sender: TObject);
    procedure btnIEnumerable1Click(Sender: TObject);
    procedure btnIEnumerable2Click(Sender: TObject);
    procedure btnIEnumerable3Click(Sender: TObject);
    procedure btnIEnumerable4Click(Sender: TObject);
  private
    function DivisibleBy(const num: integer): Predicate<integer>;
    function IntToString(const val: integer): string;
    function IsDivisibleBy3(const i: integer): boolean;
    function Join(const delim: string; const enum: IEnumerable<integer>): string;
  public
  end;

var
  frmEnumerable: TfrmEnumerable;

implementation

{$R *.dfm}

procedure TfrmEnumerable.btnEnumerable5Click(Sender: TObject);
var
  list: IList<integer>;
  filter: IEnumerable<integer>;
begin
  list := TCollections.CreateList<integer>;
  filter := list.Where(IsDivisibleBy3);
  list.AddRange([1, 2, 3]);
  ListBox1.Items.Add(Join(',', filter));
  list.AddRange([4, 5, 6]);
  ListBox1.Items.Add(Join(',', filter));
end;

procedure TfrmEnumerable.btnForInClick(Sender: TObject);
var
  enum: IEnumerable<integer>;
  i: integer;
begin
  enum := TEnumerable.Range(1, 5);
  for i in enum do
    ListBox1.Items.Add(IntToStr(i));
end;

procedure TfrmEnumerable.btnIEnumerable1Click(Sender: TObject);
var
  enum: IEnumerable<integer>;
begin
  enum := TEnumerable.Range(1, 20);
  ListBox1.Items.Add('Where/3: ' + Join(',', enum.Where(IsDivisibleBy3)));
  ListBox1.Items.Add('Where/5: ' + Join(',',
    enum.Where(function (const i: integer): boolean begin Result := (i mod 5) = 0 end)));
end;

procedure TfrmEnumerable.btnIEnumerable2Click(Sender: TObject);
var
  enum: IEnumerable<integer>;
begin
  enum := TEnumerable.Range(1, 10);
  ListBox1.Items.Add('Skip: ' + Join(',',
    enum.Skip(3).SkipLast(3).Reversed));
end;

procedure TfrmEnumerable.btnIEnumerable3Click(Sender: TObject);
begin
  ShowMessage(
    TEnumerable.Range(1, 20)
      .Where(DivisibleBy(3))
      .Where(DivisibleBy(5))
      .Single.ToString);
end;

procedure TfrmEnumerable.btnIEnumerable4Click(Sender: TObject);
var
  enum: IEnumerable<integer>;
  filtered: IEnumerable<integer>;
  i: integer;
begin
  enum := TEnumerable.Range(1, 200);
  filtered := enum.Where(
             function (const value: integer): boolean
             begin
               Result := Odd(value);
               ListBox1.Items.Add('? ' + IntToStr(value));
             end)
             .Take(3);
  ListBox1.Items.Add('Start');
  for i in filtered do
    ListBox1.Items.Add('=> ' + IntToStr(i));
end;

procedure TfrmEnumerable.btnTEnumerable1Click(Sender: TObject);
var
  list: TList<integer>;
begin
  list := TList<integer>.Create(TEnumerable.Range(1, 10).ToArray);
  ListBox1.Items.Add('Range(1,10): ' +
    Join(' ', TEnumerable.From<integer>(list)));
  list.Free;
end;

procedure TfrmEnumerable.btnTEnumerable2Click(Sender: TObject);
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

function TfrmEnumerable.DivisibleBy(const num: integer): Predicate<integer>;
begin
  Result :=
    function (const i: integer): boolean
    begin
      Result := (i mod num) = 0;
    end;
end;

function TfrmEnumerable.IntToString(const val: integer): string;
begin
  Result := IntToStr(val);
end;

function TfrmEnumerable.IsDivisibleBy3(const i: integer): boolean;
begin
  Result := (i mod 3) = 0;
end;

function TfrmEnumerable.Join(const delim: string; const enum: IEnumerable<integer>): string;
begin
  Result := ''.Join(delim, TEnumerable.Select<integer,string>(enum, IntToString).ToArray);
end;

end.
