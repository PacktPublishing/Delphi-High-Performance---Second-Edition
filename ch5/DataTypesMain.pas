unit DataTypesMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TRecord = record
    a: integer;
    b: string;
    c: integer;
  end;

  TCustomRecord = record
  private
    class var GNextID: integer;
  public
    Value: integer;
    Name: string;
    class constructor Create;
    constructor Create(AValue: integer; const AName: string);
    class operator Initialize(out Dest: TCustomRecord);
    class operator Finalize(var Dest: TCustomRecord);
    class operator Assign(var Dest: TCustomRecord; const [ref] Src: TCustomRecord);
  end;

  TCustomObject = class
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TRecValue = record
    Value: integer;
//    constructor Create;
    constructor Create(AValue: integer); overload;
    class function Create: TRecValue; overload; static;
  end;

  TfrmDataTypes = class(TForm)
    btnCopyOnWrite: TButton;
    ListBox1: TListBox;
    btnSharedDynArrays: TButton;
    btnRecordInit: TButton;
    btnCopyRec: TButton;
    btnCustomManagedRecords: TButton;
    btnArrayOfRecords: TButton;
    btnRecordConstructors: TButton;
    btnExceptions: TButton;
    procedure btnArrayOfRecordsClick(Sender: TObject);
    procedure btnCopyOnWriteClick(Sender: TObject);
    procedure btnSharedDynArraysClick(Sender: TObject);
    procedure btnRecordInitClick(Sender: TObject);
    procedure btnCopyRecClick(Sender: TObject);
    procedure btnCustomManagedRecordsClick(Sender: TObject);
    procedure btnExceptionsClick(Sender: TObject);
    procedure btnRecordConstructorsClick(Sender: TObject);
  private
    procedure ShowRecord(const rec: TRecord);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDataTypes: TfrmDataTypes;

implementation

uses
  System.Diagnostics;

{$R *.dfm}

procedure TfrmDataTypes.btnCopyOnWriteClick(Sender: TObject);
var
  s1, s2: string;
begin
  s1 := 'Delphi';
  ListBox1.Items.Add(Format('s1 = %p [%d:%s]',
    [PPointer(@s1)^, PInteger(PNativeUInt(@s1)^-8)^, s1]));
  UniqueString(s1);
  ListBox1.Items.Add(Format('s1 = %p [%d:%s]',
    [PPointer(@s1)^, PInteger(PNativeUInt(@s1)^-8)^, s1]));
  s2 := s1;
  ListBox1.Items.Add(Format('s1 = %p [%d:%s], s2 = %p [%d:%s]',
    [PPointer(@s1)^, PInteger(PNativeUInt(@s1)^-8)^, s1,
     PPointer(@s2)^, PInteger(PNativeUInt(@s2)^-8)^, s2]));
  s2[1] := 'd';
  ListBox1.Items.Add(Format('s1 = %p [%d:%s], s2 = %p [%d:%s]',
    [PPointer(@s1)^, PInteger(PNativeUInt(@s1)^-8)^, s1,
     PPointer(@s2)^, PInteger(PNativeUInt(@s2)^-8)^, s2]));
end;


function ToStringArr(const arr: TArray<integer>): string;
var
  sarr: TArray<string>;
  i: Integer;
begin
  SetLength(sarr, Length(arr));
  for i := Low(arr) to High(arr) do
    sarr[i] := IntToStr(arr[i]);
  Result := ''.Join(', ', sarr);
end;

procedure TfrmDataTypes.btnSharedDynArraysClick(Sender: TObject);
var
  arr1, arr2: TArray<Integer>;
begin
  arr1 := [1, 2, 3, 4, 5];
  arr2 := arr1;
  ListBox1.Items.Add(Format('arr1 = %p [%s], arr2 = %p [%s]',
    [PPointer(@arr1)^, ToStringArr(arr1), PPointer(@arr2)^, ToStringArr(arr2)]));
  arr1[2] := 42;
  ListBox1.Items.Add(Format('arr1 = %p [%s], arr2 = %p [%s]',
    [PPointer(@arr1)^, ToStringArr(arr1), PPointer(@arr2)^, ToStringArr(arr2)]));
  SetLength(arr2, Length(arr2));
  arr1[2] := 17;
  ListBox1.Items.Add(Format('arr1 = %p [%s], arr2 = %p [%s]',
    [PPointer(@arr1)^, ToStringArr(arr1), PPointer(@arr2)^, ToStringArr(arr2)]));
end;

procedure TfrmDataTypes.ShowRecord(const rec: TRecord);
begin
  ListBox1.Items.Add(Format('a = %d, b = ''%s'', c = %d', [rec.a, rec.b, rec.c]));
end;

procedure TfrmDataTypes.btnRecordInitClick(Sender: TObject);
var
  rec: TRecord;
begin
  ShowRecord(rec);
  rec := Default(TRecord);
  ShowRecord(rec);
end;

type
  TUnmanaged = record
    a, b, c, d: NativeUInt;
  end;

  TManaged = record
    a, b, c, d: IInterface;
  end;

procedure TfrmDataTypes.btnCopyRecClick(Sender: TObject);
var
  u1, u2: TUnmanaged;
  m1, m2: TManaged;
  i: Integer;
  sw: TStopwatch;
begin
  u1 := Default(TUnmanaged);
  sw := TStopwatch.StartNew;
  for i := 1 to 1000000 do
    u2 := u1;
  sw.Stop;
  ListBox1.Items.Add(Format('TUnmanaged: %d ms', [sw.ElapsedMilliseconds]));

  m1 := Default(TManaged);
  sw := TStopwatch.StartNew;
  for i := 1 to 1000000 do
    m2 := m1;
  sw.Stop;
  ListBox1.Items.Add(Format('TManaged: %d ms', [sw.ElapsedMilliseconds]));
end;

procedure TfrmDataTypes.btnCustomManagedRecordsClick(Sender: TObject);
var
  a, b, c: TCustomRecord;
begin
  Listbox1.Items.Add('Create a');
  a := TCustomRecord.Create(42, 'record A');
  ListBox1.Items.Add(Format('a = "%s":%d', [a.Name, a.Value]));
  b.Create(17, 'record B');
  ListBox1.Items.Add(Format('b = "%s":%d', [b.Name, b.Value]));
  Listbox1.Items.Add('Assign c := ' + a.Name);
  c := a;
  ListBox1.Items.Add(Format('c = "%s":%d', [c.Name, c.Value]));
  Listbox1.Items.Add('Exit');
end;

procedure TfrmDataTypes.btnArrayOfRecordsClick(Sender: TObject);
var
  arr: array [1..2] of TCustomRecord;
  a1,a2,a3: TArray<TCustomRecord>;
begin
  Listbox1.Items.Add('Initialize a1');
  SetLength(a1, 3);
  ListBox1.Items.Add(Format('a1[0] = "%s":%d', [a1[0].Name, a1[0].Value]));
  Listbox1.Items.Add('Assign a2');
  a2 := a1;
  ListBox1.Items.Add(Format('a2[0] = "%s":%d', [a2[0].Name, a2[0].Value]));
  Listbox1.Items.Add('Copy a3');
  a3 := Copy(a1);
  ListBox1.Items.Add(Format('a3[0] = "%s":%d', [a3[0].Name, a3[0].Value]));
  Listbox1.Items.Add('Clear a1');
  SetLength(a1, 0);
  Listbox1.Items.Add('Clear a2');
  SetLength(a2, 0);
  Listbox1.Items.Add('Exit');
end;

procedure TfrmDataTypes.btnExceptionsClick(Sender: TObject);
begin
  var rec := Default(TCustomRecord);
  var obj := TCustomObject.Create;
  raise Exception.Create('Bang!');
end;

procedure TfrmDataTypes.btnRecordConstructorsClick(Sender: TObject);
var
  a, b: TRecValue;
begin
  a := TRecValue.Create(17);
  ListBox1.Items.Add('a = ' + IntToStr(a.Value));
  b := TRecValue.Create;
  ListBox1.Items.Add('b = ' + IntToStr(b.Value));
end;

{ TCustomRecord }

class constructor TCustomRecord.Create;
begin
  GNextID := 1;
end;

class operator TCustomRecord.Assign(var Dest: TCustomRecord;
  const [ref] Src: TCustomRecord);
begin
  Dest.Value := Src.Value;
  Dest.Name := '[Copy] ' + Src.Name;
  frmDataTypes.ListBox1.Items.Add(Format('...copying "%s":%d => "%s":%d',
    [Src.Name, Src.Value, Dest.Name, Dest.Value]));
end;

constructor TCustomRecord.Create(AValue: integer; const AName: string);
begin
  frmDataTypes.ListBox1.Items.Add(Format('...creating "%s":%d (was "%s":%d)',
    [AName, AValue, Name, Value]));
  Value := AValue;
  Name := AName;
end;

class operator TCustomRecord.Finalize(var Dest: TCustomRecord);
begin
  frmDataTypes.ListBox1.Items.Add(Format('...finalizing "%s":%d',
    [Dest.Name, Dest.Value]));
end;

class operator TCustomRecord.Initialize(out Dest: TCustomRecord);
begin
//  Dest.Value := 0;
  Dest.Name := 'Record ' + IntToStr(GNextID);
  Inc(GNextID);
  frmDataTypes.ListBox1.Items.Add(Format('...initializing "%s":%d',
    [Dest.Name, Dest.Value]));
end;

{ TRecValue }

constructor TRecValue.Create(AValue: integer);
begin
  // inherited Create;
  Value := AValue;
end;

class function TRecValue.Create: TRecValue;
begin
  Result.Value := 42;
end;

{ TCustomObject }

constructor TCustomObject.Create;
begin
  frmDataTypes.ListBox1.Items.Add('...creating object');
end;

destructor TCustomObject.Destroy;
begin
  frmDataTypes.ListBox1.Items.Add('...destroying object');
  inherited;
end;

end.
