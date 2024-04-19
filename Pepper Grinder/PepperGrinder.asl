// Made by Biksel
// asl-help by ero (https://github.com/just-ero/asl-help/)

state("PepperGrinder", "1.0") {
    string32 level: 0x452B1D1;
    double igt: 0x24E7188;
    bool mainMenu: 0x4682C10;
    bool map: 0x316907C;
    int safety: 0x2FD3854; //3 before main menu, 1 after, prevents starting on game startup
    int safety2: 0x3048A40; //1 in main menu, random elsewhere, prevents starting on load game
    double hp: 0x452B290;
    bool pauseLvl1: 0x4649038, 0x2E0, 0x18, 0x120;
}

state("PepperGrinder", "1.1") {
    bool map: 0x318DDDC;
}

init {
    switch (modules.First().ModuleMemorySize) {
        case 75411456:
            version = "1.1";
            break;
        case 75042816:
            version = "1.0";
            return;
    }
}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Levels = new List<string>() {
        "LOST CLAIM",
        "WELLSPRING CANYON",
        "HEADSTONE PEAK",
        "CANNONEER'S FOLLY",
        "BEETLE RIDER",
        "MAGMAWORKS",
        "POISON GAS PASS", // In game: POISON RIDGE
        "MARAUDER BEACH",
        "GIANT'S KITCHEN",
        "WHEELBIT PITS", // In game: ROTOBURR PITS
        "DRILLWORM", // In game: MAGMAWORM
        "CANNON CLIMB",
        "BRITTLE  GLACIER",
        "SEA OF TEETH",
        "AVALANCHE",
        "BREAKER PASS",
        "MINT'S CONVOY",
        "ICEMELT MARSH",
        "WITCHFIRE BOG",
        "SUNKEN CITY LIMITS",
        "TERMINAL DEPTHS",
        "DEEPROT CITY",
        "EMPEROR NARO"
    };

    vars.AltLevels = new List<string>() {
        "HEADSTONE PEAK",
        "CANNONEER'S FOLLY",
        "POISON GAS PASS",
        "MARAUDER BEACH",
        "SEA OF TEETH",
        "AVALANCHE",
        "SUNKEN CITY LIMITS",
        "WITCHFIRE BOG"
    };

    vars.ended = false;
    vars.lastPause = new Stopwatch();
    vars.lastSplit = new Stopwatch();
    vars.hits = 0;
    vars.firstSplit = false;

    settings.Add("split_main", true, "Split on: ");
    settings.Add("splitComplete", true, "Level completion fade out (Any%)", "split_main");
    settings.Add("exitStage", false, "Exiting stage (All Skull Coins)", "split_main");
    settings.Add("shopSplit", false, "Exiting shop (100%)", "split_main");
    settings.Add("misc", false, "Miscellaneous (optional)");
    settings.Add("hitcount", false, "Show Hit Counter", "misc");
}

update {
    // Prevent split on exiting level1 without completion
    //print(modules.First().ModuleMemorySize + "");
    if (version == "1.1") print("aa");
    if (version == "1.1") return;
    if (old.pauseLvl1 && !current.pauseLvl1) {
        vars.lastPause.Start();
    }
    if (vars.lastPause.ElapsedMilliseconds > 500) {
        vars.lastPause.Reset();
    }

    // Fix doublesplitting because of values being dumb
    if (vars.lastSplit.ElapsedMilliseconds > 500) {
        vars.lastSplit.Reset();
    }

    // Hitcounter update
    if (settings["hitcount"]) {
        if(old.hp != current.hp && (old.hp - current.hp) == 1) {
            vars.hits += 1;
            vars.Helper.Texts["hitcount"].Right = vars.hits + "";
        }
    }

    // Debug
    if (old.level != current.level) {
        print("Level: " + old.level + " -> " + current.level);
    }
    if (old.mainMenu != current.mainMenu) {
        print("MainMenu: " + old.mainMenu + " -> " + current.mainMenu);
    }
    if (old.map != current.map) {
        print("Map: " + old.map + " -> " + current.map);
    }
}

isLoading {
    return current.map || (current.mainMenu && current.safety2 == 1);
}

onStart {
    if (version == "1.0") {
        vars.ended = false;
        vars.hits = 0;
        vars.firstSplit = false;

        if (settings["hitcount"]) {
            vars.Helper.Texts["hitcount"].Left = "Hit count: ";
            vars.Helper.Texts["hitcount"].Right = vars.hits + "";
        }
        else if (!settings["hitcount"]) vars.Helper.Texts.Remove("hitcount");
    }
}

onSplit {
    if (version == "1.0") {
        vars.firstSplit = true;
        vars.lastSplit.Start();
    }
}

start {
    if (version == "1.0") {
        return old.mainMenu && !current.mainMenu && current.safety != 3 && current.safety2 == 1;
    }
}

split {
    if (version == "1.0") {
        // Doublesplits
        if (vars.lastSplit.IsRunning) return false;

        // Most splits
        if (settings["splitComplete"] && vars.Levels.Contains(old.level) && String.IsNullOrEmpty(current.level)) return true;

        // First split
        if (settings["splitComplete"] && !vars.firstSplit && !old.map && current.map && !vars.lastPause.IsRunning && String.IsNullOrEmpty(old.level) && String.IsNullOrEmpty(current.level)) return true;

        // Final split
        if (current.level == "EMPEROR NARO" && current.igt != 0 && current.mainMenu && !vars.ended) {
            vars.ended = true;
            return true;
        }

        // All Skull Coins (exit bonus stage before completion on extra levels and the alternative route to them)
        if (settings["exitStage"] && vars.AltLevels.Contains(current.level) && !old.map && current.map) return true;

        // 100% Shop split (Both exit through pausing and normally)
        if (settings["shopSplit"] && current.level == "CURIOSITY SHOP" && !old.map && current.map) return true;
    }
}
