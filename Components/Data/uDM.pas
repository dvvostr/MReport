unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils,
  uIniFiles,
  ux3Utils, ux3Crypt, ux3CustomMDDataObject;

type

  TDM = class(TDataModule)
  private
    FMDConnected: Boolean;
    FMDAccessInfo: Tx3MDCustomAccessInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    TestMDConnect(var AMsg: String): Boolean;
    property    AccessInfo: Tx3MDCustomAccessInfo read FMDAccessInfo;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDM.Destroy;
begin
  inherited Destroy;
end;

function TDM.TestMDConnect(var AMsg: String): Boolean;
begin
  FMDAccessInfo := CreateMDAccesInfo(
    IfThen(
      IniReadInteger(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_AUTHMODE, 0) in [Integer(Low(Tx3MDAccessType))..Integer(High(Tx3MDAccessType))],
      Tx3MDAccessType(IniReadInteger(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_AUTHMODE, 0)),
      atNone),
    IniReadString(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_SERVERNAME, ''),
    IniReadString(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_DATABASENAME, ''),
    StrDecrypt(IniReadString(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_ADMINNAME, '')),
    StrDecrypt(IniReadString(GetIniFileName, INI_SEC_DATABASE_MD, INI_DB_ADMINPSW, ''))
  );
  FMDConnected := Tx3MDCustomDataObject.TestConnection(FMDAccessInfo, AMsg);
  Result := FMDConnected;
end;

end.
