/*

*/

state("Stairway-Win64-Shipping") {
    float igt : "Stairway-Win64-Shipping.exe", 0x3336F28, 0x130, 0x310;
    bool mainMenu : "Stairway-Win64-Shipping.exe", 0x3307800, 0xF8, 0x4D8, 0xB6C;
}

startup {
    vars.totalIGT = new TimeSpan();
}

onStart {
    vars.totalIGT = TimeSpan.Zero;
}

gameTime {
    if (old.igt > current.igt) {
        vars.totalIGT += TimeSpan.FromSeconds(old.igt);
    }
    return vars.totalIGT + TimeSpan.FromSeconds(current.igt);
}

start {
    return current.igt > 0f && !current.mainMenu && old.igt < 0.1f;
}

update {

}

split {
    //return !old.mainMenu && current.mainMenu && current.igt > 1f;
    return old.mainMenu && !current.mainMenu && current.igt > 0f;
}

isLoading {
    return true;
}
