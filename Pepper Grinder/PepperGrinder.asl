// Made by Biksel
state("PepperGrinder") {
    string32 level: 0x452B1D1;
    double igt: 0x24E7188;
    bool mainMenu: 0x4682C10;
    bool map: 0x316907C;
    int lastPause: 0x2FD3854; //3 before main menu, 1 after, prevents starting on game startup
    int lastPause2: 0x3048A40; //1 in main menu, random elsewhere, prevents starting on load game
    double hp: 0x452B290;
    bool pauseLvl1: 0x4649038, 0x2E0, 0x18, 0x120;
}

startup {
    vars.Levels = new List<string>() {
        "LOST CLAIM",
        "WELLSPRING CANYON",
        "HEADSTONE PEAK",
        "BEETLE RIDER",
        "MAGMAWORKS",
        "POISON GAS PASS", // In game: POISON RIDGE
        "GIANT'S KITCHEN",
        "WHEELBIT PITS", // In game: ROTOBURR PITS
        "DRILLWORM", // In game: MAGMAWORM
        "CANNON CLIMB",
        "BRITTLE  GLACIER",
        "SEA OF TEETH",
        "BREAKER PASS",
        "MINT'S CONVOY",
        "ICEMELT MARSH",
        "WITCHFIRE BOG",
        "SUNKEN CITY LIMITS",
        "TERMINAL DEPTHS",
        "DEEPROT CITY",
        "EMPEROR NARO"
    };
    vars.ended = false;
    vars.lastPause = new Stopwatch();
    vars.lastSplit = new Stopwatch();
    vars.hits = 0;
    vars.firstSplit = false;

    vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
            var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
            var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
            timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

            textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
            textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});

    vars.UpdateHitCounter = (Action<int>)((hits) =>
    {
        vars.SetTextComponent("Hit count: ", hits.ToString());
    });

    settings.Add("hitcount", false, "Hit Counter");
}

update {
    // Prevent split on exiting level without completion
    if (old.pauseLvl1 && !current.pauseLvl1) {
        vars.lastPause.Start();
    }
    if (vars.lastPause.ElapsedMilliseconds > 100) {
        vars.lastPause.Reset();
    }

    // Fix doublesplitting because of values being dumb
    if (vars.lastSplit.ElapsedMilliseconds > 500) {
        vars.lastSplit.Reset();
    }

    // Hitcounter update
    if(settings["hitcount"]) {
        if(old.hp != current.hp && (old.hp - current.hp) == 1) {
            vars.hits += 1;
        }
        vars.UpdateHitCounter(vars.hits);
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
    return current.map || (current.mainMenu && current.lastPause2 == 1);
}

onStart {
    vars.ended = false;
    vars.hits = 0;
    vars.firstSplit = false;
}

onSplit {
    vars.firstSplit = true;
    vars.lastSplit.Start();
}

start {
    return old.mainMenu && !current.mainMenu && current.lastPause != 3 && current.lastPause2 == 1;
}

split {
    // Doublesplits
    if (vars.lastSplit.ElapsedMilliseconds > 0) return false;

    // Most splits
    if (vars.Levels.Contains(old.level) && String.IsNullOrEmpty(current.level)) return true;

    // First split
    if (!vars.firstSplit && !old.map && current.map && vars.lastPause.ElapsedMilliseconds == 0 && String.IsNullOrEmpty(old.level) && String.IsNullOrEmpty(current.level)) return true;

    // Final split
    if (current.level == "EMPEROR NARO" && current.igt != 0 && current.mainMenu && !vars.ended) {
        vars.ended = true;
        return true;
    }
}
