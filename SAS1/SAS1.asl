// SAS1 autosplitter by Biksel, for accurate end split download the modded game from speedrun.com

state("Swords and Sandals Classic Collection") {

}

init {
    vars.bosses = new List<string>() {
        "Wolfgan",
        "Bo'sun ",
        "The Sla",
        "Nine Ca",
        "Styloni",
        "Lord Ta",
        "HeChaos"
    };

    current.raw = null;
    current.data = null;
    current.enemy = "";
    current.stats = new List<int>(new int[7]);
    current.bossesKilled = 0;
    vars.changed = false;
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
    current.enemy = current.data[27].Length > 4 ? current.data[27].Substring(0, 8) : current.enemy;
    current.gold = Int32.Parse(current.data[28]);

    vars.reader.Close();
}

split {
    //return vars.bosses.Contains(current.enemy) && old.enemy != current.enemy;
    return old.enemy != current.enemy && vars.bosses.Contains(current.enemy);
}

start {
    return old.gold == current.gold && current.gold == 1000;
}

exit {
    vars.reader.Close();
}
