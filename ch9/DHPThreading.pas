unit DHPThreading;

interface

uses
  System.SysUtils, System.Generics.Collections, System.TimeSpan, System.Threading,
  GpConsole;

type
  IAsync = interface ['{190C1975-FFCF-47AD-B075-79BC8F4157DA}']
    procedure Await(const awaitProc: TProc);
  end;

  function Async(const asyncProc: TProc): IAsync;

type
  IJoin = interface ['{ED4B4531-B233-4A02-A09A-13EE488FCCA3}']
    procedure Await(const awaitProc: TProc); overload;
    procedure Await(const awaitProc: TProc<Exception>); overload;
  end;

function Join(const async: array of TProc): IJoin;

type
  TPipe<T> = class(TThreadedQueue<T>)
  strict private
    FOnWriteProc: TProc;
  public type
    Proc<T1> = reference to procedure (const value: T1);
  public
    constructor Create(size: integer; onWriteProc: TProc = nil;
      pushTimeout: cardinal = INFINITE; popTimeout: cardinal = INFINITE);
    procedure Process<TOut>(outQueue: TPipe<TOut>;
      stageLoop: Proc<T>); overload;
    procedure Process<TOut>(outQueue: TPipe<TOut>;
      stageLoop: TProc<T>); overload;
    function  Read(var item: T): boolean;
    function  Write(const item: T): boolean;
  end;

  TPipeline<TIn, TOut> = class
  strict private
    FInputPipe: TPipe<TIn>;
    FOutputPipe: TPipe<TOut>;
    FPipes: TList<TObject>;
    FTasks: TList<ITask>;
    FThreadPool: TThreadPool;
  strict protected
  public
    constructor Create(inputSize, outputSize: integer; onOutputGenerated: TProc = nil); overload;
    destructor  Destroy; override;
    function MakePipe<T1>(size: integer; const onWriteProc: TProc = nil): TPipe<T1>;
    procedure Shutdown;
    procedure Stage(const name: string; const stage: TProc); overload;
    procedure Stage(const stage: TProc); overload;
    procedure Stage<TSIn, TSOut>(const name: string; inPipe: TPipe<TSIn>; outPipe: TPipe<TSOut>;
      const stage: TProc<TPipe<TSIn>, TPipe<TSOut>>); overload;
    procedure Stage<TSIn, TSOut>(inPipe: TPipe<TSIn>; outPipe: TPipe<TSOut>;
      const stage: TProc<TPipe<TSIn>, TPipe<TSOut>>); overload;
    property Input: TPipe<TIn> read FInputPipe;
    property Output: TPipe<TOut> read FOutputPipe;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SyncObjs;

type
  TAsync = class(TInterfacedObject, IAsync)
  strict private
    FAsyncProc: TProc;
    FAwaitProc: TProc;
    FSelf: IAsync;
  strict protected
    procedure Run;
  public
    constructor Create(const asyncProc: TProc);
    procedure Await(const awaitProc: TProc);
  end;

  TJoin = class(TInterfacedObject, IJoin)
  strict private
    FAsyncProc: TArray<TProc>;
    FAwaitProc: TProc<Exception>;
    FExceptions: TArray<Exception>;
    FNumRunning: integer;
    FSelf: IJoin;
  strict protected
    procedure AppendException(E: Exception);
    function CreateAggregateException: Exception;
    function GetAsyncProc(i: integer): TProc;
    procedure Run(const asyncProc: TProc);
  public
    constructor Create(const asyncProc: array of TProc);
    procedure Await(const awaitProc: TProc); overload;
    procedure Await(const awaitProc: TProc<Exception>); overload;
  end;

function Async(const asyncProc: TProc): IAsync;
begin
  Result := TAsync.Create(asyncProc);
end;

function Join(const async: array of TProc): IJoin;
begin
  Result := TJoin.Create(async);
end;

{ TAsync }

constructor TAsync.Create(const asyncProc: TProc);
begin
  inherited Create;
  FAsyncProc := asyncProc;
end;

procedure TAsync.Run;
begin
  FAsyncProc();

  TThread.Queue(TThread.Current,
    procedure
    begin
      FAwaitProc();
      FSelf := nil;
    end
  );
end;

procedure TAsync.Await(const awaitProc: TProc);
begin
  FSelf := Self;
  FAwaitProc := awaitProc;
  TTask.Run(Run);
end;

{ TJoin }

constructor TJoin.Create(const asyncProc: array of TProc);
var
  i: integer;
begin
  inherited Create;
  SetLength(FAsyncProc, Length(asyncProc));
  for i := Low(asyncProc) to High(asyncProc) do
    FAsyncProc[i] := asyncProc[i];
end;

function TJoin.CreateAggregateException: Exception;
begin
  if Length(FExceptions) = 0 then
    Result := nil
  else
    Result := EAggregateException.Create(FExceptions);
end;

function TJoin.GetAsyncProc(i: integer): TProc;
begin
  Result :=
    procedure
    begin
      Run(FAsyncProc[i]);
    end;
end;

procedure TJoin.Await(const awaitProc: TProc);
begin
  Await(
    procedure (E: Exception)
    begin
      if assigned(E) then
        raise E;
      awaitProc();
    end);
end;

procedure TJoin.AppendException(E: Exception);
begin
  TMonitor.Enter(Self);
  try
    SetLength(FExceptions, Length(FExceptions) + 1);
    FExceptions[High(FExceptions)] := e;
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TJoin.Await(const awaitProc: TProc<Exception>);
var
  i: integer;
begin
  FAwaitProc := awaitProc;
  FNumRunning := Length(FAsyncProc);
  FSelf := Self;
  for i := Low(FAsyncProc) to High(FAsyncProc) do begin
    TTask.Run(GetAsyncProc(i));
    // fix a problem in 10.2 Tokyo
    {$IF CompilerVersion = 32}Sleep(1);{$IFEND}
  end;
end;

procedure TJoin.Run(const asyncProc: TProc);
begin
  try
    asyncProc();
  except
    on E: Exception do
      AppendException(AcquireExceptionObject as Exception);
  end;

  if TInterlocked.Decrement(FNumRunning) = 0 then
    TThread.Queue(TThread.Current,
      procedure
      begin
        FAwaitProc(CreateAggregateException);
        FSelf := nil;
      end);
end;

{ TPipe<T> }

constructor TPipe<T>.Create(size: integer; onWriteProc: TProc;
  pushTimeout, popTimeout: cardinal);
begin
  inherited Create(size, pushTimeout, popTimeout);
  FOnWriteProc := onWriteProc;
end;

procedure TPipe<T>.Process<TOut>(outQueue: TPipe<TOut>; stageLoop: Proc<T>);
var
  item: T;
begin
  while Read(item) do
  begin
    if ShutDown then
      break; //while

    stageLoop(item);
  end;
  outQueue.DoShutDown;
end;

procedure TPipe<T>.Process<TOut>(outQueue: TPipe<TOut>; stageLoop: TProc<T>);
var
  item: T;
begin
  while Read(item) do
  begin
    if ShutDown then
      break; //while

    stageLoop(item);
  end;
  outQueue.DoShutDown;
end;

function TPipe<T>.Read(var item: T): boolean;
begin
  Result := PopItem(item) = wrSignaled;
end;

function TPipe<T>.Write(const item: T): boolean;
begin
  if ShutDown then
    Exit(False);

  Result := PushItem(item) = wrSignaled;
  if Result and assigned(FOnWriteProc) then begin
    TThread.Queue(TThread.Current,
      procedure
      begin
        FOnWriteProc();
      end);
  end;
end;

{ TPipeline }

constructor TPipeline<TIn, TOut>.Create(inputSize, outputSize: integer;
  onOutputGenerated: TProc);
begin
  inherited Create;
  FTasks := TList<ITask>.Create;
  FPipes := TObjectList<TObject>.Create(true);
  FInputPipe := TPipe<TIn>.Create(inputSize);
  FPipes.Add(FInputPipe);
  FOutputPipe := TPipe<TOut>.Create(outputSize, onOutputGenerated, INFINITE, 0);
  FPipes.Add(FOutputPipe);
  FThreadPool := TThreadPool.Create;
end;

destructor TPipeline<TIn, TOut>.Destroy;
begin
  Assert(FInputPipe.ShutDown, 'Pipeline was not shut down properly!');
  FreeAndNil(FPipes);
  inherited;
end;

function TPipeline<TIn, TOut>.MakePipe<T1>(size: integer; const onWriteProc: TProc): TPipe<T1>;
begin
  Result := TPipe<T1>.Create(size, onWriteProc);
  FPipes.Add(Result);
end;

procedure TPipeline<TIn, TOut>.Shutdown;
begin
  FInputPipe.DoShutDown;
  TTask.WaitForAll(FTasks.ToArray);
  FreeAndNil(FTasks);
  FreeAndNil(FThreadPool);
end;

procedure TPipeline<TIn, TOut>.Stage(const stage: TProc);
begin
  FTasks.Add(TTask.Run(stage, FThreadPool));
end;

procedure TPipeline<TIn, TOut>.Stage<TSIn, TSOut>(inPipe: TPipe<TSIn>; outPipe: TPipe<TSOut>;
  const stage: TProc<TPipe<TSIn>, TPipe<TSOut>>);
begin
  FTasks.Add(TTask.Run(
    procedure
    begin
      stage(inPipe, outPipe);
    end,
    FThreadPool));
end;

procedure TPipeline<TIn, TOut>.Stage<TSIn, TSOut>(const name: string;
  inPipe: TPipe<TSIn>; outPipe: TPipe<TSOut>;
  const stage: TProc<TPipe<TSIn>, TPipe<TSOut>>);
begin
  FTasks.Add(TTask.Run(
    procedure
    begin
      TThread.NameThreadForDebugging(name);
      stage(inPipe, outPipe);
    end,
    FThreadPool));
end;

procedure TPipeline<TIn, TOut>.Stage(const name: string; const stage: TProc);
begin
  FTasks.Add(TTask.Run(
    procedure
    begin
      TThread.NameThreadForDebugging(name);
      stage();
    end,
    FThreadPool));
end;

end.
