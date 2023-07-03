// Reminder; Game has better IGT access as well, but the UI time is used for easier verification
// Made by Biksel, credits to Ero for making asl-help
// v1.1
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
        vars.Helper["paused"] = mono.Make<bool>("UIManager", 1, "m_Instance", "_paused");
        vars.Helper["minutes"] = mono.Make<int>("UIManager", 1, "m_Instance", "_minutes");
        vars.Helper["seconds"] = mono.Make<int>("UIManager", 1, "m_Instance", "_seconds");
        vars.Helper["milliSeconds"] = mono.Make<int>("UIManager", 1, "m_Instance", "_milliseconds");
        return true;
    });
}

onStart {
    vars.completedLevels.Clear();
    vars.totalIGT = 0f;
}

update {
    float deltaTime = (current.minutes * 60f + current.seconds * 1f + current.milliSeconds / 100f) - (old.minutes * 60f + old.seconds * 1f + old.milliSeconds / 100f);
    if (deltaTime > 0f && deltaTime < 1f) {
        vars.totalIGT += deltaTime;
    }

    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;
}

gameTime{
    return TimeSpan.FromSeconds(vars.totalIGT);
}

isLoading {
    return true;
}

start {
    return (current.activeScene == "MainMenu" && current.loadingScene == "LoadingSceneEmpty") || // Continue
            (vars.completedLevels.Count == 0 && current.activeScene == "LoadingSceneEmpty" && current.loadingScene == "CutsceneScene"); // New Game
}

split {
    // Doesn't currently split at the end, couldn't find a condition that would fit it
    if (vars.Levels.Contains(current.activeScene) && current.loadingScene == "LoadingSceneEmpty" && vars.completedLevels.Add(current.activeScene) && !current.paused) {
        return true;
    }

}

reset {
    return old.paused && current.loadingScene == "LoadingSceneEmpty";
}
