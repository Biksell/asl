state("SG3D_Windows_64_SteamVersion_Demo") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.completedLevels = new HashSet<String>();
    vars.Levels = new List<string>() {"Level_01_Intro", "Level_03_Day", "Level_05_Sunset", "Level_08"};
    vars.totalIGT = 0f;

    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["igt"] = mono.Make<float>("GameManager", 1, "m_Instance", "_curTime");
        vars.Helper["paused"] = mono.Make<bool>("UIManager", 1, "m_Instance", "_paused");
        return true;
    });
}

onStart {
    vars.completedLevels.Clear();
    vars.totalIGT = 0f;
}

update {
    float deltaTime = current.igt - old.igt;
    if (deltaTime > 0f && deltaTime < 1f) {
        vars.totalIGT += deltaTime;
    }

    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}

gameTime{
    return TimeSpan.FromSeconds(vars.totalIGT);
}

start {
    return (current.activeScene == "MainMenu" && current.loadingScene == "LoadingSceneEmpty") || // Continue
            (vars.completedLevels.Count == 0 && current.activeScene == "LoadingSceneEmpty" && current.loadingScene == "CutsceneScene"); // New Game
}

split {
    // Doesn't currently split at the end, couldn't find a condition that would fit it
    return vars.Levels.Contains(current.activeScene) && current.loadingScene == "LoadingSceneEmpty" && vars.completedLevels.Add(current.activeScene) && !current.paused;
}

reset {
    return old.paused && current.loadingScene == "LoadingSceneEmpty";
}
