state("LEGOBatman")
{
    bool loading: 0x5C999C; // Yellow shield at the bottom of screen, character info screens
    bool loading2: 0x696D2C; // Character info screens
    bool loading3: 0x6CA7B0; // Could be used for autostarting
    bool loading4: 0x6B29D0;

    bool uiElementChange : 0x6D0270; // "Stud counter & Continue story" enabled, we want to split on 1 -> 0
    bool status: 0x696BA8; // Statu screen enabled

    bool start1 : 0x693034;
    bool start2 : 0x693674;
    bool start3 : 0x693684;
    bool start4 : 0x6DE6FC;
    bool start5 : 0x702A50;
    bool start6 : 0x702A68;

    bool inLevel : 0x5616DD;
}

isLoading {
    return current.loading || current.loading2 || current.loading3 || current.loading4;
}

state("LEGOStarWarsSaga")
{
    float wipe : 0x5507a0;
    //This is our third variable that is a short that references address 0x5513d0,0xf0
    //This is a lapcount that can land in the water
    int gameReboot: 0x0040e26c;
    int canskip: 0x003fa5f0;
    int transition: 0x00550768;
	int pause: 0x0047b7ac;
    int alttab: 0x00427610;
	int room: 0x551bc0;
    int areaID: 0x00403784;
    float inCrawl: 0x47aab0;
}

isLoading
{
	return ((current.gameReboot == 10000) || ((current.transition == 1) && (old.pause == 0) && (current.areaID != 66) && (current.inCrawl == 0))
	|| (current.canskip == 0) || (current.room == 325 && old.wipe == 1 && current.wipe == 1 && vars.inCantina)) && (current.alttab != 0);
}

state("LEGOIndy")
{
    bool Loading: 0x5C3D24;
}

state ("LEGOIndy2")
{
    bool Load1: 0xB0F5C8;
    bool Load2: 0xACBF08;
    bool Load3: 0xC5B838;
}

state("LEGOPirates", "lpc")
{
    bool Loading: 0xA171A4;
}
