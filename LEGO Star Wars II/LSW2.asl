// Made by Biksel

/*
4-1 R1: BLOCKADERUNNER_A
4-2
*/

state("LegoStarWarsII") {
    bool load: 0x26A26C;
    bool cutscene: 0x262044;
    bool status: 0x269A90;
    string16 levelBuffer: 0x330671E;
    float gametime: 0x330DF8C;
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
}

exit {
    timer.IsGameTimePaused = true;
}
