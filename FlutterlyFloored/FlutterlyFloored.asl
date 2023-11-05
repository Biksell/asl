state("Flutterly_Floored") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["igt"] = mono.Make<float>("GameTimer", 1, "_instance", "elapsedTime");
        vars.Helper["timerRunning"] = mono.Make<bool>("GameTimer", 1, "_instance", "timerRunning");
        return true;
    });
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if(old.activeScene != current.activeScene) print(old.activeScene + "->" + current.activeScene);
    if(old.loadingScene != current.loadingScene) print(old.loadingScene + "->" + current.loadingScene);

    print(current.igt.ToString());
}

gameTime {
    //return new TimeSpan(current.igt);
}
