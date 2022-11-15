{$I var.inc}

unit uIniFiles;

interface
  uses Windows, Forms, Classes, SysUtils, IniFiles, Dialogs;

const
  INI_SEC_COMMON      = 'Common';
  INI_SEC_IMAGE       = 'Image';
  INI_SEC_DATABASE_MD = 'DatabaseMD';
  INI_SEC_DATABASE_A  = 'DatabaseA';


  INI_SEC_DEFAULTS    = 'Defaults';

  INI_DB_CONNECTTYPE  = 'ConnectType';
  INI_DB_SERVERNAME   = 'ServerName';
  INI_DB_DATABASENAME = 'DatabaseName';
  INI_DB_LISTUSER     = 'ListUserName';
  INI_DB_ADMINNAME    = 'AdminValue1';
  INI_DB_ADMINPSW     = 'AdminValue2';
  INI_DB_AUTHMODE     = 'AuthMode';

  function  GetIniFileName: String;

  function  IniReadString(IniFileName, Section, KeyName, DefValue: String): String;
  procedure IniWriteString(IniFileName, Section, KeyName, Value: String);
  function  IniReadInteger(IniFileName, Section, KeyName: String; DefValue: Integer): Integer;
  procedure IniWriteInteger(IniFileName, Section, KeyName: String; Value: Integer);
  function  IniReadFloat(IniFileName, Section, KeyName: String; DefValue: Double): Double;
  procedure IniWriteFloat(IniFileName, Section, KeyName: String; Value: Double);
  function  IniReadBoolean(IniFileName, Section, KeyName: String; DefValue: Boolean): Boolean;
  procedure IniWriteBoolean(IniFileName, Section, KeyName: String; Value: Boolean);
  function  IniReadDateTime(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
  procedure IniWriteDateTime(IniFileName, Section, KeyName: String; Value: TDateTime);
  function  IniReadDate(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
  procedure IniWriteDate(IniFileName, Section, KeyName: String; Value: TDateTime);
  function  IniReadTime(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
  procedure IniWriteTime(IniFileName, Section, KeyName: String; Value: TDateTime);
  function  IniReadBinary(IniFileName, Section, KeyName: String; Value: TStream): Integer;
  procedure IniWriteBinary(IniFileName, Section, KeyName: String; Value: TStream);

implementation

const
  DEF_EXT_INIFILE = '.ini';

function GetIniFileName: String;
begin
  Result  := Concat(Copy(Application.ExeName, 1, Pos(ExtractFileExt(Application.ExeName), Application.ExeName) - 1), DEF_EXT_INIFILE);
end;

function IniReadString(IniFileName, Section, KeyName, DefValue: String): String;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadString(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteString(IniFileName, Section, KeyName, Value: String);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteString(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadInteger(IniFileName, Section, KeyName: String; DefValue: Integer): Integer;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadInteger(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteInteger(IniFileName, Section, KeyName: String; Value: Integer);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteInteger(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadFloat(IniFileName, Section, KeyName: String; DefValue: Double): Double;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadFloat(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteFloat(IniFileName, Section, KeyName: String; Value: Double);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteFloat(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadBoolean(IniFileName, Section, KeyName: String; DefValue: Boolean): Boolean;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadBool(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteBoolean(IniFileName, Section, KeyName: String; Value: Boolean);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteBool(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadDateTime(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadDateTime(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteDateTime(IniFileName, Section, KeyName: String; Value: TDateTime);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteDateTime(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadDate(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadDate(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteDate(IniFileName, Section, KeyName: String; Value: TDateTime);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteDate(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadTime(IniFileName, Section, KeyName: String; DefValue: TDateTime): TDateTime;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadTime(Section, KeyName, DefValue);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteTime(IniFileName, Section, KeyName: String; Value: TDateTime);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteTime(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

function IniReadBinary(IniFileName, Section, KeyName: String; Value: TStream): Integer;
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    Result  := FINI.ReadBinaryStream(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

procedure IniWriteBinary(IniFileName, Section, KeyName: String; Value: TStream);
var
  FINI  : TIniFile;
begin
  FINI  := TIniFile.Create(IniFileName);
  try
    FINI.WriteBinaryStream(Section, KeyName, Value);
  finally
    FINI.Free;
  end;
end;

end.
