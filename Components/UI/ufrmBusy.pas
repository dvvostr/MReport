unit ufrmBusy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ux3Classes, ux3Utils,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, cxProgressBar, Vcl.ExtCtrls;

type
  TfrmBusy = class(TForm)
    pnProcess1: TPanel;
    edProcess1: TcxProgressBar;
    lblCaption: TcxLabel;
    pnProcess2: TPanel;
    edProcess2: TcxProgressBar;
    protected
      procedure CreateParams(var Params: TCreateParams); override;
    private
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function CloseQuery: Boolean; override;
  end;

var
  frmBusy: TfrmBusy;

  function ShowBusyDialog(AValue: Px3BusyDlgPropertyes): TfrmBusy;
  procedure SetBusyDialog(AForm: TfrmBusy; AValue: Px3BusyDlgPropertyes);

implementation

{$R *.dfm}

function ShowBusyDialog(AValue: Px3BusyDlgPropertyes): TfrmBusy;
begin
  if Assigned(AValue) then
  begin
    Result := TfrmBusy.Create(Application);
    Result.Position := poDesktopCenter;
    Result.pnProcess1.Visible := (AValue^.Process1Max > 0);
    Result.edProcess1.Properties.Max := AValue^.Process1Max;
    Result.edProcess1.Position := AValue^.Process1Value;

    Result.pnProcess2.Visible := (AValue^.Process2Max > 0);
    Result.edProcess2.Properties.Max := AValue^.Process2Max;
    Result.edProcess2.Position := AValue^.Process2Value;

    Result.lblCaption.Height := IfThen((not Result.pnProcess1.Visible) and (not Result.pnProcess2.Visible), 152, 36);
    Result.Height := (GetSystemMetrics(SM_CYCAPTION) * 2) + Result.lblCaption.Height;
//    Result.Height := 48 + Result.lblCaption.Height;
    if Result.pnProcess1.Visible then
      Result.Height := Result.Height + Result.pnProcess1.Height;
    if Result.pnProcess2.Visible then
      Result.Height := Result.Height + Result.pnProcess2.Height;

    SetBusyDialog(Result, AValue);
    Result.Show;
    Application.ProcessMessages;
  end
  else if Assigned(frmBusy) then
  begin
    frmBusy.Hide;
    FreeAndNil(frmBusy);
    Result := nil;
  end
  else
    Result := nil;
end;

procedure SetBusyDialog(AForm: TfrmBusy; AValue: Px3BusyDlgPropertyes);
begin
  if Assigned(AValue) and Assigned(AForm) then
  begin
    AForm.Caption := AValue^.Caption;
    AForm.lblCaption.Caption := AValue^.Text;
    AForm.edProcess1.Position := AValue^.Process1Value;
    AForm.edProcess2.Position := AValue^.Process2Value;
    Application.ProcessMessages;
  end;
end;
//****************************************************************************//
constructor TfrmBusy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormStyle := fsStayOnTop;
  BorderStyle := bsDialog;
end;

destructor TfrmBusy.Destroy;
begin
  inherited Destroy;
end;

function TfrmBusy.CloseQuery: Boolean;
begin
  Result := False and (inherited CloseQuery);
end;

procedure TfrmBusy.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style and (not WS_MAXIMIZEBOX ) and (not WS_MINIMIZEBOX) and (not WS_ICONIC);
  Params.ExStyle := WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
end;

end.
