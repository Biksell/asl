// Couldn't find a static entry point, so doesn't work

state("Moose Lost in the Woods") {
    //bool canMove : "mono-2.0-bdwgc.dll", 0x728098, 0x490, 0x120, 0x6BC;
    bool canMove : "mono-2.0-bdwgc.dll", 0x7280F8, 0x88, 0xE78, 0x10, 0x17C;
    int talkingToNPC : "mono-2.0-bdwgc.dll", 0x7280F8, 0xA0, 0x798, 0x74;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on New Game");
    settings.Add("split_level", true, "Split on level change");
    settings.Add("split_end", true, "Split on losing control of player");
    settings.Add("reset", true, "Reset on Main Menu");

    vars.Helper.LoadSceneManager = true;
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["test"] = mono.Make<int>("SCR_PlayerInputManager", "Instance", 0x18, 0x10);

        return true;
    });
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
    print(current.talkingToNPC.ToString());
    //print(current.test.ToString());
}

isLoading {
    return current.activeScene != current.loadingScene;
}

start {
    // Old method
    //return old.activeScene == "MainMenu" && current.activeScene == "Rockland" && settings["start"];
    return !old.canMove && current.talkingToNPC == 5 && current.canMove && current.activeScene == "Rockland" && settings["start"];
}

split {
    return old.activeScene == "Rockland" && current.activeScene == "Marsh" && settings["split_level"] ||
            old.activeScene == "Marsh" && current.activeScene == "Deepwoods" && settings["split_level"] ||
            //old.activeScene == "Deepwoods" && current.activeScene == "Credits" && settings["split_end"] ;
            old.canMove && !current.canMove && current.talkingToNPC == 5 && current.activeScene == "Deepwoods" && settings["split_end"];
}

reset {
    return current.activeScene == "MainMenu" && settings["reset"];
}


