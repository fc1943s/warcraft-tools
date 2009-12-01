#include <vcl.h>
#pragma hdrstop

#include "UFormMain.h"

#pragma package(smart_init)
#pragma resource "*.dfm"

TFormMain* FormMain;
vector<HackStructure*>HackGroup;

__fastcall TFormMain::TFormMain(TComponent* Owner) : TForm(Owner)
{
}

void __fastcall TFormMain::FormCreate(TObject* Sender)
{
	if (!Stew::_CreateMutex(Title + Version))
	{
		Application->Terminate();
	}
	Application->Title = Title + L" " + Version;
	Caption = Title + L" " + Version;
	lblTitle->Caption = Title + L" " + Version;
	lblForumLink->Caption = ForumLink;

	CreateHacks();
	try
	{
		UnicodeString RegConfigs = Stew::_RegReadString(HKEY_LOCAL_MACHINE, RegKey, L"Config");
		ChangeLanguage(StrToInt(RegConfigs[1]));
		gbxSettings_chbEnableHelp->Checked = StrToBool(RegConfigs[2]);
		gbxSettings_chbAutoHacks->Checked = StrToBool(RegConfigs[3]);
	}
	catch(...)
	{
		ChangeLanguage(0);
	}

	Height = lblCredits->Top + 55;

	Application->HintPause = 0;
	Application->HintHidePause = 30000;
	ShowHint = gbxSettings_chbEnableHelp->Checked;

	triMain->Icon = Application->Icon;
	triMain->Hint = Caption;
	Application->OnMinimize = HideToTray;

	imlMain->GetBitmap(0, gbxLegend_imgUnavailable->Picture->Bitmap);
	imlMain->GetBitmap(1, gbxLegend_imgDisabled->Picture->Bitmap);
	imlMain->GetBitmap(2, gbxLegend_imgEnabled->Picture->Bitmap);
	imlMain->GetBitmap(3, gbxLegend_imgCommands->Picture->Bitmap);

	Stew::_FormPosition(this, __Center, __Center);
	/*
	ManageDriver(__Delete);
	ManageDriver(__Create);
	ManageDriver(__Start);
	 */
}

void TFormMain::SaveRegConfig()
{
	Stew::_RegWriteString(HKEY_LOCAL_MACHINE, RegKey, L"Config", IntToStr(rgpLanguage->ItemIndex) + IntToStr((int)gbxSettings_chbEnableHelp->Checked) + IntToStr
		((int)gbxSettings_chbAutoHacks->Checked), true, true);
}

void TFormMain::ChangeLanguage(int Language)
{
	rgpLanguage->ItemIndex = Language;

	TLabel* aux;

	for (UINT i = 0; i < (sizeof(Translate) / 3) / 4; i++)
	{
		if (Translate[i][2].Length() > 0)
		{
			aux = (TLabel*)FindComponent(Translate[i][2]);
			aux->Caption = Translate[i][Language];
		}
	}

	for (UINT i = 0; i < (sizeof(TranslateHint) / 3) / 4; i++)
	{
		if (TranslateHint[i][2].Length() > 0)
		{
			aux = (TLabel*)FindComponent(TranslateHint[i][2]);
			aux->Hint = TranslateHint[i][Language];
		}
	}

	for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
	{
		if ((*i)->HackCaption > 0)
		{
			(*i)->lblHack->Caption = Translate[(*i)->HackCaption][Language];
		}
		(*i)->imgHack->Hint = TranslateHint[(*i)->HintNumber][Language];
	}

	SaveRegConfig();
}

HackStructure::HackStructure(int ID, int HackCaption, int HintNumber, int const* FirstPointer, int PointerCount) : ID(ID), HackCaption(HackCaption), FirstPointer
	(FirstPointer), PointerCount(PointerCount), HintNumber(HintNumber), State(0), Type(PointerCount == 0)
{
	lblHack = new TLabel(FormMain->gbxHacks);
	imgHack = new TImage(FormMain->gbxHacks);

	lblHack->Parent = FormMain->gbxHacks;
	imgHack->Parent = FormMain->gbxHacks;

	lblHack->Left = Stew::_Odd(HackGroup.size() + 1) ? 41 : 154;
	imgHack->Left = Stew::_Odd(HackGroup.size() + 1) ? 18 : 131;

	lblHack->Top = 21 + (23 * ((HackGroup.size()) / 2));
	imgHack->Top = 21 + (23 * ((HackGroup.size()) / 2));

	lblHack->Caption = Translate[HackCaption][FormMain->rgpLanguage->ItemIndex];

	FormMain->imlMain->GetBitmap(0, imgHack->Picture->Bitmap);

	imgHack->Width = 17;
	imgHack->Height = 17;
	if (!Type)
	{
		imgHack->OnClick = imgHackClick;
	}

	FormMain->gbxHacks->Height += (Stew::_Odd(HackGroup.size() + 1) ? 23 : 0);
	FormMain->Height += (Stew::_Odd(HackGroup.size() + 1) ? 23 : 0);
	FormMain->lblCredits->Top += (Stew::_Odd(HackGroup.size() + 1) ? 23 : 0);
	FormMain->lblStatus->Top += (Stew::_Odd(HackGroup.size() + 1) ? 23 : 0);
}

void TFormMain::CreateHacks()
{
	HackGroup.push_back(new HackStructure(2, 10, 3, PMapHack, (sizeof(PMapHack) / 4) / 3));
	HackGroup.push_back(new HackStructure(4, 15, 7, PTradeAmount, (sizeof(PTradeAmount) / 4) / 3));
	HackGroup.push_back(new HackStructure(6, 16, 8, PSkills, (sizeof(PSkills) / 4) / 3));
	HackGroup.push_back(new HackStructure(8, 19, 9, POpacity, (sizeof(POpacity) / 4) / 3));
	HackGroup.push_back(new HackStructure(0, 18, 5, PCommands, (sizeof(PCommands) / 4) / 3));
	// HackGroup.push_back(new HackStructure(20,10, NULL, 0));
	HackGroup.push_back(new HackStructure(0, 17, 4, NULL, 0));
}

void TFormMain::ChangeHackState(HackStructure* Hack, int State)
{
	if (Hack->State == State)
	{
		return;
	}
	Hack->State = State;
	imlMain->GetBitmap(State, Hack->imgHack->Picture->Bitmap);
	Hack->imgHack->Refresh();
}

void TFormMain::ChangeStatus(bool aux)
{
	if (!aux)
	{
		for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
		{
			ChangeHackState(*i, 0);
		}
		lblStatus->Caption = L"Status: " + Translate[11][rgpLanguage->ItemIndex] + L" Warcraft III 1.23";
		CloseHandle(CurrentGameHandle);
		CurrentGameHandle = NULL;
		CurrentGamePID = 0;
	}
	else
	{
		lblStatus->Caption = L"Status: Warcraft III 1.23 " + Translate[12][rgpLanguage->ItemIndex];
	}
	CanClickHacks = aux;
}

void __fastcall TFormMain::FormClose(TObject* Sender, TCloseAction& Action)
{
	// ManageDriver(__Delete);
#ifdef Deploy
	OpenForum(lblForumLink);
#endif
}

void __fastcall TFormMain::OpenForum(TObject* Sender)
{
	ShellExecuteW(Handle, L"open", ForumLink.c_str(), NULL, NULL, 6);
}

void TFormMain::CheckHackState()
{
	int DLL = 0;
	for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
	{
		if (!(*i)->Type)
		{
			read = 0;
			RPM(Pointer(*((PINT)(*i)->FirstPointer)), &read, 1);
			if (*(*i)->FirstPointer == PCommands[0])
			{
				TStringList* aux2 = new TStringList;
				Stew::_GetProcessModules(CurrentGamePID, aux2);
				if (aux2->IndexOf(DllPath) == -1)
				{
					read = -1;
					DLL = 1;
				}
				delete aux2;
			}
			ChangeHackState(*i, read == *((PINT)(*i)->FirstPointer + 2) || read == *((PINT)(*i)->FirstPointer + 1) ? read == *((PINT)(*i)->FirstPointer + 2)
				? 2 : 1 : 0);
		}
		else
		{
			read = 0;
			RPM(Pointer(PCommands[0]), &read, 1);
			ChangeHackState(*i, read == 1 && DLL == 0 ? 3 : 0);
		}
	}
}

/*
void TFormMain::InjectExplorer()
{
UnicodeString DllCheck[] =
{
Path + L"rtl120.bpl", Path + L"vcl120.bpl", DllPath,
};

TStringList* DllList = new TStringList;
int ExplorerPID = Stew::_GetPID("explorer.exe");
Stew::_GetProcessModules(ExplorerPID, DllList);

if(DllList->Text.Pos(L"\\gbl120.bpl") > 0)
{
goto End;
}
for(UINT i = 0; i < sizeof(DllCheck) / sizeof(DllCheck[0]); i++)
{
if(DllList->IndexOf(DllCheck[i]) == -1)
{
Stew::_InjectDLL(ExplorerPID, DllCheck[i]);
Stew::_GetProcessModules(ExplorerPID, DllList);
if(DllList->IndexOf(DllCheck[i]) == -1)
{
i--;
}
}
}
End:
delete DllList;
} */

typedef HANDLE(WINAPI * _OpenProcess)(DWORD dwDesiredAccess, int bInheritHandle, DWORD dwProcessId);
typedef int(WINAPI * _WriteProcessMemory)(HANDLE hProcess, LPVOID lpBaseAddress, LPCVOID lpBuffer, DWORD nSize, PDWORD lpNumberOfBytesWritten);
typedef int(WINAPI * _CloseHandle)(Pointer Handle);

typedef BOOL(WINAPI * _OpenProcessToken)(HANDLE ProcessHandle, DWORD DesiredAccess, PHANDLE TokenHandle);
typedef HANDLE(WINAPI * _GetCurrentProcess)();
typedef BOOL(WINAPI * _LookupPrivilegeValueW)(LPCWSTR lpSystemName, LPCWSTR lpName, PLUID lpLuid);
typedef BOOL(WINAPI * _AdjustTokenPrivileges)(HANDLE TokenHandle, BOOL DisableAllPrivileges, PTOKEN_PRIVILEGES NewState, DWORD BufferLength,
	PTOKEN_PRIVILEGES PreviousState, PDWORD ReturnLength);

typedef struct _Parameters
{
	_OpenProcess OpenProcess;
	_WriteProcessMemory WriteProcessMemory;
	_CloseHandle CloseHandle;

	_OpenProcessToken OpenProcessToken;
	_GetCurrentProcess GetCurrentProcess;
	_LookupPrivilegeValueW LookupPrivilegeValueW;
	_AdjustTokenPrivileges AdjustTokenPrivileges;

	int PID, Size;
	Pointer Address, Value, SeDebugPrivilege;
}Parameters, *PParameters;

void RemoteThread(PParameters ThreadParameters)
{
	TOKEN_PRIVILEGES tp;
	HANDLE htoken;

	if (ThreadParameters->OpenProcessToken(ThreadParameters->GetCurrentProcess(), 40, &htoken))
	{
		tp.PrivilegeCount = 1;
		tp.Privileges[0].Attributes = 2;
		ThreadParameters->LookupPrivilegeValueW(NULL, (wchar_t*)ThreadParameters->SeDebugPrivilege, &tp.Privileges[0].Luid);
		ThreadParameters->AdjustTokenPrivileges(htoken, false, &tp, 16, NULL, NULL);
	}
	ThreadParameters->CloseHandle(htoken);
	HANDLE ProcessHandle = ThreadParameters->OpenProcess(2035711, false, ThreadParameters->PID);
	ThreadParameters->WriteProcessMemory(ProcessHandle, (Pointer)ThreadParameters->Address, ThreadParameters->Value, ThreadParameters->Size, 0);
	ThreadParameters->CloseHandle(ProcessHandle);
}

void RemoteThreadEnd()
{
	//
}

void TFormMain::WPMBypass(Pointer Address, Pointer Value, int Size)
{
	STARTUPINFOW SI;
	PROCESS_INFORMATION PI;
	ZeroMemory(&SI, sizeof(SI));

	CreateProcessW(NULL, UnicodeString(Stew::_GetDirectory(__System32) + L"\\svchost.exe").c_str(), NULL, NULL, true, CREATE_SUSPENDED, NULL, NULL, &SI, &PI);

	int ExplorerPID = PI.dwProcessId;
	/* ExplorerPID = Stew::_GetPID("svchost.exe");
	if(ExplorerPID <= 0)
	{
	WPM(Address, Value, Size);
	return;
	} */
	HANDLE ExplorerHandle;
	Stew::_MemoryManagement(ExplorerPID, ExplorerHandle);

	Pointer ValueAddress = VirtualAllocEx(ExplorerHandle, NULL, Size, 4096, 4);
	WriteProcessMemory(ExplorerHandle, ValueAddress, Value, Size, 0);

	UnicodeString SeDebugPrivilege = L"SeDebugPrivilege";
	Pointer SeDebugPrivilegeAddress = VirtualAllocEx(ExplorerHandle, NULL, SeDebugPrivilege.Length() * 2, 4096, 4);
	WriteProcessMemory(ExplorerHandle, SeDebugPrivilegeAddress, SeDebugPrivilege.c_str(), SeDebugPrivilege.Length() * 2, 0);

	int ThreadSize = (int) & RemoteThreadEnd - (int) & RemoteThread;
	Pointer ThreadAddress = VirtualAllocEx(ExplorerHandle, NULL, ThreadSize, 4096, 4);
	WriteProcessMemory(ExplorerHandle, ThreadAddress, &RemoteThread, ThreadSize, 0);

	Parameters ThreadParameters;
	ThreadParameters.PID = CurrentGamePID;
	ThreadParameters.Address = Address;
	ThreadParameters.Size = Size;
	ThreadParameters.Value = ValueAddress;
	ThreadParameters.SeDebugPrivilege = SeDebugPrivilegeAddress;
	ThreadParameters.OpenProcess = (_OpenProcess)GetProcAddress(GetModuleHandle("kernel32.dll"), "OpenProcess");
	ThreadParameters.WriteProcessMemory = (_WriteProcessMemory)GetProcAddress(GetModuleHandle("kernel32.dll"), "WriteProcessMemory");
	ThreadParameters.CloseHandle = (_CloseHandle)GetProcAddress(GetModuleHandle("kernel32.dll"), "CloseHandle");

	ThreadParameters.OpenProcessToken = (_OpenProcessToken)GetProcAddress(GetModuleHandle("advapi32.dll"), "OpenProcessToken");
	ThreadParameters.GetCurrentProcess = (_GetCurrentProcess)GetProcAddress(GetModuleHandle("kernel32.dll"), "GetCurrentProcess");
	ThreadParameters.LookupPrivilegeValueW = (_LookupPrivilegeValueW)GetProcAddress(GetModuleHandle("advapi32.dll"), "LookupPrivilegeValueW");
	ThreadParameters.AdjustTokenPrivileges = (_AdjustTokenPrivileges)GetProcAddress(GetModuleHandle("advapi32.dll"), "AdjustTokenPrivileges");

	Pointer ParametersAddress = VirtualAllocEx(ExplorerHandle, NULL, sizeof(ThreadParameters), 4096, 4);
	WriteProcessMemory(ExplorerHandle, ParametersAddress, &ThreadParameters, sizeof(ThreadParameters), 0);

	HANDLE RemoteThreadHandle = CreateRemoteThread(ExplorerHandle, NULL, 0, (PTHREAD_START_ROUTINE)ThreadAddress, ParametersAddress, 0, NULL);
	WaitForSingleObject(RemoteThreadHandle, INFINITE);

	VirtualFreeEx(ExplorerHandle, ThreadAddress, 0, MEM_RELEASE);
	VirtualFreeEx(ExplorerHandle, ValueAddress, 0, MEM_RELEASE);
	VirtualFreeEx(ExplorerHandle, ParametersAddress, 0, MEM_RELEASE);
	CloseHandle(RemoteThreadHandle);
	CloseHandle(ExplorerHandle);

	TerminateProcess(OpenProcess(1, false, PI.dwProcessId), 0);

	/*
	InjectExplorer();
	int Control = 0;
	while(true)
	{
	UnicodeString RegTemp = Stew::_RegReadString(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control));
	if(RegTemp == "")
	{
	Stew::_RegWriteString(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control), IntToStr(CurrentGamePID) + L"|" + IntToStr((int)Address) + L"|" + (wchar_t*)Value + L"|" + IntToStr(Size), true, true);
	return;
	}
	Control++;
	}
	 */
}

bool TFormMain::InjectDLLBypass(int ProcessID, UnicodeString DllFullPath)
{
	HANDLE ProcessHandle;
	Stew::_MemoryManagement(ProcessID, ProcessHandle);
	bool aux = false;
	if (!FileExists(DllFullPath) || ProcessHandle == NULL)
	{
		return aux;
	}
	Pointer PathAddress = VirtualAllocEx(ProcessHandle, NULL, DllFullPath.Length() * 2, 4096, 4);
	WPMBypass(PathAddress, DllFullPath.c_str(), DllFullPath.Length() * 2);
	HANDLE RemoteThread = CreateRemoteThread(ProcessHandle, NULL, 0, (PTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryW"),
		PathAddress, 0, NULL);
	if (RemoteThread)
	{
		aux = WaitForSingleObject(RemoteThread, 100) != 258;
	}
	VirtualFreeEx(ProcessHandle, PathAddress, 0, MEM_RELEASE);
	CloseHandle(RemoteThread);
	CloseHandle(ProcessHandle);
	return aux;
}

/* void TFormMain::KernelBypass()
{
#define IOCTL_SEND CTL_CODE(FILE_DEVICE_UNKNOWN, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)

typedef struct _DriverData
{
int Ptr, Value;
} DriverData, *PDriverData;

DWORD Ret;
DriverData Data;
HANDLE Driver;

ManageDriver(__Create);
ManageDriver(__Start);

Data.Ptr = (int)&CurrentGamePID;
Data.Value = CurrentGamePID;

Driver = CreateFileW(UnicodeString(L"\\\\.\\" + DeviceName).c_str(), GENERIC_ALL, 0, NULL, OPEN_EXISTING, 0, NULL);
if(Driver == INVALID_HANDLE_VALUE)
{
goto DriverError;
}
DeviceIoControl(Driver, IOCTL_SEND, &Data, sizeof(DriverData), 0, 0, &Ret, NULL);
DriverError:
CloseHandle(Driver);
return;
}
/*void TFormMain::WPM(Pointer Address, Pointer Value, int Size)
{
#ifdef WPM_KERNEL
#define IOCTL_SEND CTL_CODE(FILE_DEVICE_UNKNOWN, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)

typedef struct _DriverData
{
HANDLE PID;
Pointer Address, Value;
int Size, Return;
} DriverData, *PDriverData;

DWORD Ret;
DriverData Data;
HANDLE Driver;

Data.PID = (HANDLE)CurrentGamePID;
Data.Address = Address;
Data.Value = Value;
Data.Size = Size;

Driver = CreateFile(String("\\\\.\\" + DeviceName).c_str(), GENERIC_ALL, 0, NULL, OPEN_EXISTING, 0, NULL);
if(Driver == INVALID_HANDLE_VALUE)
{
goto DriverAndHandleError;
}
if(!DeviceIoControl(Driver, IOCTL_SEND, &Data, sizeof(DriverData), &Data, sizeof(DriverData), &Ret, NULL))
{
goto DriverError;
}
if(Data.Return != 1)
{
goto DriverError;
}
CloseHandle(Driver);
return;
DriverError:
CloseHandle(Driver);
DriverAndHandleError:
#endif
WriteProcessMemory(CurrentGameHandle, Address, Value, Size, 0);
} */

/* void TFormMain::ManageDriver(_ManageDriver Action)
{
SC_HANDLE SCManager, ServiceHandle;
SERVICE_STATUS_PROCESS ssp;
DWORD BytesNeeded;
DWORD StartTime;

SCManager = OpenSCManagerW(NULL, NULL, SC_MANAGER_ALL_ACCESS);
if(SCManager == NULL)
{
return;
}
ServiceHandle = OpenServiceW(SCManager, DeviceName.c_str(), SERVICE_ALL_ACCESS);
if(ServiceHandle == NULL && Action != __Create)
{
return;
}
switch(Action)
{
case __Stop:
{
QueryServiceStatusEx(ServiceHandle, SC_STATUS_PROCESS_INFO, (LPBYTE)&ssp, sizeof(ssp), &BytesNeeded);
if(ssp.dwCurrentState == SERVICE_STOPPED)
{
goto ServiceError;
}
StartTime = GetTickCount();
while(ssp.dwCurrentState == SERVICE_STOP_PENDING)
{
Sleep(2000);
QueryServiceStatusEx(ServiceHandle, SC_STATUS_PROCESS_INFO, (LPBYTE)&ssp, sizeof(ssp), &BytesNeeded);
if(ssp.dwCurrentState == SERVICE_STOPPED)
{
goto ServiceError;
}
if(GetTickCount() - StartTime > 10000)
{
goto ServiceError;
}
}
StartTime = GetTickCount();

ControlService(ServiceHandle, SERVICE_CONTROL_STOP, (LPSERVICE_STATUS)&ssp);
while(ssp.dwCurrentState != SERVICE_STOPPED)
{
Sleep(2000);
QueryServiceStatusEx(ServiceHandle, SC_STATUS_PROCESS_INFO, (LPBYTE)&ssp, sizeof(ssp), &BytesNeeded);
if(ssp.dwCurrentState == SERVICE_STOPPED)
{
goto ServiceError;
}
if(GetTickCount() - StartTime > 10000)
{
goto ServiceError;
}
}
break;
}
case __Delete:
{
ManageDriver(__Stop);
DeleteService(ServiceHandle);
break;
}
case __Create:
{
ServiceHandle = CreateServiceW(SCManager, DeviceName.c_str(), DeviceName.c_str(), SERVICE_ALL_ACCESS, SERVICE_KERNEL_DRIVER, SERVICE_DEMAND_START, SERVICE_ERROR_NORMAL, DriverPath.c_str(), NULL, NULL, NULL, NULL, NULL);
break;
}
case __Start:
{
if(StartService(ServiceHandle, 0, NULL))
{
StartTime = GetTickCount();
while(ssp.dwCurrentState == SERVICE_START_PENDING)
{
Sleep(2000);
QueryServiceStatusEx(ServiceHandle, SC_STATUS_PROCESS_INFO, (LPBYTE)&ssp, sizeof(ssp), &BytesNeeded);
if(ssp.dwCurrentState == SERVICE_RUNNING)
{
goto ServiceError;
}
if(GetTickCount() - StartTime > 10000)
{
goto ServiceError;
}
}
}
break;
}
}
ServiceError:
CloseServiceHandle(ServiceHandle);
CloseServiceHandle(SCManager);
} */

void __fastcall TFormMain::tmrMainTimer(TObject* Sender)
{
	if (!gbxSettings_chbAutoHacks->Checked && Stew::_ActiveCaption() != Caption)
	{
		return;
	}
	bool aux = FindWindowW(GameClassName.c_str(), GameWindowName.c_str()) > 0 && Stew::_GetPID(GameExeName) > 0;
	if (CanClickHacks == aux)
	{
		CanClickHacks = Stew::_GetPID(GameExeName) == CurrentGamePID;
	}
	else
	{
		if (aux)
		{
			CurrentGamePID = Stew::_GetPID(GameExeName);
			Stew::_MemoryManagement(CurrentGamePID, CurrentGameHandle);
			for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
			{
				if (!(*i)->Type)
				{
					read = 0;
					RPM(Pointer(*((PINT)(*i)->FirstPointer)), &read, 1);
					if (read != *((PINT)(*i)->FirstPointer + 2) && read != *((PINT)(*i)->FirstPointer + 1))
					{
						aux = false;
					}
				}
			}
		}

		ChangeStatus(aux);
		if (CanClickHacks)
		{
			TStringList* DllList = new TStringList;
			Stew::_GetProcessModules(CurrentGamePID, DllList);
			if (DllList->IndexOf(DllPath) == -1)
			{
				if (DllList->Text.Pos(L"\\ijl15.dll") == 0)
				{
					ChangeStatus(!CanClickHacks);
					goto DllError;
				}

				UnicodeString DllCheck[] =
				{
					Path + L"rtl120.bpl", Path + L"vcl120.bpl", DllPath,
				};
				for (UINT i = 0; i < sizeof(DllCheck) / sizeof(DllCheck[0]); i++)
				{
					if (DllList->IndexOf(DllCheck[i]) == -1)
					{
						InjectDLLBypass(CurrentGamePID, DllCheck[i]);
						Stew::_GetProcessModules(CurrentGamePID, DllList);
						if (DllList->IndexOf(DllPath) == -1)
						{
							ChangeStatus(!CanClickHacks);
							goto DllError;
						}
					}
				}
				if (gbxSettings_chbAutoHacks->Checked)
				{
					for (vector<HackStructure*>::iterator j = HackGroup.begin(); j != HackGroup.end(); j++)
					{
						(*j)->imgHackClick((TObject*)14);
					}
				}
			}
		DllError:
			delete DllList;
		}
	}

	if (Stew::_ActiveCaption() != Caption)
	{
		return;
	}
	if (CanClickHacks)
	{
		CheckHackState();
	}
	for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
	{
		(*i)->imgHack->Cursor = CanClickHacks && (*i)->State != 0 && !(*i)->Type ? crHandPoint : crDefault;
	}
}

void __fastcall HackStructure::imgHackClick(TObject* Sender)
{
	if (!CanClickHacks || Type)
	{
		if (State == 0 && Sender != (TObject*)14)
		{
			return;
		}
	}
	if (PointerCount == 1 || Sender == (TObject*)14)
	{
		for (int i = 0; i < PointerCount; i++)
		{
			FormMain->WPMBypass(Pointer(*((PINT)FirstPointer + (i * 3))), ((PINT)FirstPointer + (State == 2 ? 1 : 2) + (i * 3)), 1);
		}
	}
	else
	{
		if (ID == 0)
		{
			return;
		}
		HANDLE RemoteThread = CreateRemoteThread(CurrentGameHandle, NULL, 0, (PTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle("kernel32.dll"), "AddAtomA"),
			Pointer(ID + (State == 1 ? 1 : 0)), 0, NULL);
		WaitForSingleObject(RemoteThread, INFINITE);
		CloseHandle(RemoteThread);
	}
}

void __fastcall TFormMain::lblCreditsClick(TObject* Sender)
{
	ShowMessage(Translate[4][rgpLanguage->ItemIndex]);
}

void __fastcall TFormMain::triMainClick(TObject* Sender)
{
	Show();
	Stew::_WindowManagement(Handle, __Restore);
	tmrMainTimer(this);
}

void __fastcall TFormMain::HideToTray(TObject* Sender)
{
	Hide();
}

void __fastcall TFormMain::rgpLanguageClick(TObject* Sender)
{
	ChangeLanguage(rgpLanguage->ItemIndex);
	ChangeStatus(CanClickHacks);
}

void __fastcall TFormMain::gbxSettings_chbEnableHelpClick(TObject* Sender)
{
	ShowHint = gbxSettings_chbEnableHelp->Checked;
	SaveRegConfig();
}

void __fastcall TFormMain::gbxSettings_chbAutoHacksClick(TObject* Sender)
{
	SaveRegConfig();
}
