state("ChromaGun2-Win64-Shipping") {
    bool pointerLoading: 0x92AFF70, 0x178;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.AlertLoadless();

    settings.Add("start", true, "Start after skipping intro text");
    settings.Add("demo_any%", true, "Split on loading screens between chambers");
    settings.Add("demo_end", true, "Split on entering the portal in the final chamber");
}

init
{
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
    vars.Helper["EHUDConfig"] = vars.Helper.Make<byte>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B8);
    // GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.MyHUD.HUDLayoutInstance
    vars.Helper["test"] = vars.Helper.Make<byte>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x4B0, 0x02F8, 0x00DC);
    // GWorld.AuthorityGamemode.HUDClass.HUDLayoutInstance.Widgets
    int widgets = vars.Helper.Read<int>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x460 + 0x8);
    for (int i = 0; i < widgets; i++) {
        ulong fName = vars.Helper.Read<ulong>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x340, 0x3B0, 0x460 + i * 0x18 + 0x8, 0x18);
        print(vars.FNameToString(fName));
    }
    //GWorld.OwningGameInstance.LocalPlayers[0].PlayerController.PlayerCameraManager.TransformComponent.RelativeLocation
    vars.Helper["x"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x128);
    vars.Helper["z"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x130);
    vars.Helper["y"] = vars.Helper.Make<double>(gWorld, 0x1D8, 0x38, 0x0, 0x30, 0x0348, 0x298, 0x138);

    // GEngine.TransitionType
    vars.Helper["TransitionType"] = vars.Helper.Make<uint>(gEngine, 0xBBB);
    // GEngine.TransitionDescription
    vars.Helper["TransitionDescription"] = vars.Helper.MakeString(gEngine, 0xBC0, 0x0);
    // GWorld.AuthorityGamemode.FName
    vars.Helper["AuthorityGamemode"] = vars.Helper.Make<uint>(gEngine, 0x158, 0x2F0, 0x18);

    vars.Helper["loading"] = vars.Helper.Make<bool>(gSyncLoad);
    vars.loadCount = 0;

    //vars.endSplit = new Stopwatch();
    current.levelNumber = 0;
    current.positionTotal = 0;
}

update
{

    vars.Helper.Update();
    vars.Helper.MapPointers();
    current.player = vars.FNameToString(current.ULocalPlayer);
    current.level = vars.FNameToString(current.GWorldName);
    if (current.level.Length > 12) current.levelNumber = Int32.Parse(current.level.Substring(10,1));
    if (current.levelNumber == 4) current.positionTotal = Math.Floor(current.x + current.y + current.z);
    current.positionTotal = Math.Floor(current.x + current.y + current.z);

    //if (current.levelNumber == 4 && old.positionTotal == 20657 && old.positionTotal != current.positionTotal) vars.endSplit.Start();

    if (old.level != current.level) {
        vars.loadCount = 0;
    }

    if (current.level == "Chamber_0-1_Demo" && old.loading && !current.loading) {
        vars.loadCount++;
    }

    /*
    if (old.x != current.x || old.y != current.y || old.z != current.z) {
        print ("xyz: " + current.x + ", " + current.y + ", " + current.z);
    }*/
    print(current.test + "");
    //print(vars.FNameToString(current.test));
    if (old.player != current.player) print("player: " + old.player + " -> " + current.player);
    if (old.loading != current.loading) print("loading: " + old.loading + " -> " + current.loading);
    if (old.level != current.level) print("level: " + old.level + " -> " + current.level);
    if (old.TransitionType != current.TransitionType) print("TransitionType: " + old.TransitionType + " -> " + current.TransitionType);
    //if (old.positionTotal != current.positionTotal) print(current.positionTotal + "");
}

isLoading {
    return current.level == "None" || current.loading || current.pointerLoading;
}

start {
    return settings["start"] && vars.loadCount == 2 && !current.loading && current.levelNumber == 1;
}

onStart {
    vars.loadCount = 0;
}

split {
    return (settings["demo_any%"] && current.levelNumber - old.levelNumber == 1) ||
            //(current.levelNumber == 4 && vars.endSplit.ElapsedMilliseconds >= 4133) ||
            (settings["demo_end"] && current.levelNumber == 4 && current.positionTotal == 20657 && old.positionTotal != current.positionTotal) ||
            (settings["demo_any%"] && old.level == "None" && current.level == "Chamber_0-3_Demo_Chickenverse") ||
            (settings["demo_any%"] && old.level == "Chamber_0-3_Demo" && current.level == "Chamber_0-3_Demo_Chickenverse");
}

onSplit {
    //vars.endSplit.Reset();
    vars.loadCount = 0;
}
