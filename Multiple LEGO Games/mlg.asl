/*
Multiple LEGO Games- autosplitter
Supports load removal for most mainline TT LEGO games

!! IMPORTANT !!
IF YOU WANT TO HAVE MULTIPLE GAMES OPEN AT ONCE AND HAVE WORKING LOAD REMOVAL,
REORDER THE "state("game") {}" BLOCKS IN THE ORDER YOU'RE PLAYING THE GAMES IN.
LIVESPLIT HOOKING ORDER IS DEPENDANT ON THIS, SO ONCE YOU CLOSE GAME 1, IT WILL THEN
HOOK ONTO GAME 2 ETC.
!! IMPORTANT !!

Grunt% Games:
LEGO Star Wars: The Video Game
LEGO Star Wars II: The Original Trilogy (Only PC supported)
LEGO Star Wars: The Complete Saga
LEGO Indiana Jones: The Original Adventures
LEGO Batman: The Videogame
LEGO Indiana Jones 2: The Adventure Continues
LEGO Harry Potter: Years 1-4
LEGO Star Wars III: The Clone Wars
LEGO Pirates of the Caribbean: The Video Game
LEGO Harry Potter: Years 5-7
*/

state("LegoStarwars", "LSW1") {
    byte status : 0x39C58D;
    byte cutscene : 0x38D04C;
    string16 door : 0x39B0E0;
}

state("LegoStarWarsII", "LSW2") {
    int load: 0x26A26C;
    int endLoad: 0x24F394;
    int cutscene: 0x262044;
    byte status: 0x24F389;
    string16 levelBuffer: 0x330671E;
    string14 level2: 0x2FB7AF7;
}

state("LEGOStarWarsSaga", "TCS") {
    int gameReboot: 0x0040e26c;
    int transition: 0x00550768;
    int pause: 0x0047b7ac;
    int areaID: 0x00403784;
    float inCrawl: 0x47aab0;
    int canskip: 0x003fa5f0;
    int room: 0x551bc0;
    float wipe : 0x5507a0;
    int alttab: 0x00427610;
    int gogstream : 0x551bc0;
}

state("LEGOIndy", "LIJ1") {
    int stream : 0x6CC944;
    bool Loading: 0x5C3D24;
    bool Loading2: 0x6CC7A8;
    bool Reset: 0x572DA8;
    int door: 0x572EF0;
    int menu: 0x56F864;
    bool transition: 0x6C1664;
    int statust: 0x6927D8;

}

state("LEGOBatman", "LB1") {
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // This is an old address to remove loads before statuses, not used anymore due to some issues it caused and because of the Fades address being more accurate
    bool loading3: 0x6CA7B0; // I think this one is only used for some New Game load
    bool loading4: 0x6B29D0; // This removes the load when you exit a level
    bool Hardload: 0x6C9FD0; // This is for removing the loads when entering new hardloads via doors, and for room splitting
    bool Softload: 0x5C4A10; // This is used for room splitting in a few rooms
    bool Fades: 0x70AAC0; // This address is the only good way of removing the loads before status screens, but it flips after every room transition so a lot of safeguards have to be in place
    bool Cutscene: 0x5D48F8;
    bool Reset: 0x5A08C8;
    bool UI: 0x006B2964, 0xB68;
    bool UI2: 0x006B2964, 0xB64; //These UI addresses are for ending time on killing the boss in 2-5, 2 are needed because they both like to flip when doing certain things in the room
    ulong Newgame: 0x6D5C78; //4294901760

    int Menu: 0x59D384;
    int roomID : 0x6C98C4;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled

}


state("LEGOIndy2", "LIJ2") {
    int Room : 0xC5B598;
    int Cutscene: 0xC9A8B0;
    int Start: 0xB0B6CC;
    bool Load1: 0xB0F5C8;
    bool Load2: 0xACBF08;
    bool Load3: 0xC5B838;

}

state("LEGOHarryPotter", "1-4") {
    bool Loading: 0xA28510;
    bool Head: 0x00B1BA54, 0x18, 0x8, 0x80, 0x100, 0x770;
}

state("LEGOCloneWars", "LSW3") {
    byte status : 0xBBC744;
    byte statust : 0xBBC745;
}

state("LEGOPirates", "POTC") {
    bool Loading: 0xA171A4;
    bool Head: 0x00B57874, 0xBB8;
}

state("harry2", "5-7") {
    bool isLoading: 0xC59978;
    bool Head: 0x00C38554, 0x4, 0x28, 0x18, 0x20, 0xA8, 0x94, 0x44;
}

// END OF GRUNT%

state("LEGOlotr", "LOTR") {
    bool isLoading : 0x11BD09E;
}

state("LEGOLCUR_DX11", "LCU") {
	bool Load: 0x1C6C2AC;
	bool Status: 0x1175BE0, 0x18, 0x18, 0xF8, 0x38, 0x18, 0x860, 0x60, 0x158;
}

state("LEGOMARVEL", "LMSH1") {
    bool CornerLoads: 0x015B3BA8, 0x34, 0x20, 0xC, 0x30, 0x3C, 0x40, 0x64;
    bool IntoHub: 0x015665B0, 0x24, 0x18, 0x34, 0x34, 0x18, 0xC, 0x844;
    bool OpenGame: 0x1013F14;
    bool Fade: 0x1105C28;
    bool Fade2: 0x15B095C;
}

state("LEGOEMMET", "LM1") {
    bool Load: 0x16C04E4;
}

state ("LEGOJurassicWorld_DX11", "LJW"){
    bool Load: 0x2248474;
    bool Status: 0x02203750, 0x174;
}

state ("LEGOSWTFA_DX11", "TFA") {
    int Status: 0x027AA540, 0x60, 0x30, 0x30, 0x60, 0x48, 0x20, 0x468;
    int Load: 0x2786794;
}

state ("LEGONINJAGO_DX11", "LNMVG"){
    bool Loading: 0x245ADF0;
}

state("LEGOMARVEL2_DX11", "LMSH2") {
    bool AntiLoading: 0x2BC4C4C;
}

state ("LEGO The Incredibles_DX11", "LTI") {
    bool Load: 0x2BF395C;
    bool Load2: 0x02AA0E48, 0xB8, 0x18, 0x30, 0x0, 0x60, 0x70, 0x168;
    int Status: 0x02A6AC08, 0xB8;
}

state("LEGO DC Super-villains_DX11", "DCSV") {
    bool Status : 0x2DB02B0;
    bool Load : 0x2C3AB8C;
}

state("LEGOSTARWARSSKYWALKERSAGA_DX11", "TSS") {
    byte load: 0x05D8D850, 0xD8, 0x40, 0x10, 0x58, 0xB0, 0x0, 0x1B8;
    byte loads: 0x05D9E1A8, 0xC8, 0x10, 0x50, 0x60, 0x38, 0x30, 0xE0;
}

startup {
    vars.doubleSplit = new Stopwatch();

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    settings.Add("UTC_timer", true, "Show UTC time");

    settings.Add("lij2", true, "LEGO Indiana Jones 2");
    settings.Add("lij2_nocut", false, "N0CUT5", "lij2");
    settings.Add("lij2_standard", true, "Standard", "lij2");
}

init {
    // TCS
    vars.inCantina = false;
    vars.levellookup = new byte[43]{0x80,0x80,0x0,0x1,0x28,0x0,0x81,0x14,0x10,0x40,0x0,0x91,0x84,0xa8,0x0,0xa,0x41,0x8,0x45,0x80,0x80,0x0,0x2,0x2,0x1,0x48,0x1,0x8,0x10,0x10,0x10,0x8,0x52,0x80,0xa0,0x40,0x0,0x22,0xaa,0xaa,0x1a,0x20,0x0};

    // LB1
    vars.changeCount = 0;
    vars.level = 1;
    vars.Harley = 0;
    vars.Clayface = 0;
    vars.Bank = 0;
    vars.OOBDoorID = new List<int>() {19, 26, 39, 51, 66, 83, 112, 152, 162, 180, 200, 206, 218}; //This is a list of every end room that ends with a door/OOB door so that the roomsplitter doesn't split when you hit them - which would add unnecessary splits
    vars.statusID = new List<int>() {22, 28, 34, 41, 46, 53, 61, 69, 77, 85, 95, 101, 107, 114, 121, 127, 133, 140, 148, 156, 164, 170, 176, 182, 190, 196, 202, 208, 214, 220, 225, 228}; //This is a list of every status screen roomID, this is used to make the Fades address only stop in those maps, but before the Status value flips to 1

    // LIJ2
    vars.splitDelay = new Stopwatch();
    vars.Count = 0;


    // LTI
    vars.statusDelay = new Stopwatch();
    //vars.versions = new string[]{"LSW1", "LSW2", "TCS", "LIJ1", "LB1", "LIJ2", "1-4", "POTC", "5-7"};
}

onSplit {
    vars.doubleSplit.Start();
}

update {

    if (vars.doubleSplit.ElapsedMilliseconds > 1500) vars.doubleSplit.Reset();

    if (!settings["UTC_timer"]) {
        vars.Helper.Texts.Remove("time");
    } else if (settings["UTC_timer"]) {
        vars.Helper.Texts["time"].Left = "UTC";
        vars.Helper.Texts["time"].Right = DateTime.UtcNow.ToUniversalTime() + "";
    }

    switch (game.ProcessName) {
        case "LEGOStarWarsSaga":
            if (current.roomPath == 0 && current.room == 325 && current.wipe == 0) {
                vars.inCantina = false;
            }
            if (current.room != 325) {
                vars.inCantina = true;
            }
            break;
        case "LEGO The Incredibles_DX11":
            if (old.Status == 1 && current.Status == 0) vars.statusDelay.Start();
            if (vars.statusDelay.ElapsedMilliseconds > 2000) vars.statusDelay.Reset();
            break;
        case "LegoBatman":
            if (old.uiElementChange && !current.uiElementChange) {
                print(vars.changeCount + " -> " + vars.changeCount++);
            }
            if (current.roomID == 0) vars.Clayface = 0;
            if (current.roomID == 10) vars.Clayface = 1;
            break;
    }
}

isLoading{
    switch (game.ProcessName) {
        case "LegoStarwars": //LSW1
            return false;
        case "LegoStarWarsII": //LSW2
            return current.load == 1 || current.endLoad == 1;
        case "LEGOStarWarsSaga": //TCS
            return ((current.gameReboot == 10000) ||
                    ((current.transition == 1) && (old.pause == 0) && (current.areaID != 66) && (current.inCrawl == 0)) ||
                    (current.canskip == 0) ||
                    (current.room == 325 && old.wipe == 1 && current.wipe == 1 && vars.inCantina)) && (current.alttab != 0);
        case "LEGOIndy": //LIJ1
            return current.Loading || current.Loading2 || current.Reset && current.door == 10000 || current.transition && current.menu < 1;
        case "LEGOBatman": //LB1
            return current.loading || current.loading3 || (current.loading4 && current.roomID != 199) || current.Hardload || current.Fades && vars.statusID.Contains(current.roomID) && !current.status || current.Newgame == 4294901760 && current.roomID == 0 && current.Menu == 2|| current.Reset && current.roomID == 0 || current.roomID == 11 && vars.Clayface == 0;
        case "LEGOIndy2": //LIJ2
            return current.Load1 || current.Load2 || current.Load3;
        case "LEGOHarryPotter": //1-4
            return current.Loading;
        case "LEGOPirates": //POTC
            return current.Loading;
        case "harry2": //5-7
            return current.isLoading;
        case "LEGOlotr": // LOTR
            return current.isLoading;
        case "LEGOLCUR_DX11": // LCU
            return !current.Load && !current.Status;
        case "LEGOMARVEL": // LMSH1
            return current.CornerLoads || current.IntoHub || current.OpenGame || current.Fade || current.Fade2;
        case "LEGOEMMET":
            return !current.Load;
        case "LEGOJurassicWorld_DX11":
            return !current.Load && !current.Status;
        case "LEGOSWTFA_DX11":
            return current.Load == 0 && current.Status != 1 || current.Load != 0 && current.Status == 1;
        case "LEGONINJAGO_DX11":
            return current.Loading;
        case "LEGOMARVEL2_DX11":
            return !current.AntiLoading;
        case "LEGO The Incredibles_DX11":
            return !current.Load && current.Status == 0 && !vars.statusDelay.IsRunning;
        case "LEGO DC Super-villains_DX11":
            return !current.Load && !current.Status;
        case "LEGOSTARWARSSKYWALKERSAGA_DX11":
            return current.load == 1 && current.loads == 1;
    }
}

split {
    if (vars.doubleSplit.IsRunning) return false;

    switch (game.ProcessName) {
        case "LegoStarwars":
            return (current.status == 18 && old.status == 0) ||
                    (current.door == "door_8" && current.cutscene == 1);
        case "LegoStarWarsII":
            return (old.status == 0 && current.status == 255 && (!String.IsNullOrEmpty(current.levelBuffer) || current.level2 == "SpeederChase_A")) ||
                    ((current.levelBuffer == "CityEscape_Outro" || current.levelBuffer == "CityEscape_Statu") && old.cutscene == 0 && current.cutscene == 1);
        case "LEGOStarWarsSaga":
            if (current.gogstream == 110) return false;
            return (((vars.levellookup[current.gogstream >> 3] & (1 << (current.gogstream & 7))) != 0) && old.wipe != 0 && current.wipe == 0) ||
                    (current.gogstream == 250 && old.gogstream == 249);
        case "LEGOIndy":
            return (current.statust > old.statust && !current.Loading) ||
                    (current.stream == 67 && old.stream == 66);
        case "LEGOBatman":
            if (vars.Harley == 1)
            {
                vars.Harley = 0;
                return true;
            }
            if (vars.Bank == 1)
            {
                vars.Bank = 0;
                return true;
            }
            return (current.status && !old.status) ||
                    (current.roomID == 152 && current.Hardload && !old.Hardload);
        case "LEGOIndy2":
            //CS1
            if (current.Room==94)
            {
                vars.Count=0;
                vars.splitDelay.Reset();
            }
            if (current.Room==96 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Hangar Havoc
            if (current.Room==96 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==98 && old.Room==97) return true; //Doom Town
            if (current.Room==92 && old.Room==100) return true; //Cafe Chaos
            if (current.Room==102 && current.Cutscene==1 && old.Cutscene==0) return true; //Motorbike Mayhem
            if (current.Room==106 && old.Room==105) return true; //Crane Train

            //CS2
            if (current.Room==109)
            {
                vars.Count=0;
                vars.splitDelay.Reset();
            }
            if (current.Room==110 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Peru Cell Perusal
            if (current.Room==110 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==112 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Tomb Doom
            if (current.Room==112 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==112 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 20000 && current.Room==112 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            if (current.Room==112 && current.Cutscene==1 && vars.Count==3)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==114 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Mac Attack
            if (current.Room==114 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==119 && current.Cutscene==1 && old.Cutscene==0) return true; //Rainforest Rumble
            if (current.Room==116 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Dovchenko Duel
            if (current.Room==116 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }

            //CS3
            if (current.Room==121)
            {
                vars.Count=0;
                vars.splitDelay.Reset();
            }
            if (current.Room==122 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0) //Repair Scare
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==122 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 30000 && current.Room==122 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==122 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==124 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //River Ruckus
            if (current.Room==124 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==126 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Temple Tangle
            if (current.Room==126 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==126 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 38000 && current.Room==126 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            if (current.Room==126 && current.Cutscene==1 && vars.Count==3)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==128 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Ugha Struggle
            if (current.Room==128 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==131 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) //Akator Ambush
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==131 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.splitDelay.Reset();
                vars.Count++;
                vars.splitDelay.Start();
            }
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 10000 && current.Room==131 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.splitDelay.Reset();
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==131 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 25000 && current.Room==131 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            if (current.Room==131 && current.Cutscene==1 && vars.Count==3)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }

            //Raiders
            if (current.Room==54)
            {
                vars.Count=0;
                vars.splitDelay.Reset();
            }
            if (current.Room==55 && vars.Count==0) vars.Count++; //Raven Rescue
            if (current.Room==55 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==57 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0) //Market Mayhem
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==57 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 25000 && current.Room==57 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==57 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==60 && old.Room==59) return true; //Map Room Mystery
            if (current.Room==62 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //After The Ark
            if (current.Room==62 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==64 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0) //Belloq Battle
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==64 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 65000 && current.Room==64 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==64 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }

            //Temple of Doom
            if (current.Room==67) vars.splitDelay.Reset();
            if (current.Room==67 && old.Room !=73 && current.Cutscene==0) vars.Count=0;
            if (current.Room==68 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Lao Chase
            if (current.Room==68 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==71 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0)  //Monkey Mischief
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==71 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 35000 && current.Room==71 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==71 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==73 && current.Cutscene==0 && old.Cutscene==1) vars.Count++; //Malice at the Palace
            if (current.Room==67 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==75 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0) //Temple Tantrum
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==75 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 30000 && current.Room==75 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==75 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==67 && old.Room == 75 && current.Cutscene==1 && old.Cutscene==0) return false;
            if (current.Room==77 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Mola Rampage
            if (current.Room==77 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }

            //The Last Crusade
            if (current.Room==80)
            {
                vars.Count=0;
                vars.splitDelay.Reset();
            }
            if (current.Room==81 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++;  //Coronado Caper
            if (current.Room==81 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 4000 && current.Room==81 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 16000 && current.Room==81 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            if (current.Room==81 && current.Cutscene==1 && vars.Count==3)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (current.Room==83 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Brunwald Blaze
            if (current.Room==83 && current.Cutscene==1 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (current.Room==85 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0) //Berlin Brawl
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 5000 && current.Room==85 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 25000 && current.Room==85 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            if (current.Room==85 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            if (settings["lij2_standard"] && current.Room==87 && current.Cutscene==0 && old.Cutscene==1 && vars.Count==0) vars.Count++; //Cannon Canyon
            else if (settings["lij2_nocut"] && current.Room==87 && vars.Count==0) vars.Count++;
            if (current.Room==87 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count=0;
                return true;
            }
            if (settings["lij2_standard"] && current.Room==89 && vars.Count==0) vars.Count++; //Trial&Terror
            if (settings["lij2_standard"] && current.Room==89 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1)
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            else if(settings["lij2_nocut"] && current.Room==89 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==0)
            {
                vars.Count++;
                vars.splitDelay.Start();
            }
            if (settings["lij2_nocut"] && vars.splitDelay.ElapsedMilliseconds >= 4000 && current.Room==89 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==1) vars.Count++;
            else if (settings["lij2_standard"] && vars.splitDelay.ElapsedMilliseconds >= 23000 && current.Room==89 && current.Cutscene==1 && old.Cutscene==0 && vars.Count==2) vars.Count++;
            if (settings["lij2_nocut"] && current.Room==89 && current.Cutscene==1 && vars.Count==2)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            else if (settings["lij2_standard"] && current.Room==89 && current.Cutscene==1 && vars.Count==3)
            {
                vars.splitDelay.Reset();
                vars.Count=0;
                return true;
            }
            break;
        case "LEGOHarryPotter":
            return current.Head && !old.Head;
        case "LEGOCloneWars":
            return current.status != old.status && current.statust != old.statust;
        case "LEGOPirates":
            return current.Head && !old.Head;
        case "harry2":
            return current.Head && !old.Head;
    }
}
