#include <vcl.h>
#include <windows.h>
#include <System.hpp>
#include <process.h>
#include "UPointers.cpp"
#include "UTranslate.cpp"
#include "Stew.cpp"
#pragma hdrstop
#pragma argsused

#ifdef Deploy
#pragma resource "admin.res"
#endif

class HackStructure
{
public:
	HackStructure(int ID, int Name, int Description, AnsiString Command, int const* FirstPointer, int PointerCount, int Type) : ID(ID), Command(Command),
	FirstPointer(FirstPointer), PointerCount(PointerCount), Type(Type), Description(Description), Name(Name)
	{
	}

	AnsiString Command;
	int Name;
	int ID;
	int const* FirstPointer;
	int PointerCount;
	int Type;
	AnsiString Values;
	int Description;
};

bool Test = false;
DWORD OldProtect;
vector<HackStructure*>HackGroup;
int CurrentLanguage = 0;
Pointer OldAtom;

void ColoreInvisible()
{
	asm
	{
		PUSHAD
		PUSH EAX
		MOV EAX, [PColoredInvisible[0]]
		CMP BYTE PTR DS:[EAX], 0
		POP EAX
		JE @@4
		OR EAX,EAX
		MOV CL,[ESI+0x2D0]
		JNZ @@1
		CMP CL,2
		JE @@3
		MOV [ESI+0x2D0],0xFFFF0002
		MOV EAX,0xFFFF0000
		JMP @@2
@@1:	CMP CL,0x0FF
		JE @@3
		MOV [ESI+0x2D0],-1
		MOV EAX,-1
@@2:	MOV ECX,ESI
		PUSH ESI
		MOV ESI,0x6F29E270
		CALL ESI
		POP ESI
@@3:	POPAD
		MOV EAX, 1
		JMP @@5
@@4:	POPAD
@@5:	AND EBX, EAX
		MOV [ESP-0x1C], EAX
	}
}

void SayText(AnsiString Text)
{
	asm
	{
		PUSHAD
		MOV ESI,0x6F5ECBC0
		CALL ESI
		MOV EDX,EAX
		PUSH 0
		PUSH 0x41200000
		PUSH 0x6F001834
		PUSH Text
		MOV EAX,Text
		MOV EBX,Text
		MOV ECX,[EDX+0x3EC]
		SUB ECX,0x10000
		MOV ESI,0x6F5F66B0
		CALL ESI
		POPAD
    }
}

bool ProcessCommands(PAnsiChar aux)
{
	UnicodeString ChatText = (UnicodeString)aux;

	if (ChatText.Length() < 2 || (UnicodeString)ChatText[1] + (UnicodeString)ChatText[2] != CS)
	{
		return false;
	}
	ChatText = Stew::_DissectString(2, CS, ChatText);
	UnicodeString CommandName = Stew::_DissectString(1, L" ", ChatText);
	UnicodeString CommandValue = Stew::_DissectString(2, L" ", ChatText);
	HackStructure* CommandHelp;

	for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
	{
		if ((*i)->Command == (AnsiString)CommandName)
		{
			CommandHelp = *i;
			switch((*i)->Type)
			{
				case 0:
				{
					if (CommandValue != L"0" && CommandValue != L"1")
					{
						goto CommandDescription;
					}
					for (int j = 0; j < (*i)->PointerCount; j++)
					{
						VirtualProtect(Pointer(*((PINT)(*i)->FirstPointer + (j * 3))), 1, PAGE_EXECUTE_READWRITE, &OldProtect);
						*PBYTE(*((PINT)(*i)->FirstPointer + (j * 3))) = *((PINT)(*i)->FirstPointer + (j * 3) + 1 + StrToInt(CommandValue));
					}
					goto CommandActivation;
				}
				case 1:
				{
					for (vector<HackStructure*>::iterator x = HackGroup.begin(); x != HackGroup.end(); x++)
					{
						if ((*x)->Command == CommandValue)
						{
							CommandHelp = *x;
							goto CommandDescription;
						}
					}
					break;
				}
			}
		CommandDescription:
			SayText("\r\n|cffFFFF00" + AnsiString(Translate[CommandHelp->Name][CurrentLanguage] + L"\r\n|r|cffFFFFFF" + TranslateHint[CommandHelp->Description]
					[CurrentLanguage]) + "\r\n ");
			goto End;
		CommandActivation:
			SayText("\r\n|cffFFFF00" + AnsiString(Translate[(*i)->Name][CurrentLanguage] + L"|r|cffFFFFFF " + TranslateCommands[1 + StrToInt(CommandValue)
					][CurrentLanguage]) + ".\r\n ");
			goto End;
		}
	}
	SayText((AnsiString)TranslateCommands[0][CurrentLanguage]);
End:
	return true;
}

void FilterChat()
{
	asm
	{
		PUSH ECX
		MOV ECX, [PCommands[0]]
		CMP BYTE PTR DS:[ECX], 0
		JE @@1
		PUSHAD
		PUSH EAX
		CALL ProcessCommands
		CMP AL, 0
		POP EAX
		POPAD
		JE @@1
		POP ECX
		POP ECX
		POP EBP
		POP ECX
		MOV ECX,0x6F2FD394
		JMP ECX
@@1:	MOV ECX,0x6F530760
		CALL ECX
		POP ECX
	}
}

void HackHook(int HackID)
{
	for (vector<HackStructure*>::iterator i = HackGroup.begin(); i != HackGroup.end(); i++)
	{
		if ((*i)->ID == HackID || (*i)->ID + 1 == HackID)
		{
			for (int j = 0; j < (*i)->PointerCount; j++)
			{
				VirtualProtect(Pointer(*((PINT)(*i)->FirstPointer + (j * 3))), 1, PAGE_EXECUTE_READWRITE, &OldProtect);
				*PBYTE(*((PINT)(*i)->FirstPointer + (j * 3))) = *((PINT)(*i)->FirstPointer + (j * 3) + 1 + Stew::_Odd(HackID));
			}
			return;
		}
	}
}

void Init()
{
	/* Hacks */
	HackGroup.push_back(new HackStructure(2, 10, 3, "mh", PMapHack, (sizeof(PMapHack) / 4) / 3, 0));
	HackGroup.push_back(new HackStructure(4, 15, 7, "trade", PTradeAmount, (sizeof(PTradeAmount) / 4) / 3, 0));
	HackGroup.push_back(new HackStructure(6, 16, 8, "skills", PSkills, (sizeof(PSkills) / 4) / 3, 0));
	HackGroup.push_back(new HackStructure(8, 19, 9, "opacity", POpacity, (sizeof(POpacity) / 4) / 3, 0));
	// HackGroup.push_back(new HackStructure(   20, 5, "color",	PColoredInvisible, (sizeof(PColoredInvisible) / 4) / 3, 1));
	HackGroup.push_back(new HackStructure(0, 17, 4, "help", NULL, 1, 1));

	/* Detours */
	int aux;
	/*
	//ColoreInvisible
	aux = 0x6F398E09;
	VirtualProtect(Pointer(aux), 10, PAGE_EXECUTE_READWRITE, &OldProtect);
	 *PBYTE(aux) = 0xE8;
	 *PINT(aux + 1) = (int)ColoreInvisible - aux - 5;
	 *PBYTE(aux + 5) = 0x90;
	 */
	// FilterChat
	aux = 0x6F2FD11F;
	VirtualProtect(Pointer(aux), 10, PAGE_EXECUTE_READWRITE, &OldProtect);
	*PINT(aux + 1) = (int)FilterChat - aux - 5;

	Stew::_HookProcedure(L"kernel32.dll", L"AddAtomA", &HackHook, OldAtom);
}

/* void ProcessValues()
{
int Control = 0;
HANDLE HandleTemp;
UnicodeString
Title = "Hot Warcraft Tools",
Version = "5.0",
RegKey = "software\\Hot Cheats\\" + Title + "\\" + Version;

while(true)
{
UnicodeString RegTemp = Stew::_RegReadString(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control));
if(RegTemp != "")
{
int PIDTemp = StrToInt(Stew::_DissectString(1, "|", RegTemp));
Stew::_BeginMemoryWork(PIDTemp, HandleTemp);
WriteProcessMemory(HandleTemp, (Pointer)StrToInt(Stew::_DissectString(2, "|", RegTemp)), &Stew::_DissectString(3, "|", RegTemp), StrToInt(Stew::_DissectString(4, "|", RegTemp)), 0);
CloseHandle(HandleTemp);
Stew::_RegDeleteValue(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control));
}
else
{
return;
}
Control++;
}
} */

/* void ProcessThread(Pointer)
{
//SetTimer(NULL, NULL, 100, (TIMERPROC)ProcessValues);
int Control = 0;
HANDLE HandleTemp;
UnicodeString
Title = "Hot Warcraft Tools",
Version = "5.0",
RegKey = "software\\Hot Cheats\\" + Title + "\\" + Version;

while(true)
{
UnicodeString RegTemp = Stew::_RegReadString(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control));
if(RegTemp != "")
{
//Stew::_RegWriteString(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control) + L"-", Stew::_DissectString(1, "|", RegTemp) + L"|" + Stew::_DissectString(2, "|", RegTemp) + L"|" + Stew::_DissectString(3, "|", RegTemp) + L"|" + Stew::_DissectString(4, "|", RegTemp), true, true);
int PIDTemp = StrToInt(Stew::_DissectString(1, "|", RegTemp));
Stew::_BeginMemoryWork(PIDTemp, HandleTemp);
WriteProcessMemory(HandleTemp, (Pointer)StrToInt(Stew::_DissectString(2, "|", RegTemp)), &Stew::_DissectString(3, "|", RegTemp), StrToInt(Stew::_DissectString(4, "|", RegTemp)), 0);
CloseHandle(HandleTemp);
Stew::_RegDeleteValue(HKEY_LOCAL_MACHINE, RegKey + L"\\Values", IntToStr(Control));

Control++;
}
else
{
Control = 0;
}
}
} */

int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void* lpReserved)
{
	if (!Test)
	{
		Test = true;
		/* if(ExtractFileName(ParamStr(0)) == L"explorer.exe")
		{
		_beginthread(ProcessThread, NULL, NULL);
		}
		else
		{ */
		Init();
		// }
	}
	return 1;
}
