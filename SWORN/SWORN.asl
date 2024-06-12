state("SWORN") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();

    settings.Add("split", true, "Split after: ");
    settings.Add("split_room", false, "Every room", "split");
    settings.Add("split_boss", true, "Only Boss arenas", "split");
    settings.Add("split_end", true, "Finish", "split");
    settings.Add("reset", true, "Reset on returning to hub");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["GameTime"] = mono.Make<float>("OverlayUI", "instance", "gameTimer", "time");
        vars.Helper["finished"] = mono.Make<bool>("OverlayUI", "instance", "gamemode", "HasFinishedThisRun");
        vars.Helper["finalLevels"] = mono.MakeString("ScoreboardUI", "Instance", "levelCompleted", "m_Text");
        vars.Helper["levelCompleted"] = mono.Make<int>("ScoreboardUI", "Instance", "playerStatsManager", "levelCompleted");
        return true;
    });

    vars.lastCompleted = 0;

    vars.bossArenas = new List<string>() {
        "Kingswood - Bane Of Crows Arena (level scene)",
        "Kingswood - Questing Beast Arena (level scene)",
        "Kingswood - Gawain Arena Final (level scene)"
    };
}

update {
    try {
        current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
        current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

        if(old.activeScene != current.activeScene) print("Active: " + old.activeScene + "->" + current.activeScene);
        if(old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene + "->" + current.loadingScene);
    } catch (System.Exception) {
    }

    if(old.finished != current.finished) print("finished: " + old.finished + " -> " + current.finished);
    if(old.finalLevels != current.finalLevels) print("levelCompleted: " + old.finalLevels + " -> " + current.finalLevels);
    if(old.levelCompleted != current.levelCompleted) print("levelCompleted: " + old.levelCompleted + " -> " + current.levelCompleted);

    //print(current.GameTime + "");
}

onSplit {
    vars.lastCompleted++;
}

onStart {
    vars.lastCompleted = 0;
}

start {
    return !current.finished && old.GameTime == 0f && current.GameTime > 0f;
}

split {
    return (settings["split"] && settings["split_room"] && old.levelCompleted != current.levelCompleted && current.levelCompleted - vars.lastCompleted == 1 ||
            //settings["split"] && settings["split_boss"] && (old.levelCompleted == 6 && current.levelCompleted == 7 || old.levelCompleted == 15 && current.levelCompleted == 16) ||
            settings["split"] && settings["split_boss"] && vars.bossArenas.Contains(old.activeScene) && old.activeScene != current.activeScene && !current.finished||
            settings["split"] && settings["split_end"] && !old.finished && current.finished && current.levelCompleted == 28);
}

reset {
    return old.activeScene != current.activeScene && current.activeScene == "Hub Area (level scene)";
}

gameTime {
    return TimeSpan.FromSeconds(current.GameTime);
}

isLoading {
    return true;
}
