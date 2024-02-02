// Load removal by elle_tree, nairam. Script by Biksel

state("LEGOSTARWARSSKYWALKERSAGA_DX11", "6Apr22")
{
    byte load : 0x05D8D850, 0xD8, 0x40, 0x10, 0x58, 0xB0, 0x0, 0x1B8;
    byte loads : 0x05D9E1A8, 0xC8, 0x10, 0x50, 0x60, 0x38, 0x30, 0xE0;
}

state("LEGOSTARWARSSKYWALKERSAGA_DX11", "4May23")
{
    bool loading : 0x5F014B0, 0xE8, 0xD8, 0x8, 0x90, 0x90, 0x0, 0x20
}

init {
    switch (modules.First().ModuleMemorySize) {
        case 106549248:
            version = "4May23";
            break;
        case 104955904:
            version = "6Apr22";
            break;
    }
}

isLoading
{
    if (version == "6Apr22") return current.load == 1 && current.loads == 1;
    else if (version == "4May23") return current.loading;
}
