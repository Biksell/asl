/*
Made by Biksel, using asl-help from ero
Gamestates: 0 = Setup
            1 = Start
            2 = Game
            3 = Pause
            4 = End
            5 = Tips
*/

state("Raw Nerve"){}

startup{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var msgBox = MessageBox.Show(
			"Raw Nerve uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Raw Nerve",
			MessageBoxButtons.YesNo);

		if (msgBox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["igt"] = mono.Make<float>("GameManager", 1, "instance", "GameTime");
        vars.Helper["activeGameState"] = mono.Make<int>("GameManager", 1, "instance", "ActiveState");
        return true;
    });
}

gameTime{
    return(TimeSpan.FromSeconds(current.igt));
}

start {
    return old.igt == 0f && current.igt > 0f;
}

split {
    return current.activeGameState == 4 && old.activeGameState == 2;
}

reset {
    return ((old.activeGameState == 3 || old.activeGameState == 4) && current.activeGameState == 2 && current.igt == 0f);
}

