/*
Qui-Qon: 104
Obi-Wan: 1
Gonk: 17
*/

state("LEGOStarWarsSaga") {
    byte charP1: 0x402BD8;
    byte charP2: 0x402BDC;
    bool shop: 0x480494;
    int room: 0x5513d0;
    int gogstream: 0x551bc0;
    byte gognewgame : 0x47b758;
    byte icon: 0x2454FAB;
}

startup {
    settings.Add("load", true, "THIS SCRIPT DOES NOT HAVE LOAD REMOVAL. ACTIVATE THE BUILT-IN SCRIPT FOR THAT.");
    settings.Add("start", true, "Start on new game");
    settings.Add("split_room", true, "Split on entering outside or inside");
    settings.Add("split_shop_enter", true, "Split on entering shop");
    settings.Add("split_switch", true, "Split on switching to Gonk on either player");
    settings.Add("reset", true, "Reset on returning to title screen");
    vars.roomSplits = 0;
    vars.shopSplits = 0;
    refreshRate = 255;
}

init {
    vars.gonkSwitch = new Stopwatch();
    vars.splitDelay = new Stopwatch();
}

start {
    return settings["start"] && old.gognewgame == 0 && current.gognewgame == 1;
}

onStart {
    vars.roomSplits = 0;
    vars.shopSplits = 0;
}

update {
    if ((old.charP1 != current.charP1 && current.charP1 == 17 || old.charP2 != current.charP2 && current.charP2 == 17)) {
        vars.gonkSwitch.Start();
    }
    if (vars.gonkSwitch.IsRunning && old.icon == 61 && current.icon == 62) vars.splitDelay.Start();
    if (vars.gonkSwitch.ElapsedMilliseconds > 200) vars.gonkSwitch.Reset();
    if (vars.splitDelay.ElapsedMilliseconds > 50) vars.gonkSwitch.Reset();
}

split {
    return (settings["split_room"] && vars.roomSplits < 2 && (old.room != current.room && current.room != 0)) ||
            (settings["split_shop_enter"] && vars.shopSplits == 0 && !old.shop && current.shop) ||
            (settings["split_switch"] && vars.splitDelay.ElapsedMilliseconds > 1 * (1000 / 60));
}

onSplit {
    if (current.shop) {
        vars.shopSplits++;
    } else if (current.room != 0) {
        vars.roomSplits++;
    }
}

reset {
    return settings["reset"] && old.gogstream != 0 && current.gogstream == 0;
}
