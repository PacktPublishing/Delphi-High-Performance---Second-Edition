program LzmaDecTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows,
//  System.Win.Crtl, // uncomment to fix: [dcc32 Error] LzmaDecTest.dpr(28): E2065 Unsatisfied forward or external declaration: 'memcpy'
  System.SysUtils;

{$L LzmaDec.obj}

procedure LzmaDec_Init(var state); cdecl; external;
procedure LzmaDec_Free(var state; alloc: pointer); cdecl; external;

//function  memcpy(dest, src: Pointer; count: size_t): Pointer; cdecl; external 'msvcrt.dll';

// alternative solution:
//function memcpy(dest, src: Pointer; count: size_t): Pointer; cdecl;
//begin
//  Move(src^, dest^, count);
//  Result := dest;
//end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
