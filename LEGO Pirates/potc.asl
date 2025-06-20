// Original by Frostidllo
// Updated by FlamingLazer, Biksel

state("LEGOPirates")
{
    bool loading: 0xA171A4;
    bool head: 0x00B57874, 0xBB8;
    bool roomTransition: 0x00B7BCC0, 0xC, 0x50;
    int roomId: 0xB791B4;
    int redHatCount: 0xB7DBFC;
    int NewGame: 0xA18000;
}

startup {
    settings.Add("split_save", false, "Split on saving (old, Standard)");
    settings.Add("split_nosave", true, "Split on loading screen after level (N0CUT5)");
    settings.Add("split_room", false, "Split on room transitions");
    settings.Add("redhatrush", false, "Red Hat Rush:");
    settings.Add("start_redhat", false, "Start on loading into hub", "redhatrush");
    settings.Add("split_redhat", false, "Split on hub room transitions", "redhatrush");
    settings.Add("split_redhat_end", false, "Split on collecting 20 Red Hats", "redhatrush");

    //midtros, opening cutscenes, etc that we want to skip on roomsplitting
    vars.skipRooms = new List<int>() {11,14,21,31,35,36,42,47,52,54,59,60,66,70,74,81,87,96,101,106,107,109,115,120,122,123,133,136,142,148,149,153,156,159,57,438,58,93,95,165,19,24,28,37,38,45,51,140,144,146,151,157,161,163,59,64,71,79,85,90,91,99,113,118};

    vars.loadingScreens = new List<int> {2,20,29,39,46,65,72,80,86,87,90,100,108,114,119,144,147,152,158}; // For splitting nocut
    vars.preLoadingScreens = new List<int> {19,28,38,45,58,64,71,79,85,89,95,99,103,107,113,118,132,140,146,151,157,165}; // For splitting nocut

    vars.exceptionRooms = new List<int>() {144}; //144 only split first time, 31 and 74 split on the second time

    vars.splitRooms = new List<int>();
    vars.count = 0;
    vars.count2 = 0; //Specifically for 4-5 Midtro
}

isLoading
{
    return current.loading;
}

update {
    if (old.roomId != current.roomId) {
        if (vars.exceptionRooms.Contains(current.roomId)) vars.count++;
        if (current.roomId == 146) vars.count = 0; // Safe to reset to 0, used for 144
    }


}

start {
    return settings["split_nosave"] && old.NewGame == 0 && current.NewGame == 1 && current.roomId == 439;
    return settings["start_redhat"] && old.roomId == 439 && current.roomId == 2;
}

onStart {
    vars.count = 0;
    vars.count2 = 0;
    vars.splitRooms = new List<int>();
}

split
{
    return (settings["split_save"] && current.head && !old.head) ||
            (settings["split_nosave"] && old.roomId != current.roomId && vars.loadingScreens.Contains(current.roomId) && vars.preLoadingScreens.Contains(old.roomId)) ||
            (settings["split_room"] && old.roomId != current.roomId && !vars.exceptionRooms.Contains(current.roomId) && !vars.skipRooms.Contains(current.roomId) && old.roomId != 161 && current.roomId != 161) ||
            (settings["split_room"] && old.roomId == 32 && current.roomId == 31 && !vars.splitRooms.Contains(current.roomId))||
            (settings["split_room"] && old.roomId == 75 && current.roomId == 74 && !vars.splitRooms.Contains(current.roomId))||
            (settings["split_room"] && old.roomId != current.roomId && current.roomId == 144 && vars.count < 1) ||
            (settings["split_room"] && old.roomId == 160 && current.roomId == 161) ||
            (settings["split_room"] && old.roomId == 161 && current.roomId == 162 && vars.count2 == 0) ||
            (settings["split_redhat"] && old.roomTransition && !current.roomTransition) ||
            (settings["split_redhat_end"] && old.redHatCount == 19 && current.redHatCount == 20);
}

onSplit {
    vars.splitRooms.Add(current.roomId);
    if (current.roomId == 31 || current.roomId == 74) vars.count = 0;
    if (current.roomId == 162) vars.count2 = 1;
}

exit
{
    timer.IsGameTimePaused = false;
}
