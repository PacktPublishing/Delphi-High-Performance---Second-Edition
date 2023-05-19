unit ParallelBackgroundWorkerMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.RegularExpressions, System.Generics.Collections, System.Net.HttpClient,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ActnList,
  HTMLUn2, HtmlView,
  OtlCommon, OtlParallel;

type
  TRequest = record
  public
    Index   : integer;
    URL     : string;
    Page    : string;
    constructor Create(AIndex: integer; const AURL: string);
  end;

  TfrmBackgroundWorker = class(TForm)
    btnSearch: TButton;
    chkSitelist: TCheckListBox;
    inpSearch: TEdit;
    btnOpen: TButton;
    ActionList1: TActionList;
    ActionOpen: TAction;
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionOpenUpdate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkSitelistClick(Sender: TObject);
    procedure inpSearchKeyPress(Sender: TObject; var Key: Char);
  strict private
    HtmlViewer: THtmlViewer;
    FBackgroundWorker: IOmniBackgroundWorker;
    FRequests: TDictionary<int64, TRequest>;
    FTitles: TList<int64>;
  strict protected
    procedure ArticleDownloaded(const Sender: IOmniBackgroundWorker;
      const workItem: IOmniWorkItem);
    procedure CreateHtmlViewer;
    procedure DownloadWebPage_asy(const workItem: IOmniWorkItem);
    procedure FinalizeWorkerTask_asy(const taskState: TOmniValue);
    procedure InitializeWorkerTask_asy(var taskState: TOmniValue);
    procedure ListDownloaded(const Sender: IOmniBackgroundWorker;
      const workItem: IOmniWorkItem);
  end;

var
  frmBackgroundWorker: TfrmBackgroundWorker;

implementation

uses
  ShellAPI;

{$R *.dfm}

procedure TfrmBackgroundWorker.ActionOpenExecute(Sender: TObject);
var
  request: TRequest;
begin
  if FRequests.TryGetValue(FTitles[chkSiteList.ItemIndex], request) then
    ShellExecute(0, 'open', PChar(request.URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmBackgroundWorker.ActionOpenUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (chkSitelist.ItemIndex >= 0)
    and chkSitelist.Checked[chkSitelist.ItemIndex]
    and FRequests.ContainsKey(FTitles[chkSiteList.ItemIndex]);
end;

procedure TfrmBackgroundWorker.FormCreate(Sender: TObject);
begin
  FBackgroundWorker := Parallel.BackgroundWorker
                         .NumTasks(4)
                         .Initialize(InitializeWorkerTask_asy)
                         .Finalize(FinalizeWorkerTask_asy)
                         .Execute(DownloadWebPage_asy)
                         .OnRequestDone(ArticleDownloaded);
  FRequests := TDictionary<int64, TRequest>.Create;
  FTitles := TList<int64>.Create;
  CreateHtmlViewer;
end;

procedure TfrmBackgroundWorker.FormDestroy(Sender: TObject);
begin
  FBackgroundWorker.CancelAll;
  FBackgroundWorker.Terminate(5000);
  FBackgroundWorker := nil;
  FreeAndNil(FRequests);
  FreeAndNil(FTitles);
end;

procedure TfrmBackgroundWorker.ArticleDownloaded(const Sender: IOmniBackgroundWorker;
  const workItem: IOmniWorkItem);
var
  request: TRequest;
begin
  if not FRequests.TryGetValue(workItem.UniqueID, request) then
    Exit;
  request.Page := workItem.Result;
  FRequests.AddOrSetValue(workItem.UniqueID, request);
  chkSitelist.Checked[request.Index] := true;
end;

procedure TfrmBackgroundWorker.btnSearchClick(Sender: TObject);
begin
  chkSitelist.Clear;
  FRequests.Clear;
  FTitles.Clear;
  FBackgroundWorker.CancelAll;
  FBackgroundWorker.Schedule(
    FBackgroundWorker.CreateWorkItem('https://en.delphipraxis.net/search/?q=' + inpSearch.Text),
    FBackgroundWorker.Config.OnRequestDone(ListDownloaded));
end;

procedure TfrmBackgroundWorker.chkSitelistClick(Sender: TObject);
var
  request: TRequest;
begin
  if FRequests.TryGetValue(FTitles[chkSiteList.ItemIndex], request) then
    HtmlViewer.LoadFromString(request.Page)
  else
    HtmlViewer.Clear;
end;

procedure TfrmBackgroundWorker.CreateHtmlViewer;
begin
  HtmlViewer := THtmlViewer.Create(Self);
  with HtmlViewer do begin
    Name := 'HtmlViewer';
    Parent := Self;
    Left := chkSiteList.Left + chkSiteList.Width + 16;
    Top := btnSearch.Top;
    Width := frmBackgroundWorker.ClientWidth - Left - 16;
    Height := frmBackgroundWorker.ClientHeight - Top - 16;
    TabOrder := 3;
    Anchors := [akLeft, akTop, akRight, akBottom];
    BorderStyle := htSingle;
    CharSet := DEFAULT_CHARSET;
    DefFontName := 'Times New Roman';
    DefFontSize := 11;
    DefPreFontName := 'Courier New';
    HistoryMaxCount := 0;
    NoSelect := False;
    PrintMarginBottom := 2;
    PrintMarginLeft := 2;
    PrintMarginRight := 2;
    PrintMarginTop := 2;
    PrintScale := 1;
    QuirksMode := qmDetect;
  end;
end;

procedure TfrmBackgroundWorker.DownloadWebPage_asy(
  const workItem: IOmniWorkItem);
var
  response: IHTTPResponse;
begin
  response := workItem.TaskState.ToObject<THTTPClient>.Get(workItem.Data);
  if (response.StatusCode div 100) = 2 then
    workItem.Result := response.ContentAsString;
end;

procedure TfrmBackgroundWorker.FinalizeWorkerTask_asy(
  const taskState: TOmniValue);
begin
  taskState.AsObject.Free;
end;

procedure TfrmBackgroundWorker.InitializeWorkerTask_asy(
  var taskState: TOmniValue);
begin
  taskState := THTTPClient.Create;
end;

procedure TfrmBackgroundWorker.inpSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSearch.Click;
end;

procedure TfrmBackgroundWorker.ListDownloaded(
  const Sender: IOmniBackgroundWorker; const workItem: IOmniWorkItem);
var
  filter, url: string;
  hrefMatch: TRegEx;
  match: TMatch;
  index: integer;
  request: IOmniWorkItem;
begin
  if workItem.Result.IsEmpty then
    ShowMessage('Background worker failed to download ' + workItem.Data)
  else if assigned(FBackgroundWorker) then begin
    filter := '<a href=''(https://en.delphipraxis.net/topic/.*?)''.*?data-linkType="link".*?>(.*)</a>';
    hrefMatch := TRegEx.Create(filter, [roIgnoreCase, roMultiLine]);
    match := hrefMatch.Match(workItem.Result);
    while match.Success do begin
      url := StringReplace(match.Groups[1].Value, '&amp;', '&', [rfReplaceAll]);
      index := chkSitelist.Items.Add(match.Groups[2].Value);
      request := FBackgroundWorker.CreateWorkItem(url);
      FRequests.Add(request.UniqueID, TRequest.Create(index, url));
      FTitles.Add(request.UniqueID);
      FBackgroundWorker.Schedule(request);
      match := match.NextMatch;
    end;
  end;
end;

{ TRequest }

constructor TRequest.Create(AIndex: integer; const AURL: string);
begin
  Index := AIndex;
  URL := AURL;
end;

end.
