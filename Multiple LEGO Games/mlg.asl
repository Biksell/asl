/*
Multiple LEGO Games- autosplitter
Supports Grunt% load removal

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

state("LegoStarwars", "LSW1") {}

state("LegoStarWarsII", "LSW2") {
    int load: 0x26A26C;
    int endLoad: 0x24F394;
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
}

state("LEGOIndy", "LIJ1") {
    int stream : 0x6CC944;
    bool Loading: 0x5C3D24;
    bool Loading2: 0x6CC7A8;
}

state("LEGOBatman", "LB1") {
    bool loading: 0x5C999C;
    bool loading2: 0x696D2C;
    bool loading3: 0x6CA7B0;
    bool loading4: 0x6B29D0;
    int roomID : 0x6C98C4;
}

state("LEGOIndy2", "LIJ2") {
    bool Load1: 0xB0F5C8;
    bool Load2: 0xACBF08;
    bool Load3: 0xC5B838;
}

state("LEGOHarryPotter", "1-4") {
    bool Loading: 0xA28510;
}

state("LEGOPirates", "POTC") {
    bool Loading: 0xA171A4;
}

state("harry2", "5-7") {
    bool isLoading: 0xC59978;
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

startup {}

init {
    // TCS
    vars.inCantina = false;

    // LTI
    vars.statusDelay = new Stopwatch();
    //vars.versions = new string[]{"LSW1", "LSW2", "TCS", "LIJ1", "LB1", "LIJ2", "1-4", "POTC", "5-7"};
}

update {
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
            return current.Loading || current.Loading2 || current.Reset && current.stream == 0;
        case "LEGOBatman": //LB1
            return current.loading || current.loading2 || current.loading3 || (current.loading4 && current.roomID != 199);
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
