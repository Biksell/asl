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

    bool start1 : 0x693034;
    bool start2 : 0x693674;
    bool start3 : 0x693684;
    bool start4 : 0x6DE6FC;
    bool start5 : 0x702A50;
    bool start6 : 0x702A68;

    bool inLevel : 0x5616DD;

    int roomID : 0x6C98C4;
}


state("Game")
{
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // Character info screens
    bool loading3: 0x6CA7B0; // Could be used for autostarting
    bool loading4: 0x6B29D0;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled

    bool start1 : 0x693034;
    bool start2 : 0x693674;
    bool start3 : 0x693684;
    bool start4 : 0x6DE6FC;
    bool start5 : 0x702A50;
    bool start6 : 0x702A68;
}


startup {
    vars.changeCount = 0;
    vars.level = 1;

    //settings.Add("freeplay", true, "Start on loading into level (Free Play)");
    settings.Add("start_story", false, "(EXPERIMENTAL) Start on New Game (Add 0.583 offset to your timer)");
    settings.Add("split_continue", false, "Split at \"Continue Story\" or \"Return to hub\" in the status screen");
    settings.Add("1_1_0studs", false, "Going for 0 studs in 1-1 Story OR playing Freeplay", "split_continue"); // if true, split when changeCount == 1, if false, split when changeCount == 2
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

    vars.doubleSplit = new Stopwatch();
}

onStart {
    vars.changeCount = 0;
    vars.level = 1;
}

onSplit {
    vars.doubleSplit.Start();
}

update {
    if (old.uiElementChange && !current.uiElementChange) {
        print(vars.changeCount + " -> " + vars.changeCount++);
    }
    if (vars.doubleSplit.ElapsedMilliseconds > 1500) vars.doubleSplit.Reset();
    //if (settings["freeplay"] && old.loading2 && !current.loading2) vars.startDelay.Start();
    //if (vars.startDelay.ElapsedMilliseconds > 100) vars.startDelay.Reset();
    //print(current.inLevel + ", " + current.loading2);
    //print(current.start1 + "," + current.start2 + "," + current.start3 + "," + current.start4 + "," + current.start5 + "," + current.start6);
    //if (old.uiElementChange != current.uiElementChange) print(vars.changeCount.ToString());
    //print((settings["split_continue"] && !settings["1_1_0studs"] && vars.level == 1 && vars.changeCount >= 1).ToString());
}

isLoading {
    return current.loading || current.loading2 || current.loading3 || (current.loading4 && current.roomID != 199);
}

start {
    return (current.start1 &&
            current.start2 &&
            current.start3 &&
            current.start4 &&
            current.start5 &&
            current.start6 && settings["start_story"]);
}

split {
    if (vars.doubleSplit.IsRunning) return false;
    if (settings["split_status"] && current.status && !old.status) return true;
    if (settings["split_continue"] && !settings["1_1_0studs"] && vars.level == 1 && vars.changeCount >= 1) {
        if (vars.changeCount == 1 && !settings["1_1_0studs"]) return false;
        vars.changeCount = 0;
        vars.level++;
        return true;
    }
    else if (settings["split_continue"] && vars.changeCount == 1) {
        vars.level++;
        vars.changeCount = 0;
        return true;
    }
    return false;
}

exit {
    timer.IsGameTimePaused = true;
}
