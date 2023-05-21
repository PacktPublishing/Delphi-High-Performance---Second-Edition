program DecompressTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Win.Crtl,
  System.SysUtils;

{$LINK decompress.obj}
//{$LINK huffman.obj}    // uncomment to fix: [dcc32 Error] DecompressTest.dpr(41): E2065 Unsatisfied forward or external declaration: 'BZ2_hbCreateDecodeTables'
//{$LINK bzlib.obj}      // uncomment to fix: [dcc32 Error] DecompressTest.dpr(41): E2065 Unsatisfied forward or external declaration: 'BZ2_indexIntoF'
//{$LINK compress.obj}   // uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'BZ2_compressBlock'
//{$LINK blocksort.obj}  // uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'BZ2_blockSort'

// because compiler is single-pass
//procedure BZ2_decompress; external;           //decompress.obj // uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'BZ2_decompress'
//procedure BZ2_hbMakeCodeLengths; external;    //huffman.obj    // uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'BZ2_hbMakeCodeLengths'
//procedure BZ2_hbAssignCodes; external;        //huffman.obj    // uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'BZ2_hbAssignCodes'

//var
//  BZ2_rNums: array[0..511] of Longint;        // uncomment to fix: [dcc32 Error] DecompressTest.dpr(41): E2065 Unsatisfied forward or external declaration: 'BZ2_rNums'
//  BZ2_crc32Table: array[0..255] of Longint;   // uncomment to fix: [dcc32 Error] DecompressTest.dpr(41): E2065 Unsatisfied forward or external declaration: 'BZ2_crc32Table'

// uncomment to fix: [dcc32 Error] DecompressTest.dpr(40): E2065 Unsatisfied forward or external declaration: 'bz_internal_error'
//procedure bz_internal_error(errcode: Integer); cdecl;
//begin
//  raise Exception.CreateFmt('Compression Error %d', [errcode]);
//end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
