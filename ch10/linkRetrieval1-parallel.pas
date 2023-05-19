unit linkRetrieval1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  MMSHelpers,
  OtlParallel;

const
  WM_RETRIEVE = WM_USER;

type
  TfrmLinkRetrieval = class(TForm)
    lbLinks: TListBox;
    btnStart: TButton;
    btnStop: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    FWorker: IOmniBackgroundWorker;
    procedure RetrievePage(var msg: TMessage); message WM_RETRIEVE;
    procedure MarkLoaded(pageNum: integer);
  public
  end;

var
  frmLinkRetrieval: TfrmLinkRetrieval;

implementation

uses
  StrUtils;

{$R *.dfm}

const
  CLinks: array [1..16] of string = ('97248', '97242', '97229', '97224', '97211',
    '97214', '97193', '97183', '97173', '97174', '97169', '97156', '97150', '97149',
    '97147', '97144');

function MakeUrl(const page: string): string;
begin
  Result := 'http://www.delphifeeds.com/go/s/' + page;
end;

procedure TfrmLinkRetrieval.btnStartClick(Sender: TObject);
var
  iLink: integer;
  workItem: IOmniWorkItem;
begin
  FWorker := Parallel.BackgroundWorker.NumTasks(4)
  .Execute(
    procedure (const workItem: IOmniWorkItem)
    var
      pageContents: string;
    begin
      Sleep(1000);
      HttpGet('www.delphifeeds.com', 80, '/go/s/' + workItem.Data, pageContents, '');
      workItem.Result := pageContents;
    end
  )
  .OnRequestDone(
    procedure (const Sender: IOmniBackgroundWorker; const workItem: IOmniWorkItem)
    begin
      MarkLoaded(workItem.UniqueID);
    end
  );
  for iLink := Low(CLinks) to High(CLinks) do begin
    workItem := FWorker.CreateWorkItem(CLinks[iLink]);
    lbLinks.Items.Add(Format('%d=%s', [workItem.UniqueID, MakeUrl(CLinks[iLink])]));
    FWorker.Schedule(workItem);
  end;
//  Application.ProcessMessages;
//  PostMessage(Handle, WM_RETRIEVE, Low(CLinks), High(CLinks));
end;

procedure TfrmLinkRetrieval.btnStopClick(Sender: TObject);
begin
  FWorker.CancelAll;
  FWorker.Terminate(INFINITE);
  FWorker := nil;
end;

procedure TfrmLinkRetrieval.MarkLoaded(pageNum: integer);
var
  test: string;
  iLink: integer;
begin
  test := Format('%d=', [pageNum]);
  for iLink := 0 to lbLinks.Count - 1 do begin
    if StartsText(test, lbLinks.Items[iLink]) then begin
      lbLinks.Items[iLink] := '+' + lbLinks.Items[iLink];
      break; //for
    end;
  end;
end;

procedure TfrmLinkRetrieval.RetrievePage(var msg: TMessage);
var
  pageContents: string;
begin
  HttpGet('www.delphifeeds.com', 80, '/go/s/' + CLinks[msg.WParam], pageContents, '');
  MarkLoaded(msg.WParam);
  Application.ProcessMessages;
  if msg.WParam < msg.LParam then
    PostMessage(Handle, WM_RETRIEVE, msg.WParam + 1, msg.LParam);
end;

end.
