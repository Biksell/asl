state("flashplayer_32_sa") {
    int level: 0x00D18438, 0x32C, 0x64, 0x38, 0x160;
    bool hustlerExit: 0x00D18438, 0x32C, 0x64, 0x38, 0x1A0, 0x118;
    bool bouncerExit: 0x00D18438, 0x32C, 0x64, 0x38, 0x1A4, 0x11C;
}

split {
    return (current.level - old.level) == 1 ||
         (current.level == 20 && current.hustlerExit && current.bouncerExit);
}
