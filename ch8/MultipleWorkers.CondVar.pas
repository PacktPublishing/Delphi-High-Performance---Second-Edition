unit MultipleWorkers.CondVar;

interface

uses
  System.SysUtils, System.Classes, System.Diagnostics, System.SyncObjs,
  GpSync.CondVar;

type
  TCondVarTest = class
  strict private
    FChanged : array [1..2] of boolean;
    FCounters: array [1..2] of integer;
    FCondVar : TLockConditionVariable;
    FDuration: integer;
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

{ TCondVarTest }

constructor TCondVarTest.Create(duration_sec: integer;
  logger: TProc<string>; onStop: TProc);
begin
  inherited Create;
  FDuration := duration_sec;
  FLogger := logger;
  FOnStop := onStop;
end;

procedure TCondVarTest.GrabCounter(idx: Integer);
begin
  Inc(FTotal, FCounters[idx]);
  FCounters[idx] := 0;
end;

procedure TCondVarTest.InitWorkers;
begin
  FCounters[1] := 0; FCounters[2] := 0;
  FChanged[1] := false; FChanged[2] := false;
  FStopped[1] := false; FStopped[2] := false;
  FTotal := 0;
  FStop := false;
  TThread.CreateAnonymousThread(Worker1).Start;
  TThread.CreateAnonymousThread(Worker2).Start;
end;

procedure TCondVarTest.Run;
var
  thread: TThread;
begin
  thread := TThread.CreateAnonymousThread(TestProc);
  thread.FreeOnTerminate := true;
  thread.Start;
end;

procedure TCondVarTest.RunWorker(idx, delay_ms: Integer);
begin
  TThread.NameThreadForDebugging('Worker ' + IntToStr(idx));
  while not FStop do begin
    Sleep(delay_ms);
    FCondVar.Acquire;
    FCounters[idx] := FCounters[idx] + 1;
    FChanged[idx] := true;
    FCondVar.Release;
    FCondVar.Signal;
  end;
  FStopped[idx] := true;
end;

procedure TCondVarTest.StopWorkers;
begin
  FStop := true;
  while not (FStopped[1] and FStopped[2]) do
    Sleep(1);
end;

procedure TCondVarTest.TestProc;
var
  sw: TStopwatch;
begin
  TThread.NameThreadForDebugging('Test runner');
  InitWorkers;
  sw := TStopwatch.StartNew;
  FCondVar.Acquire;
  while sw.Elapsed.Seconds < FDuration do begin
    if not FCondVar.TryWait(500) then FLogger('.')
    else begin
      if FChanged[1] then begin
        GrabCounter(1);
        FChanged[1] := false;
        FLogger('x');
      end;
      if FChanged[2] then begin
        GrabCounter(2);
        FChanged[2] := false;
        FLogger('o');
      end;
    end;
  end;
  FCondVar.Release;
  StopWorkers;
  FLogger(' ' + IntToStr(FTotal) +
          '/' + IntToStr(FCounters[1]) +
          '/' + IntToStr(FCounters[2]));
  FOnStop();
end;

procedure TCondVarTest.Worker1;
begin
  RunWorker(1, 700);
end;

procedure TCondVarTest.Worker2;
begin
  RunWorker(2, 1200);
end;

end.
