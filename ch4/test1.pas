unit test1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections;

type
  TForm23 = class(TForm)
    Button1: TButton;
    lbLog: TListBox;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure Dump(enum: IEnumerable<integer>);
  public
    { Public declarations }
  end;

var
  Form23: TForm23;

implementation

{$R *.dfm}

procedure TForm23.Dump(enum: IEnumerable<integer>);
var
  s: string;
  i: integer;
begin
  s := '';
  for i in enum do
    s := s + IntToStr(i) + ' ';
  lbLog.Items.Add(s);
end;

procedure TForm23.Button1Click(Sender: TObject);
var
  i: integer;
begin
  var dict := TCollections.CreateSet<integer>;
  for i := 1 to 4 do begin
    dict.Add(i);
    Dump(dict);
  end;
end;

procedure TForm23.Button2Click(Sender: TObject);
begin
  var list := TList<integer>.Create([1, 2, 3, 3, 4, 4, 4]);
  lbLog.Items.Add(
    string.Join(' ',
      TEnumerable.Select<integer,string>(
        TEnumerable.Distinct<integer>(TEnumerable.From<integer>(list)),
        IntToStr).ToArray));
  list.Free;

  var l1 := TList<integer>.Create;
  var l2 := TList<integer>.Create;
  for var i := 1 to 20 do begin
    l1.Add(i*3);
    l2.Add(i*5);
  end;
  for var i in
    TEnumerable.Intersect<integer>(
      TEnumerable.From<integer>(l1),
      TEnumerable.From<integer>(l2))
  do
    lbLog.Items.Add(i.ToString);
  l1.Free; l2.Free;
end;

procedure TForm23.Button3Click(Sender: TObject);
begin
  var que := TCollections.CreateQueue<integer>;
//  TQueue<integer>(que).Capacity := 8;
  for var i := 1 to 4 do
    que.Enqueue(i);
  que.Dequeue();
  que.Dequeue();
  for var i := 5 to 10 do
    que.Enqueue(i);
end;

end.
