unit ParallelTaskMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  OtlCommon, OtlCollections, OtlParallel,
  GpRandomGen, Vcl.Samples.Spin;

type
  TfrmParallelTask = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure CreateRandomData(fileSize: integer; output: TStream);
  public
  end;

var
  frmParallelTask: TfrmParallelTask;

implementation

uses
  System.Diagnostics;

{$R *.dfm}

procedure TfrmParallelTask.Button1Click(Sender: TObject);
var
  ms: TStream;
  sw: TStopwatch;
begin
  sw := TStopwatch.StartNew;
  ms := TMemoryStream.Create;
  CreateRandomData(100*1024*1024, ms);
  sw.Stop;
  ListBox1.Items.Add('Data written in ' + IntToStr(sw.ElapsedMilliseconds) +
    ' ms / ' + IntToStr(SpinEdit1.Value) + ' task(s)');
  ms.Free;
end;

procedure FillBuffer(buf: pointer; bufSize: integer; randomGen: TGpRandom);
var
  buf64: PInt64;
  buf8 : PByte;
  i    : integer;
  rnd  : int64;
begin
  buf64 := buf;
  for i := 1 to bufSize div SizeOf(int64) do begin
    buf64^ := randomGen.Rnd64;
    Inc(buf64);
  end;
  rnd := randomGen.Rnd64;
  buf8 := PByte(buf64);
  for i := 1 to bufSize mod SizeOf(int64) do begin
    buf8^ := rnd AND $FF;
    rnd := rnd SHR 8;
    Inc(buf8);
  end;
end;

procedure TfrmParallelTask.FormCreate(Sender: TObject);
begin
  SpinEdit1.MaxValue := Environment.Process.Affinity.Count;
  SpinEdit1.Value := SpinEdit1.MaxValue;
end;

procedure TfrmParallelTask.CreateRandomData(fileSize: integer; output: TStream);
const
  CBlockSize = 1*1024*1024 {1 MB};
var
  buffer   : TOmniValue;
  memStr   : TMemoryStream;
  outQueue : IOmniBlockingCollection;
  unwritten: IOmniCounter;
begin
   outQueue := TOmniBlockingCollection.Create;
   unwritten := CreateCounter(fileSize);
   Parallel.ParallelTask.NoWait
     .NumTasks(SpinEdit1.Value)
     .OnStop(Parallel.CompleteQueue(outQueue))
     .Execute(
       procedure
       var
         buffer      : TMemoryStream;
         bytesToWrite: integer;
         randomGen   : TGpRandom;
       begin
         randomGen := TGpRandom.Create;
         try
           while unwritten.Take(CBlockSize, bytesToWrite) do begin
             buffer := TMemoryStream.Create;
             buffer.Size := bytesToWrite;
             FillBuffer(buffer.Memory, bytesToWrite, randomGen);
             outQueue.Add(buffer);
           end;
         finally FreeAndNil(randomGen); end;
       end
     );

   for buffer in outQueue do begin
     memStr := buffer.AsObject as TMemoryStream;
     output.CopyFrom(memStr, 0);
     FreeAndNil(memStr);
   end;
end;

end.
