{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2023 Spring4D Team                           }
{                                                                           }
{           http://www.spring4d.org                                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

{$I Spring.inc}

unit Spring.Patches.RSP13163;

interface

implementation

{$IFDEF DELPHIXE_UP}{$IFDEF MSWINDOWS}
uses
  Rtti,
  SysUtils,
  TypInfo,
  Windows;

type
  PInterceptFrame = Pointer;

  PParamLoc = ^TParamLoc;
  TParamLoc = record
    FTypeInfo: PTypeInfo;
    FByRefParam: Boolean;
    {$IFDEF DELPHIX_RIO_UP}
    FConstant: Boolean;
    {$ENDIF}
    {$IFDEF DELPHIX_SYDNEY_UP}
    FSetDefault: Boolean;
    {$ENDIF}
    {$IFDEF DELPHIX_ALEXANDRIA_UP}
    FOpenArray: Boolean;
    {$ENDIF}
    FOffset: Integer;
    class var GetArgLoc: function(Self: Pointer; AFrame: PInterceptFrame): Pointer;
    procedure GetArg(AFrame: PInterceptFrame; out Value: TValue);
  end;

procedure TParamLoc.GetArg(AFrame: PInterceptFrame; out Value: TValue);
var
  loc: Pointer;
begin
  loc := GetArgLoc(@Self, AFrame);
  if FTypeInfo = nil then
    TValue.Make(@loc, TypeInfo(Pointer), Value)
  else
    if FTypeInfo.Kind = tkClass then
    begin
      TValue.Make(nil, FTypeInfo, Value);
      TValueData(Value).FAsObject := PPointer(loc)^;
    end
    else
    begin
      {$IFDEF DELPHIX_SYDNEY_UP}
      if (FTypeInfo.Kind = tkMRecord) and FSetDefault then
        InitializeArray(loc, FTypeInfo, 1);
      {$ENDIF}
      TValue.Make(loc, FTypeInfo, Value);
    end;
end;

function FindMethodBytes(StartAddress: Pointer; const Bytes: array of SmallInt; MaxCount: Integer): PByte;

  function XCompareMem(P: PByte; C: PSmallint; Len: Integer): Boolean;
  begin
    while (Len > 0) and ((C^ = -1) or (P^ = Byte(C^))) do
    begin
      Dec(Len);
      Inc(P);
      Inc(C);
    end;
    Result := Len = 0;
  end;

var
  FirstByte: Byte;
  EndAddress: PByte;
  Len: Integer;
begin
  FirstByte := Bytes[0];
  Len := Length(Bytes) - 1;
  Result := StartAddress;
  EndAddress := Result + MaxCount;
  while Result < EndAddress do
  begin
    while (Result < EndAddress) and (Result[0] <> FirstByte) do
      Inc(Result);
    if (Result < EndAddress) and XCompareMem(Result + 1, @Bytes[1], Len) then
      Exit;
    Inc(Result);
  end;
  Result := nil;
end;

procedure RedirectFunction(OrgProc, NewProc: Pointer);
type
  TJmpBuffer = packed record
    Jmp: Byte;
    Offset: Integer;
  end;
var
  n: UINT_PTR;
  JmpBuffer: TJmpBuffer;
begin
  JmpBuffer.Jmp := $E9;
  JmpBuffer.Offset := PByte(NewProc) - (PByte(OrgProc) + 5);
  if not WriteProcessMemory(GetCurrentProcess, OrgProc, @JmpBuffer, SizeOf(JmpBuffer), n) then
    RaiseLastOSError;
end;

procedure ApplyPatch;
{$IFDEF DELPHIXE}
const
  GetArgCallBytes: array[0..11] of SmallInt = (
    $8B, $C8,      // mov ecx,eax
    $8B, $45, $FC, // mov eax,[ebp-$04]
    $8D, $04, $B8, // lea eax,[eax+edi*4]
    $8B, $55, $F8, // mov edx,[ebp-$08]
    $E8            // call TMethodImplementation.TParamLoc.GetArg
  );
  GetArgLocCallBytes: array[0..11] of SmallInt = (
    $8B, $C3,            // mov eax,ebx
    $8B, $D7,            // mov edx,edi
    $E8, -1, -1, -1, -1, // call TMethodImplementation.TParamLoc.GetArgLoc
    $89, $45, $FC        // mov [ebp-$04],eax
  );
var
  ctx: TRttiContext;
  p: PByte;
  GetArgAddress: Pointer;
begin
  // Get the code pointer of the TMethodImplementation.TInvokeInfo.GetParamLocs method for which
  // extended RTTI is available to find the private types TInvokeInfo private method LoadArguments.
  p := ctx.GetType(TMethodImplementation).GetField('FInvokeInfo').FieldType.GetMethod('GetParamLocs').CodeAddress;

  // Find the "locs[i].GetArg(AFrame, Result[i]);" call
  p := FindMethodBytes(p - 300 - Length(GetArgCallBytes), GetArgCallBytes, 300 - Length(GetArgCallBytes));
  if p <> nil then
  begin
    GetArgAddress := (p + 12 + 4) + PInteger(@p[12])^;
    // Find the "loc := GetArgLoc(AFrame);" call
    p := FindMethodBytes(GetArgAddress, GetArgLocCallBytes, 100);
    if p <> nil then
    begin
      TParamLoc.GetArgLoc := Pointer((p + 5 + 4) + PInteger(@p[5])^);
      RedirectFunction(GetArgAddress, @TParamLoc.GetArg);
    end;
  end;
{$ELSE}
var
  ctx: TRttiContext;
  GetArgAddress: Pointer;
begin
  with ctx.GetType(TMethodImplementation).GetField('FInvokeInfo').FieldType.GetField('FResultLoc').FieldType do
  begin
    GetArgAddress := GetMethod('GetArg').CodeAddress;
    TParamLoc.GetArgLoc := GetMethod('GetArgLoc').CodeAddress;
  end;
  RedirectFunction(GetArgAddress, @TParamLoc.GetArg);
{$ENDIF}
end;

initialization
  ApplyPatch;
{$ENDIF}{$ENDIF}

end.
