/*
Made by Biksel, thanks to ero for making asl-help and helping me out on Discord ^^
Gamestates: 0 = Setup
            1 = Start
            2 = Game
            3 = Pause
            4 = End
            5 = Tips
*/

state("Raw Nerve") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Raw Nerve";

    vars.Areas = new List<string>() {"Base", "Summit", "Guts", "Marsh"};

    settings.Add("start", true, "Start on loading to Cave");
    settings.Add("split", true, "Choose where to split: ");
    settings.Add("split_end", true, "Split at the end (final collectible)", "split");
    settings.Add("split_collectible", false, "Split on every collectible (100%)", "split");
    settings.Add("reset", true, "Reset on pressing \"Retry\"");

    foreach (string area in vars.Areas) {
        settings.Add("split_" + area, false, String.Format("Split on {0} entry", area), "split");
    }

    vars.collectedCollectibles = new HashSet<int>();
    vars.splitLevels = new HashSet<string>();

    vars.Helper.AlertGameTime();
}

onStart {
    vars.collectedCollectibles.Clear();
    vars.splitLevels.Clear();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["igt"] = mono.Make<float>("GameManager", 1, "instance", "GameTime");
        vars.Helper["activeGameState"] = mono.Make<int>("GameManager", 1, "instance", "ActiveState");
        vars.Helper["collectibles"] = mono.MakeArray<bool>("GameManager", 1, "instance", "Collectible");
        vars.Helper["area"] = mono.MakeString("UIManager", 1, "instance", "_areaText", 0xc8);

        return true;
    });
}

gameTime {
    return TimeSpan.FromSeconds(current.igt);
}

start {
    return old.igt == 0f && current.igt > 0f && settings["start"];
}

split {
    if (settings["split_collectible"]) {
        bool[] oC = old.collectibles, cC = current.collectibles;

        for (int i = 0; i < current.collectibles.Length; i++) {
            if (!oC[i] && cC[i] && vars.collectedCollectibles.Add(i)) {
                return true;
            }
        }
    }

    if (settings["split_end"] && current.activeGameState == 4 && old.activeGameState == 2) {
        return true;
    }

    if (current.area == "Cave") return false;

    foreach (string area in vars.Areas) {
        return settings["split_" + current.area] && vars.splitLevels.Add(current.area);
    }
}

reset {
    return settings["reset"] && (old.activeGameState == 3 || old.activeGameState == 4) && current.activeGameState == 2 && current.igt == 0f;
}

isLoading {
    return true;
}

update {
    //if (old.area != current.area) print(old.area + " -> " + current.area);
}
