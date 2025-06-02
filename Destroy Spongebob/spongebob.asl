state("flashplayer_32_sa") {
    uint frame: 0xD1C088, 0x24, 0x4C;
}

startup {
    settings.Add("start", true, "Start on pressing 'Accept'");
    settings.Add("split", true, "Split on:");
    settings.Add("split_send", false, "Send Spongebob to Rock Bottom (known to miss a split every now and then)", "split");
    settings.Add("split_end", true, "Mission Accomplished", "split");
    settings.Add("reset", true, "Reset on returning to Main Menu");
    refreshRate = 1000;
}

init {

}

update {
    if (old.frame != current.frame) print("frame: " + old.frame + " -> " + current.frame);
}

start {
    return old.frame == 1 && current.frame == 2;
}

split {
    return (settings["split_send"] && old.frame == 116 && current.frame == 117) ||
            (settings["split_end"] && old.frame == 306 && current.frame == 307);
}

reset {
    return current.frame == 1 && old.frame != 1;
}
