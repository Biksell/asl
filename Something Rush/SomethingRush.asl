/*
loadingScene: 5_HideScene -> 0_MainMenu
activeScene: 5_HideScene -> 0_MainMenu
loadingScene: 0_MainMenu -> 0_Prologue
activeScene: 0_MainMenu -> 0_Prologue
loadingScene: 0_Prologue -> 1_CampScene
activeScene: 0_Prologue -> 1_CampScene
loadingScene: 1_CampScene -> 2_ParkScene
activeScene: 1_CampScene -> 2_ParkScene
loadingScene: 2_ParkScene -> 3_Garage
activeScene: 2_ParkScene -> 3_Garage
loadingScene: 3_Garage -> 4_CarScene
activeScene: 3_Garage -> 4_CarScene
loadingScene: 4_CarScene -> 5_HideScene
activeScene: 4_CarScene -> 5_HideScene
loadingScene: 5_HideScene -> 6_Escape
activeScene: 5_HideScene -> 6_Escape
loadingScene: 6_Escape -> 7_2 EndTrue
activeScene: 6_Escape -> 7_2 EndTrue
*/

state("SomethingRush") {}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.Helper.LoadSceneManager = true;
}

update {
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    if(old.activeScene != current.activeScene) print("activeScene: " + old.activeScene + " -> " + current.activeScene);
    if(old.loadingScene != current.loadingScene) print("loadingScene: " + old.loadingScene + " -> " + current.loadingScene);
}

start {
    return old.activeScene == "0_MainMenu" && current.activeScene == "0_Prologue";
}

split {
    return old.activeScene != current.activeScene && old.activeScene[0] < current.activeScene[0];
}

exit {
    vars.TimerModel.Reset();
}
