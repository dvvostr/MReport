unit ux3MReportObject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.StrUtils, Vcl.Forms,
  Xml.XMLIntf, Xml.XMLDoc, ux3Classes, ux3Utils, ux3CustomMDDataObject, ux3ReportParam;

type
  Tx3MReportParamList = class;
  Tx3MReportParamItem = class;
  Tx3MReportTemplateList = class;
  Tx3MReportTemplateItem = class;
  Tx3MReportColumnList = class;
  Tx3MReportColumnItem = class;
  Tx3MReportDataList = class;
  Tx3MReportDataItem = class;

  Tx3MReportDataEventType = ( etUnassigned, rtQueryFormat );

  Tx3MReportFileVersion = packed record
    Minor: Integer;
    Major: Integer;
    Build: Integer;
  end;

  Tx3MReportDataEvent = procedure(Sender: TObject; ADataEventType: Tx3MReportDataEventType; AData: Tx3MReportDataItem; var AResult: Variant) of Object;

  Tx3MReportObject = class(TObject)
    protected
    private
      FFileName   : TFileName;
      FReportName : String;
      FCaption    : String;
      FReportFile : String;
      FScriptName : String;
      FFileVersion: Tx3MReportFileVersion;

      FParams     : Tx3MReportParamList;
      FTemplates  : Tx3MReportTemplateList;
      FColumns    : Tx3MReportColumnList;
      FData       : Tx3MReportDataList;

      FDataObject : Tx3MDCustomDataObject;

      FLastError  : String;

      FErrorEvent : Tx3ErrorEvent;
      procedure   Initialize;
      procedure   DoError(Sender: TObject; ACode: Integer; AMsg: String);
      procedure   DoDataEvent(Sender: TObject; ADataEventType: Tx3MReportDataEventType; AData: Tx3MReportDataItem; var AResult: Variant);
    public
      constructor Create(AFileName: TFileName);
      destructor  Destroy; override;
      class procedure SetReportListItems(AList: TStrings; AArray: TArray<Tx3ListItem>);
      function    Load(AFileName: TFileName): Boolean; overload;
      function    Load(AXML: String; IsParamsOnly: Boolean): Boolean; overload;
      function    LoadParams(AParams: TArray<Tx3ReportParam>): Boolean;
      function    Save(AFileName: TFileName): Boolean;
      function    AsXML(ARootName: String = 'report'): TXMLDocument;
    published
      property    FileName: TFileName read FFileName;
      property    Name: String read FReportName write FReportName;
      property    ReportFile: String read FReportFile write FReportFile;
      property    Caption: String read FCaption write FCaption;
      property    Script: String read FScriptName write FScriptName;
      property    FileVersion: Tx3MReportFileVersion read FFileVersion;
      property    Templates: Tx3MReportTemplateList read FTemplates;
      property    Columns: Tx3MReportColumnList read FColumns;
      property    Params: Tx3MReportParamList read FParams;
      property    Data: Tx3MReportDataList read FData;

      property    DataObject: Tx3MDCustomDataObject read FDataObject write FDataObject;

      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;

  Tx3MReportTemplateList = class(TCollection)
    protected
      procedure   Update(Item: TCollectionItem); override;
      procedure   DoItemChange(Item: TCollectionItem); dynamic;
    private
      FErrorEvent : Tx3ErrorEvent;
      function    GetItem(Index: Integer): Tx3MReportTemplateItem;
      procedure   SetItem(Index: Integer; const Value: Tx3MReportTemplateItem);
      procedure   DoError(Sender: TObject; ACode: Integer; AMsg: String);
    public
      constructor Create;
      destructor  Destroy; override;
      function    Add: Tx3MReportTemplateItem;
      procedure   FromXML(AXML: TXMLDocument);
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      property    Items[Index: Integer]: Tx3MReportTemplateItem read GetItem write SetItem; default;
    published
      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;
  
  Tx3MReportTemplateItem = class(TCollectionItem)
    protected
    private
      FName: String;
      FCaption: String;
      FValue: Variant;
    public
      constructor Create(Collection: TCollection); override;
      destructor  Destroy; override;
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
    published
      property Name: String read FName;
      property Caption: String read FCaption;
      property Value: Variant read FValue write FValue;
    end;
  Tx3MReportParamItem = class(TCollectionItem)
    protected
    private
      FName: String;
      FControl: String;
      FCaption: String;
      FDataType: Tx3DataType;
      FDefaultValue: String;
      FValue: Variant;
    public
      constructor Create(Collection: TCollection); override;
      destructor  Destroy; override;
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      procedure   AssignTo(ATarget: Tx3MReportParamItem);
      function    GetValue: Variant;
    published
      property Name: String read FName;
      property Control: String read FControl;
      property Caption: String read FCaption;
      property DataType: Tx3DataType read FDataType;
      property DefaultValue: String read FDefaultValue write FDefaultValue;
      property Value: Variant read GetValue write FValue;
    end;

  Tx3MReportParamList = class(TCollection)
    protected
      procedure   Update(Item: TCollectionItem); override;
      procedure   DoItemChange(Item: TCollectionItem); dynamic;
    private
      FErrorEvent : Tx3ErrorEvent;
      function    GetItem(Index: Integer): Tx3MReportParamItem;
      procedure   SetItem(Index: Integer; const Value: Tx3MReportParamItem);
      function    GetNodeValue(ANode: IXMLNode): Variant;
      procedure   DoError(Sender: TObject; ACode: Integer; AMsg: String);
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   CopyTo(ATarget: Tx3MReportParamList);
      function    Find(AName: String): Integer;
      function    FindControl(AName: String): Integer;
      function    Add: Tx3MReportParamItem;
      procedure   FromXML(AXML: TXMLDocument);
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      property    Items[Index: Integer]: Tx3MReportParamItem read GetItem write SetItem; default;
    published
      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;

  Tx3MReportColumnList = class(TCollection)
    protected
      procedure   Update(Item: TCollectionItem); override;
      procedure   DoItemChange(Item: TCollectionItem); dynamic;
    private
      FErrorEvent : Tx3ErrorEvent;
      function    GetItem(Index: Integer): Tx3MReportColumnItem;
      procedure   SetItem(Index: Integer; const Value: Tx3MReportColumnItem);
      procedure   DoError(Sender: TObject; ACode: Integer; AMsg: String);
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   CopyTo(ATarget: Tx3MReportColumnList);
      function    Find(AName: String): Integer;
      function    Add: Tx3MReportColumnItem;
      procedure   FromXML(AXML: TXMLDocument);
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      property    Items[Index: Integer]: Tx3MReportColumnItem read GetItem write SetItem; default;
    published
      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;
  Tx3MReportColumnItem = class(TCollectionItem)
    protected
    private
      FName: String;
      FCaption: String;
      FQueryName: String;
      FColumnIndex: Integer;
      FPosIndex: Integer;
      FLength: Integer;
      FColOffset: Integer;
      FPosOffset: Integer;
      FType: Integer;
    public
      constructor Create(Collection: TCollection); override;
      destructor  Destroy; override;
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      procedure   AssignTo(ATarget: Tx3MReportColumnItem);
    published
      property Name: String read FName;
      property Caption: String read FCaption;
      property QueryName: String read FQueryName;
      property ColumnIndex: Integer read FColumnIndex;
      property PosIndex: Integer read FPosIndex;
      property Length: Integer read FLength;
      property ColOffset: Integer read FColOffset;
      property PosOffset: Integer read FPosOffset;
      property AType: Integer read FType;
    end;

  Tx3MReportDataList = class(TCollection)
    protected
      procedure   Update(Item: TCollectionItem); override;
      procedure   DoItemChange(Item: TCollectionItem); dynamic;
    private
      FErrorEvent : Tx3ErrorEvent;
      FDataEvent  : Tx3MReportDataEvent;
      function    GetItem(Index: Integer): Tx3MReportDataItem;
      procedure   SetItem(Index: Integer; const Value: Tx3MReportDataItem);
      procedure   DoError(Sender: TObject; ACode: Integer; AMsg: String);
      procedure   DoDataEvent(Sender: TObject; ADataEventType: Tx3MReportDataEventType; AData: Tx3MReportDataItem; var AResult: Variant);
    public
      constructor Create;
      destructor  Destroy; override;
      function    Add: Tx3MReportDataItem;
      function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
      property    Items[Index: Integer]: Tx3MReportDataItem read GetItem write SetItem; default;
    published
      property    OnDataEvent: Tx3MReportDataEvent read FDataEvent write FDataEvent;
      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;

  Tx3MReportDataItem = class(TCollectionItem)
  protected
  private
    FName: String;
    FCaption: String;
    FQuery: WideString;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
    function    AddXMLNode(ARootNode: IXMLNode): IXMLNode;
  published
    property Name: String read FName;
    property Caption: String read FCaption;
    property Query: WideString read FQuery;
  end;

implementation
const
  ERR_XML_ROOTNODE_NOTFOUND = 'Не найден корневой элемент отчета';
  ERR_XML_QUERYNODE_NOTFOUND = 'Не найден корневой элемент запросов';
  ERR_XML_ROOTNODE_REQUIREDATTR = 'Ошибка чтения обязательных аттрибутов отчета';

//****************************************************************************//
function CreateMReportFileVersion(AMinor, AMajor, ABuild: Integer): Tx3MReportFileVersion;
begin
  Result.Minor := AMinor;
  Result.Major := AMajor;
  Result.Build := ABuild;
end;

function StringToMReportFileVersion(const Value: String; var AValue: Tx3MReportFileVersion): Boolean;
var
  FArr: TArray<String>;
begin
  AValue := CreateMReportFileVersion(0, 0, 0);
  try
    FArr := SplitString(Value, '.');
    Result := High(FArr) = 2;
    if Result then
      AValue := CreateMReportFileVersion(StrToInt(FArr[0]), StrToInt(FArr[1]), StrToInt(FArr[2]));
  except on e: Exception do
  begin
    Result := False;
  end; end;
end;

//****************************************************************************//
constructor Tx3MReportObject.Create(AFileName: TFileName);
begin
  inherited Create;
  FTemplates := Tx3MReportTemplateList.Create;
  FTemplates.OnError := DoError;
  FParams := Tx3MReportParamList.Create;
  FParams.OnError := DoError;
  FColumns := Tx3MReportColumnList.Create;
  FColumns.OnError := DoError;
  FData := Tx3MReportDataList.Create;
  FData.OnError := DoError;
  FData.OnDataEvent := DoDataEvent;

  Initialize;
  Load(AFileName);
end;

destructor Tx3MReportObject.Destroy;
begin
  inherited Destroy;
end;

class procedure Tx3MReportObject.SetReportListItems(AList: TStrings; AArray: TArray<Tx3ListItem>);
var
  i: Integer;
  FItem: Px3ListItem;
begin
  if Assigned(AList) then
  begin
    AList.Clear;
    for i := Low(AArray) to High(AArray) do
      begin
        New(FItem);
        FItem^ := FItem^.Create(AArray[i].Index, AArray[i].Text, AArray[i].Value);
        AList.AddObject(AArray[i].Text, TObject(FItem));
      end;
  end;

end;

function Tx3MReportObject.Load(AFileName: TFileName): Boolean;
var
  FDocument: TXMLDocument;
begin
  try
    Initialize;
    FDocument := TXMLDocument.Create(Application);
    FDocument.LoadFromFile(AFileName);
    FDocument.Active := True;
    Result := Load(FDocument.XML.Text, True);
  except on e: Exception do
  begin
    FFileName := '';
    Result := False;
    DoError(Self, -1, e.Message);
  end; end;
end;

function Tx3MReportObject.Load(AXML: String; IsParamsOnly: Boolean): Boolean;
var
  FDocument: TXMLDocument;
  FRoot, FNode, FListNode: IXMLNode;
  FDataItem: Tx3MReportDataItem;
  FParamItem: Tx3MReportParamItem;
  FColumnItem: Tx3MReportColumnItem;
  FTemplateItem: Tx3MReportTemplateItem;
  i: Integer;
begin
  try
    Initialize;
    FDocument := TXMLDocument.Create(Application);
    FDocument.LoadFromXML(AXML);
    FDocument.Active := True;
    FNode := FDocument.DocumentElement;
    Result := Assigned(FNode);
    if Result then
    begin
      Result := Result and FNode.HasAttribute('name');
      if Result then
        FReportName := FNode.Attributes['name'];
      Result := Result and FNode.HasAttribute('report');
      if Result then
        FReportFile := FNode.Attributes['report'];
      Result := Result and FNode.HasAttribute('caption');
      if Result then
        FCaption := FNode.Attributes['caption'];
      Result := Result and FNode.HasAttribute('script');
      if Result then
        FScriptName := FNode.Attributes['script'];
      Result := Result and FNode.HasAttribute('version') and StringToMReportFileVersion(FNode.Attributes['version'], FFileVersion);
      if not Result then
      begin
        FLastError := ERR_XML_ROOTNODE_REQUIREDATTR;
        Exit;
      end;
      FRoot := FDocument.DocumentElement.ChildNodes.FindNode('data');
      Result := Assigned(FRoot);
      if Result then
      begin
//***** Load report queryes *****//
        FNode := FRoot.ChildNodes.FindNode('queryes');
        if Assigned(FNode) And (Not IsParamsOnly) then
          for i := 0 to FNode.ChildNodes.Count - 1 do
          begin
            FListNode := FNode.ChildNodes.Get(i);
            if Assigned(FListNode) and (FListNode.NodeName = 'query') and FListNode.HasAttribute('name') and FListNode.HasAttribute('caption') then
            begin
              FDataItem := FData.Add;
              FDataItem.FName := FListNode.Attributes['name'];
              FDataItem.FCaption := CheckVarValue(FListNode.Attributes['caption'], dtString, '');
              FDataItem.FQuery := FListNode.Text;
            end;
          end;
//***** Load report templates *****//
        FNode := FRoot.ChildNodes.FindNode('templates');
        if Assigned(FNode) And (Not IsParamsOnly) then
          for i := 0 to FNode.ChildNodes.Count - 1 do
          begin
            FListNode := FNode.ChildNodes.Get(i);
            if Assigned(FListNode) and (FListNode.NodeName = 'template') and FListNode.HasAttribute('name') then
            begin
              FTemplateItem := FTemplates.Add;
              FTemplateItem.FName := CheckVarValue(FListNode.Attributes['name'], dtString, '');
              FTemplateItem.FCaption := CheckVarValue(FListNode.Attributes['caption'], dtString, '');
              FTemplateItem.FValue := FListNode.Text;
            end;
          end;
//***** Load report params *****//
        FNode := FRoot.ChildNodes.FindNode('params');
        if Assigned(FNode) then
          for i := 0 to FNode.ChildNodes.Count - 1 do
          begin
            FListNode := FNode.ChildNodes.Get(i);
            if Assigned(FListNode) and (FListNode.NodeName = 'param') and FListNode.HasAttribute('name') and FListNode.HasAttribute('control') then
            begin
              FParamItem := FParams.Add;
              FParamItem.FDataType := StrToDateType(FListNode.Attributes['dataType']);
              FParamItem.FName := CheckVarValue(FListNode.Attributes['name'], dtString, '');
              FParamItem.FCaption := CheckVarValue(FListNode.Attributes['caption'], dtString, '');
              FParamItem.FControl := CheckVarValue(FListNode.Attributes['control'], dtString, '');
              FParamItem.FDefaultValue := CheckVarValue(FListNode.Attributes['default'], dtString, '');
            end;
          end;
//***** Load report columns *****//
        FNode := FRoot.ChildNodes.FindNode('columns');
        if Assigned(FNode) then
          for i := 0 to FNode.ChildNodes.Count - 1 do
          begin
            FListNode := FNode.ChildNodes.Get(i);
            if Assigned(FListNode) and (FListNode.NodeName = 'column') and FListNode.HasAttribute('columnName') then
            begin
              FColumnItem := FColumns.Add;
              FColumnItem.FName := CheckVarValue(FListNode.Attributes['columnName'], dtString, '');
              FColumnItem.FCaption := CheckVarValue(FListNode.Attributes['caption'], dtString, '');
              FColumnItem.FQueryName := CheckVarValue(FListNode.Attributes['query'], dtString, '');
              FColumnItem.FColumnIndex := CheckVarValue(FListNode.Attributes['columnIndex'], dtInteger, -1);
              FColumnItem.FPosIndex := CheckVarValue(FListNode.Attributes['posIndex'], dtInteger, -1);
              FColumnItem.FLength := CheckVarValue(FListNode.Attributes['length'], dtInteger, 1);
              FColumnItem.FColOffset := CheckVarValue(FListNode.Attributes['colOffset'], dtInteger, 0);
              FColumnItem.FPosOffset := CheckVarValue(FListNode.Attributes['posOffset'], dtInteger, 0);
              FColumnItem.FType := CheckVarValue(FListNode.Attributes['type'], dtInteger, -1);
            end;
          end;
      end
      else
        FLastError := ERR_XML_ROOTNODE_NOTFOUND;
    end
    else
      FLastError := ERR_XML_QUERYNODE_NOTFOUND;
  except on e: Exception do
  begin
    FFileName := '';
    Result := False;
    DoError(Self, -1, e.Message);
  end; end;

end;

function Tx3MReportObject.LoadParams(AParams: TArray<Tx3ReportParam>): Boolean;
var
  i, j: Integer;
  FList: Tx3MReportParamList;
  FParam: Tx3MReportParamItem;
begin
  FList := Tx3MReportParamList.Create;
  try
    try
      FList.Clear;
      for i := Low(AParams) to High(AParams) do
      begin
        FParam := FList.Add;
        FParam.FName := AParams[i].Name;
        FParam.FDataType := AParams[i].DataType;
        FParam.FValue := AParams[i].Value;
        if Assigned(AParams[i].Control) then
        begin
          FParam.FControl := AParams[i].Control.Name;
          FParam.FCaption := AParams[i].Control.Name;
          j := Params.FindControl(AParams[i].Control.Name);
          if (j >= 0) and (j < Params.Count) then
            FParam.FDefaultValue := Params[j].FDefaultValue;
        end
        else
        begin
          FParam.FControl := '';
          FParam.FCaption := '';
          FParam.FDefaultValue := '';
        end;
      end;
      FList.CopyTo(Self.FParams);
    except on e: Exception do
    begin
      FFileName := '';
      Result := False;
      DoError(Self, -1, e.Message);
   end; end;
  finally
    FList.Free;
  end;
end;

function Tx3MReportObject.Save(AFileName: TFileName): Boolean;
var
  FDocument: TXMLDocument;
begin
  try
    Result := False;
    FDocument := AsXML();
    FDocument.SaveToFile(AFileName);
  except on e: Exception do
  begin
    Result := False;
    DoError(Self, -1, e.Message);
  end; end;
end;

function Tx3MReportObject.AsXML(ARootName: String = 'report'): TXMLDocument;
var
  FNode: IXMLNode;
begin
  Result := TXMLDocument.Create(nil);
  Result.Active := True;
  Result.DocumentElement := Result.CreateNode(ARootName, ntElement, '');
  Result.DocumentElement.Attributes['name'] := FReportName;
  Result.DocumentElement.Attributes['caption'] := FCaption;
  Result.DocumentElement.Attributes['script'] := FScriptName;
  Result.DocumentElement.Attributes['version'] := Format('%d.%d.%d', [FFileVersion.Major, FFileVersion.Major, FFileVersion.Build]);

  FNode := FData.AddXMLNode(Result.DocumentElement);
  FNode := FTemplates.AddXMLNode(Result.DocumentElement);
  FNode := FParams.AddXMLNode(Result.DocumentElement);
  FNode := FColumns.AddXMLNode(Result.DocumentElement);
end;

procedure Tx3MReportObject.Initialize;
begin
  FFileName := '';
  FReportName := '';
  FCaption := '';
  FScriptName := '';
  FFileVersion := CreateMReportFileVersion(0, 0, 0);
  FData.Clear;
  FParams.Clear;
  FTemplates.Clear;
  FColumns.Clear;
end;

procedure Tx3MReportObject.DoError(Sender: TObject; ACode: Integer; AMsg: String);
begin
  FLastError := AMsg;
  if Assigned(FErrorEvent) then
    FErrorEvent(Sender, ACode, AMsg);
end;

procedure Tx3MReportObject.DoDataEvent(Sender: TObject; ADataEventType: Tx3MReportDataEventType; AData: Tx3MReportDataItem; var AResult: Variant);
begin
  // TODO
end;

//****************************************************************************//

constructor Tx3MReportParamList.Create;
begin
  inherited Create(Tx3MReportParamItem);
end;

destructor Tx3MReportParamList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure Tx3MReportParamList.CopyTo(ATarget: Tx3MReportParamList);
var
  i: Integer;
  FItem: Tx3MReportParamItem;
begin
  if Assigned(ATarget) then
  begin
    ATarget.Clear;
    for i := 0 to Count - 1 do
    begin
      FItem := ATarget.Add;
      Items[i].AssignTo(FItem);      
    end;
  end;
end;

function Tx3MReportParamList.Find(AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:= 0 to Count - 1 do
  begin
    if AnsiCompareStr(Items[i].FName, AName) = 0 then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function Tx3MReportParamList.FindControl(AName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:= 0 to Count - 1 do
  begin
    if AnsiCompareStr(Items[i].FControl, AName) = 0 then
    begin
      Result := i;
      Break;
    end;
  end;
end;
          
function Tx3MReportParamList.Add: Tx3MReportParamItem;
begin
  Result := Tx3MReportParamItem(inherited Add)
end;

procedure Tx3MReportParamList.FromXML(AXML: TXMLDocument);
var
  FRoot, FNode: IXMLNode;
  FItem: Tx3MReportParamItem;
  i, j: Integer;
begin
  if Assigned(AXML) then
  begin
    FRoot := AXML.ChildNodes.FindNode('params');
    if Assigned(FRoot) then
      for i := 0 to FRoot.ChildNodes.Count - 1 do
      begin
        FNode := FRoot.ChildNodes.Get(i);
        if LowerCase(FNode.NodeName) = 'param' then
        begin
          FItem := Add;
          FItem.FName := FNode.Attributes['name'];
          FItem.FDataType := StrToDateType(FNode.Attributes['dataType']);
          if FItem.DataType in [dtMemo, dtSelectedList] then
            FItem.Value := GetNodeValue(FNode)
          else
            FItem.Value := FNode.Attributes['value'];
          j := FindControl(FNode.Attributes['name']);
          if (j >= 0) and (j < Self.Count) then
            FItem.FDefaultValue := Items[j].FDefaultValue;
        end;
      end;
  end;
end;

function Tx3MReportParamList.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('params', -1);
    for i := 0 to Count - 1 do
    begin
      FNode := Items[i].AddXMLNode(Result);
      FNode.Attributes['posIndex'] := IntToStr(i);
    end;
  except on e: Exception do
  begin
    Result := nil;
    DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportParamList.DoItemChange(Item: TCollectionItem);
begin
// TODO
end;

function Tx3MReportParamList.GetItem(Index: Integer): Tx3MReportParamItem;
begin
  Result := Tx3MReportParamItem(inherited GetItem(Index))
end;

procedure Tx3MReportParamList.SetItem(Index: Integer; const Value: Tx3MReportParamItem);
begin
  inherited SetItem(Index, Value)
end;

function Tx3MReportParamList.GetNodeValue(ANode: IXMLNode): Variant;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := '';
  if Assigned(ANode) then
    for i := 0 to ANode.ChildNodes.Count - 1 do
    begin
      FNode := ANode.ChildNodes.Get(i);
      if Assigned(FNode) and (FNode.NodeName = 'item') and FNode.HasAttribute('value') then
        Result := Result + IfThen(VarToStr(Result) = '', '', TEXT_LIST_SEPARARATOR) + FNode.Attributes['value'];
    end;
end;

procedure Tx3MReportParamList.DoError(Sender: TObject; ACode: Integer; AMsg: String);
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(Sender, ACode, AMsg);
end;

procedure Tx3MReportParamList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;
//****************************************************************************//
constructor Tx3MReportParamItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := '';
  FControl := '';
  FCaption := '';
  FDataType := dtUnassigned;
end;

destructor Tx3MReportParamItem.Destroy;
begin
  inherited Destroy;
end;

function Tx3MReportParamItem.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
  FStr: String;
  FSL: TStringList;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('param', -1);
    Result.Attributes['name'] := FName;
    Result.Attributes['caption'] := FCaption;
    Result.Attributes['default'] := FDefaultValue;
    Result.Attributes['dataType'] := Integer(FDataType);
    Result.Attributes['value'] := Value;
    if FDataType in [dtMemo, dtSelectedList] then
    begin
      FSL := TStringList.Create;
      Split(Value, TEXT_LIST_SEPARARATOR, FSL);
      for i := 0 to FSL.Count - 1 do
      begin
        FNode := Result.AddChild('item', -1);
        FNode.Attributes['value'] := FSL[i];
      end;
    end;
  except on e: Exception do
  begin
    Result := nil;
    Tx3MReportDataList(Collection).DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportParamItem.AssignTo(ATarget: Tx3MReportParamItem);
begin
  if Assigned(ATarget) then
  begin
    ATarget.FName := Self.FName;
    ATarget.FControl := Self.FControl;
    ATarget.FCaption := Self.FCaption;
    ATarget.FDataType := Self.FDataType;
    ATarget.FDefaultValue := Self.FDefaultValue;
    ATarget.FValue := Self.FValue;
  end;
end;

function Tx3MReportParamItem.GetValue: Variant;
begin
  if (not VarIsEmpty(FValue)) and (not VarIsNull(FValue)) and (VarToStr(FValue) <> '') then
    Result := FValue
  else
    Result := FDefaultValue;
end;
//****************************************************************************//
constructor Tx3MReportColumnList.Create;
begin
  inherited Create(Tx3MReportColumnItem);
end;

destructor Tx3MReportColumnList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure Tx3MReportColumnList.CopyTo(ATarget: Tx3MReportColumnList);
var
  i: Integer;
  FItem: Tx3MReportColumnItem;
begin
  if Assigned(ATarget) then
  begin
    ATarget.Clear;
    for i := 0 to Count - 1 do
    begin
      FItem := ATarget.Add;
      Items[i].AssignTo(FItem);
    end;
  end;
end;

function Tx3MReportColumnList.Find(AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i:= 0 to Count - 1 do
  begin
    if AnsiCompareStr(Items[i].FName, AName) = 0 then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function Tx3MReportColumnList.Add: Tx3MReportColumnItem;
begin
  Result := Tx3MReportColumnItem(inherited Add)
end;

procedure Tx3MReportColumnList.FromXML(AXML: TXMLDocument);
var
  FRoot, FNode: IXMLNode;
  FItem: Tx3MReportColumnItem;
  i, j: Integer;
begin
  if Assigned(AXML) then
  begin
    FRoot := AXML.ChildNodes.FindNode('colums');
    if Assigned(FRoot) then
      for i := 0 to FRoot.ChildNodes.Count - 1 do
      begin
        FNode := FRoot.ChildNodes.Get(i);
        if LowerCase(FNode.NodeName) = 'column' then
        begin
          FItem := Add;
          FItem.FName       := FNode.Attributes['columnName'];
          FItem.FCaption    := FNode.Attributes['caption'];
          FItem.FQueryName  := FNode.Attributes['query'];
          FItem.FColumnIndex:= FNode.Attributes['columnIndex'];
          FItem.FPosIndex   := FNode.Attributes['posIndex'];
          FItem.FLength     := FNode.Attributes['length'];
          FItem.FColOffset  := FNode.Attributes['colOffset'];
          FItem.FPosOffset  := FNode.Attributes['posOffset'];
          FItem.FType       := FNode.Attributes['type'];
        end;
      end;
  end;
end;

function Tx3MReportColumnList.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('colums', -1);
    for i := 0 to Count - 1 do
    begin
      FNode := Items[i].AddXMLNode(Result);
    end;
  except on e: Exception do
  begin
    Result := nil;
    DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportColumnList.DoItemChange(Item: TCollectionItem);
begin
// TODO
end;

function Tx3MReportColumnList.GetItem(Index: Integer): Tx3MReportColumnItem;
begin
  Result := Tx3MReportColumnItem(inherited GetItem(Index))
end;

procedure Tx3MReportColumnList.SetItem(Index: Integer; const Value: Tx3MReportColumnItem);
begin
  inherited SetItem(Index, Value)
end;

procedure Tx3MReportColumnList.DoError(Sender: TObject; ACode: Integer; AMsg: String);
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(Sender, ACode, AMsg);
end;

procedure Tx3MReportColumnList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;
//****************************************************************************//
constructor Tx3MReportColumnItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := '';
  FCaption := '';
  FQueryName := '';
  FColumnIndex := -1;
  FPosIndex := -1;
  FLength := 0;
  FColOffset := 0;
  FPosOffset := 0;
  FType := -1;
end;

destructor Tx3MReportColumnItem.Destroy;
begin
  inherited Destroy;
end;

function Tx3MReportColumnItem.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
  FStr: String;
  FSL: TStringList;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('column', -1);
    Result.Attributes['columnName'] := FName;

    Result.Attributes['caption']    := FCaption;
    Result.Attributes['query']      := FQueryName;
    Result.Attributes['columnIndex'] := FColumnIndex;
    Result.Attributes['posIndex']   := FPosIndex;
    Result.Attributes['length']     := FLength;
    Result.Attributes['colOffset']  := FColOffset;
    Result.Attributes['posOffset']  := FPosOffset;
    Result.Attributes['type']       := FType;
  except on e: Exception do
  begin
    Result := nil;
    Tx3MReportDataList(Collection).DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportColumnItem.AssignTo(ATarget: Tx3MReportColumnItem);
begin
  if Assigned(ATarget) then
  begin
    ATarget.FName := Self.FName;
    ATarget.FCaption := Self.FCaption;
    ATarget.FQueryName := Self.FQueryName;
    ATarget.FColumnIndex := Self.FColumnIndex;
    ATarget.FPosIndex := Self.FPosIndex;
    ATarget.FLength := Self.FLength;
    ATarget.FColOffset := Self.FColOffset;
    ATarget.FPosOffset := Self.FPosOffset;
    ATarget.FType := Self.FType;
  end;
end;
//****************************************************************************//

constructor Tx3MReportTemplateList.Create;
begin
  inherited Create(Tx3MReportTemplateItem);
end;

destructor Tx3MReportTemplateList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function Tx3MReportTemplateList.Add: Tx3MReportTemplateItem;
begin
  Result := Tx3MReportTemplateItem(inherited Add)
end;

procedure Tx3MReportTemplateList.FromXML(AXML: TXMLDocument);
var
  FRoot, FNode: IXMLNode;
  FItem: Tx3MReportTemplateItem;
  i: Integer;
begin
  Clear;
  if Assigned(AXML) then
  begin
    FRoot := AXML.ChildNodes.FindNode('templates');
    if Assigned(FRoot) then
      for i := 0 to FRoot.ChildNodes.Count - 1 do
      begin
        FNode := FRoot.ChildNodes.Get(i);
        if LowerCase(FNode.NodeName) = 'template' then
        begin
          FItem := Add;
          FItem.FName := FNode.Attributes['name'];
          FItem.FCaption := CheckVarValue(FNode.Attributes['caption'], dtString, '');
          FItem.Value := FNode.NodeValue;
        end;
      end;
  end;
end;

function Tx3MReportTemplateList.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('templates', -1);
    for i := 0 to Count - 1 do
    begin
      FNode := Items[i].AddXMLNode(Result);
      FNode.Attributes['posIndex'] := IntToStr(i);
    end;
  except on e: Exception do
  begin
    Result := nil;
    DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportTemplateList.DoItemChange(Item: TCollectionItem);
begin
// TODO
end;

function Tx3MReportTemplateList.GetItem(Index: Integer): Tx3MReportTemplateItem;
begin
  Result := Tx3MReportTemplateItem(inherited GetItem(Index))
end;

procedure Tx3MReportTemplateList.SetItem(Index: Integer; const Value: Tx3MReportTemplateItem);
begin
  inherited SetItem(Index, Value)
end;

procedure Tx3MReportTemplateList.DoError(Sender: TObject; ACode: Integer; AMsg: String);
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(Sender, ACode, AMsg);
end;

procedure Tx3MReportTemplateList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;
//****************************************************************************//
constructor Tx3MReportTemplateItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := '';
  FCaption := '';
end;

destructor Tx3MReportTemplateItem.Destroy;
begin
  inherited Destroy;
end;

function Tx3MReportTemplateItem.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
  FStr: String;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('template', -1);
    Result.Attributes['name'] := FName;
    Result.Attributes['caption'] := FCaption;
    Result.NodeValue := Value;
  except on e: Exception do
  begin
    Result := nil;
    Tx3MReportDataList(Collection).DoError(Self, -1, e.Message);
  end; end;
end;
//****************************************************************************//
constructor Tx3MReportDataList.Create;
begin
  inherited Create(Tx3MReportDataItem);
end;

destructor Tx3MReportDataList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function Tx3MReportDataList.Add: Tx3MReportDataItem;
begin
  Result := Tx3MReportDataItem(inherited Add)
end;

function Tx3MReportDataList.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('queryes', -1);
    for i := 0 to Count - 1 do
    begin
      FNode := Items[i].AddXMLNode(Result);
      FNode.Attributes['posIndex'] := IntToStr(i);
    end;
  except on e: Exception do
  begin
    Result := nil;
    DoError(Self, -1, e.Message);
  end; end;
end;

procedure Tx3MReportDataList.DoItemChange(Item: TCollectionItem);
begin
// TODO
end;

function Tx3MReportDataList.GetItem(Index: Integer): Tx3MReportDataItem;
begin
  Result := Tx3MReportDataItem(inherited GetItem(Index))
end;

procedure Tx3MReportDataList.SetItem(Index: Integer; const Value: Tx3MReportDataItem);
begin
  inherited SetItem(Index, Value)
end;

procedure Tx3MReportDataList.DoError(Sender: TObject; ACode: Integer; AMsg: String);
begin
  if Assigned(FErrorEvent) then
    FErrorEvent(Sender, ACode, AMsg);
end;

procedure Tx3MReportDataList.DoDataEvent(Sender: TObject; ADataEventType: Tx3MReportDataEventType; AData: Tx3MReportDataItem; var AResult: Variant);
begin
  if Assigned(FDataEvent) then
    FDataEvent(Sender, ADataEventType, AData, AResult);
end;

procedure Tx3MReportDataList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

//****************************************************************************//

constructor Tx3MReportDataItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor Tx3MReportDataItem.Destroy;
begin
  inherited Destroy;
end;

function Tx3MReportDataItem.AddXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('query', -1);
    Result.Attributes['name'] := FName;
    Result.Attributes['caption'] := FCaption;
    Result.Text := FQuery;
  except on e: Exception do
  begin
    Result := nil;
    Tx3MReportDataList(Collection).DoError(Self, -1, e.Message);
  end; end;
end;

end.
