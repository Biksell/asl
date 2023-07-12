/*
Stairway to Heaven's Gate autosplitter by Biksel
*/

state("Stairway-Win64-Shipping") {
    float igt : "Stairway-Win64-Shipping.exe", 0x3336F28, 0x130, 0x310;
    bool mainMenu : "Stairway-Win64-Shipping.exe", 0x3307800, 0xF8, 0x4D8, 0xB6C;
}

startup {
    vars.totalIGT = new TimeSpan();

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var timingMessage = MessageBox.Show (
            "This game supports In Game Time (IGT).\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Stairway to Heaven's Gate",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
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

split {
    //return !old.mainMenu && current.mainMenu && current.igt > 1f;
    return old.mainMenu && !current.mainMenu && current.igt > 0f;
}

isLoading {
    return true;
}
