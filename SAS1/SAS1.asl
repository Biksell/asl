// SAS1 autosplitter by Biksel, for accurate end split download the modded game from speedrun.com

state("Swords and Sandals Classic Collection") {

}

init {
    vars.bosses = new List<string>() {
        "Wolfgang",
        "Bo'sun S",
        "The Slav",
        "Nine Cat",
        "Styloniu",
        "Lord Tal",
        "HeChaos "
    };

    current.raw = null;
    current.data = null;
    current.enemy = "";
    current.stats = new List<int>(new int[7]);
    current.bossesKilled = 0;
    current.gold = 0;
    current.name = "";
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

    // Wait until contents change
    if (old.raw == current.raw) return false;

    //
    current.data = current.raw.Split(',');
    current.enemy = current.data[27].Length > 4 ? current.data[27].Substring(0, 7) : current.enemy;
    current.gold = Int32.Parse(current.data[28]);
    var a = "";
    for(int i = 0; i < 8; i++) {
        a += current.raw[55+i];
    }
    current.name = a;
}

split {
    //return vars.bosses.Contains(current.enemy) && old.enemy != current.enemy;
    return old.enemy != current.enemy && vars.bosses.Contains(current.enemy);
}

start {
    return old.gold == current.gold && current.gold == 1000 && current.name == "Nameless";
}

reset {
    return old.name == "Nameless" && current.name == "Gladiato";
}
