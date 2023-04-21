unit PipelineWebSpider;

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Threading,
  System.Generics.Collections, System.Net.HttpClient, System.RegularExpressions,
  DHPTHreading;

type
  TWebSpider = class
  public type
    THttpPage = TPair<string,IHTTPResponse>;
  strict private
    FHtmlParseInput : TPipe<THttpPage>;
    FHttpGetInput   : TPipe<string>;
    FOnFinished     : TProc;
    FOnPageProcessed: TProc<string>;
    FPageCount      : integer;
    FPipeline       : TPipeline<string, string>;
  strict protected
    procedure Asy_UniqueFilter(baseUrl: string; inQueue, outQueue: TPipe<string>);
    procedure Asy_HttpGet(inQueue: TPipe<string>; outQueue: TPipe<THttpPage>);
    procedure Asy_HtmlParse(inQueue: TPipe<THttpPage>; outQueue: TPipe<string>);
    procedure NotifyFinished;
  public
    procedure Start(const baseUrl: string);
    procedure Stop;
    property OnPageProcessed: TProc<string> read FOnPageProcessed write FOnPageProcessed;
    property OnFinished: TProc read FOnFinished write FOnFinished;
  end;

implementation

uses
  Windows;

{ TWebSpider }

procedure TWebSpider.Asy_HttpGet(inQueue: TPipe<string>; outQueue: TPipe<THttpPage>);
var
  httpClient: THTTPClient;
  response: IHTTPResponse;
begin
  httpClient := THTTPClient.Create;
  try
    inQueue.Process<THttpPage>(outQueue,
      procedure (const url: string)
      begin
        try
          response := httpClient.Get(url);
        except
          if TInterlocked.Decrement(FPageCount) = 0 then
            NotifyFinished;
        end;

        if (response.StatusCode div 100) = 2 then
          outQueue.Write(THttpPage.Create(url, response))
        else if TInterlocked.Decrement(FPageCount) = 0 then
          NotifyFinished;
      end);
  finally
    FreeAndNil(httpClient);
  end;
end;

procedure TWebSpider.Asy_HtmlParse(inQueue: TPipe<THttpPage>;
  outQueue: TPipe<string>);
var
  hrefMatch: TRegEx;
  match: TMatch;
begin
  hrefMatch := TRegEx.Create('<a href=["''](.*?)["''].*?>', [roIgnoreCase, roMultiLine]);

  inQueue.Process<string>(outQueue,
    procedure (const page: THttpPage)
    begin
      try
        match := hrefMatch.Match(page.Value.ContentAsString);
        while match.Success do
        begin
          if outQueue.ShutDown then
            break; //while;
          TInterlocked.Increment(FPageCount);
          outQueue.Write(match.Groups[1].Value.Split(['#', '?'])[0]);
          match := match.NextMatch;
        end;
      except
      end;

      FPipeline.Output.Write(page.Key);
      if TInterlocked.Decrement(FPageCount) = 0 then
        NotifyFinished;
    end);
end;

procedure TWebSpider.Asy_UniqueFilter(baseUrl: string;
  inQueue, outQueue: TPipe<string>);
var
  baseUrl2: string;
  visitedPages: TStringList;
begin
  visitedPages := TStringList.Create;
  try
    visitedPages.Sorted := true;
    if not (baseUrl.StartsWith('https://') or baseUrl.StartsWith('http://')) then
      baseUrl := 'http://' + baseUrl;
    if baseUrl.StartsWith('http://') then
      baseUrl2 := baseUrl.Replace('http://', 'https://')
    else
      baseUrl2 := baseUrl.Replace('https://', 'http://');

    inQueue.Process<string>(outQueue,
      procedure (url: string)
      begin
        if url.IndexOf(':') < 0 then
          url := baseUrl + url;
        if (url.StartsWith(baseUrl) or url.StartsWith(baseUrl2))
           and (visitedPages.IndexOf(url) < 0) then
        begin
          visitedPages.Add(url);
          outQueue.Write(url);
        end
        else if TInterlocked.Decrement(FPageCount) = 0 then begin
          NotifyFinished;
        end;
      end);
  finally
    FreeAndNil(visitedPages);
  end;
end;

procedure TWebSpider.NotifyFinished;
begin
  TThread.Queue(TThread.Current,
    procedure
    begin
      if assigned(OnFinished) then
        OnFinished();
    end);
end;

procedure TWebSpider.Start(const baseUrl: string);
var
  i: integer;
begin
  FPipeline := TPipeline<string, string>.Create(10000, 100,
    procedure
    var
      url: string;
    begin
      if assigned(OnPageProcessed) then
        while FPipeline.Output.Read(url) do
          OnPageProcessed(url);
    end);

  FHttpGetInput := FPipeline.MakePipe<string>(100);
  FHtmlParseInput := FPipeline.MakePipe<THttpPage>(10);

  FPipeline.Stage('Unique filter',
    procedure
    begin
      Asy_UniqueFilter(baseUrl, FPipeline.Input, FHttpGetInput);
    end);

  for i := 1 to TThread.ProcessorCount do
    FPipeline.Stage<string,THttpPage>('Http get #' + i.ToString,
        FHttpGetInput, FHtmlParseInput, Asy_HttpGet);

  FPipeline.Stage<THttpPage,string>('Html parser',
    FHtmlParseInput, FPipeline.Input, Asy_HtmlParse);

  FPageCount := 1;
  FPipeline.Input.Write('');
end;

procedure TWebSpider.Stop;
begin
  FPipeline.ShutDown;
  FreeAndNil(FPipeline);
end;

end.
