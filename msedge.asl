state("chrome") {
    bool loading : "chrome.dll", 0x0D5CC138, 0xF0, 0x378;
}

init {
    /*var count = 0;
    if (count == 3) {
        var allComponents = timer.Layout.Components;
        // Grab the autosplitter from splits
        if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) {
            allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
        }
        foreach (var component in allComponents) {
            var type = component.GetType();
            if (type.Name == "ASLComponent") {
                // Could also check script path, but renaming the script breaks that, and
                //  running multiple autosplitters at once is already just asking for problems
                var script = type.GetProperty("Script").GetValue(component);
                script.GetType().GetField(
                    "_game",
                    BindingFlags.NonPublic | BindingFlags.Instance
                ).SetValue(script, null);
            }
        }
        return;
    }
    else {
        count++;
    }*/
}

update {
    print(current.loading.ToString() + ", " + game.Id);
    //print(game.ProcessName);
}

isLoading {
    return current.loading;
}
