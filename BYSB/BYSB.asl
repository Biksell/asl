// Made by Biksel
// Supports both original and GOTY versions

state("BYSkateboarding", "OG") {
    byte yellow: 0x448824, 0xBC, 0x3C, 0x4;
    byte orange: 0x448824, 0xBC, 0x3C, 0x8;
    byte red: 0x448824, 0xBC, 0x3C, 0xC;
    byte load: 0x4FF900, 0x10, 0xF8, 0x18;
    bool menu: 0x4FF814;
    string16 level: 0x448824, 0xC4, 0xE;
}

state("BYSkateboarding", "GOTY") {
    byte yellow: 0x44081C, 0xEC, 0x50, 0x4;
    byte orange: 0x44081C, 0xEC, 0x50, 0x8;
    byte red: 0x44081C, 0xEC, 0x50, 0xC;
    byte load: 0x442880, 0x58;
    byte inChallenge: 0x44081C, 0xAC, 0x48;
    bool menu: 0x47A608;
    string16 level: 0x44081C, 0x100, 0xE;
    string4 chalTitle: 0x4404B0;
}

init {
    refreshRate = 200;
    vars.currentLevel = "";
    switch (modules.First().ModuleMemorySize) {
        case 5611520:
            version = "OG";
            break;
        case 5079040:
            version = "GOTY";
            break;
    }
}

update {
    if (old.load != current.load) print(old.load + " -> " + current.load);
    if (old.level != current.level) vars.currentLevel = current.level;
    //print(modules.First().ModuleMemorySize + "");
}


onStart {
    vars.currentLevel = current.level;
}

isLoading {
    return current.load == 1;
}

split {
    if (version == "GOTY" && current.chalTitle == "Andy" && old.inChallenge == 1 && current.inChallenge == 0) return true;
    else if (version == "GOTY" && current.level == "skatepark/" && current.chalTitle == "Boss" && old.inChallenge == 1 && current.inChallenge == 0) return true;
    return current.level == vars.currentLevel && ((current.yellow - old.yellow == 1) || (current.orange - old.orange == 1) || (current.red - old.red == 1));
}

start {
    return current.load == 1 && old.menu && !current.menu && current.yellow == 0 && current.orange == 0 && current.red == 0 && current.level == "neighborhood/";
}
