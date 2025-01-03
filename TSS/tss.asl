// Load removal by elle_tree, nairam. Script by Biksel

state("LEGOSTARWARSSKYWALKERSAGA_DX11", "6Apr22")
{
    byte load: 0x05D8D850, 0xD8, 0x40, 0x10, 0x58, 0xB0, 0x0, 0x1B8;
    byte loads: 0x05D9E1A8, 0xC8, 0x10, 0x50, 0x60, 0x38, 0x30, 0xE0;
    byte cutscene: 0x5D99380, 0x460, 0xC8, 0x48, 0x0, 0x428;
    string32 quest: 0x5D8D850, 0x308, 0x298, 0x0;
}

state("LEGOSTARWARSSKYWALKERSAGA_DX11", "4May23")
{
    bool loading : 0x5F014B0, 0xE8, 0xD8, 0x8, 0x90, 0x90, 0x0, 0x20;
    byte cutscene : 0x0;
    string32 quest : 0x0;
}

startup {
    vars.Quests = new List<string> {
        "Negotiations",
        "Warn the Naboo",
        "A Bigger Fish",
        "A Royal Rescue",
        "Transport to Coruscant",
        "The Leaking Hyperdrive",
        "Off to the Races!",
        "The Boonta Eve Classic",
        "To the Senate!",
        "New Allies",
        "Better Call Maul",
        "Preparations",
        "Outmanned But Not Out-Gungan-ed",
        "Battle of Naboo",
        "Now This is Podracing",
        "A Royal Threat",
        "A Wrestle with Wesell",
        "Missing Pieces",
        "Bounty Hunter Blues",
        "The Hunt for Jango",
        "Nightmares",
        "The Tusken Raid ",
        "Distress Signal",
        "Droid Factory Frenzy",
        "Jedi Rescue",
        "Petranaki Panic",
        "On Dooku's Trail",
        "The Battle of the Jedi",
        "Out for the Count",
        "Another Happy Landing",
        "So Uncivilized",
        "A Terrible Truth",
        "The Battle of Kashyyyk",
        "Droid Attack on the Wookies",
        "The Threat Revealed",
        "Senate Showdown",
        "A New Apprentice",
        "The High Ground",
        "Boarding Party",
        "An Urgent Message",
        "New Beginnings",
        "The Millenium Falcon",
        "Hunk of Junk",
        "That's No Moon",
        "Best Leia'd Plans",
        "Tractor Beam Takedown ",
        "This is Some Rescue",
        "Delivering the Plans",
        "Stay on Target",
        "Where's Luke?",
        "Hoth and Cold",
        "Prepare For Ground Assault!",
        "Assault On Echo Base",
        "Echo Base Escape!",
        "Never Tell Me the Odds",
        "Jedi Master Yoda",
        "The Cave of Evil",
        "A Safe Port",
        "Hibernation Station",
        "Friends in Need",
        "Revelations!",
        "Jabba's Palace",
        "A Plan to Save Han",
        "The Copa-Khetanna",
        "A Promise to Keep",
        "Back to the Fleet",
        "The Forest Moon ",
        "Endor The Line",
        "Battle of Endor",
        "The Chewbacca Defense",
        "An Expected Visit",
        "Fulfill Your Destiny",
        "Attack on Tuanul",
        "New Friends ",
        "First Order of Business",
        "Scrap for Scraps",
        "Outpost Antics",
        "Low Flying Garbage",
        "Rendezvous with the Resistance",
        "Reap What You Solo",
        "Friends of the Resistance",
        "Starkiller Queen",
        "A Bag Full of Explosives",
        "Destroying Starkiller",
        "Piece of the Resistance",
        "An Urgent Communique",
        "Dameron's Defiance",
        "Finn... Leaking... Bag?",
        "Desertion ",
        "The Master Codebreaker",
        "The Master Codebreak-Out",
        "Convincing Luke",
        "Jedi Training",
        "No Snoke Without Fire",
        "Enemy Territory",
        "Chrome Dome Down",
        "Crait Danger",
        "Ground A-Salt",
        "A Skip and a Jump",
        "Running the Training Course",
        "Festival of the Ancestors",
        "They Fly Now!",
        "Beneath the Shifting Mires",
        "Forbidden Programming",
        "C-3P-Oh no!",
        "Wookie Rescue",
        "Relics of the Empire",
        "The Strength to Do it",
        "Reporting In",
        "Parting Gifts",
        "To The Battle of Exegol",
        "Be With Me"
    };

    vars.Episodes = new List<string> {"Episode I",
        "Episode II",
        "Episode III",
        "Episode IV",
        "Episode V",
        "Episode VI",
        "Episode VII",
        "Episode VIII",
        "Episode IX"
    };

    vars.SkippedSplits = new List<string> {"Nightmares", "Tractor Beam Takedown ", "Back to the Fleet ", "Attack on Tuanul", "Finn... Leaking... Bag?"};

    vars.EndSplits = new Dictionary<string, int> {
        {"Now This is Podracing", 1},
        {"The Battle of the Jedi", 2},
        {"The High Ground", 1},
        {"Stay on Target", 2},
        {"Revelations!", 1},
        {"Fulfill Your Destiny", 2},
        {"Piece of the Resistance", 2},
        {"Ground A-Salt", 1},
        {"Be With Me", 3}
    };

    settings.Add("split", false, "Experimental splitting");

    /*
    foreach (string ep in vars.Episodes) {
        settings.Add(ep, true, ep, "split");
    }*/

    foreach(string quest in vars.Quests) {
        if(vars.SkippedSplits.Contains(quest)) settings.Add(quest, false, quest, "split");
        else settings.Add(quest, true, quest, "split");
    }

}

init {
    switch (modules.First().ModuleMemorySize) {
        case 106549248:
            version = "4May23";
            break;
        case 104955904:
            version = "6Apr22";
            break;
    }

    vars.csCount = 0;
}

onStart {
    vars.csCount = 0;
}

onSplit {
    vars.csCount = 0;
}

update {
    if (old.cutscene == 0 && current.cutscene == 1) vars.csCount++;
    if (old.quest != current.quest) print(old.quest + " -> " + current.quest);
    //print(vars.csCount + "");
}

isLoading
{
    if (version == "6Apr22") return current.load == 1 && current.loads == 1;
    else if (version == "4May23") return current.loading;
}

split {
    return (old.quest != current.quest && settings[old.quest] && vars.Quests.IndexOf(old.quest) < vars.Quests.IndexOf(current.quest) && !vars.EndSplits.ContainsKey(old.quest))
            || (vars.EndSplits.ContainsKey(current.quest) && vars.csCount == vars.EndSplits[current.quest]);
}


