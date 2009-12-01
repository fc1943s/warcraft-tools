//#define Deploy

const int
	PCodeCavePosition = 0x00455A90,
	PMapHack[] =
	{
		//MainMap Units
		0x6F3A1E9B, 0x23, 0x90, 	0x6F3A1E9C, 0xCA, 0x90,
 		//MiniMap Units
		0x6F361DFC, 1, 0,
 		//Clickable Units
		0x6F285B8C, 0x74, 0x90,		0x6F285B8D, 0x2A, 0x90,		0x6F285BA2, 0x75, 0xEB,
		//Reveal Illusions
		0x6F28345C, 0xC3, 0x40,		0x6F28345D, 0xCC, 0xC3,
		//MainMap Fog
		0x6F73DEC9, 0x8A, 0xB2,		0x6F73DECA, 0x90, 0,        0x6F73DECB, 0x6C, 0xEB,     0x6F73DECC, 0x68, 0x2,
		//MiniMap Fog
		0x6F356E7E, 0x66, 0xEB,     0x6F356E7F, 0x85, 1,
		//Reveal Invisible
		0x6F39A39B, 0x8B, 0xEB,   	0x6F39A39C, 0x97, 4,
		0x6F39A3AE, 0xF, 0xEB,   	0x6F39A3AF, 0xB7, 6,
		0x6F39A3B6, 0x7B, 0x33,   	0x6F39A3B7, 0, 0xC0,   		0x6F39A3B8, 0, 0x40,
		0x6F362211, 0x85, 0x3B,		0x6F362214, 0x84, 0x85,
		//View Items/Runes
		0x6F3F92CA, 0x75, 0x90, 	0x6F3F92CB, 0xA, 0x90, 		0x6F3A1DDB, 0x75, 0xEB,
		//Ping Signals
		0x6F431556, 0x85, 0x3B,     0x6F431559, 0x84, 0x85,		0x6F431569, 0x85, 0x3B,     0x6F43156C, 0x84, 0x85,
	},
	PTradeAmount[] =
	{
		0x6F34E75E, 0x85, 0xB8,		0x6F34E75F, 0xC0, 0x64,		0x6F34E760, 0x74, 0,		0x6F34E761, 8, 0,
		0x6F34E762, 0x8B, 0,		0x6F34E763, 0x87, 0xEB,		0x6F34E764, 0x6C, 0xB,
	},
	PSkills[] =
	{
		//Skills
		0x6F2030DC, 0xF, 0xEB,      0x6F2030DD, 0x84, 4,        0x6F34FC68, 0x74, 0x90,		0x6F34FC69, 8, 0x90,
		//Cooldowns
		0x6F28EBCE, 0x75, 0xEB,     0x6F34FCA6, 0x85, 0xEB,     0x6F34FCA7, 0xC0, 2,
	},
	POpacity[] =
	{
		0x6F3C5C22, 0x74, 0xEB,     0x6F3C135C, 0x3D, 0xB8,     0x6F3C1361, 0x76, 0xEB,
	},
	PColoredInvisible[] =
	{
		PCodeCavePosition + 4, 0, 1,
	},
	PCommands[] =
	{
		PCodeCavePosition + 5, 0, 1,
	};
