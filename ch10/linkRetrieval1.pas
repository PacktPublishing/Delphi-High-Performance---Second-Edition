unit linkRetrieval1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  MMSHelpers,
  OtlCommon,
  OtlParallel;

const
  WM_RETRIEVE = WM_USER;

type
  TfrmLinkRetrieval = class(TForm)
    lbLinks: TListBox;
    btnStart: TButton;
    btnStop: TButton;
    Memo1: TMemo;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    FStop: boolean;
    FBkGet: IOmniBackgroundWorker;
    procedure RetrievePage(var msg: TMessage); message WM_RETRIEVE;
    procedure RetrievePageBk(const workItem: IOmniWorkItem);
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
begin
  lbLinks.Clear;
  for iLink := Low(CLinks) to High(CLinks) do
    lbLinks.Items.Add(Format('%d=%s', [iLink, MakeUrl(CLinks[iLink])]));
  FStop := false;
  Application.ProcessMessages;
//  PostMessage(Handle, WM_RETRIEVE, Low(CLinks), High(CLinks));
  FBkGet := Parallel.BackgroundWorker
    .NumTasks(Environment.Process.Affinity.Count * 2)
    .OnRequestDone(
      procedure (const Sender: IOmniBackgroundWorker;
                 const workItem: IOmniWorkItem)
      begin
        Memo1.Text := workItem.Result[1];
        MarkLoaded(workItem.Result[0]);
      end)
    .Execute(RetrievePageBk);
  for iLink := Low(CLinks) to High(CLinks) do
    FBkGet.Schedule(
      FBkGet.CreateWorkItem(iLink)
    );
end;

procedure TfrmLinkRetrieval.btnStopClick(Sender: TObject);
begin
//  FStop := true;
  FBkGet.Terminate(INFINITE);
  FBkGet := nil;
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
  Memo1.Text := pageContents;
  MarkLoaded(msg.WParam);
  Application.ProcessMessages;
  if (not FStop) and (msg.WParam < msg.LParam) then
    PostMessage(Handle, WM_RETRIEVE, msg.WParam + 1, msg.LParam);
end;

procedure TfrmLinkRetrieval.RetrievePageBk(const workItem: IOmniWorkItem);
var
  pageContents: string;
begin
  HttpGet('www.delphifeeds.com', 80,
    '/go/s/' + CLinks[workitem.Data.AsInteger], pageContents, '');
  workItem.Result := TOmniValue.Create(
    [workitem.Data.AsInteger, pageContents]
  );
end;

end.
