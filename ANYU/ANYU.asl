state("ProjectSnow-Win64-Shipping") {
    int levelId : 0x5832368, 0x798, 0x1B0, 0x88, 0x178, 0x48;
}

startup {
    vars.lastLevel = -1;
}

start {
    return (vars.lastLevel == 16 || vars.lastLevel == 11648) && current.levelId == 52256;
}

update {
    if (old.levelId != current.levelId && old.levelId != 0) vars.lastLevel = old.levelId;
}

isLoading {
    return current.levelId == 0;
}

split {
    return (vars.lastLevel == 52256 && current.levelId == 30656) ||
            (vars.lastLevel == 30656 && current.levelId == 55088) ||
            (vars.lastLevel == 55088 && current.levelId == 79744) ||
            (vars.lastLevel == 79744 && current.levelId == 52496) ||
            (vars.lastLevel == 52496 && current.levelId == 75664) ||
            (vars.lastLevel == 75664 && current.levelId == 79648) ||
            (vars.lastLevel == 79648 && current.levelId == 152528) ||
            (vars.lastLevel == 152528 && current.levelId == 164832) ||
            (vars.lastLevel == 164832 && current.levelId == 31344) ||
            (vars.lastLevel == 31344 && current.levelId == 30592) ||
            (vars.lastLevel == 30592 && current.levelId == 384);
}
