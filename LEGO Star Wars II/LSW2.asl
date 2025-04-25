// Made by Biksel
// emu-help by Jujstme: https://github.com/Jujstme/emu-help

// Leia: 18
// Gonk: 12
// Antilles: 202

state("LegoStarWarsII", "PC") {
    int load: 0x26A26C;
    int endLoad: 0x261B40;
    int cutscene: 0x262044;
    //bool status: 0x269A90; //unstable
    byte status: 0x24F389;
    string16 levelBuffer: 0x330671E;
    string14 level2: 0x2FB7AF7;
    //float gametime: 0x330DF8C;
    byte newgame: 0x243BC6;
    int character_p1: 0x241BE0;
    int character_p2: 0x241BE4;
    bool shop: 0x26B7CC;
    int gonkroom: 0x24F374;
    byte level: 0x24C7B4;
    string16 transition: 0x26A281;
}

state("Dolphin") {
}

startup {

    settings.Add("start", true, "Start:");
    settings.Add("startNew", true, "New Game", "start");
    settings.Add("startDestiny", false, "[Free Play] Jedi Destiny", "start");
    settings.Add("startSecret", false, "[Minikit Rush] Secret Plans", "start");
    settings.Add("startIL", false, "[IL] Start on skipping text crawl", "start");
    settings.Add("split", true, "Split: ");
    settings.Add("splitStatus", true, "Split on status screen", "split");
    settings.Add("splitBespinCS", true, "[Any%] Split on Bespin ending cutscene", "split");
    settings.Add("splitTransition", false, "Split on transitions (rooms)", "split");
    settings.Add("gonk", false, "Gonk%");
    settings.Add("gonk_start", true, "Start on New Game", "gonk");
    settings.Add("gonk_split_room", true, "Split on entering outside or inside", "gonk");
    settings.Add("gonk_split_shop", true, "Split on entering and exiting shop", "gonk");
    settings.Add("gonk_split_switch", true, "Split on switching to Gonk on either player", "gonk");
    settings.Add("gonk_reset", true, "Reset on returing to title screen", "gonk");

    var type = Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).GetType("GCN");
    vars.Helper = Activator.CreateInstance(type, args: false);
}

init {
    vars.isEmu = game.ProcessName == "Dolphin";
    vars.Helper.Load = (Func<dynamic, bool>)(emu => {
        emu.MakeString("levelBuffer", 16, 0x80321726);
        emu.MakeString("level2", 14, 0x80271B1F);
        emu.Make<byte>("status", 0x804011CC);
        emu.Make<byte>("newgame", 0x80400BA3);
        emu.Make<int>("cutscene", 0x80401448);
        emu.Make<int>("load", 0x80400D5C);
        emu.Make<int>("character_p1", 0x80400ADC);
        emu.Make<int>("character_p2", 0x80400AE0);
        emu.Make<int>("shop", 0x80401618);
        emu.Make<int>("gonkroom", 0x804011A8);
        return true;
    });
}

isLoading {
    if (!vars.isEmu) return current.load == 1 || (current.endLoad == 1 && current.cutscene ==0);
}

update {
    vars.isEmu = vars.Helper.Update();
    if (vars.isEmu) {
        current.levelBuffer = vars.Helper["levelBuffer"].Current;
        current.level2 = vars.Helper["level2"].Current;
        current.status = vars.Helper["status"].Current;
        current.newgame = vars.Helper["newgame"].Current;
        current.cutscene = vars.Helper["cutscene"].Current;
        current.load = vars.Helper["load"].Current;
        current.endLoad = null;
        current.character_p1 = vars.Helper["character_p1"].Current;
        current.character_p2 = vars.Helper["character_p2"].Current;
        current.shop = vars.Helper["shop"].Current;
        current.gonkroom = vars.Helper["gonkroom"].Current;
    }

    /*
    if (old.load != current.load) print("load: " + old.load + " -> " + current.load);
    if (old.cutscene != current.cutscene) print("cutscene: " + old.cutscene + " -> " + current.cutscene);
    if (old.status != current.status) print("status: " + old.status + " -> " + current.status);
    if (old.levelBuffer != current.levelBuffer) print("levelBuffer: " + old.levelBuffer + " -> " + current.levelBuffer);
    if (old.newgame != current.newgame) print("newgame: " + old.newgame + " -> " + current.newgame);
    if (!vars.isEmu) if (old.endLoad != current.endLoad) print("endLoad: " + old.endLoad + " -> " + current.endLoad);
    */
    //if (old.gonkroom != current.gonkroom) print("gonkroom: " + old.gonkroom + " -> " + current.gonkroom);
    //if (old.endLoad != current.endLoad) print("endLoad: " + old.endLoad + " -> " + current.endLoad);
}

start {
    return ((settings["startNew"] || settings["gonk_start"]) && !vars.isEmu && old.newgame == 0 && current.newgame == 1 && current.status == 255) ||
            (settings["startDestiny"] && old.load == 1 && current.load == 0 && current.levelBuffer == "Fight_A\\EmperorF") ||
            (settings["startSecret"] && old.load == 1 && current.load == 0 && current.levelBuffer == "adeRunner_A\\Bloc") ||
            (settings["startIL"] && old.load == 1 && current.load == 0 && old.endLoad == 2 && current.endLoad == 0 && (current.level != 0x1C || current.level != 0xFF)) ||
            (settings["gonk_start"] && vars.isEmu && old.gonkroom == -1 && current.gonkroom == 50);
}

split {
    return (settings["splitStatus"] && old.status == 0 && current.status == 255 && (!String.IsNullOrEmpty(current.levelBuffer) || current.level2 == "SpeederChase_A")) ||
        (settings["splitBespinCS"] && (current.levelBuffer == "CityEscape_Outro" || current.levelBuffer == "CityEscape_Statu") && old.cutscene == 0 && current.cutscene == 1) ||
        (settings["splitTransition"] && old.transition != current.transition) ||
        (settings["gonk_split_room"] && (old.gonkroom == 50 && current.gonkroom == 44 || old.gonkroom == 44 && current.gonkroom == 50)) ||
        (settings["gonk_split_shop"] && (old.shop != current.shop))||
        (settings["gonk_split_switch"] && (old.character_p2 != 12 && current.character_p2 == 12) || (old.character_p1 != 12 && current.character_p1 == 12));

}

reset {
    return (settings["gonk_reset"] && !vars.isEmu && old.newgame == 1 && current.newgame == 0 ) ||
            (settings["gonk_reset"] && vars.isEmu && (old.gonkroom == 50 || old.gonkroom == 44) && current.gonkroom == -1);
}

shutdown {
    vars.Helper.Dispose();
}

exit {
    timer.IsGameTimePaused = false;
}
