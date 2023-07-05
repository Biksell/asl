// Couldn't find a static entry point, so doesn't work

state("Moose Lost in the Woods") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.Helper.LoadSceneManager = true;
}

isLoading {
    return current.activeScene != current.loadingScene;
}

start {
    return old.activeScene == "MainMenu" && current.activeScene == "Rockland";
}

split {
    return old.activeScene == "Rockland" && current.activeScene == "Marsh" ||
            old.activeScene == "Marsh" && current.activeScene == "Deepwoods";
}

reset {
    return current.activeScene == "MainMenu";
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    //print(current.activeScene + " " + current.loadingScene);

    //if (old.activeScene != current.activeScene) print(old.activeScene + " " + current.activeScene);
}
