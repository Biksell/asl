// Autosplitting by elle
// Load removal by Biksel

state("LEGOCloneWars")
{
    byte status : 0xBBC744;
    byte statust : 0xBBC745;
    byte newgame : 0xA6DF90;
    byte newgamet : 0xA6DFA2;
    byte load: 0xB80F85;
}

update {
    if (old.load != current.load) print("load: " + old.load + " -> " + current.load);
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
    return current.load != 0;
}

exit {
    timer.IsGameTimePaused = false;
}
