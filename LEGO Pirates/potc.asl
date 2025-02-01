state("LEGOPirates", "lpc")
{
    bool loading: 0xA171A4;
    bool head: 0x00B57874, 0xBB8;
    bool roomTransition: 0x00B7BCC0, 0xC, 0x50;
    int roomId: 0xB791B4;
    int redHatCount: 0xB7DBFC;
}

startup {
    settings.Add("split_save", false, "Split on saving (old, Standard)");
    settings.Add("split_nosave", true, "Split on loading screen after level (N0CUT5)");
    settings.Add("split_room", false, "Split on room transitions");
    settings.Add("redhatrush", false, "Red Hat Rush:");
    settings.Add("start_redhat", false, "Start on loading into hub", "redhatrush");
    settings.Add("split_redhat", false, "Split on hub room transitions", "redhatrush");
    settings.Add("split_redhat_end", false, "Split on collecting 20 Red Hats", "redhatrush");

    vars.skipRooms = new List<int>() {11,21,31,42,47,59,60,66,74,81,87,96,101,109,115,120,133,142,148,153,159,57,438,58,93,95,165,19,24,28,37,38,45,51,140,144,146,151,157,163,59,64,71,79,85,90,91,99,113,118};
    vars.loadingScreens = new List<int> {2,20,29,39,46,92,65,72,80,86,128,100,108,114,119,124,164,144,147,152,158};

    vars.splitRooms = new List<int>();
    vars.count = 0;
}

isLoading
{
    return current.loading;
}

start {
    return settings["start_redhat"] && old.roomId == 439 && current.roomId == 2;
}

onStart {
    vars.count = 0;
}

split
{
    return (settings["split_save"] && current.head && !old.head) ||
            (settings["split_nosave"] && old.roomId != current.roomId && vars.loadingScreens.Contains(current.roomId) && !vars.splitRooms.Contains(current.roomId)) ||
            (settings["split_room"] && old.roomId != current.roomId && current.roomId == 144 && vars.count < 1) ||
            (settings["split_room"] && old.roomId != current.roomId && current.roomId != 144 && !vars.skipRooms.Contains(current.roomId)) ||
            (settings["split_redhat"] && old.roomTransition && !current.roomTransition) ||
            (settings["split_redhat_end"] && old.redHatCount == 19 && current.redHatCount == 20);
}

onSplit {
    vars.splitRooms.Add(current.roomId);
    if (current.roomId == 144) vars.count++;
}

exit
{
    timer.IsGameTimePaused = false;
}
