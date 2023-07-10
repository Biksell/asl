// Load removal by Siedemnastek
// Autosplitting by Biksel

state("LEGOBatman")
{
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // Character info screens
    bool loading3: 0x6CA7B0; // Could be used for autostarting
    bool loading4: 0x6B29D0;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled
}

startup {
    vars.changeCount = 0;
    vars.level = 1;

    settings.Add("split_continue", false, "Split at \"Continue Story\" or \"Return to hub\"");
    settings.Add("1_1_0studs", false, "Going for 0 studs in 1-1 Story", "split_continue");
    settings.Add("split_status", false, "Split at the beginning of status screens");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | LEGO Batman",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart {
    vars.changeCount = 0;
    vars.level = 1;
}

update {
    if (old.uiElementChange && !current.uiElementChange) {
        print(vars.changeCount + " -> " + vars.changeCount++);
    }

    if (old.uiElementChange != current.uiElementChange) print(vars.changeCount.ToString());
}

isLoading {
    return current.loading || current.loading2 || current.loading3 || current.loading4;
}

split {
    if (settings["split_status"] && current.status && !old.status) return true;
    if (settings["split_continue"] && !settings["1_1_0studs"] && vars.level == 1) {
        if (vars.changeCount == 1) return false;
        vars.changeCount = 0;
        vars.level++;
        return true;
    }
    else if (settings["split_continue"] && vars.changeCount == 1) {
        vars.level++;
        vars.changeCount = 0;
        return true;
    }
}

exit {
    timer.IsGameTimePaused = true;
}
