// SAS1 autosplitter by Biksel, for accurate end split download the modded game from speedrun.com

state("Swords and Sandals Classic Collection") {

}

init {
    vars.bosses = new List<string>() {
        "Wolfg",
        "Bo'su",
        "The S",
        "Nine ",
        "Stylo",
        "Lord ",
        "HeCha"
    };

    current.raw = null;
    current.data = null;
    current.enemy = "";
    current.stats = new List<int>(new int[7]);
    current.bossesKilled = 0;
    vars.changed = false;/*
    var directory = new DirectoryInfo(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\com.game.whiskeybarrelstudios.swordsandsandalsclassic\Local Store\#SharedObjects\swf\swords_sandals_download.swf");
    vars.file = (from f in directory.GetFiles()
                orderby f.LastWriteTime descending
                select f).First();
    vars.reader = new StreamReader(vars.file.FullName, Encoding.Default);*/
}

update {
    // Init file and StreamReader
    var directory = new DirectoryInfo(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + @"\com.game.whiskeybarrelstudios.swordsandsandalsclassic\Local Store\#SharedObjects\swf\swords_sandals_download.swf");
    vars.file = (from f in directory.GetFiles()
                orderby f.LastWriteTime descending
                select f).First();
    vars.reader = new StreamReader(new FileStream(vars.file.FullName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete), Encoding.Default);


    if (vars.reader == null) return;
    current.raw = vars.reader.ReadLine();
    if (old.raw == current.raw) return false;
    current.data = current.raw.Split(',');
    current.enemy = current.data[27].Length > 4 ? current.data[27].Substring(0, 5) : current.enemy;
    current.gold = Int32.Parse(current.data[28]);

    var newStats = new List<int>(new int[7]);
    for (int i = 0; i < 7; i++) {
        newStats[i] = Int32.Parse(current.data[16 + i]);
    }
    current.stats = newStats;
    for(int i = 0; i < current.data.Length; i++) {
        //print(entry + " " + Array.IndexOf(vars.data, entry));
        print(current.data[i] + ", old: " + old.data[i] + ", index:" + i);
    }

    print("Stats: " + string.Join(", ", current.stats));

    vars.changed = false;
    for (int i = 0; i < 7; i++) {
        print("Old: " + old.stats[i] + ", Current: " + newStats[i]);
        if (old.stats[i] > current.stats[i] && current.stats[i] == 1) {
            vars.changed = true;
        }
    }

    print(vars.changed + "");

    vars.reader.Close();
}

split {
    //return vars.bosses.Contains(current.enemy) && old.enemy != current.enemy;
    return old.enemy != current.enemy && vars.bosses.Contains(current.enemy);
}

start {
    return old.gold == current.gold && current.gold == 1000 && vars.changed == false;
}

exit {
    vars.reader.Close();
}
