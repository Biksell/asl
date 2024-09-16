// Made by Biksel
// thanks to rythin for reliable resets, Frank for updating the start after the cutscene was added
// asl-help by ero (https://github.com/just-ero/asl-help/)

state("The Big Catch Tacklebox") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on spawn");
    settings.Add("split_capture", true, "Split on capturable");
    settings.Add("split_whistle", false, "Split on acquiring the whistle")
    settings.Add("categories", true, "Categories: ");
    settings.Add("split_10", true, "Split on returning 10 fish", "categories");
    settings.Add("split_26", false, "Split on returning 26 fish (All Fish)", "categories");
    settings.Add("split_scales", false, "Split on collecting the final collectable (100%)", "categories");
    settings.Add("reset", true, "Reset on entering new file");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        //vars.Helper["IGT"] = mono.Make<double>("Manager", "_instance", "_timeManagement", "_fixedGameTimeScaled");
        //vars.Helper["paused"] = mono.Make<bool>("Manager", "_instance", "_timeManagement", "_gamePaused");
        //vars.Helper["start"] = mono.Make<int>("Manager", "_instance", "_sceneLoader", "_currentLoadIndex");
        vars.Helper["fileTime"] = mono.Make<float>("Manager", "_instance", "_saveManager", "_currentSaveData", "_inGameTime");
        vars.Helper["captures"] = mono.Make<int>("Manager", "_instance", "_saveManager", "_currentSaveData", "_cachedCapturablesCapturedCount");
        vars.Helper["turnedIn"] = mono.Make<int>("Manager", "_instance", "_saveManager", "_currentSaveData", "_cachedCapturesTurnedInCount");
        vars.Helper["newSave"] = mono.Make<bool>("Manager", "_instance", "_saveManager", "_currentSaveData", "_newSave");
        vars.Helper["active"] = mono.Make<int>("Manager", "_instance", "_primaryPlayerMachine", "_characterArt", "_currentOutfit");
        vars.Helper["trad"] = mono.Make<int>("Manager", "_instance", "_primaryPlayerMachine", "_characterArt", "_traditionalOutfit");
        vars.Helper["cutscene"] = mono.Make<bool>("Manager", "_instance", "_cutsceneCoordinator", "_cutscenePlaying", "_value");
        vars.Helper["coins"] = mono.Make<int>("Manager", "_instance", "_saveManager", "_currentSaveData", "_cachedCurrentCoinCount");
        vars.Helper["whistle"] = mono.Make<bool>("Manager", "_instance", "_primaryPlayerMachine", "_hasWhistle", "_value");
        return true;
    });

    vars.splitTimer = new Stopwatch();
    vars.queueSplit = false;
}

update {
    //if(old.start != current.start) print("Start: " + old.start + " -> " + current.start);
    //if(old.paused != current.paused) print("Paused: " + old.paused + " -> " + current.paused);
    //if(old.fileTime != current.fileTime) print("fileTime: " + old.fileTime + " -> " + current.fileTime);

    if (vars.splitTimer.ElapsedMilliseconds > 1000) vars.splitTimer.Reset();

    if(old.captures != current.captures) print("captures: " + old.captures + " -> " + current.captures);
    if(old.turnedIn != current.turnedIn) print("turnedIn: " + old.turnedIn + " -> " + current.turnedIn);
    if(old.active != current.active) print("active: " + old.active + " -> " + current.active);
    if(old.newSave != current.newSave) print("newSave: " + old.newSave + " -> " + current.newSave);

    if (vars.splitTimer.ElapsedMilliseconds > 0 ) print(vars.splitTimer.ElapsedMilliseconds + "");
    //print((old.turnedIn == 9 && current.turnedIn == 10) + "");

    if ((old.turnedIn == 9 && current.turnedIn == 10 && settings["split_10"]) || (old.turnedIn == 25 && current.turnedIn == 26 && settings["split_26"])) { vars.queueSplit = true; vars.splitTimer.Start(); }
}

onStart {
    vars.splitTimer.Reset();
}

onSplit {
    vars.splitTimer.Reset();
    vars.queueSplit = false;
}

start {
    return  old.cutscene && !current.cutscene && current.captures == 0 && current.coins == 0 && settings["start"];
}

split {
    return (current.captures - old.captures == 1 && settings["split_capture"]) ||
            (settings["split_whistle"] && !old.whistle && current.whistle) ||
            (settings["split_10"] && vars.queueSplit && vars.splitTimer.ElapsedMilliseconds > 516) ||
            (settings["split_26"] && vars.queueSplit && vars.splitTimer.ElapsedMilliseconds > 516)||
            (settings["split_scales"] && old.active != current.active && current.active == current.trad && current.active != 0);
}

reset {
    return old.fileTime > 1f && current.fileTime == 0f && settings["reset"] && current.newSave;
}
