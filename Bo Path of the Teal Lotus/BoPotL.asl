// Made by Biksel
// asl-help by ero (https://github.com/just-ero/asl-help/)

state("Bo") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();

    vars.Areas = new List<string>() {
        "CBF Bump Intro",
        "CBF Cave Entrance",
        "UC Entrance",
        "UC Arena Puzzle",
        "UC Main Chamber",
        "UC Herder",
        "UC North Puzzle"
    };

    vars.splitConditions = new HashSet<string>();

    settings.Add("start", true, "Start after spawning in a new game");
    settings.Add("split_area", true, "Split on entering: ");
    foreach(var area in vars.Areas) {
        if(area != "New Main Menu" || area != "CBF Intro") {
            if (area == "CBF Bump Intro" || area == "UC Entrance" || area == "UC Herder") {
                settings.Add("split_" + area, true, area, "split_area");
            } else {
                settings.Add("split_" + area, false, area, "split_area");
            }

        }
    }
    settings.Add("split_quest", true, "Split on completing quest: ");
    settings.Add("split_bamboo", false, "Bamboo quest", "split_quest");
    settings.Add("split_shimeji", true, "Armapillo Quest", "split_quest");
    settings.Add("split_pua", true, "Split on defeating Particularly Unmanagable Armakillo");
    settings.Add("split_end", true, "Split on the end Demo screen");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["timePlayed"] = mono.Make<float>("GameManager", "instance", "betaDataManager", "TimePlayed");
        //vars.Helper["AsahiDefeated"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "AsahiDefeated");
        //vars.Helper["DefeatedJorogumo"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "DefeatedJorogumo");
        vars.Helper["DefeatedPUABoss"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "DefeatedPUABoss");
        //vars.Helper["GashaDefeated"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "GashaDefeated");
        //vars.Helper["ShogunDefeated"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "ShogunDefeated");
        vars.Helper["q_bamboo"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "AsahiBambooStaffQuestCompleted");
        vars.Helper["q_shimeji"] = mono.Make<bool>("GameManager", "instance", "QuestManager", "ShimejiQuestCompleted");
        vars.Helper["OnDemoVideo"] = mono.Make<bool>("UICache", "Instance", "OnDemoVideo");
        return true;
    });
}

update {
    try {
        current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
        current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

        if(old.activeScene != current.activeScene) print(old.activeScene + "->" + current.activeScene);
        if(old.loadingScene != current.loadingScene) print(old.loadingScene + "->" + current.loadingScene);
    } catch (System.Exception) {
    }

    //if(old.AsahiDefeated != current.AsahiDefeated) print("AsahiDefeated: " + old.AsahiDefeated + " -> " + current.AsahiDefeated);
    //if(old.DefeatedJorogumo != current.DefeatedJorogumo) print("DefeatedJorogumo: " + old.DefeatedJorogumo + " -> " + current.DefeatedJorogumo);
    if(old.DefeatedPUABoss != current.DefeatedPUABoss) print("DefeatedPUABoss: " + old.DefeatedPUABoss + " -> " + current.DefeatedPUABoss);
    //if(old.GashaDefeated != current.GashaDefeated) print("GashaDefeated: " + old.GashaDefeated + " -> " + current.GashaDefeated);
    //if(old.ShogunDefeated != current.ShogunDefeated) print("ShogunDefeated: " + old.ShogunDefeated + " -> " + current.ShogunDefeated);
    if(old.q_bamboo != current.q_bamboo) print("q_bamboo: " + old.q_bamboo + " -> " + current.q_bamboo);
    if(old.q_shimeji != current.q_shimeji) print("q_shimeji: " + old.q_shimeji + " -> " + current.q_shimeji);
}

onStart {
    vars.splitConditions.Clear();
}

start {
    return current.timePlayed == 0f && old.activeScene == "New Main Menu" && current.activeScene == "CBF Intro";
}

split {
    return (old.activeScene != current.activeScene && settings["split_" + current.activeScene] && vars.splitConditions.Add(current.activeScene) ||
            settings["split_quest"] && settings["split_bamboo"] && !old.q_bamboo && current.q_bamboo && vars.splitConditions.Add("split_bamboo") ||
            settings["split_quest"] && settings["split_shimeji"] && !old.q_shimeji && current.q_shimeji && vars.splitConditions.Add("split_shimeji") ||
            settings["split_pua"] && !old.DefeatedPUABoss && current.DefeatedPUABoss && vars.splitConditions.Add("split_pua") ||
            settings["split_end"] && !old.OnDemoVideo && current.OnDemoVideo && vars.splitConditions.Add("split_end"));
}

gameTime {
    return TimeSpan.FromSeconds(current.timePlayed);
}

isLoading {
    return true;
}
