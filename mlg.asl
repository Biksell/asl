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

state("LEGOStarWarsSaga")
{
    uint gogstatus : 0x550790;
    byte status : 0x526BD0;
    byte statust : 0x481C38;
    byte newgame : 0x47B738;
    byte gognewgame : 0x47b758;
    byte posb : 0x40B708;
    byte posc : 0x40B70C;
    string12 stream : 0x4CBB90;
    int gogstream : 0x551bc0;
    float wipe : 0x5507a0;
    //This is our third variable that is a short that references address 0x5513d0,0xf0
    short targetMap : 0x5513d0,0xf0;
    short jedibattlewave : 0x488ef4;
    //This is a lapcount that can land in the water
    float lapcount : 0x4824a0,0x28;
    int mapaddr : 0x402c54;
    int kitcount : 0x00551264;
    short incutscene : 0x551c54;
    int gameReboot: 0x0040e26c;
    int canskip: 0x003fa5f0;
    int transition: 0x00550768;
	int pause: 0x0047b7ac;
    int alttab: 0x00427610;
	int room: 0x551bc0;
	int roomPath: 0x5513d0;
    int areaID: 0x00403784;
    float inCrawl: 0x47aab0;
}
