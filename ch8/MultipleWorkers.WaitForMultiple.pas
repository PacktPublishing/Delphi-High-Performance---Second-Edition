unit MultipleWorkers.WaitForMultiple;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.SyncObjs, System.Diagnostics;

type
  TWaitForMultipleTest = class
  strict private
    FCounters: array [1..2] of integer;
    FDuration: integer;
    FEvents  : array [1..2] of TEvent;
    FLocks   : array [1..2] of TCriticalSection;
    FLogger  : TProc<string>;
    FOnStop  : TProc;
    FStop    : boolean;
    FStopped : array [1..2] of boolean;
    FTotal   : integer;
  strict protected
    procedure GrabCounter(idx: Integer);
    procedure InitWorkers;
    procedure RunWorker(idx, delay_ms: Integer);
    procedure StopWorkers;
    procedure TestProc;
    procedure Worker1;
    procedure Worker2;
  public
    constructor Create(duration_sec: integer; logger: TProc<string>; onStop: TProc);
    procedure Run;
  end;

implementation

{ TWaitForMultipleTest }

constructor TWaitForMultipleTest.Create(duration_sec: integer;
  logger: TProc<string>; onStop: TProc);
begin
  inherited Create;
  FDuration := duration_sec;
  FLogger := logger;
  FOnStop := onStop;
end;

procedure TWaitForMultipleTest.GrabCounter(idx: Integer);
begin
  FLocks[idx].Acquire;
  Inc(FTotal, FCounters[idx]);
  FCounters[idx] := 0;
  FLocks[idx].Release;
end;

procedure TWaitForMultipleTest.InitWorkers;
begin
  FLocks[1] := TCriticalSection.Create;
  FLocks[2] := TCriticalSection.Create;
  FCounters[1] := 0; FCounters[2] := 0;
  FStopped[1] := false; FStopped[2] := false;
  FEvents[1] := TEvent.Create(nil, false, false, '');
  FEvents[2] := TEvent.Create(nil, false, false, '');
  FTotal := 0;
  FStop := false;
  TThread.CreateAnonymousThread(Worker1).Start;
  TThread.CreateAnonymousThread(Worker2).Start;
end;

procedure TWaitForMultipleTest.Run;
var
  thread: TThread;
begin
  thread := TThread.CreateAnonymousThread(TestProc);
  thread.FreeOnTerminate := true;
  thread.Start;
end;

procedure TWaitForMultipleTest.RunWorker(idx, delay_ms: Integer);
begin
  TThread.NameThreadForDebugging('Worker ' + IntToStr(idx));
  while not FStop do begin
    Sleep(delay_ms);
    FLocks[idx].Acquire;
    FCounters[idx] := FCounters[idx] + 1;
    FLocks[idx].Release;
    FEvents[idx].SetEvent;
  end;
  FStopped[idx] := true;
end;

procedure TWaitForMultipleTest.StopWorkers;
begin
  FStop := true;
  while not (FStopped[1] and FStopped[2]) do
    Sleep(1);
  FEvents[1].Free; FEvents[2].Free;
  FLocks[1].Free; FLocks[2].Free;
end;

procedure TWaitForMultipleTest.TestProc;
var
  awaited: cardinal;
  handles: array [1..2] of THandle;
  sw: TStopwatch;
begin
  TThread.NameThreadForDebugging('Test runner');
  InitWorkers;
  handles[1] := FEvents[1].Handle; handles[2] := FEvents[2].Handle;
  sw := TStopwatch.StartNew;
  while sw.Elapsed.Seconds < FDuration do begin
    awaited := WaitForMultipleObjects(2, @handles, false, 500);
    if awaited = WAIT_OBJECT_0 then begin
      GrabCounter(1);
      FLogger('x');
    end
    else if awaited = (WAIT_OBJECT_0 + 1) then begin
      GrabCounter(2);
      FLogger('o');
    end
    else if awaited = WAIT_TIMEOUT then FLogger('.')
    else FLogger('?');
  end;
  StopWorkers;
  FLogger(' ' + IntToStr(FTotal) +
          '/' + IntToStr(FCounters[1]) +
          '/' + IntToStr(FCounters[2]));
  FOnStop();
end;

procedure TWaitForMultipleTest.Worker1;
begin
  RunWorker(1, 700);
end;

procedure TWaitForMultipleTest.Worker2;
begin
  RunWorker(2, 1200);
end;

end.
