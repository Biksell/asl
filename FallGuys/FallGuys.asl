// Fall Guys autosplitter by Biksel
// Uses the log file found

// Can't attach to game because of EasyAntiCheat
state("LiveSplit") {}

startup {
    settings.Add("start", true, "Start on first round starting");
    settings.Add("split", true, "Split after winning a match");
}

init {
    vars.path = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData).Replace("Roaming","LocalLow") + "\\Mediatonic\\FallGuys_client\\Player.log";
    vars.directory = new DirectoryInfo(vars.path);

    vars.reader = new StreamReader(new FileStream(vars.path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete), Encoding.Default);
    vars.reader.ReadToEnd();
    vars.firstGame = true;
    vars.collecting = false;
    vars.canStart = false;
    vars.endString = "";
    vars.loading = false;
}

update {
    current.raw = vars.reader.ReadLine();
    if (!String.IsNullOrEmpty(current.raw) && old.raw != current.raw) {
        //print(current.raw[0] + "");

        // Loading
        if (current.raw.Contains("Changing state from Countdown to Playing")) vars.loading = false;
        if (current.raw.Contains("[GameSession] Changing state from Playing to GameOver")) vars.loading = true;

        // First game
        if (current.raw.Contains("Found game on ->")) vars.firstGame = true;
        if (current.raw.Contains("[GameSession] Changing state from Playing to GameOver")) vars.firstGame = false;
        if (vars.firstGame && current.raw.Contains("Changing state from Countdown to Playing")) vars.canStart = true;

        // End
        if (current.raw.Contains("== [CompletedEpisodeDto] ==")) { vars.collecting = true; vars.endString = ""; }
        if (vars.collecting) {
            if (current.raw.Contains("SwitchToResultsState")) {
                print(vars.endString);
                vars.collecting = false;
            }
            vars.endString += current.raw;
        }

    }
}

start {
    return settings["start"] && vars.canStart;
}

split {
    return settings["split"] && !vars.collecting && !String.IsNullOrEmpty(vars.endString) && !vars.endString.Contains("Qualified: False");
}

isLoading {
    return vars.loading;
}

onStart {
    vars.canStart = false;
}

onSplit {
    //print(vars.endString);
    vars.collecting = false;
    vars.endString = "";
    vars.canStart = false;
}
