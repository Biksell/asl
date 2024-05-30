state("flashplayer_32_sa") {
    int state: 0xD1C270, 0x28, 0x490, 0x40C, 0xE8, 0xE8, 0x0, 0x38; // 0 menu, 1 game, 2 pause
    int level: 0xD18438, 0xFC, 0x2C, 0x2AC, 0xC, 0x0, 0x68; // level numbers
    bool complete: 0xD183C8, 0x0, 0x8C, 0x464, 0xE8, 0x0, 0x38; // second one of two values found in the scan
}

startup {
    vars.completedLevels = new HashSet<int>();
    vars.final = false;
    settings.Add("start", true, "Start on entering level1");
    settings.Add("split", true, "Split on level completion");
}

start {
    return settings["start"] && (old.state == 0 && current.state == 1) || (old.state == 0 && current.state == 2) && current.level == 1;
}

update {
    if (current.level == 15 && !old.complete && current.complete) vars.final = true;
}

split {
    return settings["split"] && ((!old.complete && current.complete && current.level != 15 && vars.completedLevels.Add(old.level)) ||
                                (old.state == 1 && current.state == 0 && vars.final));
}

onStart {
    vars.completedLevels.Clear();
    vars.final = false;
}
