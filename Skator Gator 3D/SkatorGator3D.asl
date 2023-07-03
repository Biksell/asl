// Reminder; Game has better IGT access as well, but the UI time is used for easier verification
// Made by Biksel, credits to Ero for making asl-help and for helping witha more accurate total IGT calculation
// v1.1
state("SG3D_Windows_64_SteamVersion_Demo") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.completedLevels = new HashSet<String>();
    vars.Levels = new List<string>() {"Level_01_Intro", "Level_03_Day", "Level_05_Sunset", "Level_08"};
    vars.totalIGT = new TimeSpan();

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
    vars.totalIGT = TimeSpan.Zero;
    current.igt = TimeSpan.Zero;
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if(vars.Levels.Contains(current.activeScene))
        current.igt = new TimeSpan(0, 0, current.minutes, current.seconds, current.milliSeconds * 10);
    else
        current.igt = TimeSpan.Zero;
}

gameTime {
    if (old.igt > current.igt)
        vars.totalIGT += old.igt;
    return vars.totalIGT + current.igt;
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
