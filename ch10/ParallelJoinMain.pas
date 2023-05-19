unit ParallelJoinMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  OtlParallel;

type
  TfrmParallelJoin = class(TForm)
    btnJoin3E: TButton;
    ListBox1: TListBox;
    btnJoinNoWait: TButton;
    btnJoinNoWaitE: TButton;
    btnJoin2: TButton;
    procedure btnJoin2Click(Sender: TObject);
    procedure btnJoin3EClick(Sender: TObject);
    procedure btnJoinNoWaitClick(Sender: TObject);
    procedure btnJoinNoWaitEClick(Sender: TObject);
  private
    FJoin: IOmniParallelJoin;
    procedure Task1;
    procedure Task2;
    procedure Task2E;
    procedure Task3;
    procedure Task3E;
    procedure TasksStopped;
    procedure QueueLog(const msg: string);
  public
  end;

var
  frmParallelJoin: TfrmParallelJoin;

implementation

{$R *.dfm}

procedure TfrmParallelJoin.btnJoinNoWaitClick(Sender: TObject);
begin
  ListBox1.Items.Add('Starting tasks');
  Parallel.Join([Task1, Task2, Task3]).NoWait.OnStopInvoke(
    procedure
    begin
      ListBox1.Items.Add('Tasks stopped');
    end).Execute;
  ListBox1.Items.Add('Tasks started');
end;

procedure TfrmParallelJoin.btnJoinNoWaitEClick(Sender: TObject);
begin
  ListBox1.Items.Add('Starting tasks');
  FJoin := Parallel.Join([Task1, Task2E, Task3E]).NoWait.OnStopInvoke(TasksStopped).Execute;
end;

procedure NullTask;
begin
end;

procedure TfrmParallelJoin.btnJoin2Click(Sender: TObject);
begin
  ListBox1.Items.Add('Starting tasks');
  Parallel.Join(Task1, Task2).Execute;
  QueueLog('Join finished');
end;

procedure TfrmParallelJoin.btnJoin3EClick(Sender: TObject);
var
  i: integer;
begin
  ListBox1.Items.Add('Starting tasks');
  try
    Parallel.Join([Task1, Task2, Task3E]).Execute;
  except
    on E: EJoinException do begin
      for i := 0 to EJoinException(E).Count - 1 do
        QueueLog('Task raised exception: ' +
          EJoinException(E)[i].FatalException.Message);
      ReleaseExceptionObject;
    end;
  end;
  QueueLog('Join finished');
end;

procedure TfrmParallelJoin.QueueLog(const msg: string);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      ListBox1.Items.Add(msg);
    end);
end;

procedure TfrmParallelJoin.Task1;
begin
  QueueLog('Task1 started in thread ' + TThread.Current.ThreadID.ToString);
  Sleep(1000);
  QueueLog('Task1 stopped in thread ' + TThread.Current.ThreadID.ToString);
end;

procedure TfrmParallelJoin.Task2;
begin
  QueueLog('Task2 started in thread ' + TThread.Current.ThreadID.ToString);
  Sleep(1000);
  QueueLog('Task2 stopped in thread ' + TThread.Current.ThreadID.ToString);
end;

procedure TfrmParallelJoin.Task2E;
begin
  QueueLog('Task2E started in thread ' + TThread.Current.ThreadID.ToString);
  Sleep(1000);
  QueueLog('Task2E raising exception in thread ' + TThread.Current.ThreadID.ToString);
  raise Exception.Create('Task2 exception');
end;

procedure TfrmParallelJoin.Task3;
begin
  QueueLog('Task3 started in thread ' + TThread.Current.ThreadID.ToString);
  Sleep(1000);
  QueueLog('Task3 stopped in thread ' + TThread.Current.ThreadID.ToString);
end;

procedure TfrmParallelJoin.Task3E;
begin
  QueueLog('Task3E started in thread ' + TThread.Current.ThreadID.ToString);
  Sleep(1000);
  QueueLog('Task3E raising exception in thread ' + TThread.Current.ThreadID.ToString);
  raise Exception.Create('Task3E exception');
end;

procedure TfrmParallelJoin.TasksStopped;
var
  i: Integer;
begin
  QueueLog('Tasks stopped');
  try
    try
      FJoin.WaitFor(0);
    except
      on E: EJoinException do begin
        for i := 0 to EJoinException(E).Count - 1 do
          QueueLog('Task raised exception: ' +
            EJoinException(E)[i].FatalException.Message);
        ReleaseExceptionObject;
      end;
    end;
  finally
    FJoin := nil;
  end;
end;

end.
