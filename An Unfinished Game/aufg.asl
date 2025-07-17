state("UnfinishedGame") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

    settings.Add("start", true, "Start on: ");
    settings.Add("start_any", true, "[Any%] Pressing New Game", "start");
    settings.Add("start_ng+", false, "[NG+] Loading into a level", "start");
    settings.Add("split", true, "Split on: ");
    settings.Add("split_level", true, "Completing a level", "split");
    settings.Add("split_credits", true, "Reaching the credits", "split");
    settings.Add("split_bug", false, "Collecting a bug", "split");
    settings.Add("reset", true, "Reset on returning to the main menu");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        //vars.Helper["fade"] = mono.Make<int>("UIManager", "_instance", "prevFadeCoroutine");
        //vars.Helper["paused"] = mono.Make<bool>("PauseMenu", "staticCanOpenMenu", "isPauseMenuOpen");
        //vars.Helper["ms"] = mono.Make<float>("GameManager", "_instance", "_ms");
        //vars.Helper["time"] = mono.Make<float>("GameManager", "_instance", "_timeSpent");
        vars.Helper["loading"] = mono.Make<bool>("SpeedrunningStats", "isLoading");
        vars.Helper["totalTime"] = mono.Make<double>("SpeedrunningStats", "totalTime");
        vars.Helper["levelTime"] = mono.Make<double>("SpeedrunningStats", "levelTime");
        vars.Helper["isRunning"] = mono.Make<int>("SpeedrunningStats", "isRunning");
        vars.Helper["levelID"] = mono.Make<int>("SpeedrunningStats", "levelID");
        vars.Helper["bugsCounter"] = mono.Make<int>("SpeedrunningStats", "bugsCounter");
        vars.Helper["bugsArray"] = mono.MakeArray<bool>("SpeedrunningStats", "bugsArray");
        return true;
    });
    current.activeScene = "";
    current.loadingScene = "";
    refreshRate = 1000;
    vars.splitLevels = new List<int>();
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    //print(current.testloading + "");
    /*
    print("activeScene: " + current.activeScene + "\n" +
            "loadingScene: " + current.loadingScene + "\n" +
            "loading: " + current.loading + "\n" +
            "totalTime: " + current.totalTime + "\n" +
            "levelTime: " + current.levelTime + "\n" +
            "isRunning: " + current.isRunning + "\n" +
            "levelID: " + current.levelID + "\n" +
            "bugsCounter: " + current.bugsCounter + "\n" +
            "bugsArray: " + string.Join(",", current.bugsArray));*/
    if(old.isRunning == 1 && current.isRunning == 2) print("1->2");
    if(old.isRunning == 2 && current.isRunning == 1) print("2->1");

    //if(old.activeScene != current.activeScene) print("Active: " + old.activeScene + "->" + current.activeScene);
    //if(old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene + "->" + current.loadingScene);
    //if(old.fade != current.fade) print("fade: " + old.fade + "->" + current.fade);
    //if(old.ms != current.ms) print("ms: " + old.ms + "->" + current.ms);
}

isLoading {
    return current.loading;
}

start {
    return (settings["start_any"] && old.isRunning == 0 && current.isRunning == 1) ||
           (settings["start_ng+"] && old.activeScene != current.activeScene && old.activeScene == "0_Lobby" && current.activeScene != "MainMenu");
}

onStart {
    vars.splitLevels.Clear();
}

split {
    return (settings["split_level"] && old.levelTime == current.levelTime && old.totalTime != current.totalTime && !vars.splitLevels.Contains(current.levelID)) ||
            (settings["split_credits"] && old.isRunning == 1 && current.isRunning == 3) ||
            (settings["split_bug"] && current.bugsCounter - old.bugsCounter == 1);
}

onSplit {
    vars.splitLevels.Add(current.levelID);
}

reset {
    return settings["reset"] && old.isRunning != 0 && current.isRunning == 0;
}
