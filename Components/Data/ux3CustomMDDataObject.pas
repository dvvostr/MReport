unit ux3CustomMDDataObject;


interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, Winapi.ActiveX, Winapi.ADOInt, Data.Win.ADODB, ADOMD_TLB,
  Xml.XMLIntf, Xml.XMLDoc, Win.ComObj, Winapi.msxml,
  System.JSON;

type
  Tx3MDAccessType = (atNone, atWindows, atPassword);

  Tx3MDErrorTextEvent = procedure(ASender: TObject; AMessage: String) of Object;

  Tx3MDCustomAccessInfo = packed record
    AccessType: Tx3MDAccessType;
    ServerName: String;
    CatalogName: String;
    UserName: String;
    Password: String;
  end;

  Tx3MDColumn = class(TObject)
    Name: String;
    Caption: String;
    ValueType: TVarType;
    IsIndex: Boolean;
    PosIndex: Integer;
    public
      constructor Create(); overload;
      constructor Create(ACaption: String; AValueType: TVarType); overload;
  end;

  Tx3MDRowValue   = OleVariant;
  Tx3MDRowValues  = array of Tx3MDRowValue;
  Px3MDRowValues  = ^Tx3MDRowValues;

  Tx3MDQueryData = class
    protected
    private
      FColumns    : TList;
      FRows       : TList;
      FErrorEvent : Tx3MDErrorTextEvent;
      function    GetKeyColumns: Tx3MDRowValues;
      function    GetColumn(AName: String): Tx3MDColumn; overload;
      function    GetColumn(AIndex: Integer): Tx3MDColumn; overload;
      function    ColumnsArray: Tx3MDRowValues;
      function    ValuesArray(ARow: Integer): Tx3MDRowValues;
    public
      constructor Create();
      destructor  Destroy(); override;
      procedure   Clear();
      function    AddColumn(AColumn: Tx3MDColumn): Integer;
      function    AddRow(ARow: Px3MDRowValues): Integer;
      function    CompareKeys(AValue: Tx3MDQueryData): Boolean;
      function    AddData(AValue: Tx3MDQueryData): Boolean;
      function    AsRecordset: _Recordset;
      function    AsXML(ARootName: String = 'data'): TXMLDocument;
      function    AsXMLNode(ARootName: String = 'data'): IXMLDOMNode;
      function    AsJSON: TJSONObject;
      procedure   PrintColumns();
      property    Columns[AName: String]: Tx3MDColumn read GetColumn; default;
      property    Columns[AIndex: Integer]: Tx3MDColumn read GetColumn; default;
    published
      property    OnError: Tx3MDErrorTextEvent read FErrorEvent write FErrorEvent;
  end;

  Tx3MDCustomDataObject = class(TObject)
    protected
    private
      FCatalog: Catalog;
      class function InternalOpenQueryA(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var AData: Tx3MDQueryData; var AMsg: String): Boolean;
      class function InternalOpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var AData: Tx3MDQueryData; var AMsg: String): Boolean;
    public
      constructor Create();
      destructor  Destroy(); override;
      function    OpenCatalog(AAccessInfo: Tx3MDCustomAccessInfo; var AMsg: String): Boolean;
      class function TestConnection(AAccessInfo: Tx3MDCustomAccessInfo; var AMsg: String): Boolean;
      class function OpenQuery(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var AData: Tx3MDQueryData; var AMsg: String): Boolean; overload;
      class function OpenQuery(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var ARecordset: _Recordset; var AMsg: String): Boolean; overload;
      class function OpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var ARecordset: _Recordset; var AMsg: String): Boolean; overload;
      class function OpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var AMsg: String): _Recordset; overload;
    published
  end;

  function CreateMDAccesInfo(AAccessType: Tx3MDAccessType; AServerName, ACatalogName, AUserName, APassword: String): Tx3MDCustomAccessInfo;

implementation

const
  MD_DATA_SOURCE: array[Low(Tx3MDAccessType)..High(Tx3MDAccessType)] of String = (
    '',
//----------------------------------------//
    'Provider=MSOLAP.8;' +
    'Integrated Security=SSPI;' +
    'Persist Security Info=True;' +
    'Data Source=%s;' +
    'Initial Catalog=%s;' +
    'MDX Compatibility=1;' +
    'Safety Options=2;' +
    'MDX Missing Member Mode=Error;' +
    'Update Isolation Level=2' +
    '%s%s',
//----------------------------------------//
    'Provider=MSOLAP.8;' +
    'Data Source=%s;' +
    'Initial Catalog=%s;' +
    'User Id=%s;' +
    'Password=%s;' +
    'MDX Compatibility=1;' +
    'Safety Options=2;' +
    'MDX Missing Member Mode=Error;' +
    'Update Isolation Level=2'
  );

//****************************************************************************//
function CreateMDAccesInfo(AAccessType: Tx3MDAccessType; AServerName, ACatalogName, AUserName, APassword: String): Tx3MDCustomAccessInfo;
begin
  Result.AccessType := AAccessType;
  Result.ServerName := IfThen(AAccessType <> atNone, AServerName, '');
  Result.CatalogName := IfThen(AAccessType <> atNone, ACatalogName, '');
  Result.UserName := IfThen(AAccessType = atPassword, AUserName, '');
  Result.Password := IfThen(AAccessType = atPassword, APassword, '');
end;
//****************************************************************************//
function Axies(X, Y: Integer): OleVariant;
begin
  Result := VarArrayCreate([0,1], varVariant);
  Result[0] := X;
  Result[1] := Y;
end;
//----------------------------------------------------------------------------//
function AddRowValue(var AArray: Tx3MDRowValues; const AValue: Tx3MDRowValue): Integer;
begin
  SetLength(AArray, High(AArray) + 2);
  AArray[High(AArray)] := AValue;
  Result := High(AArray);
end;
//----------------------------------------------------------------------------//
function GetRowColumnName(AValue: String): String;
var
  FArr: System.TArray<String>;
begin
  FArr  := AValue.Split(['.']);
  Result := FArr[High(FArr)];
end;
//----------------------------------------------------------------------------//
procedure PrintRowValue(const AArray: Tx3MDRowValues);
var
  i: Integer;
  FSL: TStringList;
begin
  try
    FSL := TStringList.Create;
    FSL.Delimiter := #9;
    for i := Low(AArray) to High(AArray) do
      if VarIsNull(AArray[i]) or VarIsEmpty(AArray[i]) then
        FSL.Add('null')
      else
        FSL.Add(VarToStr(AArray[i]));
     OutputDebugString(PChar(FSL.Text));
  finally
    FSL.Free;
  end;
end;
function VarTypeToAdoFieldType(AType: TVarType): DataTypeEnum;
begin
  case AType of
    varEmpty, varNull, varAny: Result := adBSTR;
    varSmallint: Result := adSmallInt;
    varInteger: Result := adInteger;
    varSingle: Result := adSingle;
    varDouble: Result := adDouble;
    varCurrency: Result := adCurrency;
    varDate: Result := adDate;
    varOleStr: Result := adVarWChar;
    varError: Result := adError;
    varBoolean: Result := adBoolean;
    varVariant: Result := adVariant;
    varUnknown: Result := adEmpty;
    varShortInt: Result := adTinyInt;
    varByte: Result := adBinary;
    varWord: Result := adUnsignedInt;
    varLongWord: Result := adUnsignedBigInt;
    varInt64: Result := adBigInt;
    varStrArg: Result := adVarChar;
    varString: Result := adVarChar;
    varArray: Result := adArray;
    varDispatch: Result := adIDispatch;
//    varByRef
//    varTypeMask
    else Result := adEmpty;
  end;
end;
function VarTypeToDataLength(AType: TVarType): Integer;
begin
  case AType of
    varEmpty, varNull, varAny: Result := 250;
    varSmallint: Result := 2;
    varInteger: Result := 4;
    varSingle: Result := 4;
    varDouble: Result := 8;
    varCurrency: Result := 8;
    varDate: Result := 0;
    varOleStr: Result := 255;
    varError: Result := 255;
    varBoolean: Result := 2;
    varVariant: Result := 8016;
    varUnknown: Result := 1;
    varShortInt: Result := 2;
    varByte: Result := 50;
    varWord: Result := 16;
    varLongWord: Result := 32;
    varInt64: Result := 64;
    varStrArg: Result := 255;
    varString: Result := 255;
    varArray: Result := 255;
    varDispatch: Result := 16;
//    varByRef
//    varTypeMask
    else Result := 1;
    Result := 8;
  end;
end;
//****************************************************************************//
constructor Tx3MDColumn.Create();
begin
  inherited Create;
  Name      := '';
  Caption   := '';
  PosIndex  := -1;
  ValueType := varEmpty;
  IsIndex   := False;
end;
constructor Tx3MDColumn.Create(ACaption: String; AValueType: TVarType);
begin
  Create;
  ValueType := varEmpty;
  IsIndex   := False;
end;
//****************************************************************************//
constructor Tx3MDQueryData.Create();
begin
  inherited Create;
  FColumns  := TList.Create;
  FRows     := TList.Create;
end;

destructor Tx3MDQueryData.Destroy();
begin
  Self.Clear;
  FColumns.Free;
  FRows.Free;
  inherited Destroy;
end;

function Tx3MDQueryData.GetKeyColumns: Tx3MDRowValues;
var
  i: Integer;
  FColumn: Tx3MDColumn;
begin
  SetLength(Result, 0);
  for i := 0 to FColumns.Count - 1 do
  begin
    FColumn := Tx3MDColumn(FColumns[i]);
    if FColumn.IsIndex then
    begin
      SetLength(Result, High(Result) + 2);
      Result[High(Result)] := FColumn.Name;
    end;
  end;
end;

function Tx3MDQueryData.GetColumn(AName: string): Tx3MDColumn;
begin

end;

function Tx3MDQueryData.GetColumn(AIndex: Integer): Tx3MDColumn;
begin
  if (AIndex > 0) and (AIndex < FColumns.Count - 1) then
 // TODO   Result := Tx3MDColumn(fco


end;

function Tx3MDQueryData.ColumnsArray: Tx3MDRowValues;
var
  i: Integer;
begin
  SetLength(Result, FColumns.Count);
  for i := 0 to FColumns.Count - 1 do
    Result[i] := Tx3MDColumn(FColumns[i]).Caption;
end;

function Tx3MDQueryData.ValuesArray(ARow: Integer): Tx3MDRowValues;
var
  i: Integer;
begin
  if (ARow >= 0) and (ARow < FRows.Count)  then
  begin
    SetLength(Result, High(Px3MDRowValues(FRows[ARow])^) + 1);
    for i := 0 to High(Px3MDRowValues(FRows[ARow])^) do
      Result[i] := Px3MDRowValues(FRows[ARow])^[i];
  end
  else
    SetLength(Result, 0);
end;

procedure Tx3MDQueryData.Clear();
begin
  FColumns.Clear;
  FRows.Clear;
end;

function Tx3MDQueryData.AddColumn(AColumn: Tx3MDColumn): Integer;
begin
  Result := FColumns.Add(AColumn);
end;

function Tx3MDQueryData.AddRow(ARow: Px3MDRowValues): Integer;
begin
  Result := FRows.Add(ARow);
end;

function Tx3MDQueryData.CompareKeys(AValue: Tx3MDQueryData): Boolean;
var
  i: Integer;
  FArr1, FArr2: Tx3MDRowValues;
begin
  Result := (FColumns.Count > 0) and (AValue.FColumns.Count > 0);
  if Result then
  begin
    FArr1 := GetKeyColumns;
    FArr2 := AValue.GetKeyColumns;
    Result := (Low(FArr1) = Low(FArr2)) and (High(FArr1) = High(FArr2));
    if Result then
      for i := Low(FArr1) to High(FArr2) do
      begin
        Result := (CompareText(VarToStr(FArr1[i]), VarToStr(FArr2[i])) = 0);
        if not Result then
          Exit;
      end;
  end;
end;

function Tx3MDQueryData.AddData(AValue: Tx3MDQueryData): Boolean;
var
  i: Integer;
begin
  Result := CompareKeys(AValue);
  if Result then
  begin
    try

    except on e: Exception do
    begin
      Result := False;
      if Assigned(FErrorEvent) then
        FErrorEvent(Self, e.Message);
    end; end;
  end;
end;

procedure Tx3MDQueryData.PrintColumns;
var
  i: Integer;
  FStr: String;
begin
  for i := 0 to FColumns.Count - 1 do
    FStr := Concat(FStr, IfThen(Length(FStr) = 0, '', ' | '), Format('%s [%d]', [Tx3MDColumn(FColumns[i]).Caption, Tx3MDColumn(FColumns[i]).ValueType]));
  OutputDebugString(PChar(FStr));
end;

function Tx3MDQueryData.AsRecordset: _Recordset;
var
  i: Integer;
  FColumn: Tx3MDColumn;
  FFields: Tx3MDRowValues;
  FValues: Tx3MDRowValues;
begin
  Result := CoRecordset.Create;
  if Assigned(FColumns) and Assigned(FRows) then
  begin
    for i := 0 to FColumns.Count - 1 do
    begin
      FColumn := Tx3MDColumn(FColumns[i]);
      Result.Fields._Append(FColumn.Caption, VarTypeToAdoFieldType(FColumn.ValueType), VarTypeToDataLength(FColumn.ValueType), adFldMayBeNull + adFldIsNullable);
//      Result.Fields._Append(FColumn.Caption, adBSTR, 250, adFldMayBeNull + adFldIsNullable);
    end;
    Result.Open(EmptyParam, EmptyParam, adOpenStatic, adLockOptimistic, 0);
    FFields := ColumnsArray;
    for i := 0 to FRows.Count - 1 do
    begin
      FValues := ValuesArray(i);
//      OutputDebugString(PChar(Format('%d - %d', [High(FFields), High(FValues)])));
      Result.AddNew(FFields, FValues);
    end;
  end;
end;

function Tx3MDQueryData.AsXML(ARootName: String = 'data'): TXMLDocument;
var
  FRoot, FNode, FRow: IXMLNode;
  FColumn: Tx3MDColumn;
  FValues: Tx3MDRowValues;
  i, j: Integer;
begin
  Result := TXMLDocument.Create(nil);
  Result.Active := True;
  Result.DocumentElement := Result.CreateNode(ARootName, ntElement, '');
  FNode := Result.DocumentElement.AddChild('columns', -1);
  for i := 0 to FColumns.Count - 1 do
  begin
    FColumn := Tx3MDColumn(FColumns[i]);
    with FNode.AddChild('column') do
    begin
      Attributes['name'] := ReplaceStr(FColumn.Name, #2, '&#0002');
      Attributes['caption'] := FColumn.Caption;
      Attributes['posIndex'] := i + 1; // FColumn.PosIndex;
      Attributes['valueType'] := FColumn.ValueType;
      Attributes['isIndex'] := FColumn.IsIndex;
    end;
  end;
  FNode := Result.DocumentElement.AddChild('values', -1);
  for i := 0 to FRows.Count - 1 do
  begin
    FValues := ValuesArray(i);
    FRow := FNode.AddChild('row');
    FRow.Attributes['posIndex'] := i;
    for j := Low(FValues) to High(FValues) do
      if (j >= 0) and (j < FColumns.Count) then
      begin
        FColumn := FColumns[j];
        FRow.Attributes[Format('column_%d', [j + 1])] := FValues[j];
      end;
  end;
end;

function Tx3MDQueryData.AsXMLNode(ARootName: String = 'data'): IXMLDOMNode;
var
  FDocument: IXMLDOMDocument;
begin
  FDocument := CoDOMDocument.Create;
  FDocument.loadXML(Self.AsXML(ARootName).XML.Text);
  Result := FDocument.documentElement;
end;

function Tx3MDQueryData.AsJSON: TJSONObject;
var
  FJSONArray, FJSONRow: TJSONArray;
  FJSONObject: TJSONObject;
  FColumn: Tx3MDColumn;
  FValues: Tx3MDRowValues;
  i, j: Integer;
begin
  Result := TJSONObject.Create;

  FJSONArray := TJSONArray.Create;
  for i := 0 to FColumns.Count - 1 do
  begin
    FColumn := Tx3MDColumn(FColumns[i]);
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair('name', FColumn.Name);
    FJSONObject.AddPair('caption', FColumn.Caption);
    FJSONObject.AddPair('posIndex', TJSONNumber.Create(FColumn.PosIndex));
    FJSONObject.AddPair('valueType', TJSONNumber.Create(FColumn.ValueType));
    FJSONObject.AddPair('isIndex', TJSONBool.Create(FColumn.IsIndex));
    FJSONArray.Add(FJSONObject);
  end;
  Result.AddPair('columns', FJSONArray);

  FJSONArray := TJSONArray.Create;
  for i := 0 to FRows.Count - 1 do
  begin
    FValues := ValuesArray(i);
    FJSONRow := TJSONArray.Create;
    for j := Low(FValues) to High(FValues) do
      if (j >= 0) and (j < FColumns.Count) then
      begin
        FColumn := FColumns[j];
        FJSONRow.AddElement(TJSONString.Create(VarToStr(FValues[j])));
      end;
    FJSONArray.Add(FJSONRow);
  end;
  Result.AddPair('values', FJSONArray);
end;

//****************************************************************************//
constructor Tx3MDCustomDataObject.Create();
begin
  inherited Create();
end;

destructor Tx3MDCustomDataObject.Destroy();
begin
  FCatalog  := nil;
  inherited Destroy();
end;
//****************************************************************************//
class function Tx3MDCustomDataObject.InternalOpenQueryA(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var AData: Tx3MDQueryData; var AMsg: String): Boolean;
var
  iX, iY, i, ic, ir: Integer;
  FCellSet  : Cellset;
  FCell     : Cell;
  FStr      : String;
  FArray    : OleVariant;
  FValue    : OleVariant;
  FColumn   : Tx3MDColumn;
  FValues   : Px3MDRowValues;
begin
  Result  := True;
  AMsg    := '';
  try try
    AData     := Tx3MDQueryData.Create;
    AData.Clear;
    FCellSet  := CoCellSet.Create;
    FCellSet.Open(AQuery, Format(MD_DATA_SOURCE[AAccessInfo.AccessType], [AAccessInfo.ServerName, AAccessInfo.CatalogName, AAccessInfo.UserName, AAccessInfo.Password]));
    Result := FCellSet.Axes.Count >= 2;
    if Result then
    begin
      for iY := 0 to FCellSet.Axes[1].Positions.Count - 1 do
      begin
        New(FValues);
        SetLength(FValues^, 0);
        for i := 0 to FCellSet.Axes[1].Positions[iY].Members.Count - 1 do
        begin
          if iY = 0 then
          begin
            FColumn := Tx3MDColumn.Create();
            FColumn.Name := FCellSet.Axes[1].Positions[iY].Members[i].Name;
            FColumn.Caption := GetRowColumnName(FCellSet.Axes[1].Positions[iY].Members[i].LevelName);
            FColumn.ValueType := varString;
            FColumn.IsIndex := True;
            FColumn.PosIndex:= FCellSet.Axes[1].Positions[iY].Members[i].LevelDepth;
            AData.AddColumn(FColumn);
          end;
          AddRowValue(FValues^, FCellSet.Axes[1].Positions[iY].Members[i].Caption);
        end;

        for iX := 0 to FCellSet.Axes[0].Positions.Count - 1 do
        begin
          try
            FStr := '';
            ic := -1;
            ir := -1;
            FValue := null;
            FArray := Axies(iX, iY);
            if iY = 0 then
            begin
              FColumn := Tx3MDColumn.Create();
              for i := 0 to FCellSet.Axes[0].Positions[iX].Members.Count - 1 do
              begin
                FColumn.Name := Concat(FColumn.Name, IfThen(Length(FColumn.Name) = 0, '', #2), FCellSet.Axes[0].Positions[iX].Members[i].Caption);
                FColumn.Caption := Concat(FColumn.Caption, IfThen(Length(FColumn.Caption) = 0, '', '_'), FCellSet.Axes[0].Positions[iX].Members[i].Caption);
              end;
              FColumn.Caption := Format('[%s]', [FColumn.Caption]);
              FColumn.ValueType := varEmpty;
              FColumn.IsIndex := False;
              FColumn.PosIndex := iX;
              ic := AData.AddColumn(FColumn);
            end;
            if (FCellSet.Item[PSafeArray(TVarData(FArray).VArray)].FormattedValue <> '') then
            begin
              FCell   := FCellSet.Item[PSafeArray(TVarData(FArray).VArray)];
              FValue  := FCell.Value;
            end
            else
              FValue := null;
          except on e: Exception do
             FValue := null;
          end;
          ir := AddRowValue(FValues^, FValue);
          if (AData.FColumns.Count > 0) and (ir < AData.FColumns.Count) then
          begin
            FColumn := Tx3MDColumn(AData.FColumns[ir]);
            if (FColumn.ValueType = varEmpty) or (FColumn.ValueType = varNull) then
              FColumn.ValueType := TVarData(FValue).VType;
          end;
        end;
        AData.AddRow(FValues);
      end;
    end;
  except on e: Exception do
    begin
      Result  := False;
      AMsg    := e.Message;
    end;
  end;
  finally
    FCellSet.Close;
    FCellSet := nil;
  end;
end;

class function Tx3MDCustomDataObject.InternalOpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var AData: Tx3MDQueryData; var AMsg: String): Boolean;
var
  FQuery   : String;
  i        : Integer;
  FCellSet : Cellset;
  FValue    : OleVariant;
  FColumn   : Tx3MDColumn;
  FValues   : Px3MDRowValues;

begin
  FQuery := 'Select '+'{'+' '+
            '       '+'}'+' on 0, '+
            ' '+ ADimention +
            IfThen(IsRestrictedHierarchy, ' ', '.members ') +
            'Dimension Properties member_caption, unique_name, parent_unique_name '+
            'On 1 '+
            'From [' + AAccessInfo.CatalogName + '] ';
  try try
    AData     := Tx3MDQueryData.Create;
    AData.Clear;
    FCellSet :=CoCellSet.Create;
    FCellSet.Open(FQuery, Format(MD_DATA_SOURCE[AAccessInfo.AccessType], [AAccessInfo.ServerName, AAccessInfo.CatalogName, AAccessInfo.UserName, AAccessInfo.Password]));
    Result := FCellSet.Axes.Count >= 2;
    for i := 0 to 2 do
    begin
      FColumn := Tx3MDColumn.Create();
      case i of
        0: FColumn.Name := 'NAME';
        1: FColumn.Name := 'ID';
        2: FColumn.Name := 'PARENT';
      end;
      FColumn.Caption   := FColumn.Name;
      FColumn.ValueType := varString;
      AData.AddColumn(FColumn);
    end;
    for i:= 0 to FCellSet.Axes[1].Positions.Count - 1 do
    begin
      New(FValues);
      FValues^ := VarArrayOf([
        FCellSet.Axes[1].Positions[i].Members[0].Properties.Item[0].Value,
        FCellSet.Axes[1].Positions[i].Members[0].Properties.item[1].Value,
        FCellSet.Axes[1].Positions[i].Members[0].Properties.item[2].Value
      ]);
      AData.AddRow(FValues);
    end;
  except on e: exception do
  begin
    Result := False;
    AMsg := e.Message;
  end; end;
  finally
    FCellSet.Close;
    FCellSet := nil;
  end;
end;

class function Tx3MDCustomDataObject.TestConnection(AAccessInfo: Tx3MDCustomAccessInfo; var AMsg: String): Boolean;
var
  FObj: Tx3MDCustomDataObject;
begin
  try
    FObj := Tx3MDCustomDataObject.Create;
    Result := FObj.OpenCatalog(AAccessInfo, AMsg);
  finally
    FObj.Free;
  end;

end;

function Tx3MDCustomDataObject.OpenCatalog(AAccessInfo: Tx3MDCustomAccessInfo; var AMsg: String): Boolean;
var
  FStr: String;
begin
  Result  := AAccessInfo.AccessType <> atNone;
  if not Result then
  begin
    AMsg := 'Подключение невозможно. Проверьте настройки программы';
    Exit;
  end
  else
    AMsg    := '';
  try
    FCatalog := CoCatalog.Create;
    FStr := Format(MD_DATA_SOURCE[AAccessInfo.AccessType], [AAccessInfo.ServerName, AAccessInfo.CatalogName, AAccessInfo.UserName, AAccessInfo.Password]);
    FCatalog.Set_ActiveConnection(OleVariant(FStr));
    Result := (FCatalog.CubeDefs.Count > 0);
  except on e: Exception do
    begin
      Result  := False;
      AMsg    := e.Message;
    end;
  end;
end;

class function Tx3MDCustomDataObject.OpenQuery(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var AData: Tx3MDQueryData; var AMsg: String): Boolean;
begin
  AData := Tx3MDQueryData.Create;
  Result  := Tx3MDCustomDataObject.InternalOpenQueryA(AAccessInfo, AQuery, AData, AMsg);
  if Result then
    AMsg := 'OK';
end;

class function Tx3MDCustomDataObject.OpenQuery(AAccessInfo: Tx3MDCustomAccessInfo; AQuery: String; var ARecordset: _Recordset; var AMsg: String): Boolean;
var
  FData: Tx3MDQueryData;
begin
  FData := Tx3MDQueryData.Create;
  Result  := Tx3MDCustomDataObject.InternalOpenQueryA(AAccessInfo, AQuery, FData, AMsg);
  if Result then
    ARecordset := FData.AsRecordset
  else
    ARecordset := nil;
end;

class function Tx3MDCustomDataObject.OpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var ARecordset: _Recordset; var AMsg: String): Boolean;
var
  FData: Tx3MDQueryData;
begin
  FData := Tx3MDQueryData.Create;
  Result  := Tx3MDCustomDataObject.InternalOpenDimention(AAccessInfo, ADimention, IsRestrictedHierarchy, FData, AMsg);
  if Result then
    ARecordset := FData.AsRecordset
  else
    ARecordset := nil;
end;

class function Tx3MDCustomDataObject.OpenDimention(AAccessInfo: Tx3MDCustomAccessInfo; ADimention: String; IsRestrictedHierarchy: Boolean; var AMsg: String): _Recordset;
var
 FStr     : String;
 FCellSet : ICellset;
 i        : Integer;
 FValue1, FValue2, FValue3: OleVariant;
begin
  FStr :=
          'SELECT '+'{ }'+' ON 0, '+ ADimention +
          IfThen(IsRestrictedHierarchy, ' ', '.MEMBERS ')+
          'DIMENSION PROPERTIES UNIQUE_NAME, PARENT_UNIQUE_NAME, MEMBER_CAPTION ON 1 '+
          'FROM ['+ AAccessInfo.CatalogName +'] ';
  try try
    FCellSet := CoCellSet.Create;
    FCellSet.Open(FStr, Format(MD_DATA_SOURCE[AAccessInfo.AccessType], [AAccessInfo.ServerName, AAccessInfo.CatalogName, AAccessInfo.UserName, AAccessInfo.Password]));
    Result := CoRecordset.Create;
    Result.Fields._Append('ID', adVarChar, 250, adFldMayBeNull + adFldIsNullable);
    Result.Fields._Append('PARENT',adVarChar, 250, adFldMayBeNull + adFldIsNullable);
    Result.Fields._Append('NAME', adVarChar, 250, adFldMayBeNull + adFldIsNullable);
    Result.Open(EmptyParam, EmptyParam, adOpenStatic, adLockOptimistic, 0);
    for i:= 0 to FCellSet.Axes[1].Positions.Count - 1 do
    begin
      Result.AddNew(
        VarArrayOf(['ID', 'PARENT', 'NAME']),
        VarArrayOf([
            FCellSet.Axes[1].Positions[i].Members[0].Properties.item[0].Value,
            FCellSet.Axes[1].Positions[i].Members[0].Properties.item[1].Value,
            FCellSet.Axes[1].Positions[i].Members[0].Properties.item[2].Value
        ]
      ));
      FValue1 := FCellSet.Axes[1].Positions[i].Members[0].Properties.item[0].Value;
      FValue2 := FCellSet.Axes[1].Positions[i].Members[0].Properties.item[1].Value;
      FValue3 := FCellSet.Axes[1].Positions[i].Members[0].Properties.item[2].Value;
    end;
  except on e: Exception do
  begin
    Result := nil;
    AMsg := e.Message;
  end; end;
  finally
    FCellSet.Close;
    FCellSet := nil;
  end;
end;

end.
