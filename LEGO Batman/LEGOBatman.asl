// By Siedemnastek and Biksel
// V4
state("LEGOBatman")
{
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // This is an old address to remove loads before statuses, not used anymore due to some issues it caused and because of the Fades address being more accurate
    bool loading3: 0x6CA7B0; // I think this one is only used for some New Game load
    bool loading4: 0x6B29D0; // This removes the load when you exit a level
    bool Hardload: 0x6C9FD0; // This is for removing the loads when entering new hardloads via doors, and for room splitting
    bool Softload: 0x5C4A10; // This is used for room splitting in a few rooms
    bool Fades: 0x70AAC0; // This address is the only good way of removing the loads before status screens, but it flips after every room transition so a lot of safeguards have to be in place
    bool Cutscene: 0x5D48F8;
    bool Reset: 0x5A08C8;
    bool UI: 0x006B2964, 0xB68;
    bool UI2: 0x006B2964, 0xB64; //These UI addresses are for ending time on killing the boss in 2-5
    ulong Newgame: 0x6D5C78; //4294901760

    int Menu: 0x59D384;
    int roomID : 0x6C98C4;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled

    //bool start1 : 0x693034;
    //bool start2 : 0x693674;
    //bool start3 : 0x693684;
    //bool start4 : 0x6DE6FC;
    //bool start5 : 0x702A50;
    //bool start6 : 0x702A68;

    //bool inLevel : 0x5616DD;


}


state("Game")
{
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // This is an old address to remove loads before statuses, not used anymore due to some issues it caused and because of the Fades address being more accurate
    bool loading3: 0x6CA7B0; // I think this one is only used for some New Game load
    bool loading4: 0x6B29D0; // This removes the load when you exit a level
    bool Hardload: 0x6C9FD0; // This is for removing the loads when entering new hardloads via doors, and for room splitting
    bool Softload: 0x5C4A10; // This is used for room splitting in a few rooms
    bool Fades: 0x70AAC0; // This address is the only good way of removing the loads before status screens, but it flips after every room transition so a lot of safeguards have to be in place
    bool Cutscene: 0x5D48F8;
    bool Reset: 0x5A08C8;
    bool UI: 0x006B2964, 0xB68;
    bool UI2: 0x006B2964, 0xB64; //These UI addresses are for ending time on killing the boss in 2-5, 2 are needed because they both like to flip when doing certain things in the room
    ulong Newgame: 0x6D5C78; //4294901760

    int Menu: 0x59D384;
    int roomID : 0x6C98C4;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled

    //bool start1 : 0x693034;
    //bool start2 : 0x693674;
    //bool start3 : 0x693684;
    //bool start4 : 0x6DE6FC;
    //bool start5 : 0x702A50;
    //bool start6 : 0x702A68;

    //bool inLevel : 0x5616DD;
}


startup {
    vars.changeCount = 0;
    vars.level = 1;
    vars.Harley = 0; //this variable is used to make the room splitter split for the start of the Harley Quinn fight in 3-2
    vars.Clayface = 0; //this variable is used to stop the load remover from pausing on the 4-1 intro since it's the same as the 1-1 intro
    vars.Bank = 0; //this variable is used to make the room splitter split for the start of the Clayface fight in 1-1

    //settings.Add("freeplay", true, "Start on loading into level (Free Play)");
    //settings.Add("start_story", false, "(EXPERIMENTAL) Start on New Game (Add 0.583 offset to your timer)");
    settings.Add("h", true, "Hero Story/Free Play (End on 2-5)");
    settings.Add("v", false, "Villain Story/Any% (End on 5-5)");
    settings.Add("split_continue", true, "Split at \"Continue Story\" or \"Return to hub\" in the status screen");
    settings.Add("1_1_0studs", true, "Going for 0 studs in 1-1 Story OR playing Freeplay", "split_continue"); // if true, split when changeCount == 1, if false, split when changeCount == 2
    settings.Add("split_status", false, "Split at the beginning of status screens");
    settings.Add("room", false, "Split on every room");


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

init {
  vars.OOBDoorID = new List<int>() {19, 26, 39, 51, 66, 83, 112, 152, 162, 180, 200, 206, 218}; //This is a list of every end room that ends with a door/OOB door so that the roomsplitter doesn't split when you hit them - which would add unnecessary splits
  vars.statusID = new List<int>() {22, 28, 34, 41, 46, 53, 61, 69, 77, 85, 95, 101, 107, 114, 121, 127, 133, 140, 148, 156, 164, 170, 176, 182, 190, 196, 202, 208, 214, 220, 225, 228}; //This is a list of every status screen roomID, this is used to make the Fades address only stop in those maps, but before the Status value flips to 1
}

onStart {
    vars.changeCount = 0;
    vars.level = 1;
    vars.Harley = 0;
    vars.Clayface = 0;
    vars.Bank = 0;
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

    //print(vars.Clayface.ToString());

    if (current.roomID == 0) vars.Clayface = 0;
    if (current.roomID == 10) vars.Clayface = 1;

}

isLoading {
     //current.loading2 && current.roomID == 190 ||
    return current.loading || current.loading3 || (current.loading4 && current.roomID != 199) || current.Hardload || current.Fades && vars.statusID.Contains(current.roomID) && !current.status || current.Newgame == 4294901760 && current.roomID == 0 && current.Menu == 2|| current.Reset && current.roomID == 0 || current.roomID == 11 && vars.Clayface == 0;
}

start {
    if (current.Newgame == 4294901760 && current.roomID == 0 && current.Menu == 2) return true;
}

split {
    if (settings["room"] && current.Hardload && !old.Hardload && !vars.OOBDoorID.Contains(current.roomID) || current.Softload && !old.Softload || current.roomID == 12 && old.roomID == 9 || current.roomID == 15 && old.roomID == 9 || current.roomID == 11 && old.roomID == 10 || current.roomID == 12 && old.roomID == 10 || current.roomID == 15 && old.roomID == 10) return true;
    if (settings["room"] && current.roomID == 168 && current.Cutscene && !old.Cutscene && vars.Harley == 0) vars.Harley = 1;
    if (vars.Harley == 1)
    {
        vars.Harley = 0;
        return true;
    }
    if (settings["room"] && current.roomID == 19 && current.Cutscene && !old.Cutscene && vars.Bank == 0) vars.Bank = 1;
    if (vars.Bank == 1)
    {
        vars.Bank = 0;
        return true;
    }
    if (settings["h"] && current.roomID == 143 && !current.UI && old.UI && !current.UI2 && old.UI2 && current.Fades && !old.Fades) return true;
    if (settings["v"] && current.roomID == 152 && current.Hardload && !old.Hardload) return true;
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
    timer.IsGameTimePaused = false;
}
