// Made by Biksel
// emu-help by Jujstme: https://github.com/Jujstme/emu-help

state("LegoStarWarsII", "PC") {
    int load: 0x26A26C;
    int endLoad: 0x24F394;
    int cutscene: 0x262044;
    //bool status: 0x269A90; //unstable
    byte status: 0x24F389;
    string16 levelBuffer: 0x330671E;
    string14 level2: 0x2FB7AF7;
    //float gametime: 0x330DF8C;
    byte newgame: 0x243BC6;
}

state("Dolphin") {
}

startup {

    settings.Add("startNew", true, "Start on New Game");
    settings.Add("startDestiny", false, "Start on entering Jedi Destiny (Free Play)");
    settings.Add("split", true, "Split: ");
    settings.Add("splitStatus", true, "Split on status screen", "split");
    settings.Add("splitBespinCS", true, "Split on Bespin ending cutscene", "split");

    var type = Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).GetType("GCN");
    vars.Helper = Activator.CreateInstance(type, args: false);
}

init {
    vars.isEmu = game.ProcessName == "Dolphin";
    vars.Helper.Load = (Func<dynamic, bool>)(emu => {
        emu.MakeString("levelBuffer", 16, 0x80321726);
        emu.MakeString("level2", 14, 0x80271B1F);
        emu.Make<byte>("status", 0x804011CC);
        emu.Make<byte>("newgame", 0x80400BA3);
        emu.Make<int>("cutscene", 0x80401448);
        emu.Make<int>("load", 0x80400D5C);
        return true;
    });
}

isLoading {
    return current.load == 1 || current.endLoad == 1;
}

update {
    vars.isEmu = vars.Helper.Update();
    if (vars.isEmu) {
        current.levelBuffer = vars.Helper["levelBuffer"].Current;
        current.level2 = vars.Helper["level2"].Current;
        current.status = vars.Helper["status"].Current;
        current.newgame = vars.Helper["newgame"].Current;
        current.cutscene = vars.Helper["cutscene"].Current;
        current.load = vars.Helper["load"].Current;
    }
    if (old.load != current.load) print("load: " + old.load + " -> " + current.load);
    if (old.cutscene != current.cutscene) print("cutscene: " + old.cutscene + " -> " + current.cutscene);
    if (old.status != current.status) print("status: " + old.status + " -> " + current.status);
    if (old.levelBuffer != current.levelBuffer) print("levelBuffer: " + old.levelBuffer + " -> " + current.levelBuffer);
    if (old.newgame != current.newgame) print("newgame: " + old.newgame + " -> " + current.newgame);
    if (old.endLoad != current.endLoad) print("endLoad: " + old.endLoad + " -> " + current.endLoad);
}

start {
    return (settings["startNew"] && old.newgame == 0 && current.newgame == 1 && current.status == 255) ||
        (settings["startDestiny"] && old.load == 1 && current.load == 0 && current.levelBuffer == "Fight_A\\EmperorF");
}

split {
    return (settings["splitStatus"] && old.status == 0 && current.status == 255 && (!String.IsNullOrEmpty(current.levelBuffer) || current.level2 == "SpeederChase_A")) ||
        (settings["splitBespinCS"] && (current.levelBuffer == "CityEscape_Outro" || current.levelBuffer == "CityEscape_Statu") && old.cutscene == 0 && current.cutscene == 1);

}

shutdown {
    vars.Helper.Dispose();
}

exit {
    timer.IsGameTimePaused = true;
}
