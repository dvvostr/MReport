unit uReportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Xml.XMLIntf, Xml.XMLDoc, Win.ComObj, Winapi.msxml,
  uSelectedList, uPopupSelectedList, ux3Classes, ux3Utils, ux3ReportParam, ux3MReportObject;

type
  TReportForm = class(TForm)
    protected
      function    Initialize(var AMsg: String): Boolean; virtual;
      procedure   ParamRegister(AParams: TArray<Tx3ReportParam>); virtual;
      function    FormatQuery(AFileName: String; AReport: Tx3MReportObject; var ADocument: IXMLDOMDocument; var AMsg: String): Boolean; virtual;
      function    AddData(ADocument: IXMLDOMDocument; AIndex: Integer; AData: String; var AMsg: String): Boolean; virtual;
    private
      FParams: TList;
      FErrorEvent : Tx3ErrorEvent;
      function    GetParams: TArray<Tx3ReportParam>;
      function    GetXMLParams: TXMLDocument;
    public
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
      property    Params: TArray<Tx3ReportParam> read GetParams;
      property    XMLParams: TXMLDocument read GetXMLParams;
    published
      property    OnError: Tx3ErrorEvent read FErrorEvent write FErrorEvent;
  end;

implementation


constructor TReportForm.Create(AOwner: TComponent);
var
  FFlag: Boolean;
  FMsg: String;
begin
  inherited;
  FParams := TList.Create;
  FFlag := Initialize(FMsg);
end;

destructor TReportForm.Destroy;
begin
  FParams.Clear;
  FParams.Free;
  inherited;
end;

function TReportForm.Initialize(var AMsg: String): Boolean;
begin
  Result := True;
  AMsg := '';
  ParamRegister([]);
end;

procedure TReportForm.ParamRegister(AParams: TArray<Tx3ReportParam>);
var
  i: Integer;
begin
  if not Assigned(FParams) then
    FParams := TList.Create;
  FParams.Clear;
  for i := Low(AParams) to High(AParams) do
    FParams.Add(AParams[i]);
end;

function TReportForm.FormatQuery(AFileName: String; AReport: Tx3MReportObject; var ADocument: IXMLDOMDocument; var AMsg: String): Boolean;
var
  FDocument, FStyle: IXMLDOMDocument;
  FXMLNode, FXSLNode: IXMLDOMNode;

  FExcel: OLEVariant;
  FWorkbook: OLEVariant;
  i: Integer;
  FStr, FMsg: String;
  FWStr: WideString;
begin
  Result := FileExists(AFileName);
  ADocument := nil;
  AMsg := '';
  if Result then
  begin
    AReport := Tx3MReportObject.Create(AFileName);
    FDocument := CoDOMDocument.Create;
    FStyle := CoDOMDocument.Create;
    FDocument.load(AFileName);

    FStyle.loadXML(FDocument.documentElement.xml);
    AReport.LoadParams(Params);
//    TextSave(AReport.A1sXML.XML.Text, ExtractFilePath(AFileName) + '_input_xml_.xml'); Exit;
    try
      try
        FExcel := CreateOleObject('Excel.Application');
        FExcel.Visible := False;
        FExcel.Workbooks.Open(ExtractFilePath(AFileName) + AReport.ReportFile);
        FStr := AReport.AsXML.XML.Text;

//        TextSave(FStr, ExtractFilePath(Application.ExeName) + '_input_xml_.xml'); Exit;

        Result := FExcel.Run('Main.FormatQuery', AReport.Script, 1, FStr, FMsg);
        if Result then
        begin
          FDocument.loadXML(Format('<?x1ml version="1.0" encoding="windows-1251"?>%s', [FStr]));
          FXMLNode := FDocument.documentElement;
          FXSLNode := FStyle.documentElement.SelectSingleNode('//transform/xsl:stylesheet');
          if Assigned(FXMLNode) And Assigned(FXSLNode) then
          begin
            FDocument.loadXML(FXMLNode.xml);
            FStyle.loadXML(FXSLNode.xml);
            FDocument.async := False;
            FDocument.validateOnParse := True;

//            TextSave(FDocument.xml, ExtractFilePath(Application.ExeName) + '_out_xml_.xml');
//            TextSave(FStyle.xml, ExtractFilePath(Application.ExeName) + '_out_xlt_.xml');

            FDocument.transformNodeToObject(FStyle, FDocument);
            ADocument := FDocument;
          end;
        end
        else
          ShowMessage(FMsg);
      finally
        FExcel.Quit;
        Result := Assigned(ADocument);
      end;
    except on e: Exception do
    begin
      Result := False;
      AMsg := e.Message;
    end; end;
  end
  else
    AMsg := ERROR_FILE_NOT_EXISTS;
end;

function TReportForm.AddData(ADocument: IXMLDOMDocument; AIndex: Integer; AData: String; var AMsg: String): Boolean;
begin


end;

function TReportForm.GetParams: TArray<Tx3ReportParam>;
var
  i: Integer;
begin
  SetLength(Result, TVarData(IfThen(Assigned(FParams), FParams.Count, 0)).VInteger);
  for i := 0 to FParams.Count - 1 do
    Result[i] := Tx3ReportParam(FParams[i]);
end;

function TReportForm.GetXMLParams: TXMLDocument;
var
  i: Integer;
  FItem: Tx3ReportParam;
  FNode: IXMLNode;
begin
  Result := TXMLDocument.Create(nil);
  try
    Result.Active := True;
    Result.DocumentElement := Result.CreateNode('params', ntElement, '');
    Result.DocumentElement.Attributes['name'] := 'unassigned';
    for i := 0 to FParams.Count - 1 do
    begin
      FItem := Tx3ReportParam(FParams[i]);
      if Assigned(FItem) then
      begin
        FNode := FItem.AsXMLNode(Result.DocumentElement);
      end;

    end;
  except on e: Exception do
  begin
    if Assigned(FErrorEvent) then
      FErrorEvent(Self, -1, e.Message);
  end;
end; end;

end.
