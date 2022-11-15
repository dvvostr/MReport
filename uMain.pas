unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Win.ComObj, System.StrUtils,
  ux3Utils, ux3Crypt, ux3CustomMDDataObject, ux3MReportObject,
  uIniFiles, uDM, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutcxEditAdapters, cxContainer,
  cxEdit, Vcl.ExtCtrls, dxLayoutContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxClasses, dxLayoutControl, uPopupSelectedList,
  ux3Classes,
  Xml.XMLIntf, Xml.XMLDoc, Winapi.msxml,
  ufrmBusy, uAnalystReferenceReport;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
  private
    procedure ShowBusyDlg(AActionType: Integer; AParams: Px3BusyDlgPropertyes);
    procedure DoTest1(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

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

procedure TfrmMain.Button1Click(Sender: TObject);
var
  FReport: Tx3MReportObject;
begin
  if OpenDialog1.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(OpenDialog1.FileName);
    SaveDialog1.DefaultExt := 'xml';
    SaveDialog1.InitialDir := OpenDialog1.InitialDir;
    if SaveDialog1.Execute then
      FReport.Save(SaveDialog1.FileName);
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  FReport: Tx3MReportObject;
begin
  if OpenDialog1.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(OpenDialog1.FileName);
    SaveDialog1.DefaultExt := 'xml';
    SaveDialog1.InitialDir := OpenDialog1.InitialDir;
    if SaveDialog1.Execute then
      FReport.Save(SaveDialog1.FileName);
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  FReport: Tx3MReportObject;
  FExcel: OLEVariant;
  FWorkbook: OLEVariant;
  FStr, FMsg: String;
begin
  if OpenDialog1.Execute(Handle) then
  begin
    FReport := Tx3MReportObject.Create(OpenDialog1.FileName);
    try
      FExcel := CreateOleObject('Excel.Application');
      FExcel.Visible := True;
      FExcel.Workbooks.Open(ExtractFilePath(OpenDialog1.FileName) + FReport.Script);
      FExcel.Workbooks.Open(ExtractFilePath(OpenDialog1.FileName) + 'example1.xlsm');
      FStr := FReport.AsXML.XML.Text;
      if FExcel.Run('Main.FormatQuery', 1, FStr, FMsg) then
      begin
        ShowMessage(FMsg);
        SaveDialog1.InitialDir := OpenDialog1.InitialDir;
        SaveDialog1.DefaultExt := 'xml';
        if SaveDialog1.Execute then
          TextSave(FStr, SaveDialog1.FileName);
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

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  with TfrmAnalystReferenceReport.Create(Application) do
    ShowModal;
end;

constructor TfrmMain.Create(AOwner: TComponent);
var
  FMsg: String;
begin
  inherited Create(AOwner);

  Button5.OnClick := DoTest1;

  DM := TDM.Create(Application);
  if not DM.TestMDConnect(FMsg) then
    ShowMessage(FMsg)
  else
    ShowMessage('OK');


end;

destructor  TfrmMain.Destroy;
begin
  inherited Destroy;
end;

procedure TfrmMain.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    XWM_BUSY_SHOW: ShowBusyDlg(Message.WParam, Px3BusyDlgPropertyes(Message.LParam));
    else inherited WndProc(Message);
  end;
end;

procedure TfrmMain.ShowBusyDlg(AActionType: Integer; AParams: Px3BusyDlgPropertyes);
begin
  if AActionType = 1 then
    frmBusy := ShowBusyDialog(AParams)
  else if (AActionType = 0) and Assigned(frmBusy) then
    frmBusy := ShowBusyDialog(nil)
  else if AActionType = 2 then
    SetBusyDialog(frmBusy, AParams);
end;

procedure TfrmMain.DoTest1(Sender: TObject);
var
  FInputFileName, FOutputFileName: String;
  FDocument, FStyle: IXMLDOMDocument;
  FRoot: IXMLDOMElement;
  FXMLNode, FXSLNode: IXMLDOMNode;
begin
  try
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
    if FileExists(FOutputFileName) then
      ShowMessage('OK')
    else
      ShowMessage('File not exists');
  except on e: Exception do
    ShowMessage(e.Message);
  end;
end;
end.
