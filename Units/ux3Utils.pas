unit ux3Utils;

interface

uses
  System.Classes, System.Variants, System.SysUtils, System.StrUtils,
  Xml.XMLIntf, Xml.XMLDoc, Win.ComObj, ux3Classes;



function IfThen(AValue: Boolean; const ATrue: Variant; AFalse: Variant): Variant;
function TagToString(ATag: Integer): String;
procedure Split(AStr: String; ADelimiter: Char; AResult: TStrings);
procedure TextSave(AText, AFileName: String);
function CheckVarValue(const AValue: Variant; ADataType: Tx3DataType; ADefault: Variant): Variant;
function StrToDateType(const AValue: String): Tx3DataType;
function FindNode(ARoot: IXMLNode; APath: String; ANamespace: String = ''): IXMLNode;

implementation

function IfThen(AValue: Boolean; const ATrue: Variant; AFalse: Variant): Variant;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function TagToString(ATag: Integer): String;
var
  FStr: ^String;
begin
  Result := '';
  try
    if (ATag <> 0) then
      Result := PString(ATag)^;
  except
    Result := '';
  end;
end;

procedure Split(AStr: String; ADelimiter: Char; AResult: TStrings) ;
begin
  if Assigned(AResult) then
  begin
    AResult.Clear;
    AResult.Delimiter       := ADelimiter;
    AResult.StrictDelimiter := True;
    AResult.DelimitedText   := AStr;
  end;
end;

procedure TextSave(AText, AFileName: String);
var
  FSL: TStringList;
begin
  FSL := TStringList.Create;
  try
    FSL.Text := AText;
    FSL.SaveToFile(AFileName);
  finally
    FSL.Clear;
    FSL.Free;
  end;
end;

function CheckVarValue(const AValue: Variant; ADataType: Tx3DataType; ADefault: Variant): Variant;
var
  i, j: Integer;

begin
  try
    Result := null;
    try
      if VarIsEmpty(AValue) or VarIsNull(AValue) then
        Result := ADefault
      else
        case ADataType of
          dtString  : Result := VarToStr(AValue);
          dtInteger : begin
            val(AValue, i, j);
            if j = 0 then
              Result := i;
          end;
          else
            Result := AValue;
        end;
    finally
      if VarIsNull(Result) or VarIsEmpty(Result) then
        Result := ADefault;
    end;
  except on e: Exception do
    Result  := ADefault;
  end;
end;

function StrToDateType(const AValue: String): Tx3DataType;
var
  FValue: Integer;
begin
  try
    FValue := StrToInt(AValue);
    if (FValue in [Integer(Low(Tx3DataType))..Integer(High(Tx3DataType))]) then
      Result := Tx3DataType(FValue)
    else
      Result := dtUnassigned;
  except
    Result := dtUnassigned;
  end;
end;

function FindNode(ARoot: IXMLNode; APath: String; ANamespace: String = ''): IXMLNode;
var
  i: Integer;
  FSL: TStringList;
  FNode: IXMLNode;
begin
  Result := nil;
  if Assigned(ARoot) then
  begin
    try
      FSL := TStringList.Create;
      FNode := ARoot;
      Split(APath, '/', FSL);
      for i := 0 to FSL.Count - 1 do
      begin
        if Assigned(FNode) And (i = FSL.Count - 1) then
          if (Length(ANamespace) > 0) and (Pos(':', FSL[i]) > 0) then
            Result := FNode.ChildNodes.FindNode(FSL[i], ANamespace)
          else
            Result := FNode.ChildNodes.FindNode(FSL[i])
        else if Assigned(FNode) then
          if (Length(ANamespace) > 0) and (Pos(':', FSL[i]) > 0) then
            FNode := FNode.ChildNodes.FindNode(FSL[i], ANamespace)
          else
            FNode := FNode.ChildNodes.FindNode(FSL[i])
        else
          Exit;
      end;
    finally
      FSL.Free;
    end;
  end;
end;

end.
