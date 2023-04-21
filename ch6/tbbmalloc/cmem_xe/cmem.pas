unit cmem;

//{$mode objfpc}

interface


Function scalable_getmem(Size : nativeUInt) : Pointer;cdecl;external 'tbbmalloc' name 'scalable_malloc';
Procedure scalable_freemem(P : Pointer); cdecl; external 'tbbmalloc' name 'scalable_free';
function scalable_realloc(P : Pointer; Size : NativeUInt) : pointer; cdecl;external 'tbbmalloc' name 'scalable_realloc';

implementation

Function CGetMem(Size : NativeInt) : Pointer;
begin
  result:=scalable_getmem(Size);
end;

Function CFreeMem(P : pointer) : integer;
begin
  scalable_freemem(P);
  Result:=0;
end;

Function CReAllocMem(p:pointer;Size:NativeInt):Pointer;
begin
  Result:=scalable_realloc(p,size);
end;

Function CAllocMem(Size : NativeInt) : Pointer;
begin
  result:=scalable_getmem(Size);
if Assigned(Result) then
  FillChar(Result^, Size, 0);
end;

function RegisterUnregisterExpectedMemoryLeak(P: Pointer): Boolean; inline;
begin
  Result := False;
end;

Const
 CMemoryManager : TMemoryManagerEx =
    (
      GetMem : CGetmem;
      FreeMem : CFreeMem;
      //FreememSize : CFreememSize;
      ReallocMem : CReAllocMem;
      AllocMem : CAllocMem;
      //MemSize : CMemSize;
      //MemAvail : CMemAvail;
      //MaxAvail : MaxAvail;
      //HeapSize : CHeapSize;
      RegisterExpectedMemoryLeak: RegisterUnregisterExpectedMemoryLeak;
      UnregisterExpectedMemoryLeak: RegisterUnregisterExpectedMemoryLeak
    );

Var
  OldMemoryManager : TMemoryManagerEx;

Initialization
  GetMemoryManager(OldMemoryManager);
  SetMemoryManager(CmemoryManager);

Finalization
  SetMemoryManager(OldMemoryManager);
end.
