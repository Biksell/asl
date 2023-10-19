// Credits to Ero for making asl-help
state("ThePortraits") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.Helper.LoadSceneManager = true;
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["isShitting"] = mono.Make<bool>("GameManager", "IsShitting");
        vars.Helper["interaction"] = mono.Make<bool>("GameManager", "Player", "FPSController", "currentInteraction");
        return true;
    });
}

isLoading {
    return current.loadingScene != current.activeScene;
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if (old.activeScene != current.activeScene) print("Active: " + old.activeScene  + " -> " + current.activeScene);
    if (old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene  + " -> " + current.loadingScene);
    if (old.interaction != current.interaction) print("Interaction: " + old.interaction + "->" + current.interaction);
    print(current.journalEntries.ToString());
}

start {
    return old.activeScene == "TitleScreen" && current.activeScene == "Indoors";
}

split {
    return old.activeScene == "Ending" && current.activeScene == "Credits";
}

reset {
    return old.activeScene != "TitleScreen" && current.activeScene == "TitleScreen";
}
