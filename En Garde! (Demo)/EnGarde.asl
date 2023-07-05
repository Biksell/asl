/*
Huge thanks to Meta for getting me into making autosplitters!

Values are actually loaded object count? But they're consistent so should work.
Level IDs:
24 = Main Menu
427 = 1st Cutscene
501 = level1 (Tutorial)
578 = level2 (First Trial)
575 = level2.2 (changes on dodge/box tutorial)
539 = level3 (Docks)
517 = level4 (Escape)
531 = level5 (Final Fight)
413 = EndCutscene
*/

state ("EnGarde-Win64-Shipping") {
	bool loading : 0x074BF4D0, 0x108, 0x78;
    int levelId : 0x74A0EF8, 0x30, 0x18;
}

startup {
    settings.Add("start", true, "Start on New Game (first loading screen)");
    settings.Add("split_level", true, "Split on map change (after loading screen)");
    settings.Add("split_end", true, "Split on end cutscene start");
    settings.Add("reset_onMenu", true, "Reset on returning to Main Menu");

    // To prevent double/triple splits that happen quite often, loaded instead of completed so resetting can be done more easily
    vars.loadedLevels = new HashSet<int>();
    vars.Levels = new List<int>() {501, 575, 539, 517, 531};

    // Asks user to change to game time if LiveSplit is currently set to Real Time.
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | En Garde!",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart {
    //timer.IsGameTimePaused = true; Didn't work for some reason, so put it in start{}
    vars.loadedLevels.Clear();
}

isLoading {
	return current.loading;
}

start {
    //return settings["start"] && current.loading && current.levelId == 24;
    if (settings["start"] && current.loading && current.levelId == 24) {
        timer.IsGameTimePaused = true;
        return true;
    }
}

split {
    return
        (settings["split_level"] && old.levelId != current.levelId && vars.loadedLevels.Add(current.levelId) && vars.Levels.Contains(old.levelId) && current.levelId != 24)
        || (settings["split_end"] && old.loading && !current.loading && current.levelId == 413); // Final split
}

reset {
    return settings["reset_onMenu"] && current.levelId == 24 && vars.loadedLevels.Contains(501);
}
