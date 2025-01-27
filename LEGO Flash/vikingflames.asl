state("flashplayer_32_sa") {
    int level: 0x00D18438, 0xFC, 0x1E8, 0x14, 0x9C, 0x80;
    bool gameplayEnabled: 0x00D18438, 0xFC, 0x1E8, 0x14, 0x9C, 0x84;
    int totalScore: 0x00D18438, 0xFC, 0x1E8, 0x14, 0x9C, 0x64;
}

start {
    return current.level == 1 && !old.gameplayEnabled && current.gameplayEnabled;
}

split {
    return current.level - old.level == 1;
}

reset {
    return current.level == 0 || current.level == null;
}
