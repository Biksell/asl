state("flashplayer_32_sa") {
    int state: 0xD1C270, 0x28, 0x490, 0x40C, 0xE8, 0xE8, 0x0, 0x38; // 0 menu, 1 game, 2 pause
    int level: 0xD18438, 0xFC, 0x2C, 0x2AC, 0xC, 0x0, 0x68; // level numbers
    bool complete: 0xD18438, 0x150, 0x504, 0xE8, 0x0, 0x38;
}

startup {
    vars.completedLevels = new HashSet<int>();
    settings.Add("start", true, "Start on entering level1");
    settings.Add("split", true, "Split on level completion");
}

start {
    return settings["start"] && (old.state == 0 && current.state == 1) || (old.state == 0 && current.state == 2) && current.level == 1;
}

split {
    return (!old.complete && current.complete && vars.completedLevels.Add(old.level));
}

onStart {
    vars.completedLevels.Clear();
}
