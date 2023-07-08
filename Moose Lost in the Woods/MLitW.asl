// Credits to Ero for making asl-help
state("Moose Lost in the Woods") {
    bool canMove : "mono-2.0-bdwgc.dll", 0x7280F8, 0x88, 0xE78, 0x10, 0x17C;
    bool paused : "mono-2.0-bdwgc.dll", 0x7280F8, 0x88, 0xCE0, 0xB0, 0xB0;
    int talkingToNPC : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0x798, 0x74;           //5 = false, 1 = true
    int inventoryOpen : "mono-2.0-bdwgc.dll", 0x728098, 0xA8, 0x150, 0x420, 0x8;    //0 = false, 8 = true
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on New Game");
    settings.Add("split_level", true, "Split on level change");
    settings.Add("split_end", true, "Split ending (!!ONLY WORKS IN ANY% AND NO MAJOR SKIPS!!)");
    settings.Add("reset", true, "Reset on Main Menu");

    vars.Helper.LoadSceneManager = true;
    vars.splitDelay = new Stopwatch();  // Handles end split delay
    vars.talkDelay = new Stopwatch();  // Makes sure timer doesn't start on Rockland when talking to an NPC
    vars.hasStarted = false;
}

onReset {
    vars.splitDelay.Reset();
    vars.hasStarted = false;
}

onStart {
    vars.hasStarted = true;
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if (vars.talkDelay.ElapsedMilliseconds > 200) vars.talkDelay.Reset();

    if (!vars.hasStarted && old.talkingToNPC == 1 && current.talkingToNPC == 5) {
        vars.talkDelay.Start();
    }
}

start {
    // Old method
    //return old.activeScene == "MainMenu" && current.activeScene == "Rockland" && settings["start"];
    return !old.canMove && current.canMove && current.activeScene == "Rockland" && settings["start"] &&
            old.talkingToNPC == 5 && !old.paused && old.inventoryOpen == 0 && vars.talkDelay.ElapsedMilliseconds == 0;
}

split {
    // End split fade out time
    if (vars.splitDelay.ElapsedMilliseconds >= 1133) {
        vars.splitDelay.Reset();
        return true;
    }

    // End split, start delay
    if (!current.canMove && old.canMove && current.activeScene == "Deepwoods" && current.talkingToNPC == 5
        && current.inventoryOpen == 0 && !current.paused && settings["split_end"]) {
        vars.splitDelay.Start();
    }

    // All other splits
    return old.activeScene == "Rockland" && current.activeScene == "Marsh" && settings["split_level"] ||
            old.activeScene == "Marsh" && current.activeScene == "Deepwoods" && settings["split_level"];
}

reset {
    return current.activeScene == "MainMenu" && settings["reset"];
}


