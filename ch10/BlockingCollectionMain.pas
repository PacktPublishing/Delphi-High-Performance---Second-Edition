unit BlockingCollectionMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  OtlCommon, OtlCollections;

type
  TfrmBlockingCollection = class(TForm)
    btnStart: TButton;
    Memo1: TMemo;
    btnStop: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  strict private
    FQueue: IOmniBlockingCollection;
  strict protected
    function  CreateProducer(interval: integer; const queue: IOmniBlockingCollection): TProc;
    function  CreateConsumer(const queue: IOmniBlockingCollection): TProc;
    procedure QueueLog(const msg: string);
  public
  end;

var
  frmBlockingCollection: TfrmBlockingCollection;

implementation

{$R *.dfm}

procedure TfrmBlockingCollection.btnStartClick(Sender: TObject);
begin
  FQueue := TOmniBlockingCollection.Create;
  TThread.CreateAnonymousThread(CreateProducer(17, FQueue)).Start;
  TThread.CreateAnonymousThread(CreateProducer(42, FQueue)).Start;
  TThread.CreateAnonymousThread(CreateConsumer(FQueue)).Start;
  btnStart.Enabled := false;
  btnStop.Enabled := true;
end;

procedure TfrmBlockingCollection.btnStopClick(Sender: TObject);
begin
  FQueue.CompleteAdding;
  FQueue := nil;
  btnStart.Enabled := true;
  btnStop.Enabled := false;
end;

function TfrmBlockingCollection.CreateConsumer(const queue: IOmniBlockingCollection): TProc;
begin
  Result :=
    procedure
    var
      value: integer;
    begin
      for value in queue do
        QueueLog(IntToStr(value));
      QueueLog('STOP');
    end;
end;

function TfrmBlockingCollection.CreateProducer(interval: integer;
  const queue: IOmniBlockingCollection): TProc;
begin
  Result :=
    procedure
    var
      num: integer;
    begin
      num := interval;
      while queue.TryAdd(num) do begin
        Inc(num, interval);
        Sleep(250);
      end;
      QueueLog('END/' + IntToStr(interval));
    end;
end;

procedure TfrmBlockingCollection.QueueLog(const msg: string);
begin
  TThread.Queue(nil,
    procedure
    begin
      Memo1.Text := Memo1.Text + msg + ' ';
    end);
end;

end.
