unit UMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xpman, Stew, shellapi, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    lblTitle: TLabel;
    lblStew: TLabel;
    lblUF: TLabel;
    lblStatus: TLabel;
    btnActive: TButton;
    lblUpdates: TLabel;
    gbxHacks: TGroupBox;
    tmr1: TTimer;
    chbMapHack: TCheckBox;
    rgpLanguage: TRadioGroup;
    rgpVersion: TRadioGroup;
    lblHotkey: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblUFClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmr1Timer(Sender: TObject);
    procedure btnActiveClick(Sender: TObject);
    procedure SetPrivilege;
    procedure ChangeStatus(aux: bool);
    procedure PatchGarena;
    procedure rgpVersionClick(Sender: TObject);
    procedure rgpLanguageClick(Sender: TObject);
    procedure chbMapHackClick(Sender: TObject);
    procedure SaveChanges;
  end;

  {
    procedure TForm1.FormCreate(Sender: TObject);
    var
    warhandle:Integer;
    i,read1:Integer;
    nbw:cardinal;
    begin
    setprivilege;
    warhandle:=OpenProcess(2035711,false,StewPID('war3.exe'));
    for i:=0 to 59 do
    begin
    ReadProcessMemory(OpenProcess(2035711,false,StewPID('war3.exe')),ptr(pointers_122[i]),@read1,1,nbw);
    memo1.text:=memo1.text+inttostr(read1)+', ';
    end;
    end;
    }

const
  title = 'UnknowN Warcraft Tools';
  version = '2.0';
  forumlink = 'http://u-forum.org/';

  POINTERS_121b: array [0 .. 94] of Integer = ($6F40AA9F, $6F40AAA0, $6F40AAA4, $6F40AAA5, $6F2A3C23, $6F2A3C24, $6F2A3C25, $6F2A3C26, $6F2A3C27, $6F2A3C28,
    $6F074325, $6F074326, $6F074327, $6F07432B, $6F07432C, $6F07432D, $6F0735D5, $6F0735D6, $6F0735D7, $6F0735E1, $6F0735E2, $6F0735E3, $6F17EA8C, $6F17EA8D,
    $6F17EA8E, $6F17EA92, $6F17EA93, $6F17EA94, $6F563D37, $6F563D38, $6F15C524, $6F15C525, $6F325E54, $6F325E57, $6F325E67, $6F325E69, $6F149540, $6F149543,
    $6F124DFD, $6F124E00, $6F1B01DC, $6F1B01DD, $6F17D898, $6F17D899, $6F17D89A, $6F17D89B, $6F17D89C, $6F17D89D, $6F17D89E, $6F17D89F, $6F12DC3A, $6F12DC3B,
    $6F12DC7A, $6F12DC7B, $6F1C0787, $6F1C0788, $6F1C079B, $6F149208, $6F1C2C9E, $6F147C72, $6F147C73, $6F147C74, $6F147C77, $6F147C78, $6F147C79, $6F148754,
    $6F148755, $6F148756, $6F14875B, $6F14875C, $6F14875D, $6F149255, $6F149256, $6F149257, $6F149258, $6F149259, $6F14925A, $6F14925E, $6F14925F, $6F149260,
    $6F149261, $6F149262, $6F149263, $6F149267, $6F149268, $6F149269, $6F14926A, $6F14926B, $6F14926C, $6F149270, $6F149271, $6F149272, $6F149273, $6F149274,
    $6F149275);

  ACTIVATED_121b: array [0 .. 94] of Integer = (9, 144, 9, 144, 64, 51, 192, 66, 51, 210, 71, 51, 255, 65, 51, 201, 66, 51, 210, 64, 51, 192, 67, 51, 219, 66, 51,
    210, 235, 2, 235, 6, 57, 133, 57, 117, 57, 133, 57, 133, 64, 195, 144, 144, 144, 144, 184, 1, 0, 0, 144, 144, 144, 144, 144, 144, 235, 0, 235, 64, 51, 192, 65,
    51, 201, 65, 51, 201, 65, 51, 201, 186, 255, 255, 255, 255, 144, 184, 210, 255, 0, 255, 144, 185, 0, 0, 255, 255, 144, 186, 0, 170, 170, 255, 144);

  DEACTIVATED_121b: array [0 .. 94] of Integer = (73, 4, 73, 8, 139, 66, 20, 139, 82, 16, 139, 120, 16, 139, 72, 20, 139, 86, 16, 139, 70, 20, 139, 94, 16, 139,
    86, 20, 133, 192, 133, 192, 133, 132, 133, 116, 133, 132, 133, 132, 195, 144, 106, 0, 80, 86, 232, 175, 100, 18, 116, 8, 116, 8, 116, 46, 117, 1, 117, 139, 70,
    20, 139, 78, 16, 139, 72, 20, 139, 72, 16, 139, 151, 188, 7, 0, 0, 139, 135, 192, 7, 0, 0, 139, 143, 196, 7, 0, 0, 139, 151, 216, 7, 0, 0);

  POINTERS_122: array [0 .. 59] of Integer = ($6F3A04AB, $6F3A04AC, $6F36087C, $6F28464C, $6F28464D, $6F284662, $6F284663, $6F281F1C, $6F281F1D, $6F73B949,
    $6F73B94A, $6F73B94B, $6F73B94C, $6F73B94D, $6F73B94E, $6F42F836, $6F42F837, $6F42F838, $6F42F839, $6F42F83A, $6F42F83B, $6F42F83C, $6F42F83D, $6F42F83E,
    $6F42F83F, $6F42F840, $6F42F841, $6F42F842, $6F42F843, $6F42F844, $6F42F845, $6F42F846, $6F42F847, $6F42F848, $6F42F849, $6F42F84A, $6F42F84B, $6F42F84C,
    $6F42F84D, $6F42F84E, $6F42F84F, $6F398E01, $6F398E02, $6F398E03, $6F398E04, $6F398E05, $6F398E06, $6F398E07, $6F398E08, $6F360C91, $6F360C92, $6F360C93,
    $6F360C94, $6F360C95, $6F360C96, $6F360C97, $6F360C98, $6F3558FE, $6F3558FF, $6F355900);

  ACTIVATED_122: array [0 .. 59] of Integer = (144, 144, 0, 144, 144, 235, 41, 64, 195, 178, 0, 144, 144, 144, 144, 59, 192, 15, 133, 192, 0, 0, 0, 141, 139, 240,
    0, 0, 0, 232, 151, 60, 3, 0, 59, 192, 15, 133, 173, 0, 0, 144, 144, 144, 144, 144, 51, 192, 64, 59, 192, 15, 133, 48, 4, 0, 0, 144, 144, 144);

  DEACTIVATED_122: array [0 .. 59] of Integer = (35, 202, 1, 116, 42, 117, 41, 195, 204, 138, 144, 12, 232, 168, 111, 133, 192, 15, 132, 192, 0, 0, 0, 141, 139,
    240, 0, 0, 0, 232, 151, 60, 3, 0, 133, 192, 15, 132, 173, 0, 0, 85, 80, 86, 232, 247, 118, 0, 0, 133, 192, 15, 132, 48, 4, 0, 0, 102, 133, 192);

  translate: array [0 .. 9] of array [0 .. 1] of UnicodeString = (('Versão:', 'Version:'), ('Aguardando', 'Waiting'), (' encontrado', ' found'),
    ('Atualizações em ', 'Updates in '), ('Selecione algum hack primeiro', 'Select any hack first'), ('Ativar', 'Enable'), ('Desativar', 'Disable'),
    ('Status: Hacks ativados', 'Status: Enabled'), ('Status: Hacks desativados', 'Status: Disabled'), ('Tecla de atalho: Delete', 'Hotkey: Delete')
    // ('',''),
    );

var
  MainForm: TMainForm;
  hackactive, waropen: bool;
  warhandle, warpid: Integer;
  nbw: cardinal;
  status: Integer = 0;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  configs: UnicodeString;
begin
  if not Stewcreatemutex(title + version) then
    halt;
  application.title := title + ' ' + version;
  caption := title + ' ' + version;
  lblTitle.caption := title + ' ' + version;
  hackactive := false;
  warhandle := 0;
  SetPrivilege;
  configs := StewRegReadString(hkey_local_machine, 'software\UnknowN Warcraft Tools 2.0\', 'Config');
  try
    rgpLanguage.ItemIndex := strtoint(configs[1]);
    rgpVersion.ItemIndex := strtoint(configs[2]);
    chbMapHack.Checked := StrToBool(configs[3]);
  except
  end;
  StewFormPos(self, cccenter, cccenter);
end;

procedure TMainForm.ChangeStatus(aux: bool);
begin
  chbMapHack.enabled := not aux;
  hackactive := aux;
  if aux then
    lblStatus.caption := translate[7][rgpLanguage.ItemIndex]
  else
    lblStatus.caption := translate[8][rgpLanguage.ItemIndex];
end;

procedure TMainForm.SaveChanges;
begin
  StewRegWriteString(hkey_local_machine, 'software\UnknowN Warcraft Tools 2.0\', 'Config', inttostr(rgpLanguage.ItemIndex) + inttostr(rgpVersion.ItemIndex)
      + inttostr(Integer(chbMapHack.Checked)), true, true);
end;

procedure TMainForm.chbMapHackClick(Sender: TObject);
begin
  SaveChanges;
end;

procedure TMainForm.PatchGarena;
const
  GGPOINTERS: array [0 .. 2] of Integer = ($004EEF05, $004EEF06, $004EEF07);
  GGVALUES: array [0 .. 2] of Integer = (233, 147, 0);
var
  ggpid: Integer;
  gghandle: Integer;
  ggopen: bool;
  i: Integer;
begin
  ggpid := StewPID('Garena.exe');
  ggopen := (findwindow('#32770', 'Garena') <> 0) and (ggpid <> 0);
  if ggopen then
  begin
    gghandle := openprocess(2035711, false, ggpid);
    for i := 0 to 2 do
      WriteProcessMemory(gghandle, ptr(GGPOINTERS[i]), @GGVALUES[i], 1, nbw);
    closehandle(gghandle);
  end;
end;

procedure TMainForm.rgpLanguageClick(Sender: TObject);
begin
  SaveChanges;
end;

procedure TMainForm.rgpVersionClick(Sender: TObject);
begin
  warhandle := -2;
  SaveChanges;
end;

procedure TMainForm.btnActiveClick(Sender: TObject);
var
  i, wh: Integer;
begin
  PatchGarena;
  wh := openprocess(2035711, false, warpid);
  if not hackactive then
  begin
    if chbMapHack.Checked then
    begin
      ChangeStatus(true);
      status := 2;

      for i := 0 to 94 do
        if rgpVersion.ItemIndex = 0 then
          WriteProcessMemory(wh, ptr(POINTERS_121b[i]), @ACTIVATED_121b[i], 1, nbw)
        else
          WriteProcessMemory(wh, ptr(POINTERS_122[i]), @ACTIVATED_122[i], 1, nbw);
    end
    else
      showmessage(translate[4][rgpLanguage.ItemIndex]);
  end
  else
  begin
    ChangeStatus(false);
    status := 3;

    for i := 0 to 94 do
      if rgpVersion.ItemIndex = 0 then
        WriteProcessMemory(wh, ptr(POINTERS_121b[i]), @DEACTIVATED_121b[i], 1, nbw)
      else
        WriteProcessMemory(wh, ptr(POINTERS_122[i]), @DEACTIVATED_122[i], 1, nbw)
  end;
  closehandle(wh);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  lblUFClick(self);
end;

procedure TMainForm.lblUFClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', forumlink, nil, nil, 1);
end;

procedure TMainForm.SetPrivilege;
var
  tp: _token_privileges;
  htoken, aux: cardinal;
  luid: int64;
begin
  OpenProcessToken(GetCurrentProcess, 40, htoken);
  LookupPrivilegeValue('', 'SeDebugPrivilege', luid);
  tp.PrivilegeCount := 1;
  tp.Privileges[0].luid := luid;
  tp.Privileges[0].Attributes := 2;
  AdjustTokenPrivileges(htoken, false, tp, 16, nil, aux);
end;

procedure TMainForm.tmr1Timer(Sender: TObject);
var
  read1: Integer;
begin
  warpid := StewPID('war3.exe');
  waropen := (findwindow('Warcraft III', 'Warcraft III') <> 0) and (warpid <> 0);

  if warhandle = -2 then
    waropen := false;

  if not waropen then
  begin
    ChangeStatus(false);
    status := 0;
    btnActive.enabled := false;
    warhandle := 0;
  end
  else
  begin
    if warhandle <> -1 then
    begin
      warhandle := openprocess(2035711, false, warpid);
      if warhandle <> 0 then
      begin
        read1 := 0;
        if rgpVersion.ItemIndex = 0 then
        begin
          ReadProcessMemory(warhandle, ptr(POINTERS_121b[2]), @read1, 1, nbw);
          if (read1 = ACTIVATED_121b[2]) or (read1 = DEACTIVATED_121b[2]) then
          begin
            if read1 = ACTIVATED_121b[2] then
            begin
              ChangeStatus(true);
              status := 2;
            end
            else
            begin
              ChangeStatus(false);
              status := 1;
            end;
            warhandle := -1;
            btnActive.enabled := true;
          end;
        end
        else
        begin
          ReadProcessMemory(warhandle, ptr(POINTERS_122[2]), @read1, 1, nbw);
          if (read1 = ACTIVATED_122[2]) or (read1 = DEACTIVATED_122[2]) then
          begin
            if read1 = ACTIVATED_122[2] then
            begin
              ChangeStatus(true);
              status := 2;
            end
            else
            begin
              ChangeStatus(false);
              status := 1;
            end;
            warhandle := -1;
            btnActive.enabled := true;
          end;
        end;
      end;
    end
    else if Odd(getasynckeystate(46)) and btnActive.enabled then
      btnActive.Click;
  end;
  rgpVersion.caption := translate[0][rgpLanguage.ItemIndex];
  lblUpdates.caption := translate[3][rgpLanguage.ItemIndex] + forumlink;
  lblHotkey.caption := translate[9][rgpLanguage.ItemIndex];

  if not hackactive then
    btnActive.caption := translate[5][rgpLanguage.ItemIndex]
  else
    btnActive.caption := translate[6][rgpLanguage.ItemIndex];
  case status of
    0:
    lblStatus.caption := 'Status: ' + translate[1][rgpLanguage.ItemIndex] + ' Warcraft ' + rgpVersion.items.Strings[rgpVersion.ItemIndex];
    1:
    lblStatus.caption := 'Status: Warcraft ' + rgpVersion.items.Strings[rgpVersion.ItemIndex] + translate[2][rgpLanguage.ItemIndex];
    2:
    lblStatus.caption := translate[7][rgpLanguage.ItemIndex];
    3:
    lblStatus.caption := translate[8][rgpLanguage.ItemIndex];
  end;
end;

end.
