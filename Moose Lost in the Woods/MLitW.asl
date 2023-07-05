// Couldn't find a static entry point, so doesn't work

state("Moose Lost in the Woods") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on New Game (set an offset of around -2.3 to match with timing rules)");
    settings.Add("split_level", true, "Split on level change");
    settings.Add("split_end", true, "Split on credits roll (not current timing rules)");
    settings.Add("reset", true, "Reset on Main Menu");

    vars.Helper.LoadSceneManager = true;
}

isLoading {
    return current.activeScene != current.loadingScene;
}

start {
    return old.activeScene == "MainMenu" && current.activeScene == "Rockland" && settings["start"];
}

split {
    return old.activeScene == "Rockland" && current.activeScene == "Marsh" && settings["split_level"] ||
            old.activeScene == "Marsh" && current.activeScene == "Deepwoods" && settings["split_level"] ||
            old.activeScene == "Deepwoods" && current.activeScene == "Credits" && settings["split_end"] ;
}

reset {
    return current.activeScene == "MainMenu" && settings["reset"];
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}
