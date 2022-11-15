unit uPopupSelectedList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles,
  dxScrollbarAnnotations, cxTL, cxTLdxBarBuiltInMenu, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, cxInplaceContainer, cxTLData, cxDBTL, System.ImageList, System.StrUtils,
  Vcl.ImgList, Vcl.Buttons, Data.DB, Data.Win.ADODB, Winapi.ADOInt, cxMaskEdit, cxDropDownEdit,
  ux3Utils, uSelectedList, cxTextEdit;

type
  TPopupSelectedList = class(TFrame)
    ImageList   : TImageList;
    pnWorkspace : TPanel;
    TreeList    : TcxDBTreeList;
    pnButtons   : TPanel;
    btnOK       : TSpeedButton;
    btnClear    : TSpeedButton;
    pnCaption   : TPanel;
    TreeListColumnName: TcxDBTreeListColumn;
    bvSpacer    : TBevel;
  private
    FOwner      : TComponent;
    FTreeList   : TTreeSelectedList;
    FSelectedKeys: String;
    FCloseEvent : TNotifyEvent;
    function    GetKeys: String;
    procedure   SetKeys(const Value: String);
    function    GetValues: String;
    procedure   SetValues(const Value: String);
    function    GetCaption: String;
    procedure   SetCaption(const AValue: String);
    procedure   DoShowPopup(Sender: TObject);
    procedure   DoOKButtonClick(Sender: TObject);
    procedure   DoClearButtonClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    class function ItemArrayToRecordset(AArray: array of TPopupSelectedItem; var ARecordset: _Recordset; var AMsg: String): Boolean;
  published
    property Caption: String read GetCaption write SetCaption;
    property Keys: String read GetKeys write SetKeys;
    property Values: String read GetValues write SetValues;
    property OnClose: TNotifyEvent read FCloseEvent write FCloseEvent;
  end;

  function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; ARecordset: _Recordset; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
  function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; ADimention: String; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
  function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; AData: array of TPopupSelectedItem; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;

implementation

{$R *.dfm}

uses
  uDM, ux3CustomMDDataObject;

const
  FIELD_ID    = 'ID';
  FIELD_PARENT= 'PARENT';
  FIELD_NAME  = 'NAME';

function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; ARecordset: _Recordset; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
var
  FResult: TPopupSelectedList;
  FItem: TcxTreeListNode;
begin
  Result := Assigned(ARecordset);
  if Result then
  begin
    try
      FResult := TPopupSelectedList.Create(AOwner);
      FResult.FTreeList.ListType := AListType;
      FResult.Caption := ACaption;
      Result  := FResult.FTreeList.Load(FResult.TreeList, ARecordset, AMsg);
      if AOwner is TcxPopupEdit then
      begin
        TcxPopupEdit(AOwner).ParentColor := True;
        TcxPopupEdit(AOwner).Properties.PopupControl := FResult;
        TcxPopupEdit(AOwner).Properties.ReadOnly := True;
      end;
    except on e: Exception do
    begin
      Result := False;
      AMsg := e.Message;
    end; end;
  end
  else
    AMsg := 'Недоступен набор данных';
end;

function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; ADimention: String; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean;
var
  FRS: _Recordset;
begin
  Result := Tx3MDCustomDataObject.OpenDimention(DM.AccessInfo, ADimention, False, FRS, AMsg) and
      CreatePopupSelectedList(AOwner, ACaption, FRS, AMsg, AListType);
end;

function CreatePopupSelectedList(AOwner: TComponent; ACaption: String; AData: array of TPopupSelectedItem; var AMsg: String; AListType: TPopupSelectedListType = sltUnassigned): Boolean; overload;
var
  FRS: _Recordset;
begin
  Result := TPopupSelectedList.ItemArrayToRecordset(AData, FRS, AMsg) and CreatePopupSelectedList(AOwner, ACaption, FRS, AMsg, AListType);
end;

//****************************************************************************//
constructor TPopupSelectedList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOwner      := AOwner;
  FTreeList   := TTreeSelectedList.Create(TreeList);
  AOwner.Tag  := LongInt(FTreeList);
  Caption     := '';
  btnOK.OnClick := DoOKButtonClick;
  btnClear.OnClick := DoClearButtonClick;
  if AOwner is TcxPopupEdit then
  begin
    TcxPopupEdit(AOwner).Text := '';
    TcxPopupEdit(AOwner).Properties.OnPopup := DoShowPopup;
  end;
end;

destructor TPopupSelectedList.Destroy;
begin
  if Assigned(FOwner) then
    FOwner.Tag := 0;
  FTreeList.Free;
  inherited Destroy;
end;

class function TPopupSelectedList.ItemArrayToRecordset(AArray: array of TPopupSelectedItem; var ARecordset: _Recordset; var AMsg: String): Boolean;
begin
  Result := TTreeSelectedList.ItemArrayToRecordset(AArray, ARecordset, AMsg);
end;

function TPopupSelectedList.GetKeys: String;
begin
  if Assigned(FTreeList) then
    Result := FTreeList.Keys
  else
    Result := '';
end;

procedure TPopupSelectedList.SetKeys(const Value: String);
begin
  if Assigned(FTreeList) then
    FTreeList.Keys := Value;
end;

function TPopupSelectedList.GetValues: String;
begin
  if Assigned(FTreeList) and Assigned(FTreeList.TreeList) and (not FTreeList.TreeList.TopNode.Checked) then
    Result := FTreeList.Values
  else
    Result := '';
end;

procedure TPopupSelectedList.SetValues(const Value: String);
begin
  // TODO
end;

function TPopupSelectedList.GetCaption: String;
begin
  Result := pnCaption.Caption;
end;

procedure TPopupSelectedList.SetCaption(const AValue: String);
begin
  pnCaption.Caption := ReplaceStr(IfThen(Length(AValue) > 24, Concat(Copy(AValue, 1, 24), '...'), AValue), ':', '');
end;

procedure TPopupSelectedList.DoShowPopup(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TcxPopupEdit) and Assigned(FTreeList) then
    case FTreeList.ListType of
      sltUnassigned: Keys := FSelectedKeys;
      sltAllValues: Keys := FSelectedKeys;
    end;
end;

procedure TPopupSelectedList.DoOKButtonClick(Sender: TObject);
begin
  if Assigned(FOwner) and (FOwner is TcxPopupEdit) then
    with TcxPopupEdit(FOwner) do
    begin
      Text := Values;
      FSelectedKeys := Keys;
      DroppedDown := False;
    end;
end;

procedure TPopupSelectedList.DoClearButtonClick(Sender: TObject);
var
  FItem : TcxTreeListNode;
begin
  FItem := TreeList.TopNode;
  while FItem <> nil do
  begin
    FItem.Checked := False;
    FItem := FItem.GetNext;
  end;
  if Assigned(FOwner) and (FOwner is TcxPopupEdit) then
    with TcxPopupEdit(FOwner) do
    begin
      FSelectedKeys := '';
      Text := '';
      DroppedDown := False;
    end;
end;

end.
