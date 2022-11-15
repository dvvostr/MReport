unit uSelectedList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  dxScrollbarAnnotations, cxTL, cxTLdxBarBuiltInMenu, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, cxInplaceContainer, cxTLData, cxDBTL, System.ImageList, System.StrUtils,
  Vcl.ImgList, Vcl.Buttons, Data.DB, Data.Win.ADODB, Winapi.ADOInt, cxMaskEdit, cxDropDownEdit,
  ux3Classes, ux3Utils, ux3CustomMDDataObject, uDM;

type
  TPopupSelectedListType = (sltUnassigned, sltAllValues);
  TPopupSelectedItem = packed record
    Index: Integer;
    Parent: Integer;
    Caption: String;
    Value: String;
    procedure Create(AIndex, AParent: Integer; ACaption: String; AValue: String = '');
    function IndexOfList(AList: TStrings): Integer; overload;
    class function IndexOfList(AList: TStrings; AValue: Integer): Integer; overload; static;
    class function SelectedIndexOfList(AList: TStrings; AValue: Integer): Integer; static;
  end;
  PPopupSelectedItem = ^TPopupSelectedItem;
  TPopupSelectedItemArray = TArray<TPopupSelectedItem>;

  TTreeSelectedList = class
    protected
    private
      FListType   : TPopupSelectedListType;
      FErrorEvent : Tx3ErrorEvent;
      FRecordset  : _Recordset;
      FADODataSet : TADODataSet;
      FDataSource : TDataSource;
      FTreeList   : TcxDBTreeList;
      FLastError  : String;
      procedure   SetTreeList(const AValue: TcxDBTreeList);
      procedure   SetRecordset(const AValue: _Recordset);

      function    InternalGetNodeKeys(ASelectedNodeOnly: Boolean = False): String;
      function    GetKeys: String;
      procedure   SetKeys(const Value: String);
      function    GetValues: String;

    public
      constructor Create(AOwner: TcxDBTreeList);
      destructor  Destroy; override;
      function    Load(ATreeList: TcxDBTreeList; ARecordset: _Recordset; var AMsg: String): Boolean;
      class procedure  SetPopupList(AList: TStrings; AValues: array of TPopupSelectedItem);
      class function ItemArrayToRecordset(AArray: array of TPopupSelectedItem; var ARecordset: _Recordset; var AMsg: String): Boolean;
     
    published
      property ListType: TPopupSelectedListType read FListType write FListType;
      property TreeList: TcxDBTreeList read FTreeList write SetTreeList;
      property Recordset: _Recordset read FRecordset write SetRecordset;
      property Keys: String read GetKeys write SetKeys;
      property Values: String read GetValues;

      property LastError: String read FLastError;
      property OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;
  
  function CreateSelectedList(AList: TcxDBTreeList; ARecordset: _Recordset; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
  function CreateSelectedList(AList: TcxDBTreeList; ADimention: String; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
  function CreateSelectedList(AList: TcxDBTreeList; AData: array of TPopupSelectedItem; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;

implementation

const
  FIELD_ID    = 'ID';
  FIELD_PARENT= 'PARENT';
  FIELD_NAME  = 'NAME';
  
//****************************************************************************//
function CreateSelectedList(AList: TcxDBTreeList; ARecordset: _Recordset; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
var
  FResult: TTreeSelectedList;
  FItem: TcxTreeListNode;
begin
  Result := Assigned(AList) and Assigned(ARecordset);
  if Result then
  begin
    try
      FResult := TTreeSelectedList.Create(AList);
      FResult.FListType := AListType;
      Result  := FResult.Load(AList, ARecordset, AMsg);
    except on e: Exception do
    begin
      Result := False;
      AMsg := e.Message;
    end; end;
  end
  else
    AMsg := 'Недоступен набор данных';
end;

function CreateSelectedList(AList: TcxDBTreeList; ADimention: String; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean;
var
  FRS: _Recordset;
begin
  Result := Tx3MDCustomDataObject.OpenDimention(DM.AccessInfo, ADimention, False, FRS, AMsg) and
      CreateSelectedList(AList, FRS, AMsg, AListType);
end;

function CreateSelectedList(AList: TcxDBTreeList; AData: array of TPopupSelectedItem; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
var
  FRS: _Recordset;
begin
  Result := TTreeSelectedList.ItemArrayToRecordset(AData, FRS, AMsg) and CreateSelectedList(AList, FRS, AMsg, AListType);
end;
//****************************************************************************//
procedure TPopupSelectedItem.Create(AIndex, AParent: Integer; ACaption: String; AValue: String = '');
begin
  Index := AIndex;
  Parent := AParent;
  Caption := ACaption;
  Value := AValue;
end;

function TPopupSelectedItem.IndexOfList(AList: TStrings): Integer;
begin
  Result := TPopupSelectedItem.IndexOfList(AList, Index);
end;

class function TPopupSelectedItem.IndexOfList(AList: TStrings; AValue: Integer): Integer; 
var
  i: Integer;
begin
  Result := -1;
  if Assigned(AList) then
    for i := 0 to AList.Count - 1 do
      if Assigned(AList.Objects[i]) and (PPopupSelectedItem(AList.Objects[i])^.Index = AValue) then
      begin
        Result := i;
        Break;
      end;
end;

class function TPopupSelectedItem.SelectedIndexOfList(AList: TStrings; AValue: Integer): Integer; 
begin
  if Assigned(AList) and (AList.Count > 0) and (AList.Count > AValue) then
    Result := PPopupSelectedItem(AList.Objects[AValue])^.Index
  else
    Result := -1;
end;
//****************************************************************************//
constructor TTreeSelectedList.Create(AOwner: TcxDBTreeList);
begin
  inherited Create;
  FListType     := sltUnassigned;
  AOwner.Tag    := LongInt(Self);
  FADODataSet   := TADODataSet.Create(AOwner);
  FDataSource   := TDataSource.Create(AOwner);
  if Assigned(AOwner) then
  begin
    FDataSource.DataSet := FADODataSet;
    AOwner.DataController.DataSource := FDataSource;
  end;
  FTreeList := AOwner;
end;

destructor TTreeSelectedList.Destroy;
begin
  if Assigned(FTreeList) then
    FTreeList.Tag := 0;
  FADODataSet.Free;
  FDataSource.Free;
  FTreeList := nil;
  FRecordset := nil;
  inherited Destroy;
end;

class procedure  TTreeSelectedList.SetPopupList(AList: TStrings; AValues: array of TPopupSelectedItem);
var
  i: Integer;
  FItem: PPopupSelectedItem;
begin
  if Assigned(AList) then
  begin
    AList.Clear;
    for i := Low(AValues) to High(AValues) do
    begin
      New(FItem);
      FItem^.Create(AValues[i].Index, AValues[i].Parent, AValues[i].Caption);
      AList.AddObject(AValues[i].Caption, TObject(FItem));
    end;
  end;
end;

class function TTreeSelectedList.ItemArrayToRecordset(AArray: array of TPopupSelectedItem; var ARecordset: _Recordset; var AMsg: String): Boolean;
var
  i: Integer;
  FFields: Tx3MDRowValues;
  FValues: Tx3MDRowValues;
begin
  Result := True;
  try
    ARecordset := CoRecordset.Create;
    ARecordset.Fields._Append(FIELD_ID, varInteger, 4, adFldMayBeNull + adFldIsNullable);
    ARecordset.Fields._Append(FIELD_PARENT, varInteger, 4, adFldMayBeNull + adFldIsNullable);
    ARecordset.Fields._Append(FIELD_NAME, adBSTR, 250, adFldMayBeNull + adFldIsNullable);
    ARecordset.Open(EmptyParam, EmptyParam, adOpenStatic, adLockOptimistic, 0);
    FFields := [FIELD_ID, FIELD_PARENT, FIELD_NAME];
    for i := Low(AArray) to High(AArray) do
    begin
      FValues := [AArray[i].Index, AArray[i].Parent, AArray[i].Caption];
      ARecordset.AddNew(FFields, FValues);
    end;
  except on e: Exception do
  begin
    Result := False;
    AMsg := e.Message;
  end; end;
end;

procedure TTreeSelectedList.SetTreeList(const AValue: TcxDBTreeList);
begin
  if not Load(AValue, FRecordset, FLastError) then
    FTreeList := nil;
end;

procedure TTreeSelectedList.SetRecordset(const AValue: _Recordset);
begin
  if not Load(FTreeList, AValue, FLastError) then
    FRecordset := nil;
end;

function TTreeSelectedList.Load(ATreeList: TcxDBTreeList; ARecordset: _Recordset; var AMsg: String): Boolean;
var
  FItem: TcxTreeListNode;
begin
  Result := Assigned(ATreeList) and Assigned(ARecordset);
  try
    try
      FADODataSet.Recordset := ARecordset;
      FTreeList.OptionsData.Editing       := False;
      FTreeList.OptionsView.CheckGroups   := True;
      FTreeList.OptionsView.Headers       := False;
      FTreeList.DataController.DataSource := FDataSource;
      FTreeList.DataController.KeyField   := FIELD_ID;
      FTreeList.DataController.ParentField:= FIELD_PARENT;
      if Assigned(TreeList.ColumnByName(FIELD_NAME)) then
      begin
        TcxDBTreeListColumn(TreeList.ColumnByName(FIELD_NAME)).DataBinding.FieldName := FIELD_NAME;
        TcxDBTreeListColumn(TreeList.ColumnByName(FIELD_NAME)).DataBinding.ValueType := 'String';
      end;
      FItem := TreeList.Root;
      while FItem <> nil do
      begin
        FItem.CheckGroupType := ncgCheckGroup;
        FItem := FItem.GetNext;
      end;
      TreeList.TopNode.Expand(False);
    finally
      FTreeList := ATreeList;
      FRecordset := ARecordset;
    end;
  except on e: Exception do
  begin
    FTreeList := nil;
    FRecordset := nil;
    Result := False;
    AMsg := e.Message;
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, AMsg);
  end; end;
end;

function TTreeSelectedList.InternalGetNodeKeys(ASelectedNodeOnly: Boolean = False): String;
//----------------------------------------------------------------------------//
  procedure GetCheckedNodeKeys(ANode : TcxTreeListNode; var AKeyList: String);
  var
    FChildItem: TcxTreeListNode;
  begin
    FChildItem := ANode.getFirstChild;
    while FChildItem <> nil do
    begin
      case FChildItem.CheckState of
        cbsChecked: begin
          if ASelectedNodeOnly then
            if not FChildItem.HasChildren then
              AKeyList := Concat(AKeyList, IfThen(Length(AKeyList) > 0, TEXT_LIST_SEPARARATOR, ''), VarToStr(TcxDBTreeListnode(FChildItem).KeyValue))
            else
              GetCheckedNodeKeys(FChildItem, AKeyList)
          else
            AKeyList := Concat(AKeyList, IfThen(Length(AKeyList) > 0, TEXT_LIST_SEPARARATOR, ''), VarToStr(TcxDBTreeListnode(FChildItem).KeyValue));
      end;
      cbsGrayed: GetCheckedNodeKeys(FChildItem, AKeyList);
      end; //case
      FChildItem := ANode.GetNextChild(FChildItem);
    end; // while
  end;
//----------------------------------------------------------------------------//
var
  FRoot, FNode: TcxTreeListNode;
  FKeyList: String;
begin
  Result  := '';
  if not Assigned(TreeList) then
    Exit;
  if TreeList.Root <> nil then
    FRoot := TreeList.Root
  else
    FRoot := TreeList.TopNode;
  FNode := FRoot.getFirstChild;
  while FNode <> nil do
  begin
    case FNode.CheckState of
      cbsChecked: begin
        if ASelectedNodeOnly then
          if not FNode.HasChildren then
            Result := Concat(Result, IfThen(Length(Result) > 0, TEXT_LIST_SEPARARATOR, ''), VarToStr(TcxDBTreeListnode(FNode).KeyValue))
          else
            GetCheckedNodeKeys(FNode, Result)
        else
          Result := Concat(Result, IfThen(Length(Result) > 0, TEXT_LIST_SEPARARATOR, ''), VarToStr(TcxDBTreeListnode(FNode).KeyValue))
      end;
      cbsGrayed: GetCheckedNodeKeys(FNode, Result);
    end; //case
    FNode := FRoot.GetNextChild(FNode);
  end; //  while
end;

function TTreeSelectedList.GetKeys: String;
begin
  Result := InternalGetNodeKeys(FListType = sltAllValues);
end;

procedure TTreeSelectedList.SetKeys(const Value: String);
//----------------------------------------------------------------------------//
  procedure SetChildChecked(ANode: TcxTreeListNode; AValue: Boolean);
  var
    FNode: TcxTreeListNode;
  begin
    if Assigned(ANode) then
    begin
      FNode := ANode.getFirstChild;
      while FNode <> nil do
      begin
        if AValue and FNode.HasChildren then
          SetChildChecked(FNode, AValue);
        FNode.Checked := IfThen(AValue, cbsChecked, cbsUnchecked);
        FNode := FNode.GetNextChild(FNode);
      end;
      ANode.Checked := IfThen(AValue, cbsChecked, cbsUnchecked);
    end;
  end;
//----------------------------------------------------------------------------//
var
//  FArr: TArray<String>;
  FNode: TcxTreeListNode;
  FSL: TStringList;
  FValue: Boolean;
begin
//  FArr := Value.Split([',']);
//  for i:= Low(FArr) to High(FArr) do
//    FStr := FArr[i];
  FNode := TreeList.TopNode;
  FSL := TStringList.Create;
  Split(Value, TEXT_LIST_SEPARARATOR, FSL);
  while FNode <> nil do
  begin
    FValue := IfThen(FSL.IndexOf(TcxDBTreeListNode(FNode).KeyValue) >= 0, cbsChecked, cbsUnchecked);
    if FValue and FNode.HasChildren then
      SetChildChecked(FNode, FValue)
    else if not FNode.Parent.Checked then
      FNode.Checked := IfThen(FSL.IndexOf(TcxDBTreeListNode(FNode).KeyValue) >= 0, cbsChecked, cbsUnchecked);
    FNode := FNode.GetNext;
  end;
end;

function TTreeSelectedList.GetValues: String;
var
  FItem: TcxTreeListNode;
  FFlag: boolean;
begin
  Result := '';
  FItem := TreeList.TopNode;
  if FItem.Checked then
    Result := FItem.Texts[0]
  else
  begin
    while FItem <>nil do
    begin
      if (FItem.Checked = True) and (not FItem.HasChildren) then
        Result := Concat(Result, IfThen((Length(Result) = 0), '', ';'), FItem.Texts[0]);
      FItem := FItem.GetNext;
    end;
  end;
end;

end.
