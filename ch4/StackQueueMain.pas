unit StackQueueMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmStackQueueMain = class(TForm)
    ListBox1: TListBox;
    btnStack: TButton;
    btnQueue: TButton;
    btnDeque: TButton;
    btnBoundedQueue: TButton;
    btnEvictingQueue: TButton;
    procedure btnBoundedQueueClick(Sender: TObject);
    procedure btnDequeClick(Sender: TObject);
    procedure btnEvictingQueueClick(Sender: TObject);
    procedure btnQueueClick(Sender: TObject);
    procedure btnStackClick(Sender: TObject);
  private
  public
  end;

var
  frmStackQueueMain: TfrmStackQueueMain;

implementation

uses
  Spring.Collections, Spring.Collections.LinkedLists, Spring.Collections.Extensions;

{$R *.dfm}

procedure TfrmStackQueueMain.btnBoundedQueueClick(Sender: TObject);
var
  ch: char;
  queue: IQueue<string>;
begin
  queue := TCollections.CreateBoundedQueue<string>(5);
  for ch := '1' to '7' do
    queue.Enqueue(ch);
  ListBox1.Items.Add('BoundedQueue: ' + string.Join(' ', queue.ToArray));
end;

procedure TfrmStackQueueMain.btnDequeClick(Sender: TObject);
var
  i: integer;
  llDeque: IDeque<string>;
  s: string;
begin
  llDeque := TCollections.CreateDeque<string>;
  for i := 1 to 7 do
    if Odd(i) then
      llDeque.AddFirst(IntToStr(i))
    else
      llDeque.AddLast(IntToStr(i));
  ListBox1.Items.Add('Deque: ' + string.Join(' ', llDeque.ToArray));

  s := 'Deque remove: ';
  for i := 1 to 7 do
    if Odd(i) then
      s := s + llDeque.RemoveFirst + ' '
    else
      s := s + llDeque.RemoveLast + ' ';
  ListBox1.Items.Add(s);
end;

procedure TfrmStackQueueMain.btnEvictingQueueClick(Sender: TObject);
var
  ch: char;
  queue: IQueue<string>;
begin
  queue := TCollections.CreateEvictingQueue<string>(5);
  for ch := '1' to '7' do
    queue.Enqueue(ch);
  ListBox1.Items.Add('EvictingQueue: ' + string.Join(' ', queue.ToArray));
end;

procedure TfrmStackQueueMain.btnQueueClick(Sender: TObject);
var
  ch: char;
  queue: IQueue<string>;
  s: string;
begin
  queue := TCollections.CreateQueue<string>;
  for ch := '1' to '7' do
    queue.Enqueue(ch);
  ListBox1.Items.Add('Queue: ' + string.Join(' ', queue.ToArray));

  s := 'Queue remove: ';
  while not queue.IsEmpty do
    s := s + queue.Dequeue + ' ';
  ListBox1.Items.Add(s);
end;

procedure TfrmStackQueueMain.btnStackClick(Sender: TObject);
var
  ch: char;
  stack: IStack<string>;
  s: string;
begin
  stack := TCollections.CreateStack<string>;
  for ch := '1' to '7' do
    stack.Push(ch);
  ListBox1.Items.Add('Stack: ' + string.Join(' ', stack.ToArray));

  s := 'Stack remove: ';
  while not stack.IsEmpty do
    s := s + stack.Pop + ' ';
  ListBox1.Items.Add(s);
end;

end.
