unit ux3Classes;

interface

uses
  System.Classes, Winapi.Messages;

type
  Tx3StringEvent = procedure(Sender: TObject; AValue: String) of Object;
  Tx3ErrorEvent = procedure(Sender: TObject; ACode: Integer; AMsg: String) of Object;

  Tx3DataType = (
      dtUnassigned, dtString, dtInteger, dtCurrency, dtDouble,
      dtBoolean, dtDateTime, dtDate, dtTime, dtGUID,
      dtMemo, dtVariant, dtStringList, dtIntegerList, dtDictionaryList,
      dtSelectedList
  );

  Tx3ListItem = packed record
    Index: Integer;
    Text: String;
    Value: Variant;
    function Create(AIndex: Integer; AText: String; AValue: Variant): Tx3ListItem;
  end;
  Px3ListItem = ^Tx3ListItem;

  Tx3BusyDlgPropertyes = packed record
    Caption: String;
    Text: String;
    Process1Max: Double;
    Process1Value: Double;
    Process2Max: Double;
    Process2Value: Double;
    class function Create(ACaption: String): Tx3BusyDlgPropertyes; static;
    function WithText(AText: String): Tx3BusyDlgPropertyes;
    function WithProcess1(AMax, AValue: Double): Tx3BusyDlgPropertyes;
    function WithProcess2(AMax, AValue: Double): Tx3BusyDlgPropertyes;
    function AsPointer: Pointer;
  end;
  Px3BusyDlgPropertyes = ^Tx3BusyDlgPropertyes;

const
  TEXT_LIST_SEPARARATOR = #44;
  XWM_BUSY_SHOW = WM_USER + 1021;
  CAP_DATATYPENAMES: Array[Low(Tx3DataType)..High(Tx3DataType)] of String = (
    'none', 'string', 'int', 'currency', 'double', 'boolean', 'datetime', 'date',
    'time', 'GUID', 'memo', 'variant', 'strlist', 'intlist', 'diclist',
    'selectedlist' );
  ERROR_FILE_NOT_EXISTS = 'Файл не существует';

implementation

//****************************************************************************//
function Tx3ListItem.Create(AIndex: Integer; AText: String; AValue: Variant): Tx3ListItem;
begin
  Result.Index := AIndex;
  Result.Text := AText;
  Result.Value := AValue;
end;
//****************************************************************************//

class function Tx3BusyDlgPropertyes.Create(ACaption: String): Tx3BusyDlgPropertyes;
begin
  Result.Caption := ACaption;
  Result.Text := '';
  Result.Process1Max := 0;
  Result.Process1Value := 0;
  Result.Process2Max := 0;
  Result.Process2Value := 0;
end;

function Tx3BusyDlgPropertyes.WithText(AText: String): Tx3BusyDlgPropertyes;
begin
  Text := AText;
  Result := Self;
end;

function Tx3BusyDlgPropertyes.WithProcess1(AMax, AValue: Double): Tx3BusyDlgPropertyes;
begin
  Process1Max := AMax;
  Process1Value := AValue;
  Result := Self;
end;

function Tx3BusyDlgPropertyes.WithProcess2(AMax, AValue: Double): Tx3BusyDlgPropertyes;
begin
  Process2Max := AMax;
  Process2Value := AValue;
  Result := Self;
end;

function Tx3BusyDlgPropertyes.AsPointer: Pointer;
var
  FResult: Px3BusyDlgPropertyes;
begin
  Result := nil;
  New(FResult);
  FResult^ := Self;
  Result := FResult;
end;
//****************************************************************************//
end.
