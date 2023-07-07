// Credits to Ero for making asl-help! https://github.com/just-ero/asl-help/raw/main/lib/asl-help
/*
(if needed in the future)
PlayModes:
0: Campaign
1: Challenge
2: Custom
3: Daily
4: Online
5: Test
*/

state("Strike Force Heroes Demo") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Strike Force Heroes";
    vars.Helper.LoadSceneManager = true;

    // <missionId, lastMap>
    vars.demoMissions = new Dictionary<string, string> {
        {"Under Siege", "Facility"},
        {"Rebellion", "Tropic"},
        {"Hijack", "Plane"},
        {"Infection", "Caves"}
    };

    // <missionId, <lastMap, displayName>>
    vars.demoExtraMissions = new Dictionary<string, Tuple<string, string>> {
        {"Tropic CTF", Tuple.Create("Tropic", "Side Ops 2-1")},
        {"Tropic Domination", Tuple.Create("Tropic", "Side Ops 2-2")},
        {"Plane DOM", Tuple.Create("Plane", "Side Ops 3-1")},
        {"Plane CTF", Tuple.Create("Plane", "Side Ops 3-2")},
        {"Plane FFA", Tuple.Create("Plane", "Side Ops 3-3")}
    };

    settings.Add("start", true, "Start on \"Press Any Button\"");
    settings.Add("demo_any%", true, "Any% (Demo) splits: ");
    settings.Add("demo_100%", false, "100% (Demo) splits: ");
    settings.Add("demo_end", true, "End run on:     (split at cutscene start)");

    foreach (KeyValuePair<string, string> mission in vars.demoMissions) {
        settings.Add(mission.Key, true, "Split on " + mission.Key, "demo_any%");
        if (mission.Key == "Infection") {
            settings.Add("end_" + mission.Key, true, "End on " + mission.Key, "demo_end");
            continue;
        }
        settings.Add("end_" + mission.Key, false, "End on " + mission.Key, "demo_end");
    }

    foreach (KeyValuePair<string, Tuple<string, string>> mission in vars.demoExtraMissions) {
        settings.Add(mission.Key, false, "Split on " + mission.Value.Item2, "demo_100%");
        settings.Add("end_ " + mission.Key, false, "End on " + mission.Value.Item2, "demo_end");
    }

    vars.inputChanges = 0; // AnyInput-InputAction gets reset once before the wanted start time, and once right when time starts, so start timer when it has reset twice
    vars.hasStarted = false;
    vars.canReset = false;
    vars.latestMap = "";
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["mission"] = mono.MakeString("GI", "GlobalVars", "CurMission", "Title");
        vars.Helper["playMode"] = mono.Make<int>("GI", "GlobalVars", "CurPlayMode");
        vars.Helper["inputID"] = mono.Make<int>("GI", "ControlHandler", "Actions", "m_AnyInput", "m_Id");
        vars.Helper["inputName"] = mono.Make<int>("GI", "ControlHandler", "Actions", "m_AnyInput", "m_Name");

        return true;
    });
}

onReset {
    vars.hasStarted = false;
    vars.inputChanges = 0;
}

onStart {
    vars.hasStarted = true;
    vars.canReset = false;
    vars.latestMap = "";
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? "noScene";
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? "noScene";

    //Set the latestMap
    if (current.activeScene != "noScene" && current.activeScene != "CutsceneMov" && vars.latestMap != current.activeScene) vars.latestMap = current.activeScene;

    // Add +1 on input change (so we can start at 2)
    if (!vars.hasStarted && old.inputID != current.inputID && old.inputID != 0 && current.inputID != 0) vars.inputChanges++;

    // Debug
    //if (old.activeScene != current.activeScene) print(old.activeScene + " -> " + current.activeScene);
    //if (old.mission != current.mission) print(old.mission + " -> " + current.mission);
}

start {
    return vars.inputChanges == 2 && !vars.hasStarted;
}

split {
    // Normal splits
    if (old.activeScene != "Results" && current.activeScene == "Results" && settings[current.mission]) {
        if (vars.demoExtraMissions.ContainsKey(current.mission) && settings["demo_100%"]) return true;
        return settings["demo_any%"];
    }

    // End split
    if (settings["end_" + current.mission] && settings["demo_end"] && old.activeScene != "CutsceneMov" && current.activeScene == "CutsceneMov")  {
        if (vars.demoExtraMissions.ContainsKey(current.mission)) return vars.demoExtraMissions[current.mission].Item1 == vars.latestMap;
        else return vars.demoMissions[current.mission] == vars.latestMap;
    }
}
