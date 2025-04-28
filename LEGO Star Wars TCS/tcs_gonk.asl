/*
Qui-Qon: 471982520
Obi-Wan: 471956648
Gonk: 471978208
*/

state("LEGOStarWarsSaga") {
    int charP1: 0x53D810;
    int charP2: 0x53D834;
    bool shop: 0x480494;
    int room: 0x5513d0;
    int gogstream: 0x551bc0;
    byte gognewgame : 0x47b758;
}

init {
    settings.Add("load", true, "THIS SCRIPT DOES NOT HAVE LOAD REMOVAL. ACTIVATE THE BUILT-IN SCRIPT FOR THAT.");
    settings.Add("start", true, "Start on new game");
    settings.Add("split_room", true, "Split on entering outside or inside");
    settings.Add("split_shop", true, "Split on entering and exiting shop");
    settings.Add("split_switch", true, "Split on switching to Gonk on either player");
    settings.Add("reset", true, "Reset on returning to title screen");
    vars.roomSplits = 0;
}

start {
    return settings["start"] && old.gognewgame == 0 && current.gognewgame == 1;
}


split {
    return (settings["split_room"] && old.room == 469889996 && current.room == 469890292 || old.room == 469890292 && current.room == 469889996) ||
            (settings["split_shop"] && old.shop == 0 && current.shop == 1 || old.shop == 1 && current.shop == 0) ||
            (settings["split_switch"] && (old.charP1 != current.charP1 && current.charP1 == 471978208 || old.charP2 != current.charP2 && current.charP2 == 471978208));
}

reset {
    return settings["reset"] && old.gogstream != 0 && current.gogstream == 0;
}
