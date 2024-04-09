// Made by Biksel
/*
4-1 R1: BLOCKADERUNNER_A
4-2
*/

state("LegoStarWarsII") {
    bool load: 0x26A26C;
    bool cutscene: 0x262044;
    //bool status: 0x269A90; //unstable
    byte status: 0x24F389;
    string16 levelBuffer: 0x330671E;
    float gametime: 0x330DF8C;
    byte newgame: 0x243BC6;
}

startup {
    settings.Add("split", false, "Experimental splitting: ");
    settings.Add("splitStatus", true, "Split on status screen", "split");
    settings.Add("splitBespinCS", true, "Split on Bespin ending cutscene", "split");
    settings.Add("startNew", true, "Start on New Game", "split");
    settings.Add("startDestiny", false, "Start on entering Jedi Destiny (Free Play)", "split");
}

isLoading {
    return current.load;
}

update {
    if (old.load != current.load) {
        print("load: " + old.load + " -> " + current.load);
    }
    if (old.cutscene != current.cutscene){
        print("cutscene: " + old.cutscene + " -> " + current.cutscene);
    }
    if (old.status != current.status){
        print("status: " + old.status + " -> " + current.status);
    }
    if (old.levelBuffer != current.levelBuffer){
        print("levelBuffer: " + old.levelBuffer + " -> " + current.levelBuffer);
    }
    if (old.newgame != current.newgame){
        print("newgame: " + old.newgame + " -> " + current.newgame);
    }
}

start {
    if(!settings["split"]) return false;
    return (settings["startNew"] && old.newgame == 0 && current.newgame == 1 && current.status == 255) ||
            (settings["startDestiny"] && old.load && !current.load && current.levelBuffer == "Fight_A\\EmperorF");
}

split {
    if(!settings["split"]) return false;
    return (settings["splitStatus"] && old.status == 0 && current.status == 255 && !String.IsNullOrEmpty(current.levelBuffer)) ||
            (settings["splitBespinCS"] && (current.levelBuffer == "CityEscape_Outro" || current.levelBuffer == "CityEscape_Statu") && !old.cutscene && current.cutscene);
}

exit {
    timer.IsGameTimePaused = true;
}
