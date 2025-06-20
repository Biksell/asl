state("JadeEngine_final") {
    bool pauseMenu: 0x800DF4;
    int menuButton: 0x85B578, 0x13C, 0x168, 0x170;
    bool levelComplete: 0x1442CC4, 0x4;
    float levelTime: 0x85B490, 0x13C, 0x108, 0xF64;
    bool restart: 0x859C9C, 0x13C, 0x1C8, 0x70C;
    bool loading: 0x14386A8;
}

startup {
    settings.Add("split", true, "Split on level completion");
    settings.Add("start", false, "[IL] Start on Confirming level Restart");
    settings.Add("reset", false, "[IL] Reset on pressing the Restart button");
}

init {
    vars.splitDelay = new Stopwatch();
}

isLoading
{
    return current.loading;
}

update {
    if (!old.levelComplete && current.levelComplete) vars.splitDelay.Start();
    if (vars.splitDelay.ElapsedMilliseconds > 200) vars.splitDelay.Reset();
}

start {
    return settings["start"] && current.pauseMenu && old.restart && !current.restart && current.menuButton == 1 && old.levelTime == current.levelTime;
}

split {
    return settings["split"] && vars.splitDelay.ElapsedMilliseconds > 3 * (1000 / 60);
}

onSplit {
    vars.splitDelay.Reset();
}

reset {
    return settings["reset"] && current.menuButton == 1 && !old.restart && current.restart;
}
