state ("LEGOATeamAltTab") {
    int id1 : "DDPackedDirFileLib.dll", 0xF19C;
    int id2 : "BehaviorComp.dll", 0x8598;
}

state ("LEGOATeam") {
    int id1 : "DDPackedDirFileLib.dll", 0xF19C;
    int id2 : "BehaviorComp.dll", 0x8598;
}

startup {
    // <levelName, <id1, id2>>
    vars.Levels = new List<Tuple<string, int, int>> {
        //{Tuple.Create("Main Menu", 265, 11)},
        //{Tuple.Create("Tutorial #1", 307, 18)},
        {Tuple.Create("Mission One", 350, 19)},
        {Tuple.Create("On the Right Path", 310, 18)},
        {Tuple.Create("The Hidden Hop", 342, 30)},
        {Tuple.Create("The Which-Way Warehouse", 352, 32)},
        {Tuple.Create("The Triple Jump", 374, 27)},
        {Tuple.Create("High and Low", 353, 32)},
        {Tuple.Create("Sliding By", 374, 34)},
        {Tuple.Create("The Trouble Tube", 414, 30)},
        {Tuple.Create("Crunch Time", 401, 34)},
        {Tuple.Create("The Boom Room", 385, 47)},
        {Tuple.Create("Crisscross", 408, 51)},
        {Tuple.Create("Yee-Haw, See Saws!", 381, 37)},
        {Tuple.Create("See-Saw Doublecross", 394, 40)},
        {Tuple.Create("Demolition Derby", 433, 44)},
        {Tuple.Create("Fill in the Blanks", 388, 35)},
        {Tuple.Create("Punch a Bunch of Punchers", 416, 40)},
        {Tuple.Create("Tag-Team Crossover", 418, 50)},
        {Tuple.Create("Trouble Train Depot", 522, 52)},
        {Tuple.Create("Entrance to the Goo Caverns", 431, 50)},
        {Tuple.Create("See-Saw Laser Maze", 419, 36)},
        {Tuple.Create("Mirror Madness", 375, 38)},
        {Tuple.Create("Mirror Mirror", 381, 39)},
        {Tuple.Create("Too Many Mirrors", 352, 26)},
        {Tuple.Create("You Know the Drill", 386, 37)},
        {Tuple.Create("Barrel Hop", 422, 52)},
        {Tuple.Create("Confused", 473, 43)},
        {Tuple.Create("Trouble Tube Twist", 433, 36)},
        //{Tuple.Create("Tutorial #2", 294, 13)},
        {Tuple.Create("Hectic Electric", 422, 38)},
        {Tuple.Create("Pump Room Jump", 420, 41)},
        {Tuple.Create("Have See-Saw, Will Travel", 453, 40)},
        {Tuple.Create("Double Trouble", 459, 39)},
        {Tuple.Create("Turbo Relay", 455, 47)},
        {Tuple.Create("Second Step's a Doozy", 479, 48)},
        {Tuple.Create("Trouble Sub Rescue", 507, 44)},
        //{Tuple.Create("Tutorial #3", , )},
        {Tuple.Create("Trouble Sub Docking Bay", 507, 39)},
        {Tuple.Create("Cam in Control", 447, 29)},
        {Tuple.Create("Double-Duty Charge", 511, 40)},
        {Tuple.Create("Ejector Sector", 409, 39)},
        {Tuple.Create("Rescue Flex!", 465, 33)},
        //{Tuple.Create("Tutorial #4", 333, 16)},
        {Tuple.Create("Tug Team", 410, 33)},
        {Tuple.Create("Drop into Danger", 424, 32)},
        {Tuple.Create("Computer Hop", 493, 41)},
        {Tuple.Create("Dash's Decoy", 399, 40)},
        {Tuple.Create("The D.O.O.M. Room", 500, 48)},
        {Tuple.Create("Arctic Dash", 430, 40)},
        {Tuple.Create("Crunch Punch", 451, 52)},
        {Tuple.Create("Rely on Radia", 526, 50)},
        {Tuple.Create("Charge in Charge", 449, 44)},
        {Tuple.Create("Cam's Challenge", 442, 47)},
        {Tuple.Create("Featuring Flex", 412, 34)},
        {Tuple.Create("Mission Control", 563, 48)}
    };

    settings.Add("split", true, "Split after: ");
    foreach (var level in vars.Levels) {
        settings.Add(level.Item1, true, level.Item1, "split");
    }

    vars.latestLevel = 0;
    vars.enabledSplits = new List<Tuple<string, int, int>>();
}

onStart {
    vars.latestLevel = 0;
    vars.enabledSplits = new List<Tuple<string, int, int>>();
    foreach (var level in vars.Levels) {
        if (settings[level.Item1]) vars.enabledSplits.Add(level);
    }
}

update {
    if (old.id1 != current.id1 || old.id2 != current.id2) print("latestLevel: " + vars.latestLevel + ", " + old.id1 + ", " + old.id2 + " -> " + current.id1 + ", " + current.id2);
}

split {
    if ((old.id1 != current.id1 || old.id2 != current.id2) && vars.enabledSplits[vars.latestLevel + 1].Item2 == current.id1 && vars.enabledSplits[vars.latestLevel + 1].Item3 == current.id2 && settings[vars.enabledSplits[vars.latestLevel+1].Item1]) {
        vars.latestLevel++;
        return true;
    }
}
