state("ChromaGun2-Win64-Shipping") {}

startup {

    vars.chambers = new List<string>() {
        "Chamber_0-1_Demo",
        "Chamber_0-2_Demo",
        "Chamber_0-3_Demo",
        "Chamber_0-3_Demo_Chickenverse",
        "Chamber_0-4_Demo"
    };

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.AlertGameTime();

    settings.Add("start", true, "Start after skipping intro text");
    settings.Add("demo_any%", true, "Split on loading screens between chambers: ");
    settings.Add("demo_end", true, "Split on entering the portal in the final chamber");
    settings.Add("split_golden", false, "Split on collecting a Golden ChromaGun");
    settings.Add("reset", true, "Reset on returning to Main Menu");

    for (int i = 1; i < vars.chambers.Count; i++) {
        var str = vars.chambers[i - 1]  + " -> " + vars.chambers[i];
        settings.Add(str, true, str, "demo_any%");
    }

}

init {
    var gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
    var gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
    var fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
    var gSyncLoad = vars.Helper.ScanRel(5, "89 43 60 8B 05");

    if (gEngine == IntPtr.Zero || gWorld == IntPtr.Zero)
         throw new Exception();

    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);

        int length = vars.Helper.Read<short>(entry) >> 6;
        string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

        return number == 0 ? name : name + "_" + number;
    });

    // GWorld name
    vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gWorld, 0x18);
    // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.FName
    vars.Helper["ULocalPlayer"] = vars.Helper.Make<ulong>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x18);
    // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.MyHUD.CurrentHUDConfig
    //vars.Helper["EHUDConfig"] = vars.Helper.Make<byte>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B8);
    // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.MyHUD.HUDLayoutInstance
    //vars.Helper["test"] = vars.Helper.Make<byte>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x4B0, 0x02F8, 0x00DC);
    // GWorld.AuthorityGamemode.HUDClass.HUDLayoutInstance.Widgets
    //int widgets = vars.Helper.Read<int>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x460 + 0x8);
    /*
    for (int i = 0; i < widgets; i++) {
        ulong fName = vars.Helper.Read<ulong>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x460 + i * 0x18 + 0x8, 0x18);
        print(vars.FNameToString(fName));
    }*/

    //GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.PlayerCameraManager.TransformComponent.RelativeLocation
    vars.Helper["x"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x128);
    vars.Helper["z"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x130);
    vars.Helper["y"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x138);

    // GEngine.TransitionType
    //vars.Helper["TransitionType"] = vars.Helper.Make<uint>(gEngine, 0xBBB);

    // GEngine.GameViewport.SpeedRunWidget.TimeText...
    vars.Helper["SpeedrunTimer"] = vars.Helper.MakeString(128, ReadStringType.UTF16, gEngine, 0xA80, 0x3F0, 0x2E8, 0x1A0, 0x28, 0x0);

    // GEngine.GameViewport.SpeedrunWidget.TrinketText
    vars.Helper["TrinketCount"] = vars.Helper.MakeString(128, ReadStringType.UTF16, gEngine, 0xA80, 0x3F0, 0x2F0, 0x1A0, 0x28, 0x0);

    // GEngine.TransitionDescription
    //vars.Helper["TransitionDescription"] = vars.Helper.MakeString(gEngine, 0xBC0, 0x0);
    // GWorld.AuthorityGamemode.FName
    //vars.Helper["AuthorityGamemode"] = vars.Helper.Make<uint>(gEngine, 0x158, 0x2F0, 0x18);

    //vars.Helper["loading"] = vars.Helper.Make<bool>(gSyncLoad);

    current.positionTotal = 0;
    current.chamber = "Chamber_0-1_Demo";
}

update {
    vars.Helper.Update();
    vars.Helper.MapPointers();
    current.time = TimeSpan.Parse("00:" + current.SpeedrunTimer);
    current.trinkets = Int32.Parse(current.TrinketCount.Substring(current.TrinketCount.Length - 2));
    current.world = vars.FNameToString(current.GWorldName);
    if (vars.chambers.Contains(current.world)) current.chamber = current.world;

    if (current.chamber == "Chamber_0-4_Demo") current.positionTotal = Math.Floor(current.x + current.y + current.z);
    current.positionTotal = Math.Floor(current.x + current.y + current.z);

    //print(current.TrinketCount[current.TrinketCount.Length - 1] + "");
    //print(current.trinkets + "");

    //if (old.positionTotal != current.positionTotal) print(old.positionTotal + " -> " + current.positionTotal);
    //if (old.x != current.x || old.y != current.y || old.z != current.z) print("X: " + current.x + ",Y: " + current.y + ",Z: " + current.z);
    if (old.world != current.world) print("world: " + old.world + " -> " + current.world);
    if (old.chamber != current.chamber) print("chamber: " + old.chamber + " -> " + current.chamber);
}

gameTime {
    return current.time;
}

isLoading {
    return true;
}

start {
    return settings["start"] && current.chamber == "Chamber_0-1_Demo" && old.time.Milliseconds <= 50 && current.time.Milliseconds > 50;
}

split {
    return (old.GWorldName != current.GWorldName && settings[old.chamber + " -> " + current.chamber]) ||
            (settings["split_golden"] && current.trinkets - old.trinkets == 1) ||
            (settings["demo_end"] && current.chamber == "Chamber_0-4_Demo" && current.positionTotal == 20657 && old.positionTotal != current.positionTotal);
}

reset {
    return settings["reset"] && old.world != "MainMenu" && current.world == "MainMenu";
}
