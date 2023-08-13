state("javaw") {}

init {
    old.line = "";

    var path = System.IO.Path.Combine(Environment.GetEnvironmentVariable("APPDATA"), ".minecraft/logs/latest.log");
    if (File.Exists(path)) {
        vars.stream = new StreamReader(File.Open(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
    } else {
        vars.stream = null;
    }
    while (vars.stream.EndOfStream == false) {
        var line = vars.stream.ReadLine();
    }
}

update {
    if (vars.stream == null) return false;
    var line = vars.stream.ReadLine();
    if (line != null) current.line = line;
    if (old.line != current.line) print(current.line);
}

split{
    return old.line != current.line && current.line.Contains("<split>") && current.line.Contains("[System]");
}
