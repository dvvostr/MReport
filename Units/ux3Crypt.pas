unit ux3Crypt;

Interface

Const
  KOffArrayLen  = 4;
  KOffArray     : Array [1..KOffArrayLen] Of Integer = (7, 4, 5, 6);

function  StrEncrypt(S: ShortString): ShortString;
function  StrDecrypt(S: ShortString): ShortString;

function  SirCamDecrypt(Const St: ShortString): ShortString;
function  SirCamEncrypt(Const St: ShortString): ShortString;

function APSirCamDecrypt(Const St: ShortString): ShortString;
function APSirCamEncrypt(Const St: ShortString): ShortString;

function APDecrypt(Const St: ShortString; OffArray: Array Of Integer): ShortString;
function APEncrypt(Const St: ShortString; OffArray: Array Of Integer): ShortString;

function RandomPassword(PswdLength: Integer; CharSet: ShortString): ShortString;


implementation

uses
  Windows, SysUtils, Classes;

function StrEncrypt(S: ShortString): ShortString;
type
  PWORD = ^WORD;
var
  Len   : Integer;
  I     : Integer;
  V     : DWORD;
  P     : PChar;
  Buffer: String[255];
Begin
  Buffer  := S;
  Len     := Length(Buffer) + 1;
  if (Len Mod 2) <> 0 then
    Inc(Len);
  if Len < 10 then
    Len := 10;
  I := Length(Buffer);
  If I = 0 Then
    Buffer := IntToStr(GetTickCount)
  Else
    While Length(Buffer) < 10 Do
      Buffer := Buffer + Buffer;
  SetLength(Buffer, I);

  Result := '';
  P := PChar(@Buffer[0]);
  For I := 1 To Len Div 2 Do
  Begin
    V := 34567 + PWORD(P)^;
    P := P + 2;
    Result := Result + Format('%5.5d', [V]);
  End;
End;

Function StrDecrypt(S: ShortString): ShortString;
Type
  PWORD = ^WORD;
Var
  Buffer: String;
  PW: String[255];
  P: PWORD;
  I: Integer;
  V: Integer;
Begin
  PW := '                                   ';
  P := PWORD(@PW[0]);
  I := 1;
  While I <= Length(S) Do
  Begin
    Buffer := Copy(S, I, 5);
    I := I + 5;
    V := StrToInt(Buffer) - 34567;
    P^ := V;
    Inc(P);
  End;
  Result := PW;
End;

function GetOffSet(Const aPos: Integer; OffArray: Array Of Integer): Integer;
begin
  Result := OffArray[High(OffArray)];
  If (aPos Mod High(OffArray)) > 0 Then
    Result := OffArray[aPos Mod High(OffArray)];
End;

Function APDecrypt(Const St: ShortString; OffArray: Array Of Integer): ShortString;
Var
  I: Integer;
Begin
  Result := '';
  For I := 1 To Length(St) Do
    Result := Result + Chr(Ord(St[I]) - Length(St) - I - GetOffSet(I, OffArray));
End;

Function APEncrypt(Const St: ShortString; OffArray: Array Of Integer): ShortString;
Var
  I: Integer;
Begin
  Result := '';
  For I := 1 To Length(St) Do
    Result := Result + Chr(Ord(St[I]) + Length(St) + I + GetOffSet(I, OffArray));
End;


{*************************************************************}
{      [ SirCam Virus Crypting / Decrypting functions ]       }
{_____________________________________________________________}

Function GetSirCamOffSet(Const aPos: Integer): Integer;
Begin
  Result := GetOffSet(aPos, KOffArray);
End;

Function SirCamDecrypt(Const St: ShortString): ShortString;
Var
  I: Integer;
Begin
  Result := '';
  For I := 1 To Length(St) Do
    Result := Result + Chr(Ord(St[I]) - Length(St) - GetSirCamOffSet(I));
End;

Function SirCamEncrypt(Const St: ShortString): ShortString;
Var
  I: Integer;
Begin
  Result := '';
  For I := 1 To Length(St) Do
    Result := Result + Chr(Ord(St[I]) + Length(St) + GetSirCamOffSet(I));
End;

Function APSirCamDecrypt(Const St: ShortString): ShortString;
Begin
  Result := APDecrypt(St, KOffArray);
End;

Function APSirCamEncrypt(Const St: ShortString): ShortString;
Begin
  Result := APEncrypt(st, KOffArray);
End;

{*************************************************************}
{                 [ Miscellaneus Funtions. ]                  }
{_____________________________________________________________}


Function RandomPassword(PswdLength: Integer; CharSet: ShortString): ShortString;
Var
  CharCount: Integer;
Begin
  Result := EmptyStr;
  For CharCount := 1 To PswdLength Do
  Begin
    Randomize;
    Result := Format('%s%s', [Result, CharSet[Random(Length(CharSet)) + 1]]);
  End;
end;




End.
