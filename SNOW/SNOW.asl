state("GameLauncher") {
    //float x : 0x2FAC8, 0x620, 0x18, 0xC48, 0xB4, 0x298;
    //float y : 0x2FAC8, 0x620, 0x18, 0xAF8, 0xC8, 0x2A0;
    //float z : 0x2FAC8, 0x620, 0x18, 0x668, 0xCC, 0x29C;
    float y : "CrySystem.dll", 0x006FCB60, 0x30, 0x378, 0x0, 0xD8, 0x1F0;
    float x : "CryGameSNOW.dll", 0x004C55B0, 0x30, 0x3E0, 0x1E0, 0x10, 0x298;
    float z : "CryGameSNOW.dll", 0x004BADE0, 0x5B8, 0x8E8, 0x180, 0x0, 0x29C;
}

startup {

    vars.refreshTick = 0;
    vars.speeds = new List<double>() {};

    vars.lastUpdate = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

    refreshRate = 60;
    settings.Add("speedometer", true, "Show Speedometer");

    // Speedometer logic from https://github.com/Micrologist/LiveSplit.Ghostrunner/blob/master/GhostrunnerDemo.asl
    vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
            var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
            var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
            timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

            textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
            textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});

    vars.UpdateSpeedometer = (Action<double>)((speed) =>
    {
        vars.SetTextComponent("Speed", speed.ToString() + " km/h");
    });
}

update {
    vars.refreshTick += 1;
    float timeFromLast = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond - vars.lastUpdate;
    vars.lastUpdate = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
    if(settings["speedometer"] && vars.refreshTick > 5) {
        vars.refreshTick = 0;
        double d = Math.Sqrt(Math.Pow(current.x - old.x, 2) + Math.Pow(current.z - old.z, 2) + Math.Pow(current.y - old.y, 2));
        double speed = Math.Floor(d / (timeFromLast / 1000) * 3.6);
        if (vars.speeds.Count < 5) vars.speeds.Add(speed);
        else {
            for(int i = 1; i < vars.speeds.Count; i++) {
                vars.speeds[i-1] = vars.speeds[i];
            }
            vars.speeds[4] = speed;
        }
        //print(vars.speeds.Count.ToString());
        List<double> temp = vars.speeds;
        vars.UpdateSpeedometer(temp.Average());
        print(String.Join(", ", temp));
        //print(d.ToString() + ", " + timeFromLast.ToString());
        //print(dx.ToString() + ", " + dz.ToString());
        //print("X:" + (current.x - old.x).ToString() + ", Y: " + (current.y - old.y).ToString() + ", Z: " + (current.z - old.z).ToString());
    }
}
