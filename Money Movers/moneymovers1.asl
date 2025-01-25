state("flashplayer_32_sa") {
    int level: 0x00D18438, 0x32C, 0x64, 0x38, 0x160;
    int hustler: 0x00D18438, 0x32C, 0x64, 0x38, 0x1A0;
    bool hustlerExit: 0x00D18438, 0x32C, 0x64, 0x38, 0x1A0, 0x118;
    bool bouncerExit: 0x00D18438, 0x32C, 0x64, 0x38, 0x1A4, 0x11C;
}

startup {
    settings.Add("start", true, "Start on starting level1");
    settings.Add("split", true, "Split on level change");
    settings.Add("split_end", true, "Split on entering elevator on level20");
}

start {
    return settings["start"] && (current.level == 0 || current.level == 1) && old.hustler != current.hustler;
}

split {
    return (settings["split"] && current.level - old.level == 1 && old.level != 0) ||
            (settings["split_end"] && current.level == 20 && current.hustlerExit && current.bouncerExit && (!old.hustlerExit || !old.bouncerExit));
}

update {
    if (old.level != current.level) print("level: " + old.level + " -> " + current.level);
}
