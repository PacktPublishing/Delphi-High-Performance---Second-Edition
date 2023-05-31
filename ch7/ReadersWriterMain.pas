unit ReadersWriterMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmReadersWriter = class(TForm)
    lbLog: TListBox;
    btnCS: TButton;
    btnMREW: TButton;
    procedure btnCSClick(Sender: TObject);
    procedure btnMREWClick(Sender: TObject);
  private
    procedure LogResult(const name: string; const counters: TArray<integer>);
    procedure RunTests(const name: string; const mrew: IReadWriteSync);
    function  TestReader(list: TList<integer>; const mrew: IReadWriteSync): integer;
    function  TestWriter(list: TList<integer>; const mrew: IReadWriteSync): Integer;
  public
  end;

var
  frmReadersWriter: TfrmReadersWriter;

implementation

uses
  System.SyncObjs, System.Threading, System.Diagnostics,
  SlimReaderWriter;

{$R *.dfm}

const
  CTestDuration_sec = 3;
  CNumReaders = 6;

type
  TCSSync = class(TInterfacedObject, IReadWriteSync)
  private
    FLock: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
  end;

  TMREWSync = class(TInterfacedObject, IReadWriteSync)
  private
    FLock: TLightweightMREW;
  public
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
  end;

{ TCSSync }

constructor TCSSync.Create;
begin
  FLock := TCriticalSection.Create;
end;

destructor TCSSync.Destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TCSSync.BeginRead;
begin
  FLock.Acquire;
end;

function TCSSync.BeginWrite: Boolean;
begin
  FLock.Acquire;
  Result := true;
end;

procedure TCSSync.EndRead;
begin
  FLock.Release;
end;

procedure TCSSync.EndWrite;
begin
  FLock.Release;
end;

{ TMREWSync }

procedure TMREWSync.BeginRead;
begin
  FLock.BeginRead;
end;

function TMREWSync.BeginWrite: Boolean;
begin
  FLock.BeginWrite;
  Result := true;
end;

procedure TMREWSync.EndRead;
begin
  FLock.EndRead;
end;

procedure TMREWSync.EndWrite;
begin
  FLock.EndWrite;
end;

{ TfrmReadersWriter }

procedure TfrmReadersWriter.btnCSClick(Sender: TObject);
begin
  RunTests('TCSSync', TCSSync.Create);
end;

procedure TfrmReadersWriter.btnMREWClick(Sender: TObject);
begin
  RunTests('TMREWSync', TMREWSync.Create);
end;

procedure TfrmReadersWriter.LogResult(const name: string;
  const counters: TArray<integer>);
var
  s: string;
  iCntr: Integer;
begin
  s := '';
  for iCntr := 1 to High(counters) do
    s := s + counters[iCntr].ToString + ' ';
  lbLog.Items.Add(Format('%s: Writer %s Readers %s', [name, counters[0].ToString, s]));
end;

procedure TfrmReadersWriter.RunTests(const name: string;
  const mrew: IReadWriteSync);
var
  counters: TArray<integer>;
  i: Integer;
  sharedList: TList<integer>;
  tasks: TArray<ITask>;

  function MakeReader(idx: integer): TProc;
  begin
    Result :=
      procedure
      begin
        counters[idx] := TestReader(sharedList, mrew);
      end;
  end;

begin
  sharedList := TList<integer>.Create;
  try
    SetLength(tasks, CNumReaders + 1);
    SetLength(counters, Length(tasks));
    tasks[0] := TTask.Run(
      procedure
      begin
        counters[0] := TestWriter(sharedList, mrew);
      end);
    for i := 1 to CNumReaders do
      tasks[i] := TTask.Run(MakeReader(i));
    TTask.WaitForAll(tasks);
  finally
    FreeAndNil(sharedList);
  end;
  LogResult(name, counters);
end;

function TfrmReadersWriter.TestReader(list: TList<integer>;
  const mrew: IReadWriteSync): integer;
var
  a: real;
  el: Integer;
  timer: TStopwatch;
  i: Integer;
begin
  Result := 0;
  timer := TStopwatch.StartNew;
  while timer.ElapsedMilliseconds < (CTestDuration_sec * 1000) do
  begin
    mrew.BeginRead;
    try
      for el in list do
      begin
        a := 1/el;
        // simulate workload
        for i := 1 to 1000 do
          a := Cos(a);
      end;
    finally
      mrew.EndRead;
    end;
    Inc(Result);
    Sleep(1);
  end;
end;

function TfrmReadersWriter.TestWriter(list: TList<integer>;
  const mrew: IReadWriteSync): Integer;
var
  nextEl: Integer;
  timer: TStopwatch;
  i: Integer;
begin
  Result := 0;
  timer := TStopwatch.StartNew;
  nextEl := 1;
  while timer.ElapsedMilliseconds < (CTestDuration_sec * 1000) do
  begin
    mrew.BeginWrite;
    try
      list.Clear;
      list.Capacity := 1000;
      for i := 1 to 1000 do
      begin
        list.Add(nextEl);
        Inc(nextEl);
      end;
    finally
      mrew.EndWrite;
    end;
    Inc(Result);
    Sleep(100);
  end;
end;

end.
