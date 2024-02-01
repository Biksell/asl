// Autosplitting by Biksel, Load removal by RedMage08

state("SWRepublicCommando")
{
    int isLoading : "Core.dll", 0x0003E4A0, 0x4;
    string7 level : "Engine.dll", 0x00463914, 0x118, 0x58, 0x0;
}

startup {
    vars.levels = new Dictionary<string, string>(){
        //"PRO"
        //"GEO_01Brie"
        {"GEO_01A", "Extreme Prejudice"},
		{"GEO_01B", "Into the Hive"},
		{"GEO_01C", "The Strength of Brothers"},
		{"GEO_03A", "Infiltrate the Foundry"},
		{"GEO_03C", "Heart of the Machine"},
		{"GEO_03D", "Destroy the Foundry"},
		{"GEO_04A", "Advance to the Coreship"},
		{"GEO_04B", "Canyons of Death"},
		{"GEO_04C", "To Own the Skies"},
		{"GEO_04D", "Territory"},
		{"GEO_05A", "Infiltrate the Coreship"},
		{"GEO_05B", "Waking the Giant"},
		{"GEO_05C", "Belly of the Beast"},
        //"RAS_01Brie",
        {"RAS_01A", "Ghost Ship Recon"},
		{"RAS_01B", "Delta Down"},
		{"RAS_01C", "Unwelcome Visitors"},
		{"RAS_02A", "Rescue the Squad"},
		{"RAS_02B", "Alone"},
		{"RAS_02C", "Troika"},
		{"RAS_02D", "Jailbreak"},
		{"RAS_02E", "Tactical Supremacy"},
		{"RAS_03A", "Attack of the Clones"},
		{"RAS_03B", "Lockdown"},
		{"RAS_03C", "Wrath of the Republic"},
		{"RAS_04A", "Saving the Ship"},
		{"RAS_04B", "Holding the Line"},
		{"RAS_04C", "Overwhelming the Odds"},
		{"RAS_04D", "Deus Ex Machina"},
        //"YYY_01Brie"
        {"YYY_01B", "Rescue Tarfful"},
		{"YYY_01C", "Hard Contact"},
		{"YYY_01D", "From the Shadows"},
		{"YYY_01E", "The Bodyguards"},
		{"YYY_35A", "Obliterate the Outpost"},
		{"YYY_35B", "Aim for the Heart"},
		{"YYY_35C", "Critical Strike"},
		{"YYY_04A", "The Bridge of Kachirho"},
		{"YYY_04B", "Frontline"},
		{"YYY_04C", "The Gauntlet"},
		{"YYY_04E", "Detour"},
		{"YYY_04F", "A Bridge Too Far"},
        {"YYY_05A", "The Wookie Resistance"},
		{"YYY_05B", "Behind Enemy Lines"},
		{"YYY_05C", "VIW"},
		{"YYY_05D", "Saving Ammo"},
		{"YYY_05E", "Live Ordnance"},
		{"YYY_05F", "Fate of the Resistance"},
		{"YYY_06A", "Search and Destroy"},
		{"YYY_06B", "Heart of the Citadel"},
		{"YYY_06C", "Moving Upstream"},
        //"YYY07Brie"
        {"YYY_06D", "The Final Strike"}
        //"EPILOGUE"
    };

    vars.levelIds = new List<string>(vars.levels.Keys);
    vars.levelNames = new List<string>(vars.levels.Values);

    foreach(KeyValuePair<string, string> level in vars.levels) {
        if (level.Key == "YYY_06D") continue;
        settings.Add(level.Key, true, "Split after " + level.Value);
    }

    vars.lastLevel = "Entry.c";
}

split {
    return (old.level != current.level && vars.levelIds.IndexOf(current.level) > vars.levelIds.IndexOf(vars.lastLevel) && settings[vars.lastLevel]);
}

start {
    //return old.level == "Entry.c" && current.level == "PRO";
}

isLoading
{
	return current.isLoading != 0;
}

update {
    if (old.level != current.level) {
        print(old.level + " => " + current.level + vars.completedLevels.Count.ToString());
        if (vars.levelIds.Contains(old.level)) {
            vars.lastLevel = old.level;
        }
    }
}
