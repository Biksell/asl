// Made by Biksel
// asl-help by ero (https://github.com/just-ero/asl-help/)

state("SWORN Demo") {
    float GameTime: "GameAssembly.dll", 0x4a1fd28, 0xB8, 0x0, 0xA8, 0x60;
    bool finished: "GameAssembly.dll", 0x4a57fc8, 0x140, 0x0, 0xA8, 0x198;
    int levelCompleted: "GameAssembly.dll", 0x4a46a68, 0xB8, 0x0, 0x98, 0xB0;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();

    settings.Add("split", true, "Split after: (Only Boss & Finish recommended)");
    settings.Add("split_room", false, "Every room", "split");
    settings.Add("split_boss", true, "Only Boss arenas", "split");
    settings.Add("split_end", true, "Finish", "split");
    settings.Add("reset", true, "Reset on returning to hub");
}

init {
    /*
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["GameTime"] = mono.Make<float>("OverlayUI", "instance", "gameTimer", "time");
        vars.Helper["finished"] = mono.Make<bool>("OverlayUI", "instance", "gamemode", "HasFinishedThisRun");
        vars.Helper["finalLevels"] = mono.MakeString("ScoreboardUI", "Instance", "levelCompleted", "m_Text");
        vars.Helper["levelCompleted"] = mono.Make<int>("ScoreboardUI", "Instance", "playerStatsManager", "levelCompleted");
        return true;
    });*/

    vars.bossArenas = new List<string>() {
        "b370d40fbca123841b3ceea0a5a16186", //"Kingswood - Bane Of Crows Arena (level scene)", //
        "85d9faf8534a99048b624a6dfd9caf67", //"Kingswood - Questing Beast Arena (level scene)", //
        "d252359acf8dc4542ab7cc1fc4db1ad7", //"Kingswood - Gawain Arena Final (level scene)", //
        "dd7795900c12d084aada9c4b442aa295", //"Cornucopia - Mauler Rat Arena (level scene)", //
        "07f271142f0470345bf10106f0bf947e", //"Cornucopia - Raving Blight Arena (level scene)", //
        "cd292f0b2dccc4245850fc0843d5e977", //"Cornucopia - Percival Arena (level scene)" //
    };

    vars.ignored = new List<string>() {
        "12d51152f6e170441aeb4bd6d6f32bba", //"Kingswood - Intro (level scene)",
        "3e46d34be382e6f40999ce606619fde5" //"Hub Area (level scene)"
    };

    current.activeScene = "";
    current.loadingScene = "";
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if(old.activeScene != current.activeScene) print("Active: " + old.activeScene + "->" + current.activeScene);
    if(old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene + "->" + current.loadingScene);

    if(old.finished != current.finished) print("finished: " + old.finished + " -> " + current.finished);
    if(old.levelCompleted != current.levelCompleted) print("levelCompleted: " + old.levelCompleted + " -> " + current.levelCompleted);
}

start {
    return !current.finished && old.GameTime == 0f && current.GameTime > 0f;
}

split {
    return (settings["split_room"] && old.loadingScene != current.loadingScene && !vars.ignored.Contains(current.loadingScene) ||
            //settings["split"] && settings["split_boss"] && (old.levelCompleted == 6 && current.levelCompleted == 7 || old.levelCompleted == 15 && current.levelCompleted == 16) ||
            settings["split_boss"] && !settings["split_room"] && vars.bossArenas.Contains(old.activeScene) && old.activeScene != current.activeScene && !current.finished||
            settings["split_end"] && current.finished && current.levelCompleted == 28 && ((!old.finished && current.finished) || (old.levelCompleted < current.levelCompleted)) && current.activeScene == "cd292f0b2dccc4245850fc0843d5e977");
}

reset {
    return settings["reset"] && old.activeScene != current.activeScene && current.activeScene == "3e46d34be382e6f40999ce606619fde5";
}

gameTime {
    return TimeSpan.FromSeconds(current.GameTime);
}

isLoading {
    return true;
}
