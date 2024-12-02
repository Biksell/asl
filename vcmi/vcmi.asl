state("NSMBVersus vic's Custom Match-inator") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertLoadless();

    settings.Add("start", true, "Start on level fade-in");
    settings.Add("split_flag", false, "Split on touching the flagpole");
    settings.Add("split_timer", true, "Split on end-timer entering screen");
    settings.Add("reset", true, "Reset on leaving without finishing level");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        //var gm = mono["GameManager", "_instance"];
        //vars.Helper["coins"] = gm.Make<int>("coins");
        //var gm = mono["GameManager"];
        var ui = mono["UIUpdater"];
        var gm = mono["GameManager"];
        vars.Helper["timer"] = gm.MakeString("_instance", 0x150, 0xE0);
        vars.Helper["started"] = gm.Make<bool>("_instance", 0x11A);
        vars.Helper["loaded"] = gm.Make<bool>("_instance", 0x119);
        vars.Helper["gameover"] = gm.Make<bool>("_instance", 0x168);
        vars.Helper["flag"] = ui.Make<int>("Instance", 0x40, 0x280);
        return true;
    });

    vars.startDelay = new Stopwatch();
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if (!old.started && current.started) vars.startDelay.Start();
    if (vars.startDelay.ElapsedMilliseconds > 3200) vars.startDelay.Reset();

    /*
    if(old.activeScene != current.activeScene) print(old.activeScene + "->" + current.activeScene);
    if(old.loadingScene != current.loadingScene) print(old.loadingScene + "->" + current.loadingScene);


    if (old.timer != current.timer) print("timer: " + old.timer + "->" + current.timer);
    if (old.started != current.started) print("started: " + old.started + "->" + current.started);
    if (old.loaded != current.loaded) print("loaded: " + old.loaded + "->" + current.loaded);
    if (old.gameover != current.gameover) print("gameover: " + old.gameover + "->" + current.gameover);
    if (old.flag != current.flag) print("flag: " + old.flag + "->" + current.flag);*/
    //print(String.IsNullOrEmpty(current.timer) + "");
}

isLoading {
    return current.activeScene != current.loadingScene || current.activeScene == "Loading" || !current.loaded;
}

split {
    return (settings["split_timer"] && String.IsNullOrEmpty(old.timer) && !String.IsNullOrEmpty(current.timer)) ||
            (settings["split_flag"] && old.flag == 0 && old.flag != current.flag);
}

start {
    return settings["start"] && vars.startDelay.ElapsedMilliseconds >= 3133;
}

onStart {
    vars.startDelay.Reset();
}

reset {
    return settings["reset"] && current.activeScene == "MainMenu" && old.activeScene != current.activeScene && String.IsNullOrEmpty(current.timer);
}
