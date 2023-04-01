unit cmem;

//{$mode objfpc}

interface

Function scalable_getmem(Size : Longword) : Pointer;cdecl;external 'tbbmalloc' name 'scalable_malloc';
Procedure scalable_freemem(P : Pointer); cdecl; external 'tbbmalloc' name 'scalable_free';
function scalable_realloc(P : Pointer; Size : Longword) : pointer; cdecl;external 'tbbmalloc' name 'scalable_realloc';

implementation

Function CGetMem(Size : Longint) : Pointer;

begin
  result:=scalable_getmem(Size);
end;

Function CFreeMem(P : pointer) : Longint;

begin
  scalable_freemem(P);
  Result:=0;
end;

Function CReAllocMem(p:pointer;Size:longint):Pointer;
begin
  Result:=scalable_realloc(p,size);
end;

Function CAllocMem(Size : Longword) : Pointer;
begin
  result:=scalable_getmem(Size);
if Assigned(Result) then
  FillChar(Result^, Size, 0);
end;

Const
 CMemoryManager : TMemoryManagerEx =
    (
      GetMem : CGetmem;
      FreeMem : CFreeMem;
      //FreememSize : CFreememSize;
      //AllocMem : CAllocMem;
      ReallocMem : CReAllocMem;
      AllocMem : CAllocMem;
      //MemSize : CMemSize;
      //MemAvail : CMemAvail;
      //MaxAvail : MaxAvail;
      //HeapSize : CHeapSize;
    );

Var
  OldMemoryManager : TMemoryManagerEx;

Initialization
  GetMemoryManager(OldMemoryManager);
  SetMemoryManager(CmemoryManager);

Finalization
  SetMemoryManager(OldMemoryManager);
end.
