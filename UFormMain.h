#ifndef UFormMainH
#define UFormMainH

#define RPM(Address, Value, Size) ReadProcessMemory(CurrentGameHandle, Address, Value, Size, 0)
#define WPM(Address, Value, Size) WriteProcessMemory(CurrentGameHandle, Address, Value, Size, 0)
#define exe

#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <ExtCtrls.hpp>
#include <ImgList.hpp>
#include <iostream.h>
#include <winioctl.h>

#include "UTranslate.cpp"
#include "UPointers.cpp"
#include "Stew.cpp"

#ifdef Deploy
#pragma resource "admin.res"
#endif

int Status, read, CurrentGamePID;

HANDLE CurrentGameHandle;

bool CanClickHacks;

const UnicodeString Title = "Hot Warcraft Tools", Version = "5.0", ForumLink = "http://hotcheats.org/", RegKey = "software\\Hot Cheats\\" + Title + "\\" + Version,

GameClassName = "Warcraft III", GameWindowName = "Warcraft III", GameExeName = "war3.exe",

Path = ExtractFilePath(ParamStr(0)),

DllPath = Path + "gbl120.bpl";
// DriverPath = Path + "drv120.bpl",
// DeviceName = "HotWarcraftTools";

typedef enum
{
	__Stop, __Delete, __Start, __Create
}_ManageDriver;

class HackStructure
{
public:
	HackStructure(int ID, int HackCaption, int HintNumber, int const* FirstPointer, int PointerCount);
	void __fastcall imgHackClick(TObject* Sender);

	TLabel* lblHack;
	TImage* imgHack;
	int HackCaption;
	int HintNumber;
	int const* FirstPointer;
	int PointerCount;
	int State;
	int ID;
	bool Type;
};

class TFormMain : public TForm
{
__published:
	TLabel* lblTitle;
	TLabel* lblStew;
	TLabel* lblForumLink;
	TTimer* tmrMain;
	TLabel* lblCredits;
	TTrayIcon* triMain;
	TGroupBox* gbxSettings;
	TCheckBox* gbxSettings_chbEnableHelp;
	TRadioGroup* rgpLanguage;
	TGroupBox* gbxLegend;
	TImage* gbxLegend_imgUnavailable;
	TLabel* gbxLegend_lblUnavailable;
	TLabel* gbxLegend_lblDisabled;
	TImage* gbxLegend_imgDisabled;
	TImage* gbxLegend_imgEnabled;
	TLabel* gbxLegend_lblEnabled;
	TImage* gbxLegend_imgCommands;
	TLabel* gbxLegend_lblCommands;
	TImageList* imlMain;
	TGroupBox* gbxHacks;
	TLabel* lblStatus;
	TCheckBox* gbxSettings_chbAutoHacks;

	void __fastcall FormClose(TObject* Sender, TCloseAction& Action);
	void __fastcall OpenForum(TObject* Sender);
	void __fastcall tmrMainTimer(TObject* Sender);
	void __fastcall FormCreate(TObject* Sender);
	void __fastcall lblCreditsClick(TObject* Sender);
	void __fastcall triMainClick(TObject* Sender);
	void __fastcall rgpLanguageClick(TObject* Sender);
	void __fastcall gbxSettings_chbEnableHelpClick(TObject* Sender);
	void __fastcall gbxSettings_chbAutoHacksClick(TObject* Sender);

private:
public:
	void SaveRegConfig();
	void ChangeLanguage(int Language);
	void __fastcall HideToTray(TObject* Sender);
	void ChangeHackState(HackStructure* Hack, int State);
	void ChangeStatus(bool aux);
	void CheckHackState();
	// void KernelBypass();
	void InjectExplorer();
	// void ManageDriver(_ManageDriver Action);
	// void WPM(Pointer Address, Pointer Value, int Size);
	void WPMBypass(Pointer Address, Pointer Value, int Size);
	bool InjectDLLBypass(int ProcessID, UnicodeString DllFullPath);
	void CreateHacks();
	__fastcall TFormMain(TComponent* Owner);
};

extern PACKAGE TFormMain* FormMain;

#endif
