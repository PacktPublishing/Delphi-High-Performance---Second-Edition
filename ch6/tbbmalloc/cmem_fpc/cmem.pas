unit cmem;

//{$mode objfpc}

interface

Function scalable_getmem(Size : ptrint) : Pointer;cdecl;external 'tbbmalloc' name 'scalable_malloc';
Procedure scalable_freemem(P : Pointer); cdecl; external 'tbbmalloc' name 'scalable_free';
function scalable_realloc(P : Pointer; Size : ptrint) : pointer; cdecl;external 'tbbmalloc' name 'scalable_realloc';

implementation


Function CGetMem(Size : ptrint) : Pointer;

begin
  result:=scalable_getmem(Size+sizeof(ptrint));
  if (result <> nil) then
    begin
      Pptruint(result)^ := size;
      inc(result,sizeof(ptrint));
    end;

end;

Function CFreeMem(P : pointer) : ptrint;

begin
  if (p <> nil) then
    dec(p,sizeof(ptrint));
  scalable_freemem(P);
  CFreeMem:=0;
end;

Function CFreeMemSize(p:pointer;Size:ptrint):ptrint;

begin
  if size<=0 then
    exit;
  if (p <> nil) then
    begin
      if (size <> Pptrint(p-sizeof(ptrint))^) then
        runerror(204);
    end;
  CFreeMemSize:=CFreeMem(P);
end;

Function CAllocMem(Size : ptrint) : Pointer;

begin
  result:=scalable_getmem(Size+sizeof(ptrint));
  
if Assigned(Result) then
  FillChar(Result^, Size, 0);

if (result <> nil) then
    begin
      Pptruint(result)^ := size;
      inc(result,sizeof(ptruint));
    end;


end;

Function CReAllocMem(var p:pointer;Size:ptrint):Pointer;

begin
  if size=0 then
    begin
      if p<>nil then
        begin
          dec(p,sizeof(ptrint));
          scalable_freemem(p);
          p:=nil;
        end;
    end
  else
    begin
      inc(size,sizeof(ptrint));
      if p=nil then
        p:=scalable_getmem(Size)
      else
        begin
          dec(p,sizeof(ptrint));
          p:=scalable_realloc(p,size);
        end;
      if (p <> nil) then
        begin
          Pptrint(p)^ := size-sizeof(ptrint);
          inc(p,sizeof(ptrint));
        end;
    end;
  CReAllocMem:=p;
end;

Function CMemSize(p:pointer): ptrint;

begin
  CMemSize:=Pptrint(p-sizeof(ptrint))^;
end;

function CGetHeapStatus:THeapStatus;

var res: THeapStatus;

begin
  fillchar(res,sizeof(res),0);
  CGetHeapStatus:=res;
end;

function CGetFPCHeapStatus:TFPCHeapStatus;

begin
  fillchar(result,sizeof(TFPCHeapStatus),0);
end;

Const
 CMemoryManager : TMemoryManager =
    (
      NeedLock : false;
      GetMem : @CGetmem;
      FreeMem : @CFreeMem;
      FreememSize : @CFreememSize;
      AllocMem : @CAllocMem;
      ReallocMem : @CReAllocMem;
      MemSize : @CMemSize;
      InitThread : nil;
      DoneThread : nil;
      RelocateHeap : nil;
      GetHeapStatus : @CGetHeapStatus;
      GetFPCHeapStatus: @CGetFPCHeapStatus;
    );

Var
  OldMemoryManager : TMemoryManager;

Initialization
  GetMemoryManager(OldMemoryManager);
  SetMemoryManager(CmemoryManager);

Finalization
  SetMemoryManager(OldMemoryManager);
end.