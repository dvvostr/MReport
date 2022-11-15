unit uAnalystReferenceReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit,Vcl.StdCtrls, dxLayoutcxEditAdapters, Vcl.ComCtrls, dxCore,
  cxDateUtils, dxLayoutContainer, cxCalendar, cxSplitter, cxClasses,
  dxLayoutControl, cxCheckBox, cxCustomData, cxStyles, dxScrollbarAnnotations,
  cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer, cxTLData, cxDBTL, dxLayoutControlAdapters,
  Xml.XMLIntf, Xml.XMLDoc, Win.ComObj, Winapi.msxml,
  uSelectedList, uPopupSelectedList, ux3Classes, ux3Utils, ux3ReportParam, uReportForm,
  uDM, ux3MReportObject, ux3CustomMDDataObject;

type
  TfrmAnalystReferenceReport = class(TReportForm)
    btnReportExecute: TButton;
    LayoutControlLeftGroup_Root: TdxLayoutGroup;
    LayoutControlLeft: TdxLayoutControl;
    liReportDateType: TdxLayoutItem;
    liReportSettings: TdxLayoutGroup;

    liReportDatePeriod: TdxLayoutGroup;
    liReportDateStart: TdxLayoutItem;
    liReportDateEnd: TdxLayoutItem;
    liReportSeparator1: TdxLayoutSeparatorItem;
    liReportBrandType: TdxLayoutItem;
    liReportGoodsType: TdxLayoutItem;
    liReportProductionType: TdxLayoutItem;
    liReportCollection: TdxLayoutItem;
    liReportPriceGroup: TdxLayoutItem;
    liReportGoldColor: TdxLayoutItem;
    liReportTopCount: TdxLayoutItem;
    liReportColumns: TdxLayoutItem;
    liReportLiquidType: TdxLayoutItem;
    liReportSeparator2: TdxLayoutSeparatorItem;
    liReportUseDistribution: TdxLayoutItem;
    liReportSortByModels: TdxLayoutItem;
    liReportShowRefWithSalesOnly: TdxLayoutItem;
    liReportShowWatchDiameter: TdxLayoutItem;
    liReportShowSize: TdxLayoutItem;
    liReportUseConsignation: TdxLayoutItem;
    liReportAllSizePhoto: TdxLayoutItem;
    liReportSeparator3: TdxLayoutSeparatorItem;
    liReportCreatePivot: TdxLayoutItem;
    liReportLocationDetail: TdxLayoutItem;
    liReportShowPhotoForEachSize: TdxLayoutItem;
    liReportSeparator4: TdxLayoutSeparatorItem;
    liReportBrandGroupGroup: TdxLayoutGroup;
    liReportBrandGroup: TdxLayoutItem;
    liReportExecute: TdxLayoutItem;
    liReportRight: TdxLayoutAutoCreatedGroup;
    edReportDateType: TcxComboBox;
    edReportDateStart: TcxDateEdit;
    edReportDateEnd: TcxDateEdit;
    edReportBrandType: TcxPopupEdit;
    edReportGoodsType: TcxPopupEdit;
    edReportProductionType: TcxPopupEdit;
    edReportCollection: TcxPopupEdit;
    edReportPriceGroup: TcxPopupEdit;
    edReportGoldColor: TcxPopupEdit;
    edReportColumns: TcxPopupEdit;
    edReportTopCount: TcxMaskEdit;
    edReportLiquidType: TcxPopupEdit;
    edReportUseDistribution: TcxCheckBox;
    edReportUseConsignation: TcxCheckBox;
    edReportSortByModels: TcxCheckBox;
    edReportShowRefWithSalesOnly: TcxCheckBox;
    edReportShowWatchDiameter: TcxCheckBox;
    edReportShowSize: TcxCheckBox;
    edReportAllSizePhoto: TcxCheckBox;
    edReportCreatePivot: TcxCheckBox;
    edReportLocationDetail: TcxCheckBox;
    edReportShowPhotoForEachSize: TcxCheckBox;
    edReportBrandGroup: TcxDBTreeList;
    edReportBrandGroupcxDBTreeListColumn1: TcxDBTreeListColumn;
  protected
    function Initialize(var AMsg: String): Boolean; override;
    procedure  ParamRegister(AParams: TArray<Tx3ReportParam>); override;
  private
    function    GetDateType: Integer;
    procedure   SetDateType(const AValue: Integer);
    procedure   DoReportDateTypeChange(Sender: TObject);
    procedure   DoReportExecute1(Sender: TObject);
    procedure   DoReportExecute2(Sender: TObject);
    procedure   DoReportExecute(Sender: TObject);
    procedure   DoTest(Sender: TObject);
    procedure   DoTest3(Sender: TObject);
    procedure   DoTest4(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    CloseQuery: Boolean; override;
    procedure   CreateParams(var Params: TCreateParams); override;
    property    DateType: Integer read GetDateType write SetDateType;
  end;

var
  frmAnalystReferenceReport: TfrmAnalystReferenceReport;

implementation

{$R *.dfm}

//****************************************************************************//

const
  REPORT_DATETYPE: array[1..2] of TPopupSelectedItem = (
    (Index: 1; Parent: -1; Caption: 'Последние 12 месяцев'),
    (Index: 2; Parent: -1; Caption: 'Произвольный период')
  );
  REPORT_COLUMNS: array[1..28] of TPopupSelectedItem = (
    (Index: 1; Parent: -1; Caption: 'Все'),
  //***** Все *****//
    (Index: 1001; Parent: 1; Caption: 'Group1'),
    (Index: 1002; Parent: 1; Caption: 'Group2'),
    (Index: 1003; Parent: 1; Caption: 'Group3'),
    (Index: 2;    Parent: 1; Caption: 'Property1'),
    (Index: 4;    Parent: 1; Caption: 'Property2'),
    (Index: 61;   Parent: 1; Caption: 'Property61'),
    (Index: 62;   Parent: 1; Caption: 'Property62'),
    (Index: 66;   Parent: 1; Caption: 'Property66'),
    (Index: 67;   Parent: 1; Caption: 'Property67'),
    (Index: 71;   Parent: 1; Caption: 'Property71'),

  //***** Ювелирные изделия *****//
    (Index: 8;    Parent: 1001; Caption: 'Property8'),
    (Index: 63;   Parent: 1001; Caption: 'Property63'),
    (Index: 64;   Parent: 1001; Caption: 'Property64'),
    (Index: 65;   Parent: 1001; Caption: 'Property65'),
  //***** Часы *****//
    (Index: 9;    Parent: 1002; Caption: 'Property9'),
    (Index: 10;   Parent: 1002; Caption: 'Property10'),
    (Index: 11;   Parent: 1002; Caption: 'Property11'),
    (Index: 12;   Parent: 1002; Caption: 'Property12'),
    (Index: 13;   Parent: 1002; Caption: 'Property13'),
    (Index: 14;   Parent: 1002; Caption: 'Property14'),
    (Index: 15;   Parent: 1002; Caption: 'Property15'),
    (Index: 16;   Parent: 1002; Caption: 'Property16'),
    (Index: 17;   Parent: 1002; Caption: 'Property17'),
    (Index: 18;   Parent: 1002; Caption: 'Property18'),
    (Index: 19;   Parent: 1002; Caption: 'Property19'),
    (Index: 20;   Parent: 1002; Caption: 'Property20'),
    (Index: 21;   Parent: 1002; Caption: 'Property21')
  );
//****************************************************************************//
constructor TfrmAnalystReferenceReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  btnReportExecute.OnClick := DoReportExecute;
//  btnReportExecute.OnClick := DoTest4;
end;

destructor TfrmAnalystReferenceReport.Destroy;
begin
  inherited Destroy;
end;

function TfrmAnalystReferenceReport.CloseQuery: Boolean;
begin
  Result := inherited CloseQuery;
end;

procedure TfrmAnalystReferenceReport.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style and (not WS_MAXIMIZEBOX ) and (not WS_MINIMIZEBOX) and (not WS_ICONIC);
  Params.ExStyle := WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
end;

function TfrmAnalystReferenceReport.Initialize(var AMsg: String): Boolean;
var
  FBusy: Tx3BusyDlgPropertyes;
  PBusy: Px3BusyDlgPropertyes;
begin
  Result := inherited Initialize(AMsg);
  try
    try
      Screen.Cursor := crHourGlass;
      FBusy := Tx3BusyDlgPropertyes.Create('Загрузка данных');

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 1, LongInt(FBusy.WithText('Тип бренда').WithProcess1(9, 0).AsPointer));
      Result := CreatePopupSelectedList(edReportBrandType, liReportBrandType.Caption, '[Товар].[Тип бренда]', AMsg);

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Тип товара').WithProcess1(9, 1).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportGoodsType, liReportGoodsType.Caption, '[Товар].[Тип товара]', AMsg));


      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Тип изделия').WithProcess1(9, 2).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportProductionType, liReportProductionType.Caption, '[Товар].[Тип изделия]', AMsg));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Коллекция').WithProcess1(9, 3).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportCollection, liReportCollection.Caption, '[Товар].[Коллекции]', AMsg));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Ценовая категория').WithProcess1(9, 4).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportPriceGroup, liReportPriceGroup.Caption, '[Товар].[Ценовая категория общая УпрТек]', AMsg));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Цвет золота').WithProcess1(9, 5).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportGoldColor, liReportGoldColor.Caption, '[Товар].[Цвет золота]', AMsg));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Тип ликвидности').WithProcess1(9, 6).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportLiquidType, liReportLiquidType.Caption, '[Товар].[Тип ликвидности 2]', AMsg));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Колонки отчета').WithProcess1(9, 7).AsPointer));
      Result := (Result and CreatePopupSelectedList(edReportColumns, liReportColumns.Caption, REPORT_COLUMNS, AMsg, sltAllValues));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Бренд / группа').WithProcess1(9, 8).AsPointer));
      Result := (Result and CreateSelectedList(edReportBrandGroup, '[Товар].[БрендГруппа]', AMsg, sltAllValues));

      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 2, LongInt(FBusy.WithText('Готово').WithProcess1(9, 9).AsPointer));
      TTreeSelectedList.SetPopupList(edReportDateType.Properties.Items, REPORT_DATETYPE);
      edReportDateType.Properties.OnChange := DoReportDateTypeChange;
      DateType := 1;
    finally
      SendMessage(Application.MainForm.Handle, XWM_BUSY_SHOW, 0, 0);
      Screen.Cursor := crDefault;
    end;
  except on e: Exception do
  begin
    Result := False;
    AMsg := e.Message;
  end; end;
end;

procedure TfrmAnalystReferenceReport.ParamRegister(AParams: TArray<Tx3ReportParam>);
begin
  inherited ParamRegister([
    Tx3ReportParam.Init(edReportDateType, 'DateType', dtIntegerList),
    Tx3ReportParam.Init(edReportDateStart, 'DateStart', dtDate),
    Tx3ReportParam.Init(edReportDateEnd, 'DateEnd', dtDate),
    Tx3ReportParam.Init(edReportBrandType, 'BrandType', dtSelectedList),
    Tx3ReportParam.Init(edReportGoodsType, 'GoodsType', dtSelectedList),
    Tx3ReportParam.Init(edReportProductionType, 'ProductionType', dtSelectedList),
    Tx3ReportParam.Init(edReportCollection, 'Collection', dtSelectedList),
    Tx3ReportParam.Init(edReportPriceGroup, 'PriceGroup', dtSelectedList),
    Tx3ReportParam.Init(edReportGoldColor, 'GoldColor', dtSelectedList),
    Tx3ReportParam.Init(edReportTopCount, 'TopCount', dtInteger),
    Tx3ReportParam.Init(edReportColumns, 'Columns', dtSelectedList),
    Tx3ReportParam.Init(edReportLiquidType, 'LiquidType', dtSelectedList),
    Tx3ReportParam.Init(edReportUseDistribution, 'UseDistribution', dtBoolean),
    Tx3ReportParam.Init(edReportUseConsignation, 'UseConsignation', dtBoolean),
    Tx3ReportParam.Init(edReportSortByModels, 'SortByModels', dtBoolean),
    Tx3ReportParam.Init(edReportShowRefWithSalesOnly, 'ShowRefWithSalesOnly', dtBoolean),
    Tx3ReportParam.Init(edReportShowWatchDiameter, 'ShowWatchDiameter', dtBoolean),
    Tx3ReportParam.Init(edReportShowSize, 'ShowSize', dtBoolean),
    Tx3ReportParam.Init(edReportAllSizePhoto, 'AllSizePhoto', dtBoolean),
    Tx3ReportParam.Init(edReportCreatePivot, 'CreatePivot', dtBoolean),
    Tx3ReportParam.Init(edReportLocationDetail, 'LocationDetail', dtBoolean),
    Tx3ReportParam.Init(edReportShowPhotoForEachSize, 'ShowPhotoForEachSize', dtBoolean),
    Tx3ReportParam.Init(edReportBrandGroup, 'BrandGroup', dtSelectedList)
  ])
end;

function TfrmAnalystReferenceReport.GetDateType: Integer;
begin
  Result  := TPopupSelectedItem.SelectedIndexOfList(edReportDateType.Properties.Items, edReportDateType.ItemIndex);
end;

procedure TfrmAnalystReferenceReport.SetDateType(const AValue: Integer);
var
  FOldValue: Integer;
begin
  FOldValue := edReportDateType.ItemIndex;
  edReportDateType.ItemIndex := TPopupSelectedItem.IndexOfList(edReportDateType.Properties.Items, AValue);
  if FOldValue <> edReportDateType.ItemIndex then
    DoReportDateTypeChange(edReportDateType);
end;

procedure TfrmAnalystReferenceReport.DoReportDateTypeChange(Sender: TObject);
begin
  liReportDatePeriod.Enabled := (TPopupSelectedItem.SelectedIndexOfList(edReportDateType.Properties.Items, edReportDateType.ItemIndex) = 2);
  if (TPopupSelectedItem.SelectedIndexOfList(edReportDateType.Properties.Items, edReportDateType.ItemIndex) = 1) then
  begin
    edReportDateStart.Date := IncMonth(Now, -12);
    edReportDateEnd.Date := Now;
  end;
end;

procedure TfrmAnalystReferenceReport.DoReportExecute1(Sender: TObject);
var
  FOpenDialog: TOpenDialog;
  FSaveDialog: TSaveDialog;
  FDocument: TXMLDocument;
  FNode, FListNode: IXMLNode;
  FReport: Tx3MReportObject;
  FExcel: OLEVariant;
  FWorkbook: OLEVariant;
  i: Integer;
  FStr, FMsg: String;
  FWStr: WideString;
begin

//  FDocument := XMLParams;
//  FDocument.XML.SaveToFile(ExtractFilePath(Application.ExeName) + 'PARAMS_AnalystReferenceReport.xml');
//  ShowMessage('OK');
  FOpenDialog := TOpenDialog.Create(Application);
  FSaveDialog := TSaveDialog.Create(Application);
  if FOpenDialog.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(FOpenDialog.FileName);
    FDocument := TXMLDocument.Create(nil);
    FDocument.Active := True;
    FDocument.LoadFromFile(FOpenDialog.FileName);
    FReport.LoadParams(Params);
    TextSave(FReport.AsXML.XML.Text, ExtractFilePath(FOpenDialog.FileName) + '_data_01_.xml');
    try
      FExcel := CreateOleObject('Excel.Application');
      FExcel.Visible := True;
      FExcel.Workbooks.Open(ExtractFilePath(FOpenDialog.FileName) + FReport.Script);
      FExcel.Workbooks.Open(ExtractFilePath(FOpenDialog.FileName) + 'example1.xlsm');
//      FReport.AsXML.DocumentElement.TransformNode(FDocument.DocumentElement, FWStr);
//      TextSave(FWStr, ExtractFilePath(FOpenDialog.FileName) + '_data_.xml');
      FStr := FReport.AsXML.XML.Text;
      TextSave(FStr, ExtractFilePath(FOpenDialog.FileName) + '_data_.xml');
      if FExcel.Run('Main.FormatQuery', 'main1.xlsm', 1, FStr, FMsg) then
      begin
        ShowMessage(FMsg);
        FSaveDialog.InitialDir := FOpenDialog.InitialDir;
        FSaveDialog.DefaultExt := 'xml';
        if FSaveDialog.Execute then
          TextSave(FStr, FSaveDialog.FileName);
          FDocument := TXMLDocument.Create(Application);
          FDocument.LoadFromXML(FStr);
          FDocument.Active := True;
          FNode := FDocument.DocumentElement.ChildNodes.FindNode('queryes');
          if Assigned(FNode) then
            for i := 0 to FNode.ChildNodes.Count - 1 do
            begin
              FListNode := FNode.ChildNodes.Get(i);
              if Assigned(FListNode) and (FListNode.NodeName = 'query') and FListNode.HasAttribute('name') and FListNode.HasAttribute('caption') then
              begin
                FStr := FListNode.Text;
                TextSave(FStr, ExtractFilePath(FSaveDialog.FileName) + Format('_query_%d.mdx', [i + 1]));
              end;
            end;
      end
      else
        ShowMessage(FMsg);
    finally
      FExcel.Quit;
    end;
//    SaveDialog1.DefaultExt := 'xml';
//    SaveDialog1.InitialDir := OpenDialog1.InitialDir;
//    if SaveDialog1.Execute then
//      FReport.Save(SaveDialog1.FileName);
  end;
end;

procedure TfrmAnalystReferenceReport.DoReportExecute2(Sender: TObject);
var
  FOpenDialog: TOpenDialog;
  FSaveDialog: TSaveDialog;
  FDocument, FStyle: IXMLDOMDocument;
  FXMLNode, FXSLNode: IXMLDOMNode;

  FReport: Tx3MReportObject;
  FExcel: OLEVariant;
  FWorkbook: OLEVariant;
  i: Integer;
  FStr, FMsg: String;
  FWStr: WideString;
begin
  FOpenDialog := TOpenDialog.Create(Application);
  FSaveDialog := TSaveDialog.Create(Application);
  if FOpenDialog.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(FOpenDialog.FileName);
    FDocument := CoDOMDocument.Create;
    FStyle := CoDOMDocument.Create;
    FDocument.load(FOpenDialog.FileName);

    FStyle.loadXML(FDocument.documentElement.xml);
    FReport.LoadParams(Params);
    try
      FExcel := CreateOleObject('Excel.Application');
      FExcel.Visible := True;
      FExcel.Workbooks.Open(ExtractFilePath(FOpenDialog.FileName) + 'excel\example1.xlsm');

      FStr := FReport.AsXML.XML.Text;
      TextSave(FStr, ExtractFilePath(FOpenDialog.FileName) + '_data_.xml');
      if FExcel.Run('Main.FormatQuery', FReport.Script, 1, FStr, FMsg) then
      begin
        FDocument.loadXML(Format('<?x1ml version="1.0" encoding="windows-1251"?>%s', [FStr]));
        FXMLNode := FDocument.documentElement;
        FXSLNode := FStyle.documentElement.SelectSingleNode('//transform/xsl:stylesheet');

//        TextSave(FDocument.xml, ExtractFilePath(FOpenDialog.FileName) + '_data_doc_.xml');
//        TextSave(FStr, ExtractFilePath(FOpenDialog.FileName) + '_data_params_.xml');
//        TextSave(FXMLNode.xml, ExtractFilePath(FOpenDialog.FileName) + '_data_xml_.xml');
//        TextSave(FXSLNode.xml, ExtractFilePath(FOpenDialog.FileName) + '_data_xls_.xml');

        if Assigned(FXMLNode) And Assigned(FXSLNode) then
        begin
          FDocument.loadXML(FXMLNode.xml);
          FStyle.loadXML(FXSLNode.xml);
          FDocument.async := False;
          FDocument.validateOnParse := True;
          FDocument.transformNodeToObject(FStyle, FDocument);
          FSaveDialog.InitialDir := FOpenDialog.InitialDir;
          FSaveDialog.DefaultExt := 'xml';
          if FSaveDialog.Execute then
            FDocument.save(FSaveDialog.FileName);
          FXMLNode := FDocument.documentElement.SelectSingleNode('//queryes');
          if Assigned(FXMLNode) then
          for i := 0 to FXMLNode.ChildNodes.length - 1 do
          begin
            FXSLNode := FXMLNode.ChildNodes.item[i];
            if Assigned(FXSLNode) and
                (FXSLNode.NodeName = 'query') and
                Assigned(FXSLNode.attributes.getNamedItem('name')) and
                Assigned(FXSLNode.attributes.getNamedItem('caption'))
            then
            begin
              FStr := FXSLNode.Text;
              TextSave(FStr, ExtractFilePath(FSaveDialog.FileName) + Format('_query_%d.mdx', [i + 1]));
            end;
          end;
        end;
      end
      else
        ShowMessage(FMsg);
    finally
      FExcel.Quit;
    end;
//    SaveDialog1.DefaultExt := 'xml';
//    SaveDialog1.InitialDir := OpenDialog1.InitialDir;
//    if SaveDialog1.Execute then
//      FReport.Save(SaveDialog1.FileName);
  end;
end;
procedure TfrmAnalystReferenceReport.DoReportExecute(Sender: TObject);
var
  FOpenDialog: TOpenDialog;
  FSaveDialog: TSaveDialog;
  FDocument: IXMLDOMDocument;
  FXMLNode, FQueryNode, FDataNode, FResultNode, FAttrNode: IXMLDOMNode;
  FReport: Tx3MReportObject;
  FData: Tx3MDQueryData;
  i: Integer;
  FMsg, FStr: String;
begin
  FOpenDialog := TOpenDialog.Create(Application);
  FSaveDialog := TSaveDialog.Create(Application);
  if FOpenDialog.Execute(Handle) and FormatQuery(FOpenDialog.FileName, FReport, FDocument, FMsg) then
  begin
    FSaveDialog.InitialDir := FOpenDialog.InitialDir;
    FSaveDialog.DefaultExt := 'xml';
    if FSaveDialog.Execute then
      FDocument.save(FSaveDialog.FileName);
    FXMLNode := FDocument.documentElement.SelectSingleNode('//queryes');
    FDataNode := FDocument.createElement('results');
    FDocument.documentElement.appendChild(FDataNode);
    if Assigned(FXMLNode) then
    for i := 0 to FXMLNode.ChildNodes.length - 1 do
    begin
      FQueryNode := FXMLNode.ChildNodes.item[i];
      if Assigned(FQueryNode) and
          (FQueryNode.NodeName = 'query') and
          Assigned(FQueryNode.attributes.getNamedItem('name')) and
          Assigned(FQueryNode.attributes.getNamedItem('caption'))
      then
      begin
        FStr := FQueryNode.Text;
        TextSave(FStr, ExtractFilePath(FSaveDialog.FileName) + Format('_query_%d.mdx', [i + 1]));
        if Tx3MDCustomDataObject.OpenQuery(DM.AccessInfo, FStr, FData, FMsg) then
        begin
          FResultNode := FData.AsXMLNode('result');
          FAttrNode := FDocument.createAttribute('name');
          FAttrNode.nodeValue := FQueryNode.attributes.getNamedItem('name').nodeValue;
          FResultNode.attributes.setNamedItem(FAttrNode);
          FAttrNode := FDocument.createAttribute('caption');
          FAttrNode.nodeValue := FQueryNode.attributes.getNamedItem('caption').nodeValue;
          FResultNode.attributes.setNamedItem(FAttrNode);
          FAttrNode := FDocument.createAttribute('isMain');
          if Assigned(FQueryNode.attributes.getNamedItem('isMain')) then
            FAttrNode.nodeValue := FQueryNode.attributes.getNamedItem('isMain').nodeValue;
          FResultNode.attributes.setNamedItem(FAttrNode);

          FDataNode.appendChild(FResultNode);
//          TextSave(FStr, ExtractFilePath(FSaveDialog.FileName) + Format('_data_%d.xml', [i + 1]));
        end;
      end;
    end;
    TextSave(FDocument.xml, ExtractFilePath(FSaveDialog.FileName) + '_result_data.xml');
  end;
  ShowMessage('Done');
end;

procedure TfrmAnalystReferenceReport.DoTest(Sender: TObject);
var
  FOpenDialog: TOpenDialog;
  FDocument: TXMLDocument;
  FXMLNode, FXSLNode: IXMLNode;
  FReport: Tx3MReportObject;
  FStr, FMsg: String;
  FWStr: WideString;
begin
  FOpenDialog := TOpenDialog.Create(Application);
  if FOpenDialog.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(FOpenDialog.FileName);
    FDocument := TXMLDocument.Create(Application);
    FDocument.LoadFromFile(FOpenDialog.FileName);
    FDocument.Active := True;
    FReport.LoadParams(Params);
    try
      FXMLNode := FReport.AsXML.DocumentElement;
      FXSLNode := FDocument.DocumentElement.ChildNodes.FindNode('transform');
      if Assigned(FXSLNode) then
        FXSLNode := FXSLNode.ChildNodes.First;
        if Assigned(FXSLNode) then
        begin
          FXMLNode.TransformNode(FXSLNode, FWStr);
          TextSave(FWStr, ExtractFilePath(FOpenDialog.FileName) + '_data_.xml');
          TextSave(FXMLNode.XML, ExtractFilePath(FOpenDialog.FileName) + '_data_xml_.xml');
          TextSave(FXSLNode.XML, ExtractFilePath(FOpenDialog.FileName) + '_data_xsl_.xml');
        end;
    finally
    end;
  end;
end;

procedure TfrmAnalystReferenceReport.DoTest3(Sender: TObject);
var
  FFileName: String;
  FDocument: TXMLDocument;
  FXMLNode, FXSLNode: IXMLNode;
  FStr, FMsg: String;
  FWStr: WideString;
begin
  FFileName := 'c:\_test_\_xlst_.xml';
  FDocument := TXMLDocument.Create(Application);
  FDocument.LoadFromFile(FFileName);
  FDocument.Active := True;
  try
    FXMLNode := FDocument.DocumentElement.ChildNodes.FindNode('data');
    FXSLNode := FDocument.DocumentElement.ChildNodes.FindNode('transform');
//    FXSLNode := FDocument.DocumentElement.ChildNodes.FindNode('transform/xsl:stylesheet', 'http://www.w3.org/1999/XSL/Transform');

//    FXMLNode := FindNode(FDocument.DocumentElement, 'data','http://www.w3.org/1999/XSL/Transform');
//    FXSLNode := FindNode(FDocument.DocumentElement, 'transform/xsl:stylesheet','http://www.w3.org/1999/XSL/Transform');

    if Assigned(FXMLNode) And Assigned(FXSLNode) then
    begin
      FXSLNode := FXSLNode.ChildNodes.First;
      TextSave(FXMLNode.XML, ExtractFilePath(FFileName) + '_data_xml_.xml');
      TextSave(FXSLNode.XML, ExtractFilePath(FFileName) + '_data_xsl_.xml');
      FXMLNode.TransformNode(FXSLNode, FDocument);
      TextSave(FDocument.XML.Text, ExtractFilePath(FFileName) + '_data_.xml');
    end;
  finally
  end;
end;

procedure TfrmAnalystReferenceReport.DoTest4(Sender: TObject);
var
  FInputFileName, FOutputFileName: String;
  FDocument, FStyle: IXMLDOMDocument;
  FRoot: IXMLDOMElement;
  FXMLNode, FXSLNode: IXMLDOMNode;
begin
  FInputFileName := 'c:\_test_\_xlst_.xml';
  FOutputFileName := ExtractFilePath(FInputFileName) + '_data_.xml';

  FDocument := CoDOMDocument.Create;
  FStyle := CoDOMDocument.Create;

  FDocument.load(FInputFileName);
  FRoot := FDocument.documentElement;
  FXMLNode := FRoot.SelectSingleNode('//data');
  FXSLNode := FRoot.SelectSingleNode('//transform/xsl:stylesheet');
  if Assigned(FXMLNode) And Assigned(FXSLNode) then
  begin
    FDocument.loadXML(FXMLNode.xml);
    FStyle.loadXML(FXSLNode.xml);
    FDocument.async := False;
    FDocument.validateOnParse := True;
    FDocument.transformNodeToObject(FStyle, FDocument);
    FDocument.save(FOutputFileName);
  end;
end;

end.

