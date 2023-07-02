/*
Made by Biksel, thanks to ero for making asl-help and helping me out on Discord ^^
Gamestates: 0 = Setup
            1 = Start
            2 = Game
            3 = Pause
            4 = End
            5 = Tips
*/

state("Raw Nerve"){}

startup{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("info", true, "Raw Nerve Autosplitter v1.0 by Biksel");
    settings.Add("split_end", true, "Split on game end");
    settings.Add("split_collectible", false, "Split on every collectible");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var msgBox = MessageBox.Show(
			"Raw Nerve uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Raw Nerve",
			MessageBoxButtons.YesNo);

		if (msgBox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        var col = mono.GetClass("Collectibles");

        vars.Helper["igt"] = mono.Make<float>("GameManager", 1, "instance", "GameTime");
        vars.Helper["activeGameState"] = mono.Make<int>("GameManager", 1, "instance", "ActiveState");
        vars.Helper["collectibles"] = mono.MakeArray<bool>("GameManager", 1, "instance", "Collectible");
        return true;
    });

    vars.collectedCollectibles = new List<int>();
}

gameTime{
    return(TimeSpan.FromSeconds(current.igt));
}

start {
    return old.igt == 0f && current.igt > 0f;
}

split {
    if(settings["split_end"]) {
        if(settings["split_collectible"]) {
            for(int i = 0; i < current.collectibles.Length; i++) {
                if(old.collectibles[i] != current.collectibles[i] && !vars.collectedCollectibles.Contains(i)) {
                    vars.collectedCollectibles.Add(i);
                    return true;
                }
            }
        }
        return current.activeGameState == 4 && old.activeGameState == 2;
    }
}

reset {
    return ((old.activeGameState == 3 || old.activeGameState == 4) && current.activeGameState == 2 && current.igt == 0f);
}

