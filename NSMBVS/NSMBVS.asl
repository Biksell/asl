state("NSMB-MarioVsLuigi") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("start", true, "Start on spawning");
    settings.Add("split", true, "Split upon:");
    settings.Add("split_req", true, "Collecting all stars", "split");
    settings.Add("split_10c", false, "10 coins", "split");
    settings.Add("split_25c", false, "25 coins", "split");
    settings.Add("split_50c", false, "50 coins", "split");
    settings.Add("split_99c", false, "99 coins", "split");
    settings.Add("reset", false, "Reset on leaving match without reaching star requirement");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["gameover"] = mono.Make<bool>("GameManager", "_instance", "gameover");
        vars.Helper["spawned"] = mono.Make<bool>("UIUpdater", "Instance", "player", "spawned");
        vars.Helper["stars"] = mono.Make<int>("UIUpdater", "Instance", "stars");
        vars.Helper["coins"] = mono.Make<int>("UIUpdater", "Instance", "coins");
        vars.Helper["starRequirement"] = mono.Make<int>("GameManager", "_instance", "starRequirement");
        return true;
    });
}

update {
    /*
    if(old.activeScene != current.activeScene) print("Active: " + old.activeScene + "->" + current.activeScene);
    if(old.loadingScene != current.loadingScene) print("Loading: " + old.loadingScene + "->" + current.loadingScene);
    if(old.gameover != current.gameover) print("gameover: " + old.gameover + "->" + current.gameover);
    if(old.spawned != current.spawned) print("spawned: " + old.spawned + "->" + current.spawned);
    if(old.stars != current.stars) print("stars: " + old.stars + "->" + current.stars);
    if(old.coins != current.coins) print("coins: " + old.coins + "->" + current.coins);
    if(old.starRequirement != current.starRequirement) print("starRequirement: " + old.starRequirement + "->" + current.starRequirement);
    */
}

start {
    return settings["start"] && !old.spawned && current.spawned;
}

split {
    return (settings["split_req"] && current.stars == current.starRequirement && old.stars != current.stars) ||
            (settings["split_10c"] && old.coins == 9 && current.coins == 10) ||
            (settings["split_25c"] && old.coins == 24 && current.coins == 25) ||
            (settings["split_50c"] && old.coins == 49 && current.coins == 50) ||
            (settings["split_99c"] && old.coins == 98 && current.coins == 99);
}

reset {
    return settings["reset"] && !old.gameover && current.gameover && current.stars != current.starRequirement;
}
