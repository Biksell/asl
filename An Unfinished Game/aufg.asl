state("UnfinishedGame") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

    settings.Add("demo", true, "Demo: ");
    settings.Add("start", true, "Start on starting New Game");
    settings.Add("split", true, "Split on finishing a level (Intro included)");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["fade"] = mono.Make<int>("UIManager", "_instance", "prevFadeCoroutine");
        //vars.Helper["paused"] = mono.Make<bool>("PauseMenu", "staticCanOpenMenu", "isPauseMenuOpen");
        vars.Helper["ms"] = mono.Make<float>("GameManager", "_instance", "_ms");
        vars.Helper["time"] = mono.Make<float>("GameManager", "_instance", "_timeSpent");
        return true;
    });
    current.activeScene = "";
    current.loadingScene = "";
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if(old.activeScene != current.activeScene) print("Active: " + old.activeScene + "->" + current.activeScene);
    if(old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene + "->" + current.loadingScene);
    if(old.fade != current.fade) print("fade: " + old.fade + "->" + current.fade);
    if(old.ms != current.ms) print("ms: " + old.ms + "->" + current.ms);
}

isLoading {
    return current.loadingScene != current.activeScene;
}

start {
    return settings["start"] && current.activeScene == "MainMenu" && old.fade == 0 && current.fade != 0;
}

split {
    return settings["split"] (old.ms != current.ms && current.ms != 0f) || (old.activeScene == "0_LobbyDemo" && current.activeScene == "01_Tutorial");
}
