unit TreesMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Spring.Collections, Spring.Collections.Trees;

type
  TfrmTrees = class(TForm)
    btnRBTree1: TButton;
    ListBox1: TListBox;
    btnRBTree2: TButton;
    btnRBTree3: TButton;
    procedure btnRBTree1Click(Sender: TObject);
    procedure btnRBTree2Click(Sender: TObject);
    procedure btnRBTree3Click(Sender: TObject);
  private
    function GenerateOptimalInsertionOrder(min, max: integer): IEnumerable<integer>;
  public
  end;

var
  frmTrees: TfrmTrees;

implementation

{$R *.dfm}

procedure TfrmTrees.btnRBTree1Click(Sender: TObject);
var
  tree: IRedBlackTree<integer>;
  i: integer;
  node: TNodes<integer>.PRedBlackTreeNode;
  s: string;
begin
  tree := TRedBlackTree<integer>.Create;
  for i := 15 downto 1 do
    tree.Add(i);

  s := '';
  for i in tree do s := s + IntToStr(i) + ' ';
  ListBox1.Items.Add('Enumerator: ' + s);

  s := '';
  for node in tree.Root.InOrder do
    s := s + IntToStr(node.Key) + ' ';
  ListBox1.Items.Add('InOrder: ' + s);

  s := '';
  for node in tree.Root.PreOrder do
    s := s + IntToStr(node.Key) + ' ';
  ListBox1.Items.Add('PreOrder: ' + s);

  s := '';
  for node in tree.Root.PostOrder do
    s := s + IntToStr(node.Key) + ' ';
  ListBox1.Items.Add('PostOrder: ' + s);
end;

procedure TfrmTrees.btnRBTree2Click(Sender: TObject);
var
  q, q2: IQueue<TNodes<integer>.PRedBlackTreeNode>;
  node: TNodes<integer>.PRedBlackTreeNode;
  t: IRedBlackTree<integer>;
  i: integer;
  s: string;
begin
  t := TRedBlackTree<integer>.Create;
//  for i := 1 to 15 do
  for i := 15 downto 1 do
//  for i in GenerateOptimalInsertionOrder(1, 15) do
    t.Add(i);

  q := TCollections.CreateQueue<TNodes<integer>.PRedBlackTreeNode>;
  q.Enqueue(TNodes<integer>.PRedBlackTreeNode(t.Root));
  while not q.IsEmpty do begin
    s := '';
    q2 := TCollections.CreateQueue<TNodes<integer>.PRedBlackTreeNode>;
    while not q.IsEmpty do begin
      node := q.Dequeue;
      if not assigned(node) then
        s := s + 'x '
      else begin
        s := s + IntToStr(node.Key) + IfThen(node.Color = Black, 'b ', 'r ');
        q2.Enqueue(node.Left);
        q2.Enqueue(node.Right);
      end;
    end;
    ListBox1.Items.Add(s);
    q := q2;
  end;
end;

procedure TfrmTrees.btnRBTree3Click(Sender: TObject);
var
  tree: IRedBlackTree<integer, string>;
  node: TPair<integer, string>;
begin
  tree := TRedBlackTree<integer, string>.Create;
  tree.Add(3, 'three');
  tree.Add(1, 'one');
  tree.Add(2, 'two');
  tree.Add(1, 'One');
  for node in tree do
    ListBox1.Items.Add(IntToStr(node.Key) + ': ' + node.Value);
end;

function TfrmTrees.GenerateOptimalInsertionOrder(min, max: integer): IEnumerable<integer>;
var
  i, j, prev: integer;
  output: array [boolean] of IQueue<integer>;
  skip: boolean;
  res: IStack<integer>;
begin
  skip := false;
  prev := min - 1;
  res := TCollections.CreateStack<integer>;
  output[false] := TCollections.CreateQueue<integer>;
  output[true] := TCollections.CreateQueue<integer>(TEnumerable.Range(min, max-min+1));
  while output[true].TryDequeue(i) do begin
    if i < prev then begin
      for j in output[false] do
        res.Push(j);
      output[false].Clear;
      skip := false;
    end;
    output[skip].Enqueue(i);
    skip := not skip;
    prev := i;
  end;
  res.Push(output[false].Single);
  Result := res;
end;

end.
