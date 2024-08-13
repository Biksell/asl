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

state("LEGOIndy", "LIJ1")
{
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

state("LEGOHarryPotter", "1-4")
{
    bool Loading: 0xA28510;
}


state("LEGOPirates", "POTC")
{
    bool Loading: 0xA171A4;
}

state("harry2", "5-7")
{
    bool isLoading: 0xC59978;
}

startup {}

init {
    // TCS
    vars.inCantine = false;
    vars.versions = new string[]{"LSW1", "LSW2", "TCS", "LIJ1", "LB1",
                                "LIJ2", "1-4", "POTC", "5-7"};
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
        case "harry2": //5-7
            return current.isLoading;
        case "LEGOPirates": //POTC
            return current.Loading;
    }
}
