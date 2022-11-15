program Project1;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  ux3MReportObject in 'Components\ux3MReportObject.pas',
  ADODB_TLB in 'Components\Import\ADODB_TLB.pas',
  ADOMD_TLB in 'Components\Import\ADOMD_TLB.pas',
  uAnalystReferenceReport in 'Reports\uAnalystReferenceReport.pas' {frmAnalystReferenceReport},
  uDM in 'Components\Data\uDM.pas' {DM: TDataModule},
  uIniFiles in 'Units\uIniFiles.pas',
  ux3Utils in 'Units\ux3Utils.pas',
  ux3Crypt in 'Units\ux3Crypt.pas',
  uPopupSelectedList in 'Components\UI\uPopupSelectedList.pas' {PopupSelectedList: TFrame},
  uSelectedList in 'Components\UI\uSelectedList.pas',
  ux3Classes in 'Units\ux3Classes.pas',
  ufrmBusy in 'Components\UI\ufrmBusy.pas' {frmBusy},
  uReportForm in 'Components\UI\uReportForm.pas',
  ux3ReportParam in 'Units\ux3ReportParam.pas',
  ux3CustomMDDataObject in 'Components\Data\ux3CustomMDDataObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
