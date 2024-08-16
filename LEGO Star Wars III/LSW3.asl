// Autosplitting by elle
// Load removal by Biksel

state("LEGOCloneWars")
{
    byte status : 0xBBC744;
    byte statust : 0xBBC745;
    byte newgame : 0xA6DF90;
    byte newgamet : 0xA6DFA2;
    byte load: 0xB80F85;
    byte dynLoad1: 0x8F05C4;
    byte dynLoad2: 0x8F0834;
    bool gameplay: 0xA0EF50, 0x108, 0x8AC;
    bool windowFocused: 0xA128F4;
    float igt: 0xAB4CA0;
}

startup {
    vars.altTab = new Stopwatch();
}

update {
    if (old.load != current.load) print("load: " + old.load + " -> " + current.load);
    if (old.gameplay != current.gameplay) print("gameplay: " + old.gameplay + " -> " + current.gameplay);
    if (current.load != 0 && !current.gameplay && !vars.altTab.IsRunning) print("Loading");
    if (old.windowFocused != current.windowFocused) vars.altTab.Restart();
    if (vars.altTab.ElapsedMilliseconds > 1000) vars.altTab.Reset();
    //if (current.paused == 255 && current.inMenu == 255 && current.inMenu2 == 255) print("In menu");
}

start
{
    if (current.newgame > old.newgame && current.newgamet > old.newgamet) return true;
}

split
{
    if (current.status != old.status && current.statust != old.statust) return true;
}

isLoading {
    return current.load != 0 && !current.gameplay && !vars.altTab.IsRunning;
}

exit {
    timer.IsGameTimePaused = false;
}
