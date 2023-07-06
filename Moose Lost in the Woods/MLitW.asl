state("Moose Lost in the Woods") {
    //bool canMove : "mono-2.0-bdwgc.dll", 0x728098, 0x490, 0x120, 0x6BC;
    bool canMove : "mono-2.0-bdwgc.dll", 0x7280F8, 0x88, 0xE78, 0x10, 0x17C;
    bool paused : "mono-2.0-bdwgc.dll", 0x7280F8, 0x88, 0xCE0, 0xB0, 0xB0;
    int talkingToNPC : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0x798, 0x74;           //5 = false, 1 = true
    int inventoryOpen : "mono-2.0-bdwgc.dll", 0x728098, 0xA8, 0x150, 0x420, 0x8;    //0 = false, 8 = true
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on New Game");
    settings.Add("split_level", true, "Split on level change");
    settings.Add("split_end", true, "Split on losing control of player");
    settings.Add("reset", true, "Reset on Main Menu");

    vars.Helper.LoadSceneManager = true;
    vars.watch = new Stopwatch();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["test"] = mono.Make<int>("SCR_PlayerInputManager", "Instance", 0x18, 0x10);

        return true;
    });
}

onStart {
    vars.watch.Reset();
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}

isLoading {
    //return current.activeScene != current.loadingScene;
}

start {
    // Old method
    //return old.activeScene == "MainMenu" && current.activeScene == "Rockland" && settings["start"];
    return !old.canMove && current.talkingToNPC == 5 && current.canMove && current.activeScene == "Rockland" && settings["start"];
}

split {
    // End split fade out time
    if (vars.watch.ElapsedMilliseconds >= 1116) {
        vars.watch.Stop();
        return true;
    }

    // End split, start delay
    if (!current.canMove && old.canMove && current.activeScene == "Deepwoods" && current.talkingToNPC == 5
        && current.inventoryOpen == 0 && !current.paused && settings["split_end"]) {
        vars.watch.Start();
    }

    // All other splits
    return old.activeScene == "Rockland" && current.activeScene == "Marsh" && settings["split_level"] ||
            old.activeScene == "Marsh" && current.activeScene == "Deepwoods" && settings["split_level"];
}

reset {
    return current.activeScene == "MainMenu" && settings["reset"];
}


