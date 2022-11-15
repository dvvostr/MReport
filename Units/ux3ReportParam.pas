unit ux3ReportParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.XMLIntf, Xml.XMLDoc,
  cxControls, cxLookAndFeels,
  cxEdit, cxTextEdit, cxSpinEdit, cxMaskEdit, cxCalc, cxCheckBox, cxCalendar,
  cxMemo, cxTL, cxDropDownEdit,
  uSelectedList, uPopupSelectedList, ux3Classes, ux3Utils;

type
  Tx3ReportParam = class(TObject)
    private
      FErrorEvent : Tx3ErrorEvent;
      FName       : String;
      FDataType   : Tx3DataType;
      FControl    : TControl;
    protected
    public
      constructor Create(AOwner: TControl);
      destructor  Destroy; override;
      class function Init(AControl: TControl; AName: String; ADataType: Tx3DataType): Tx3ReportParam;
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; virtual;
      function GetValue: Variant; virtual;
    published
      property Control: TControl read FControl;
      property Name: String read FName;
      property DataTYpe: Tx3DataType read FDataType;
      property Value: Variant read GetValue;
      property OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;
  Tx3StringReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3IntegerReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3CurrencyReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3DoubleReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3BooleanReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3DateTimeReportParam = class(Tx3ReportParam)
    private
      FFormat: String;
      function GetValue: Variant; override;
    public
      constructor Create(AOwner: TControl);
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
    published
      property DateFormat: String read FFormat write FFormat;
  end;
  Tx3DateReportParam = class(Tx3ReportParam)
    private
      FFormat: String;
      function GetValue: Variant; override;
    public
      constructor Create(AOwner: TControl);
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
    published
      property DateFormat: String read FFormat write FFormat;
  end;
  Tx3TimeReportParam = class(Tx3ReportParam)
    private
      FFormat: String;
      function GetValue: Variant; override;
    public
      constructor Create(AOwner: TControl);
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
    published
      property DateFormat: String read FFormat write FFormat;
  end;
  Tx3GUIDReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3MemoReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3VariantReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3StringListReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3IntegerListReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3DictionatyListReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;
  Tx3SelectedListReportParam = class(Tx3ReportParam)
    private
      function GetValue: Variant; override;
    public
      function AsXMLNode(ARootNode: IXMLNode): IXMLNode; override;
  end;

implementation

constructor Tx3ReportParam.Create(AOwner: TControl);
begin
  inherited Create;
  FControl := AOwner;
end;

destructor Tx3ReportParam.Destroy;
begin
  FControl := nil;
  inherited Destroy;
end;

class function Tx3ReportParam.Init(AControl: TControl; AName: String; ADataType: Tx3DataType): Tx3ReportParam;
begin
  case ADataType of
    dtString: Result := Tx3StringReportParam.Create(AControl);
    dtInteger: Result := Tx3IntegerReportParam.Create(AControl);
    dtCurrency: Result := Tx3CurrencyReportParam.Create(AControl);
    dtDouble: Result := Tx3DoubleReportParam.Create(AControl);
    dtBoolean: Result := Tx3BooleanReportParam.Create(AControl);
    dtDateTime: Result := Tx3DateTimeReportParam.Create(AControl);
    dtDate: Result := Tx3DateReportParam.Create(AControl);
    dtTime: Result := Tx3TimeReportParam.Create(AControl);
    dtGUID: Result := Tx3GUIDReportParam.Create(AControl);
    dtMemo: Result := Tx3MemoReportParam.Create(AControl);
    dtVariant: Result := Tx3VariantReportParam.Create(AControl);
    dtStringList: Result := Tx3StringListReportParam.Create(AControl);
    dtIntegerList: Result := Tx3IntegerListReportParam.Create(AControl);
    dtDictionaryList: Result := Tx3DictionatyListReportParam.Create(AControl);
    dtSelectedList: Result := Tx3SelectedListReportParam.Create(AControl);
    else
      Result := Tx3ReportParam.Create(AControl);
  end;
  Result.FName := AName;
  Result.FDataType := ADataType;
end;

function Tx3ReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
var
  i: Integer;
  FNode: IXMLNode;
begin
  Result := nil;
  if not Assigned(ARootNode) then
    Exit;
  try
    Result := ARootNode.AddChild('param', -1);
    Result.Attributes['name'] := FName;
    Result.Attributes['dataType'] := Integer(FDataType);
    Result.Attributes['value'] := Value;
  except on e: Exception do
  begin
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
    Result := nil;
  end; end;
end;

function Tx3ReportParam.GetValue: Variant;
begin
  Result := null;
end;
//****************************************************************************//
function Tx3StringReportParam.GetValue: Variant;
begin
  try
    if Assigned(FControl) and (FControl is TcxTextEdit) then
      Result := TcxTextEdit(FControl).Text
    else
      Result := '';
  except on e: Exception do
  begin
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
    Result := '';
  end; end;

end;

function Tx3StringReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3IntegerReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxSpinEdit) then
      Result := VarToStr(TcxSpinEdit(FControl).Value)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text
    else if Assigned(FControl) and (FControl is TcxCalcEdit) then
      Result := VarToStr(TcxCalcEdit(FControl).Text);
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3IntegerReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3CurrencyReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxSpinEdit) then
      Result := VarToStr(TcxSpinEdit(FControl).Value)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text
    else if Assigned(FControl) and (FControl is TcxCalcEdit) then
      Result := VarToStr(TcxCalcEdit(FControl).Text);
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3CurrencyReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3DoubleReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxSpinEdit) then
      Result := VarToStr(TcxSpinEdit(FControl).Value)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text
    else if Assigned(FControl) and (FControl is TcxCalcEdit) then
      Result := VarToStr(TcxCalcEdit(FControl).Text);  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3DoubleReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3BooleanReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxCheckBox) then
      Result := IfThen(TcxCheckBox(FControl).Checked, '1', '0');
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3BooleanReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
constructor Tx3DateTimeReportParam.Create(AOwner: TControl);
begin
  inherited Create(AOwner);
  FFormat := 'dd.mm.yyyy hh:nn:ss';
end;

function Tx3DateTimeReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxDateEdit) then
      Result := FormatDateTime(FFormat, TcxDateEdit(FControl).Date)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text;
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3DateTimeReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
constructor Tx3DateReportParam.Create(AOwner: TControl);
begin
  inherited Create(AOwner);
  FFormat := 'dd.mm.yyyy';
end;

function Tx3DateReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxDateEdit) then
      Result := FormatDateTime(FFormat, TcxDateEdit(FControl).Date)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text;
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3DateReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
constructor Tx3TimeReportParam.Create(AOwner: TControl);
begin
  inherited Create(AOwner);
  FFormat := 'hh:nn:ss';
end;

function Tx3TimeReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxDateEdit) then
      Result := FormatDateTime(FFormat, TcxDateEdit(FControl).Date)
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text;
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3TimeReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3GUIDReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxTextEdit) then
      Result := TcxTextEdit(FControl).Text
    else if Assigned(FControl) and (FControl is TcxMaskEdit) then
      Result := TcxMaskEdit(FControl).Text
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3GUIDReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3MemoReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxMemo) then
      Result := TcxMemo(FControl).Lines.Text;
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3MemoReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.NodeValue := Self.Value;
end;
//****************************************************************************//
function Tx3VariantReportParam.GetValue: Variant;
begin
// TODO
  try
    Result := null;
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3VariantReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3StringListReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxComboBox) then
      Result := TcxComboBox(FControl).Text
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3StringListReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);

end;
//****************************************************************************//
function Tx3IntegerListReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxComboBox) then
      Result := TPopupSelectedItem.SelectedIndexOfList(TcxComboBox(FControl).Properties.Items, TcxComboBox(FControl).ItemIndex);
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3IntegerListReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.Attributes['value'] := Self.Value;
end;
//****************************************************************************//
function Tx3DictionatyListReportParam.GetValue: Variant;
begin
// TODO
end;

function Tx3DictionatyListReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  try
    Result := inherited AsXMLNode(ARootNode);
// TODO
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;
//****************************************************************************//
function Tx3SelectedListReportParam.GetValue: Variant;
begin
  try
    Result := null;
    if Assigned(FControl) and (FControl is TcxPopupEdit) and (TcxPopupEdit(FControl).Tag <> 0) then
      Result := TTreeSelectedList(TcxPopupEdit(FControl).Tag).Keys
    else if Assigned(FControl) and (FControl is TcxCustomTreeList) then
      Result := TTreeSelectedList(TcxCustomTreeList(FControl).Tag).Keys
  except on e: Exception do
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end;

function Tx3SelectedListReportParam.AsXMLNode(ARootNode: IXMLNode): IXMLNode;
begin
  Result := inherited AsXMLNode(ARootNode);
  Result.NodeValue := Self.Value;
end;
//****************************************************************************//

end.
