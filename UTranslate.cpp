#include <System.hpp>
const UnicodeString
	CS = "//",
	Translate[][3] =
	{
		//0
		"Clique aqui para checar por atualizações",
		"Click here to check for updates",
		"lblUpdates",
		//1
		"Clique aqui para visualizar os créditos",
		"Click here to view the credits",
		"lblCredits",
		//2
		"Configurações",
		"Settings",
		"gbxSettings",
		//3
		"Ativar ajuda",
		"Enable help",
		"gbxSettings_chbEnableHelp",
		//4
		"Agradecimentos: sd333221, pudge666, DarkSupremo, Beta Testers, etc.",
		"Thanks to: sd333221, pudge666, DarkSupremo, Beta Testers, etc.",
		"",
		//5
		"Legenda",
		"Legend",
		"gbxLegend",
		//6
		"Indisponível",
		"Unavailable",
		"gbxLegend_lblUnavailable",
		//7
		"Inativo",
		"Disabled",
		"gbxLegend_lblDisabled",
		//8
		"Ativo",
		"Enabled",
		"gbxLegend_lblEnabled",
		//9
		"Hack por comandos",
		"Hack by commands",
		"gbxLegend_lblCommands",
		//10
		"Map Hack",
		"Map Hack",
		"",
		//11
		"Aguardando",
		"Waiting",
		"",
		//12
		"encontrado",
		"opened",
		"",
		//13
		"Erro",
		"Error",
		"",
		//14
		"\"%s\" não encontrada.\r\nPor favor faça o download do programa novamente.",
		"\"%s\" not found.\r\nPlease download the program again.",
		"",
		//15
		"Trade Amount",
		"Trade Amount",
		"",
		//16
		"Skills",
		"Skills",
		"",
		//17
		"Ajuda",
		"Help",
		"",
		//18
		"Comandos",
		"Commands",
		"",
		//19
		"Opacidade (-ah)",
		"Opacity (-ah)",
		"",
		//20
		"Inivisivel colorido",
		"Colored invisible",
		"",
	},
	TranslateHint[][3] =
	{
		//0
		"Marque esta opção se você deseja ajuda\r\nquando parar o mouse em cima de algo.",
		"Check this box if you want help\r\nwhen stop the mouse above something.",
		"gbxSettings_chbEnableHelp",
		//1
		"Clique aqui para visitar o fórum oficial.",
		"Click here to visit the official forum.",
		"lblStew",
		//2
		"Clique aqui para visitar o fórum oficial.",
		"Click here to visit the official forum.",
		"lblForumLink",
		//3
		(String)"Revela o mapa." +
		#ifdef exe
		"\r\n\r\nHacks:\r\n- Mini Map\r\n- Main Map\r\n- Unidades clicáveis no fog - PS.: É salvo no replay.\r\n- Ilusões\r\n- Unidades invisíveis\r\n- Itens/Runas\r\n- Sinais de ping ( ! ) - PS.: É salvo no replay." +
		#else
		"\r\n\r\nInformacoes dos hacks no executavel (Hot Warcraft Tools)." +
		#endif
		"\r\n\r\nComando: \""+CS+"mh XX\" (Ligar = 1, Desligar = 0)\r\n\r\nExemplo:\r\n"+CS+"mh 1",
		/**//**/
		(String)"Reveals the map." +
		#ifdef exe
		"\r\n\r\nHacks:\r\n- Mini Map\r\n- Main Map\r\n- Clickable units on fog - PS.: Is saved in replay.\r\n- Illusions\r\n- Invisible units\r\n- Items/Runes\r\n- Ping signals ( ! ) - PS.: Is saved in replay." +
		#else
		"\r\n\r\nHacks info on executable." +
		#endif
		"\r\n\r\nCommand: \""+CS+"mh XX\" (On = 1, Off = 0)\r\n\r\nExample:\r\n"+CS+"mh 1",
		"",
		//4
		"Comando para receber ajuda de outros comandos dentro do jogo.\r\n\r\nComando: \""+CS+"help XX\"\r\n\r\nExemplo:\r\n"+CS+"help mh",
		"Command to get help of other commands in game.\r\n\r\nCommand: \""+CS+"help XX\"\r\n\r\nExample:\r\n"+CS+"help mh",
		"",
		//5
		"Marque esta opção se você deseja ativar os hacks\r\natravés do chat do Warcraft.\r\nPS.: Ninguém verá você digitando o comando, e ele não será salvo no replay.\r\n\r\nComando: Digite \"//\" para ver a lista de comandos.",
		"Check this box if you want enable hacks in Warcraft chat.\r\nPS.: Nobody will see you saying the command, and the command will not be saved in replay.\r\n\r\nCommand: Say \"//\" to see the command list.",
		"",
		//6
		"Marque esta opção se você deseja que os hacks sejam ativados\r\nautomaticamente quando o Warcraft for detectado.",
		"If this box is checked, the hacks will enable automatically when Warcraft open.",
		"gbxSettings_chbAutoHacks",
		//7
		"Permite enviar gold para aliados. - PS.: Salvo no replay.\r\n\r\nComando: \""+CS+"trade XX\" (Ligar = 1, Desligar = 0)\r\n\r\nExemplo:\r\n"+CS+"trade 1",
		"Allows send gold to allies. - PS.: Is saved in replay.\r\n\r\nCommand: \""+CS+"trade XX\" (On = 1, Off = 0)\r\n\r\nExample:\r\n"+CS+"trade 1",
		"",
		//8
		"Exibe skills e cooldowns de unidades que voce nao tem controle.\r\n\r\nComando: \""+CS+"skills XX\" (Ligar = 1, Desligar = 0)\r\n\r\nExemplo:\r\n"+CS+"skills 1",
		"Show skills and cooldowns of units that you don't have control.\r\n\r\nCommand: \""+CS+"skills XX\" (On = 1, Off = 0)\r\n\r\nExample:\r\n"+CS+"skills 1",
		"",
		//9
		"Remove a transparencia das unidades (tambem anula o comando do DotA \"-ah\").\r\n\r\nComando: \""+CS+"opacity XX\" (Ligar = 1, Desligar = 0)\r\n\r\nExemplo:\r\n"+CS+"opacity 1",
		"Remove the transparency of units (also bypass the DotA command \"-ah\").\r\n\r\nCommand: \""+CS+"opacity XX\" (On = 1, Off = 0)\r\n\r\nExample:\r\n"+CS+"opacity 1",
		"",
		//10
		"Exibe as unidades invisiveis em vermelho.\r\n\r\nComando: \""+CS+"color XX\" (Ligar = 1, Desligar = 0)\r\n\r\nExemplo:\r\n"+CS+"color 1",
		"Shows the invisible units as red.\r\n\r\nCommand: \""+CS+"color XX\" (On = 1, Off = 0)\r\n\r\nExample:\r\n"+CS+"color 1",
		"",
	},
	TranslateCommands[][2] =
	{
		//0
		"\n|r|cffFFFF00Comandos:|r\r\n|cffFFFFFFmh\r\ntrade\r\nskills\r\nopacity\r\nhelp\r\n ",
		"\r\n|r|cffFFFF00Commands:|r\r\n|cffFFFFFFmh\r\ntrade\r\nskills\r\nopacity\r\nhelp\r\n ",
		//1
		"desativado",
		"disabled",
		//2
		"ativado",
		"enabled",
	};
