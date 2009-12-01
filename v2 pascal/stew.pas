unit Stew;

interface

{ ..:: USES ::.. }
// {$DEFINE formless}
uses
  Windows, ShellApi, Winsock
{$IFNDEF formless}
{$DEFINE sysutils}
{$DEFINE classes}
{$DEFINE forms}
{$ENDIF}
{$IFDEF forms}
  , Forms, StdCtrls, ExtCtrls, Controls, Graphics
{$DEFINE sysutils}
{$DEFINE classes}
{$ENDIF}
{$IFDEF classes}
  , Classes
{$DEFINE sysutils}
{$ENDIF}
{$IFDEF sysutils}
  , SysUtils
{$ENDIF}
  ;
{ ..:: END USES ::.. }

{ ..:: DECLARATIONS ::.. }
type
  TStewGetDir = (ccSystem32, ccWin, ccTemp, ccWindrive);
  TStewKillProcess = (ccLast, ccAll);
  TStewTools = (ccOpenCD, ccCloseCD, ccHideStartButton, ccShowStartButton, ccDisableStartButton, ccEnableStartButton, ccHideTaskBar, ccShowTaskBar,
    ccMonitorOff, ccSwapMouse, ccUnswapMouse, ccHideIcons, ccShowIcons, ccHideClock, ccShowClock, ccOpenScreensaver, ccHideTaskBarIcons, ccShowTaskBarIcons,
    ccOpenStartMenu, ccHideTray, ccShowTray);
  TStewFormPos = (ccLeft, ccCenter, ccRight);
  TStewGetMD5 = (ccFile, ccString);
  TStewWindowUtils = (ccHide, ccShow, ccMinimize, ccMaximize, ccRestore);

function StewIntToStr(cInt: Longint): string;
function StewStrToInt(cStr: string): Longint;
function StewLowerCase(S: string): string;
function StewFileExists(FileName: string): boolean;
function StewRegReadString(HKEY_: HKEY; Key, Value: UnicodeString): UnicodeString; // **//
function StewRegCreateKey(HKEY_: HKEY; Key: UnicodeString): boolean; // **//
function StewRegKeyExists(HKEY_: HKEY; Key: UnicodeString): boolean;
function StewRegDeleteKey(HKEY_: HKEY; Key: UnicodeString): boolean; // **//
function StewRegWriteString(HKEY_: HKEY; Key, Value, Text: UnicodeString; CanCreateKey, CanOverrideValue: boolean): boolean; // **//
function StewRegValueExists(HKEY_: HKEY; Key, Value: UnicodeString): boolean; // **//
function StewRegDeleteValue(HKEY_: HKEY; Key, Value: UnicodeString): boolean; // **//
function StewGetDir(Dir: TStewGetDir): string;
function StewCrypt1(StrValue: AnsiString; Key: integer): AnsiString;
function StewTrim(S: string): string;
function StewHDNum: string;
function StewIntToHex(Value: integer): string; overload;
function StewCreateMutex(Name: string): boolean; // **//
function StewGetIP: string;
function StewCrypt2(str: ansistring; Key: integer): ansistring;
function StewGetIPbyDNS(dns: string): string;
function StewGetDNSbyIP(ip: string): string;
function StewReverseStr(S: string): string;
function StewGetMD5(target: unicodestring; MD5Type: TStewGetMD5): unicodestring;
function StewSystemLanguage: string;
function StewGetResolution: string;
function StewReadClipboard: string;
function StewUserName: string;
function StewPCName: string;
function StewFileSize(Path: string): integer;
function StewPID(ProcessName: string): DWORD; // **//
function StewOSName: string;
function StewExtractFileDir(FileName: string): string;
function StewUpperCase(S: string): string;
function StewExtractFileName(Path: string): string;
function StewCheckInternet: boolean;
function StewKillProcess(ProcessName: string; Mode: TStewKillProcess): boolean;
function StewXCrypt(txt: string): string;
procedure StewWriteTxt(Path: string; Text: string; CanCreate, ReCreate: boolean);
procedure StewCreateTxt(Path: string; ReCreate: boolean);
procedure StewTools(Action: TStewTools);
procedure StewDeleteDir(Dir: string);
procedure StewShellExecute(Path: string);
procedure StewDebugPrivilege; // **//
procedure StewLoadAPI(dll, api: string; var variable: pointer);
procedure StewBeginMemoryWork(ProcessName: string; var ProcessHandle: integer); // **//
procedure StewChangeCaption(before, after: string);
procedure StewWindowUtils(WindowName: string; Action: TStewWindowUtils);
procedure StewWindowEnabled(WindowName: string; WindowEnabled: boolean);
procedure StewAlwaysOnTop(WindowName: string; AlwaysOnTop: boolean);
procedure StewChangeClipboard(Text: string);
procedure StewAddStartUp(Path: string; Description: string);
procedure StewDelStartUp(Description: string);
procedure StewDelFirewall(Path: string);
procedure StewAddFirewall(Path: string; Description: string);
procedure StewCloseApp(ClassName: string; caption: string);
procedure StewClearClipboard;
procedure StewBringToFront(WindowName: string);
{$IFDEF sysutils}
{$ENDIF}
{$IFDEF classes}
procedure StewExtractResource(Name: string; ResType: pansichar; Path: string);
function StewDissectStr(Position: integer; Separator, Line: string): string;
{$ENDIF}
{$IFDEF forms}
procedure StewMoveWorkArea(sender: tform);
procedure StewWriteLabel(lb: tlabel; Text: string; speed: integer; xrepeat: boolean);
procedure StewFormPos(Form: tform; Horizontal, Vertical: TStewFormPos); // **//
procedure StewDragMemo(memo: tcustommemo);
procedure StewAppPanel(ClassName: string; caption: string; npanel: tpanel);
procedure StewPaintBorder(Form: tform; obj: TControl; Color: TColor);
procedure StewDisableCloseButton(Form: tform);
{$ENDIF}
{ ..:: END DECLARATIONS ::.. }

{ ..:: API IMPORT ::.. }
type
  StewtagPROCESSENTRY32 = packed record
    dwSize, cntUsage, th32ProcessID, th32DefaultHeapID, th32ModuleID, cntThreads, th32ParentProcessID, dwFlags: DWORD;
    pcPriClassBase: Longint;
    szExeFile: array [0 .. MAX_PATH - 1] of Char;
  end;

var
  StewInternetGetConnectedState: function(lpdwFlags: LPDWORD; dwReserved: DWORD): BOOL stdcall;
  StewmciSendStringA: function(lpstrCommand, lpstrReturnString: PChar; uReturnLength, hWndCallback: Cardinal): Cardinal stdcall;
  StewCreateToolhelp32Snapshot: function(dwFlags: Cardinal; th32ProcessID: Cardinal): Cardinal stdcall;
  StewProcess32First: function(hSnapshot: Cardinal; var lppe: StewtagPROCESSENTRY32): LongBool stdcall;
  StewProcess32Next: function(hSnapshot: Cardinal; var lppe: StewtagPROCESSENTRY32): LongBool stdcall;
  { ..:: END API IMPORT ::.. }

  { ..:: PUBLIC VALUES ::.. }
const
  CR = #13;
  LF = #10;
  CRLF = CR + LF;
  { ..:: END PUBLIC VALUES ::.. }

implementation


  { ..:: FUNCTIONS ::.. }

function StewReverseStr(S: string): string;
var
  I: integer;
begin
  result := '';
  for I := length(S) downto 1 do
    result := result + S[I];
end;

function StewXCrypt(txt: string): string;
var
  str1, str2, str3, str4: string;
begin
  str1 := txt + txt;
  str1 := StewGetMD5(StewGetMD5(str1, ccString), ccString);
  str1 := StewReverseStr(str1);
  str2 := copy(str1, 2, 1);
  str3 := copy(str1, 7, 1);
  str4 := copy(str1, 1, 1);
  str4 := str4 + str3;
  str4 := str4 + copy(str1, 3, 4);
  str4 := str4 + str2;
  str4 := str4 + copy(str1, 8, 32 - 7);
  result := str4;
end;

function StewGetIPbyDNS(dns: string): string;
var
  wd: wsadata;
  he: phostent;
begin
  result := '';
  wsastartup(257, wd);
  try
    he := gethostbyname(pansichar(ansistring(dns)));
    result := UnicodeString(inet_ntoa(pinaddr(he.h_addr^)^));
  except
  end;
  WSACleanup;
end;

function StewGetDNSbyIP(ip: string): string;
var
  wd: wsadata;
  he: phostent;
  addr: integer;
begin
  result := '';
  wsastartup(257, wd);
  try
    addr := Inet_Addr(pansichar(ansistring(ip)));
    he := GetHostByAddr(@addr, 4, 2);
    result := UnicodeString(he.h_name);
  except
  end;
  WSACleanup;
end;

function StewCrypt2(str: ansistring; Key: integer): ansistring;
var
  I: Byte;
  z: ansistring;
  a: integer;
begin
  a := 20986 + Key;

  for I := 1 to strlen(pansichar(str)) do
    if odd(I) then
      z := z + ansiChar(Byte(str[I]) xor (a shr 2))
    else
      z := z + ansiChar(Byte(str[I]) xor (a shl 4));
  result := z;
end;

function StewReadClipboard: string;
var
  Data: THandle;
begin
  result := '';
  try
    CloseClipboard;
    OpenClipboard(0);
    Data := GetClipboardData(1);
    result := PChar(GlobalLock(Data));
    GlobalUnlock(Data);
    CloseClipboard;
  except
  end;
end;

procedure StewChangeClipboard(Text: string);
var
  Data: THandle;
  len: integer;
begin
  try
    CloseClipboard;
    OpenClipboard(0);
    len := length(Text) + 1;
    Data := GlobalAlloc(8194, len);
    Move(PChar(Text)^, GlobalLock(Data)^, len);
    EmptyClipboard;
    SetClipboardData(1, Data);
    GlobalUnlock(Data);
    GlobalFree(Data);
    CloseClipboard;
  except
  end;
end;

procedure StewTools(Action: TStewTools);
begin
  case Action of
    ccMonitorOff:
    PostMessage(FindWindow(nil, ''), 274, 61808, 1);
    ccOpenScreensaver:
    PostMessage(FindWindow(nil, ''), 274, 61760, 0);
    ccOpenStartMenu:
    PostMessage(FindWindow(nil, ''), 274, 61744, 0);
    ccOpenCD:
    StewmciSendStringA('Set cdaudio door open wait', nil, 0, 0);
    ccCloseCD:
    StewmciSendStringA('Set cdaudio door closed wait', nil, 0, 0);
    ccHideStartButton:
    ShowWindow(FindWindowEx(FindWindow('Shell_traywnd', nil), 0, 'button', nil), 0);
    ccShowStartButton:
    ShowWindow(FindWindowEx(FindWindow('Shell_traywnd', nil), 0, 'button', nil), 1);
    ccDisableStartButton:
    EnableWindow(FindWindowEx(FindWindow('Shell_traywnd', nil), 0, 'button', nil), False);
    ccEnableStartButton:
    EnableWindow(FindWindowEx(FindWindow('Shell_traywnd', nil), 0, 'button', nil), True);
    ccHideTaskBar:
    ShowWindow(FindWindow('shell_traywnd', nil), 0);
    ccShowTaskBar:
    ShowWindow(FindWindow('shell_traywnd', nil), 1);
    ccSwapMouse:
    SystemParametersInfo(33, 1, nil, 0);
    ccUnswapMouse:
    SystemParametersInfo(33, 0, nil, 0);
    ccHideIcons:
    ShowWindow(FindWindow(nil, 'Program Manager'), 0);
    ccShowIcons:
    ShowWindow(FindWindow(nil, 'Program Manager'), 1);
    ccHideClock:
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'TrayNotifyWnd', nil), 0, 'TrayClockWClass', nil), 0);
    ccShowClock:
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'TrayNotifyWnd', nil), 0, 'TrayClockWClass', nil), 1);
    ccHideTaskBarIcons:
    ShowWindow(FindWindowEx(FindWindow(PChar('Shell_traywnd'), nil), 0, 'ReBarWindow32', nil), 0);
    ccShowTaskBarIcons:
    ShowWindow(FindWindowEx(FindWindow(PChar('Shell_traywnd'), nil), 0, 'ReBarWindow32', nil), 1);
    ccHideTray:
    ShowWindow(FindWindowEx(FindWindow(PChar('Shell_traywnd'), nil), 0, 'TrayNotifyWnd', nil), 0);
    ccShowTray:
    ShowWindow(FindWindowEx(FindWindow(PChar('Shell_traywnd'), nil), 0, 'TrayNotifyWnd', nil), 1);
  end;
end;
{$IFDEF forms}

procedure StewDisableCloseButton(Form: tform);
var
  hwndHandle: Cardinal;
  hMenuHandle: HMenu;
begin
  hwndHandle := Form.Handle;
  if (hwndHandle <> 0) then
  begin
    hMenuHandle := GetSystemMenu(hwndHandle, False);
    if (hMenuHandle <> 0) then
      DeleteMenu(hMenuHandle, 61536, 0);
  end;
end;
{$ENDIF}

function StewPID(ProcessName: string): DWORD; // **//
var
  Snapshot: integer;
  Entry: StewtagPROCESSENTRY32;
begin
  result := 0;
  Snapshot := StewCreateToolhelp32Snapshot(2, 0);
  Entry.dwSize := SizeOf(Entry);
  StewProcess32First(Snapshot, Entry);
  repeat
    if (StewUpperCase(ProcessName) = StewUpperCase(Entry.szExeFile)) then
      result := Entry.th32ProcessID;
  until not StewProcess32Next(Snapshot, Entry);
end;

function StewKillProcess(ProcessName: string; Mode: TStewKillProcess): boolean;
begin
  result := False;
  case Mode of
    ccAll:
    while StewPID(ProcessName) <> 0 do
      result := TerminateProcess(OpenProcess(1, False, StewPID(ProcessName)), 0);
    ccLast:
    result := TerminateProcess(OpenProcess(1, False, StewPID(ProcessName)), 0);
  end;
end;

function StewCheckInternet: boolean;
var
  aux: integer;
begin
  aux := 7;
  result := StewInternetGetConnectedState(@aux, 0);
end;

function StewExtractFileName(Path: string): string;
var
  Ch: Char;
  I: integer;
  L: integer;
begin
  L := length(Path);
  for I := L downto 1 do
  begin
    Ch := Path[I];
    if (Ch = '\') or (Ch = '/') then
    begin
      result := copy(Path, I + 1, L - I);
      Break;
    end;
  end;
end;

function StewUpperCase(S: string): string;
var
  Ch: Char;
  L: integer;
  Source, Dest: PChar;
begin
  L := length(S);
  SetLength(result, L);
  Source := pointer(S);
  Dest := pointer(result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'a') and (Ch <= 'z') then
      Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function StewExtractFileDir(FileName: string): string;
var
  str: string;
begin
  str := '';
  while Pos('\', FileName) <> 0 do
  begin
    str := str + FileName[1];
    Delete(FileName, 1, 1);
  end;
  if str <> '' then
    if (str[length(str)] = '\') or (str[length(str)] = '/') then
      Delete(str, length(str), 1);
  result := str;
end;

function StewFileSize(Path: string): integer;
var
  f: file of Byte;
begin
  AssignFile(f, Path);
  try
    FileMode := 0;
    Reset(f);
    result := FileSize(f);
  finally
    CloseFile(f);
    FileMode := 2;
  end;
end;

function StewUserName: string;
var
  S: string;
  size: DWORD;
begin
  size := 256;
  SetLength(S, size);
  GetUserName(PChar(S), size);
  SetLength(S, size - 1);
  result := S;
end;

function StewGetResolution: string;
begin
  result := StewIntToStr(GetSystemMetrics(0)) + 'x' + StewIntToStr(GetSystemMetrics(1));
end;

function StewPCName: string;
var
  buffer: array [0 .. 16] of Char;
  length: Cardinal;
begin
  length := 16;
  GetComputerName(@buffer, length);
  result := buffer;
end;

function StewSystemLanguage: string;
var
  Lang: array [0 .. 100] of Char;
begin
  VerLanguageName(GetSystemDefaultLangID, Lang, 100);
  result := string(Lang);
end;

function StewOSName: string;
var
  osVerInfo: TOSVersionInfo;
begin
  result := 'Desconhecido';
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(osVerInfo);
  case osVerInfo.dwPlatformId of
    2:
    begin
      case osVerInfo.dwMajorVersion of
        4:
        result := 'Windows NT 4.0';
        5:
        case osVerInfo.dwMinorVersion of
          0:
          result := 'Windows 2000';
          1:
          result := 'Windows XP';
          2:
          result := 'Windows Server 2003';
        end;
        6:
        result := 'Windows Vista';
      end;
    end;
    1:
    begin
      case osVerInfo.dwMinorVersion of
        0:
        result := 'Windows 95';
        10:
        result := 'Windows 98';
        90:
        result := 'Windows ME';
      end;
    end;
  end;
  if osVerInfo.szCSDVersion <> '' then
    result := result + ' ' + osVerInfo.szCSDVersion;
end;
{$IFDEF forms}

procedure StewPaintBorder(Form: tform; obj: TControl; Color: TColor);
begin
  Form.Canvas.Pen.Color := Color;
  Form.Canvas.RoundRect(obj.Left - 2, obj.Top - 1, obj.Left + obj.Width + 2, obj.Top + obj.Height + 1, 5, 5);
end;
{$ENDIF}
{$IFDEF forms}

procedure StewAppPanel(ClassName: string; caption: string; npanel: tpanel);
begin
  if (ClassName <> '') and (caption <> '') then
    SetParent(FindWindow(PChar(ClassName), PChar(caption)), npanel.Handle);

  if (ClassName = '') then
    SetParent(FindWindow(nil, PChar(caption)), npanel.Handle);

  if (caption = '') then
    SetParent(FindWindow(PChar(ClassName), nil), npanel.Handle);
end;
{$ENDIF}

function StewCreateMutex(Name: string): boolean; // **//
begin
  result := False;
  if CreateMutex(nil, True, PChar(Name)) <> 0 then
    result := GetLastError <> 183;
end;

procedure StewCloseApp(ClassName: string; caption: string);
begin
  if (ClassName <> '') and (caption <> '') then
    PostMessage(FindWindow(PChar(ClassName), PChar(caption)), 16, 0, 0);

  if (ClassName = '') then
    PostMessage(FindWindow(nil, PChar(caption)), 16, 0, 0);

  if (caption = '') then
    PostMessage(FindWindow(PChar(ClassName), nil), 16, 0, 0);
end;

function StewTrim(S: string): string;
var
  I, L: integer;
begin
  L := length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do
    Inc(I);
  if I > L then
    result := ''
  else
  begin
    while S[L] <= ' ' do
      Dec(L);
    result := copy(S, I, L - I + 1);
  end;
end;

function StewRegDeleteValue(HKEY_: HKEY; Key, Value: UnicodeString): boolean; // **//
var
  reg: HKEY;
begin
  RegOpenKey(HKEY_, PChar(Key), reg);
  result := RegDeletevalue(reg, PChar(Value)) = 0;
  RegCloseKey(reg);
end;


{$IFDEF forms}

procedure StewDragMemo(memo: tcustommemo);
begin
  SendMessage(memo.Handle, 277, 7, 0);
end;
{$ENDIF}
{$IFDEF forms}

procedure StewFormPos(Form: tform; Horizontal, Vertical: TStewFormPos); // **//
var
  R: TRect;
begin
  if not SystemParametersInfo(48, 0, @R, 0) then
    R := Rect(0, 0, Screen.Width, Screen.Height);
  case Horizontal of
    ccLeft:
    Form.Left := 0;
    ccCenter:
    Form.Left := (R.Right - R.Left - Form.Width) div 2;
    ccRight:
    Form.Left := R.Right - Form.Width;
  end;
  case Vertical of
    ccLeft:
    Form.Top := 0;
    ccCenter:
    Form.Top := (R.Bottom - R.Top - Form.Height) div 2;
    ccRight:
    Form.Top := R.Bottom - Form.Height;
  end;
end;
{$ENDIF}

function StewCrypt1(StrValue: AnsiString; Key: integer): AnsiString;
var
  I: integer;
  OutValue: AnsiString;
begin
  OutValue := '';
  for I := 1 to StrLen(PAnsiChar(StrValue)) do
    OutValue := OutValue + AnsiChar(not(ord(StrValue[I]) - Key));
  result := OutValue;
end;

function StewIntToHex(Value: integer): string;
const
  x: array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  a: int64;
  aux: integer;
  c, d: string;
begin
  a := Value;
  if Value < 0 then
    a := a + $FFFFFFFF + 1;
  while True do
  begin
    c := c + x[a mod 16];
    a := a div 16;
    if a = 0 then
    begin
      for aux := length(c) downto 1 do
        d := d + c[aux];
      Break;
    end;
  end;
  result := d;
end;

function StewHDNum: string;
var
  Serial: DWORD;
  DirLen, Flags: DWORD;
  DLabel: array [0 .. 11] of Char;
begin
  result := '';
  GetVolumeInformation(PChar(StewGetDir(ccWindrive)), DLabel, 12, @Serial, DirLen, Flags, nil, 0);
  result := StewIntToHex(Serial);
end;

function StewGetMD5(target: UnicodeString; MD5Type: TStewGetMD5): UnicodeString;
// +++++++ //
type
  MD5Count = array [0 .. 1] of DWORD;
  MD5State = array [0 .. 3] of DWORD;
  MD5Block = array [0 .. 15] of DWORD;
  MD5CBits = array [0 .. 7] of Byte;
  MD5Digest = array [0 .. 15] of Byte;
  MD5Buffer = array [0 .. 63] of Byte;

  MD5Context = record
    State: MD5State;
    Count: MD5Count;
    buffer: MD5Buffer;
  end;

  procedure MD5Init(var Context: MD5Context);
  begin
    with Context do
    begin
      State[0] := $67452301;
      State[1] := $EFCDAB89;
      State[2] := $98BADCFE;
      State[3] := $10325476;
      Count[0] := 0;
      Count[1] := 0;
      ZeroMemory(@buffer, SizeOf(MD5Buffer));
    end;
  end;

  procedure Encode(Source, target: pointer; Count: LongWord);
  var
    S: PByte;
    T: PDWORD;
    I: LongWord;
  begin
    S := Source;
    T := target;
    for I := 1 to Count div 4 do
    begin
      T^ := S^;
      Inc(S);
      T^ := T^ or (S^ shl 8);
      Inc(S);
      T^ := T^ or (S^ shl 16);
      Inc(S);
      T^ := T^ or (S^ shl 24);
      Inc(S);
      Inc(T);
    end;
  end;

  procedure rot(var x: DWORD; n: Byte);
  begin
    x := (x shl n) or (x shr (32 - n));
  end;

  function f(x, y, z: DWORD): DWORD;
  begin
    result := (x and y) or ((not x) and z);
  end;

  function G(x, y, z: DWORD): DWORD;
  begin
    result := (x and z) or (y and (not z));
  end;

  function H(x, y, z: DWORD): DWORD;
  begin
    result := x xor y xor z;
  end;

  function I(x, y, z: DWORD): DWORD;
  begin
    result := y xor (x or (not z));
  end;

  procedure FF(var a: DWORD; b, c, d, x: DWORD; S: Byte; ac: DWORD);
  begin
    Inc(a, f(b, c, d) + x + ac);
    rot(a, S);
    Inc(a, b);
  end;

  procedure GG(var a: DWORD; b, c, d, x: DWORD; S: Byte; ac: DWORD);
  begin
    Inc(a, G(b, c, d) + x + ac);
    rot(a, S);
    Inc(a, b);
  end;

  procedure HH(var a: DWORD; b, c, d, x: DWORD; S: Byte; ac: DWORD);
  begin
    Inc(a, H(b, c, d) + x + ac);
    rot(a, S);
    Inc(a, b);
  end;

  procedure II(var a: DWORD; b, c, d, x: DWORD; S: Byte; ac: DWORD);
  begin
    Inc(a, I(b, c, d) + x + ac);
    rot(a, S);
    Inc(a, b);
  end;

  procedure Transform(buffer: pointer; var State: MD5State);
  var
    a, b, c, d: DWORD;
    Block: MD5Block;
  begin
    Encode(buffer, @Block, 64);
    a := State[0];
    b := State[1];
    c := State[2];
    d := State[3];
    FF(a, b, c, d, Block[0], 7, $D76AA478);
    FF(d, a, b, c, Block[1], 12, $E8C7B756);
    FF(c, d, a, b, Block[2], 17, $242070DB);
    FF(b, c, d, a, Block[3], 22, $C1BDCEEE);
    FF(a, b, c, d, Block[4], 7, $F57C0FAF);
    FF(d, a, b, c, Block[5], 12, $4787C62A);
    FF(c, d, a, b, Block[6], 17, $A8304613);
    FF(b, c, d, a, Block[7], 22, $FD469501);
    FF(a, b, c, d, Block[8], 7, $698098D8);
    FF(d, a, b, c, Block[9], 12, $8B44F7AF);
    FF(c, d, a, b, Block[10], 17, $FFFF5BB1);
    FF(b, c, d, a, Block[11], 22, $895CD7BE);
    FF(a, b, c, d, Block[12], 7, $6B901122);
    FF(d, a, b, c, Block[13], 12, $FD987193);
    FF(c, d, a, b, Block[14], 17, $A679438E);
    FF(b, c, d, a, Block[15], 22, $49B40821);
    GG(a, b, c, d, Block[1], 5, $F61E2562);
    GG(d, a, b, c, Block[6], 9, $C040B340);
    GG(c, d, a, b, Block[11], 14, $265E5A51);
    GG(b, c, d, a, Block[0], 20, $E9B6C7AA);
    GG(a, b, c, d, Block[5], 5, $D62F105D);
    GG(d, a, b, c, Block[10], 9, $2441453);
    GG(c, d, a, b, Block[15], 14, $D8A1E681);
    GG(b, c, d, a, Block[4], 20, $E7D3FBC8);
    GG(a, b, c, d, Block[9], 5, $21E1CDE6);
    GG(d, a, b, c, Block[14], 9, $C33707D6);
    GG(c, d, a, b, Block[3], 14, $F4D50D87);
    GG(b, c, d, a, Block[8], 20, $455A14ED);
    GG(a, b, c, d, Block[13], 5, $A9E3E905);
    GG(d, a, b, c, Block[2], 9, $FCEFA3F8);
    GG(c, d, a, b, Block[7], 14, $676F02D9);
    GG(b, c, d, a, Block[12], 20, $8D2A4C8A);
    HH(a, b, c, d, Block[5], 4, $FFFA3942);
    HH(d, a, b, c, Block[8], 11, $8771F681);
    HH(c, d, a, b, Block[11], 16, $6D9D6122);
    HH(b, c, d, a, Block[14], 23, $FDE5380C);
    HH(a, b, c, d, Block[1], 4, $A4BEEA44);
    HH(d, a, b, c, Block[4], 11, $4BDECFA9);
    HH(c, d, a, b, Block[7], 16, $F6BB4B60);
    HH(b, c, d, a, Block[10], 23, $BEBFBC70);
    HH(a, b, c, d, Block[13], 4, $289B7EC6);
    HH(d, a, b, c, Block[0], 11, $EAA127FA);
    HH(c, d, a, b, Block[3], 16, $D4EF3085);
    HH(b, c, d, a, Block[6], 23, $4881D05);
    HH(a, b, c, d, Block[9], 4, $D9D4D039);
    HH(d, a, b, c, Block[12], 11, $E6DB99E5);
    HH(c, d, a, b, Block[15], 16, $1FA27CF8);
    HH(b, c, d, a, Block[2], 23, $C4AC5665);
    II(a, b, c, d, Block[0], 6, $F4292244);
    II(d, a, b, c, Block[7], 10, $432AFF97);
    II(c, d, a, b, Block[14], 15, $AB9423A7);
    II(b, c, d, a, Block[5], 21, $FC93A039);
    II(a, b, c, d, Block[12], 6, $655B59C3);
    II(d, a, b, c, Block[3], 10, $8F0CCC92);
    II(c, d, a, b, Block[10], 15, $FFEFF47D);
    II(b, c, d, a, Block[1], 21, $85845DD1);
    II(a, b, c, d, Block[8], 6, $6FA87E4F);
    II(d, a, b, c, Block[15], 10, $FE2CE6E0);
    II(c, d, a, b, Block[6], 15, $A3014314);
    II(b, c, d, a, Block[13], 21, $4E0811A1);
    II(a, b, c, d, Block[4], 6, $F7537E82);
    II(d, a, b, c, Block[11], 10, $BD3AF235);
    II(c, d, a, b, Block[2], 15, $2AD7D2BB);
    II(b, c, d, a, Block[9], 21, $EB86D391);
    Inc(State[0], a);
    Inc(State[1], b);
    Inc(State[2], c);
    Inc(State[3], d);
  end;

  procedure MD5Update(var Context: MD5Context; Input: pansichar; length: LongWord);
  var
    Index, PartLen, I: LongWord;
  begin
    with Context do
    begin
      Index := (Count[0] shr 3) and 63;
      Inc(Count[0], length shl 3);
      if Count[0] < (length shl 3) then
      begin
        Inc(Count[1]);
      end;
      Inc(Count[1], length shr 29);
    end;
    PartLen := 64 - Index;
    if length >= PartLen then
    begin
      CopyMemory(@Context.buffer[Index], Input, PartLen);
      Transform(@Context.buffer, Context.State);
      I := PartLen;
      while I + 63 < length do
      begin
        Transform(@Input[I], Context.State);
        Inc(I, 64);
      end;
      Index := 0;
    end
    else
    begin
      I := 0;
    end;
    CopyMemory(@Context.buffer[Index], @Input[I], length - I);
  end;

  procedure Decode(Source, target: pointer; Count: LongWord);
  var
    S: PDWORD;
    T: PByte;
    I: LongWord;
  begin
    S := Source;
    T := target;
    for I := 1 to Count do
    begin
      T^ := S^ and $FF;
      Inc(T);
      T^ := (S^ shr 8) and $FF;
      Inc(T);
      T^ := (S^ shr 16) and $FF;
      Inc(T);
      T^ := (S^ shr 24) and $FF;
      Inc(T);
      Inc(S);
    end;
  end;

  procedure MD5Final(var Context: MD5Context; var Digest: MD5Digest);
  var
    Bits: MD5CBits;
    Index, PadLen: LongWord;
  const
    PADDING: MD5Buffer = (128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  begin
    Decode(@Context.Count, @Bits, 2);
    Index := (Context.Count[0] shr 3) and 63;
    if Index < 56 then
    begin
      PadLen := 56 - Index;
    end
    else
    begin
      PadLen := 120 - Index;
    end;
    MD5Update(Context, @PADDING, PadLen);
    MD5Update(Context, @Bits, 8);
    Decode(@Context.State, @Digest, 4);
    ZeroMemory(@Context, SizeOf(MD5Context));
  end;

  function MD5Print(d: MD5Digest): UnicodeString;
  var
    I: Byte;
  const
    Digits: array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
  begin
    result := '';
    for I := 0 to 15 do
    begin
      result := result + Digits[(d[I] shr 4) and $0F] + Digits[d[I] and $0F];
    end;
  end;

// +++++++ //
var
  Context: MD5Context;
  FileHandle, MapHandle: THandle;
  ViewPointer: pointer;
  Last: MD5Digest;
begin
  result := '';
  try
    MD5Init(Context);
    case MD5Type of
      ccFile:
      begin
        FileHandle := CreateFileW(PWideChar(target), GENERIC_READ, 1 or 2, nil, 3, 128 or 134217728, 0);
        if FileHandle <> INVALID_HANDLE_VALUE then
          try
            MapHandle := CreateFileMappingW(FileHandle, nil, 2, 0, 0, nil);
            if MapHandle <> 0 then
              try
                ViewPointer := MapViewOfFile(MapHandle, 4, 0, 0, 0);
                if ViewPointer <> nil then
                  try
                    MD5Update(Context, ViewPointer, GetFileSize(FileHandle, nil));
                  finally
                    UnmapViewOfFile(ViewPointer);
                  end;
              finally
                CloseHandle(MapHandle);
              end;
          finally
            CloseHandle(FileHandle);
          end;
      end;
      ccString:
      begin
        MD5Update(Context, pansichar(ansistring(target)), length(target));
      end;
    end;
    MD5Final(Context, Last);
    result := MD5Print(Last);
  except
  end;
end;

function StewGetIP: string;
type
  TaPInAddr = array [0 .. 10] of pinaddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: phostent;
  pptr: PaPInAddr;
  buffer: array [0 .. 63] of wideChar;
  I: integer;
  GInitData: TWSADATA;
begin
  I := 0;
  result := '';
  try
    try
      wsastartup(257, GInitData);
      GetHostName(pansichar(ansistring(buffer)), SizeOf(buffer));
      phe := gethostbyname(pansichar(ansistring(buffer)));
      if phe = nil then
        Exit;
      pptr := PaPInAddr(phe^.h_addr_list);
      while pptr^[I] <> nil do
      begin
        result := string(inet_ntoa(pptr^[I]^));
        Inc(I);
      end;
    finally
      WSACleanup;
    end;
  except
  end;
end;
{$IFDEF classes}

function StewDissectStr(Position: integer; Separator, Line: string): string;
var
  sAux: TStringList;
begin
  result := '';
  sAux := TStringList.Create;
  sAux.Text := StringReplace(Line, Separator, #13#10, [rfReplaceAll, rfIgnoreCase]);
  if Position <= sAux.Count then
    result := sAux.Strings[Position - 1];
  sAux.Free;
end;
{$ENDIF}

function StewGetDir(Dir: TStewGetDir): string;
var
  Path: array [0 .. MAX_PATH - 1] of Char;
begin
  Path := '';
  case Dir of
    ccSystem32:
    GetSystemDirectory(Path, length(Path));
    ccWin:
    GetWindowsDirectory(Path, length(Path));
    ccTemp:
    GetTempPath(length(Path), Path);
  end;
  if Dir = ccWindrive then
    result := copy(StewGetDir(ccWin), 1, 3)
  else
    result := string(Path);
end;
{$IFDEF forms}

// ++++++++++++++++++++++++++++++++++++++++
var
  StewWriteLabelThread, xrepeat2: boolean;
  lb2: tlabel;
  text2: string;
  speed2: integer;

  // ++++++++++++++++++
procedure StewWriteLabel2;
var
  a: integer;
begin
  StewWriteLabelThread := True;
  lb2.caption := '';
  for a := 1 to length(text2) do
  begin
    lb2.caption := lb2.caption + text2[a];
    sleep(speed2);
  end;
  StewWriteLabelThread := False;
  if xrepeat2 then
    StewWriteLabel(lb2, text2, speed2, True);
end;

// ++++++++++++++++++++++++++++++++++++++++
procedure StewWriteLabel(lb: tlabel; Text: string; speed: integer; xrepeat: boolean);
var
  ID: Cardinal;
begin
  try
    lb2 := lb;
    text2 := Text;
    speed2 := speed;
    xrepeat2 := xrepeat;
    if not StewWriteLabelThread then
      BeginThread(nil, 0, @StewWriteLabel2, nil, 0, ID);
  except
  end;
end;
{$ENDIF}
{$IFDEF forms}

procedure StewMoveWorkArea(sender: tform);
var
  WorkArea: TRect;
begin
  if SystemParametersInfo(48, 0, @WorkArea, 0) then
  begin
    if sender.Left < WorkArea.Left then
      sender.Left := WorkArea.Left
    else if sender.Left + sender.Width > WorkArea.Right then
      sender.Left := WorkArea.Right - sender.Width;
    if sender.Top < WorkArea.Top then
      sender.Top := WorkArea.Top
    else if sender.Top + sender.Height > WorkArea.Bottom then
      sender.Top := WorkArea.Bottom - sender.Height;
  end;
end;
{$ENDIF}
{$IFDEF classes}

procedure StewExtractResource(Name: string; ResType: pansichar; Path: string);
begin
  with TResourceStream.Create(HInstance, Name, PWideChar(ResType)) do
    try
      SaveToFile(Path);
    finally
      Free;
    end;
end;
{$ENDIF}

procedure StewCreateTxt(Path: string; ReCreate: boolean);
var
  TF: TextFile;
  Attributes: integer;
begin
  Attributes := GetFileAttributesW(PWideChar(Path));
  SetFileAttributesW(PWideChar(Path), 0);
  CreateDir(ExtractFileDir(Path));
  try
    AssignFile(TF, Path);
    if ((not ReCreate) and (not FileExists(Path))) or ReCreate then
    begin
      Rewrite(TF, Path);
    end;
  finally
    Append(TF);
    CloseFile(TF);
    if Attributes > 0 then
    begin
      SetFileAttributesW(PWideChar(Path), Attributes);
    end;
  end;
end;

procedure StewWriteTxt(Path: string; Text: string; CanCreate, ReCreate: boolean);
var
  TF: TextFile;
  Attributes: integer;
begin
  StewCreateTxt(Path, ReCreate);
  Attributes := GetFileAttributesW(PWideChar(Path));
  SetFileAttributesW(PWideChar(Path), 0);
  if FileExists(Path) then
  begin
    try
      AssignFile(TF, Path);
      Append(TF);
      if Text <> '' then
      begin
        Write(TF, Text);
      end;
    finally
      CloseFile(TF);
      if Attributes > 0 then
      begin
        SetFileAttributesW(PWideChar(Path), Attributes);
      end;
    end;
  end;
end;

function StewRegValueExists(HKEY_: HKEY; Key, Value: UnicodeString): boolean; // **//
var
  reg: HKEY;
begin
  result := False;
  if RegOpenKeyW(HKEY_, PWideChar(Key), reg) = 0 then
  begin
    result := RegQueryValueExW(reg, PWideChar(Value), nil, nil, nil, nil) = 0;
    RegCloseKey(reg);
  end;
end;

function StewRegWriteString(HKEY_: HKEY; Key, Value, Text: UnicodeString; CanCreateKey, CanOverrideValue: boolean): boolean; // **//
var
  reg: HKEY;
begin
  result := False;
  if CanCreateKey then
  begin
    StewRegCreateKey(HKEY_, Key);
  end;
  if RegOpenKeyW(HKEY_, PWideChar(Key), reg) = 0 then
  begin
    if CanOverrideValue or (not CanOverrideValue and not StewRegValueExists(HKEY_, Key, Value)) then
    begin
      result := RegSetValueExW(reg, PWideChar(Value), 0, REG_SZ, PWideChar(Text), length(Text) * 2) = 0;
    end;
    RegCloseKey(reg);
  end;
end;

function StewRegDeleteKey(HKEY_: HKEY; Key: UnicodeString): boolean; // **//
begin
  result := RegDeleteKey(HKEY_, PChar(Key)) = 0;
end;

function StewRegKeyExists(HKEY_: HKEY; Key: UnicodeString): boolean;
var
  reg: HKEY;
begin
  result := RegOpenKey(HKEY_, PChar(Key), reg) = 0;
  RegCloseKey(reg);
end;

function StewRegCreateKey(HKEY_: HKEY; Key: UnicodeString): boolean; // **//
var
  reg: HKEY;
begin
  result := RegCreateKey(HKEY_, PChar(Key), reg) = 0;
  RegCloseKey(reg);
end;

function StewRegReadString(HKEY_: HKEY; Key, Value: UnicodeString): UnicodeString; // **//
var
  reg: HKEY;
  lpData: pointer;
  lpcbData: DWORD;
  sResult: string;
  lptype: DWORD;
begin
  result := '';
  RegOpenKey(HKEY_, PChar(Key), reg);
  lptype := 1;
  if RegQueryValueEx(reg, PChar(Value), nil, @lptype, nil, @lpcbData) = 0 then
  begin
    GetMem(lpData, lpcbData);
    if RegQueryValueEx(reg, PChar(Value), nil, @lptype, lpData, @lpcbData) = 0 then
    begin
      Dec(lpcbData);
      SetLength(sResult, lpcbData);
      CopyMemory(@sResult[1], lpData, lpcbData);
      result := sResult;
    end;
    FreeMem(lpData, lpcbData);
  end;
  RegCloseKey(reg);
end;

function StewFileExists(FileName: string): boolean;
var
  cHandle: THandle;
  FindData: TWin32FindData;
begin
  cHandle := FindFirstFileW(PWideChar(FileName), FindData);
  result := cHandle > 0;
  if result then
    Windows.FindClose(cHandle);
end;

function StewStrToInt(cStr: string): Longint;
var
  Code: integer;
begin
  Val(cStr, result, Code);
end;

function StewIntToStr(cInt: Longint): string;
var
  aux: ansistring;
begin
  str(cInt, aux);
  result := UnicodeString(aux);
end;

function StewLowerCase(S: string): string;
var
  Ch: Char;
  L: integer;
  Source, Dest: PChar;
begin
  L := length(S);
  SetLength(result, L);
  Source := pointer(S);
  Dest := pointer(result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then
      Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

procedure StewLoadAPI(dll, api: string; var variable: pointer);
var
  aux: integer;
begin
  aux := LoadLibrary(PChar(dll));
  variable := getprocaddress(aux, PChar(api));
  FreeLibrary(aux);
end;

procedure StewShellExecute(Path: string);
begin
  ShellExecute(0, 'open', PChar(Path), nil, nil, 1);
end;

procedure StewDebugPrivilege; // **//
var
  tp: _token_privileges;
  htoken, aux: Cardinal;
  luid: int64;
begin
  OpenProcessToken(GetCurrentProcess, 40, htoken);
  LookupPrivilegeValue('', 'SeDebugPrivilege', luid);
  tp.PrivilegeCount := 1;
  tp.Privileges[0].luid := luid;
  tp.Privileges[0].Attributes := 2;
  AdjustTokenPrivileges(htoken, False, tp, 16, nil, aux);
end;

procedure StewBeginMemoryWork(ProcessName: string; var ProcessHandle: integer); // **//
begin
  StewDebugPrivilege;
  ProcessHandle := OpenProcess(2035711, False, StewPID(ProcessName));
end;

procedure StewChangeCaption(before, after: string);
begin
  SetWindowText(FindWindow(nil, PChar(before)), PChar(after));
end;

procedure StewWindowUtils(WindowName: string; Action: TStewWindowUtils);
begin
  ShowWindowAsync(FindWindow(nil, PChar(WindowName)), integer(Action));
end;

procedure StewWindowEnabled(WindowName: string; WindowEnabled: boolean);
begin
  EnableWindow(FindWindow(nil, PChar(WindowName)), WindowEnabled);
end;

procedure StewClearClipboard;
begin
  CloseClipboard;
  OpenClipboard(0);
  EmptyClipboard;
  CloseClipboard;
end;

procedure StewAlwaysOnTop(WindowName: string; AlwaysOnTop: boolean);
var
  aux: integer;
begin
  aux := -2;
  if AlwaysOnTop then
    aux := -1;
  SetWindowPos(FindWindow(nil, PChar(WindowName)), aux, 0, 0, 0, 0, 2 or 1);
end;

procedure StewBringToFront(WindowName: string);
begin
  SetForegroundWindow(FindWindow(nil, PChar(WindowName)));
end;

procedure StewDeleteDir(Dir: string);
var
  Operaction: TSHFileOpStruct;
  FromBuffer, ToBuffer: array [0 .. 128] of Char;
begin
  fillChar(Operaction, SizeOf(Operaction), 0);
  fillChar(FromBuffer, SizeOf(FromBuffer), 0);
  fillChar(ToBuffer, SizeOf(ToBuffer), 0);
  StrLCopy(FromBuffer, PChar(Dir), length(Dir));
  with Operaction do
  begin
    Wnd := 0;
    wFunc := 3;
    pFrom := @FromBuffer;
    pTo := @ToBuffer;
    fFlags := 20;
    fAnyOperationsAborted := False;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;
  ShFileOperation(Operaction);
end;

{ ..:: END FUNCTIONS ::.. }

{ ..:: INITIALIZATION ::.. }
initialization

StewLoadAPI('wininet.dll', 'InternetGetConnectedState', @StewInternetGetConnectedState);
StewLoadAPI('winmm.dll', 'mciSendStringA', @StewmciSendStringA);
StewLoadAPI('kernel32.dll', 'CreateToolhelp32Snapshot', @StewCreateToolhelp32Snapshot);
StewLoadAPI('kernel32.dll', 'Process32First', @StewProcess32First);
StewLoadAPI('kernel32.dll', 'Process32Next', @StewProcess32Next);

{ ..:: END INITIALIZATION ::.. }
end.
