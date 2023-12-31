state("DMZNorthKorea") {
    int levelId : 0x2A904, 0x34, 0xC4, 0x30, 0x408;
    bool loading : 0x2A904, 0x34, 0xB0, 0x74, 0xC4, 0x10, 0xC30;
    bool inCutScene : 0x2A904, 0x34, 0xB0, 0x128;
}

startup {
    vars.csCount = 0;
    refreshRate = 60;

    settings.Add("start", true, "Start after first loading screen on level1");
    settings.Add("split_level", true, "Split on level end (after cutscene)");
    settings.Add("split_end", true, "Split on level10 cutscene start");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | DMZ: North Korea",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart {
    vars.csCount = 0;
}

update {
    if (!old.inCutScene && current.inCutScene && current.levelId == 9) {
        vars.csCount++;
    }
}

isLoading {
    return current.loading;
}

start {
    return settings["start"] && current.levelId == 0 && old.loading && current.inCutScene;
}

split {
    if (settings["split_end"] && current.levelId == 9 && vars.csCount == 3) { // Final split
        vars.csCount++;
        return true;
    }
    return settings["split_level"] && old.inCutScene && current.loading; // Levels 1-9
}
