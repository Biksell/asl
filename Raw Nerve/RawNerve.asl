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

    settings.Add("split_end", true, "Split on game end");
    settings.Add("split_collectible", false, "Split on every collectible");

    vars.collectedCollectibles = new HashSet<int>();

    vars.Helper.AlertGameTime();
}

onStart {
    vars.collectedCollectibles.Clear();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["igt"] = mono.Make<float>("GameManager", 1, "instance", "GameTime");
        vars.Helper["activeGameState"] = mono.Make<int>("GameManager", 1, "instance", "ActiveState");
        vars.Helper["collectibles"] = mono.MakeArray<bool>("GameManager", 1, "instance", "Collectible");

        return true;
    });
}

gameTime {
    return TimeSpan.FromSeconds(current.igt);
}

start {
    return old.igt == 0f && current.igt > 0f;
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

    if (settings["split_end"]) {
        return current.activeGameState == 4 && old.activeGameState == 2;
    }
}

reset {
    return (old.activeGameState == 3 || old.activeGameState == 4) && current.activeGameState == 2 && current.igt == 0f;
}
