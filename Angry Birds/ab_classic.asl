// Made for the 4.0.0 version found in archive.org

state("AngryBirds") {
    float level: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x37C8;
    float birdsShot: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x4934;
    bool canShoot: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x4638, 0x3C;
}

update {
    current.levelInt = (int)Math.Floor(current.level);
    current.birdsShotInt = (int)Math.Floor(current.birdsShot);
    if (old.canShoot != current.canShoot) print("old.canShoot: " + old.canShoot + " current.canShoot: " + current.canShoot);
    if (old.level != current.level) print("old.level: " + old.level + " current.level: " + current.level);
    if (old.birdsShot != current.birdsShot) print("old.birdsShot: " + old.birdsShot + " current.birdsShot: " + current.birdsShot);
}

split {
    return old.levelInt != current.levelInt;
}

start {
    return current.birdsShotInt == 1 && old.canShoot && !current.canShoot;
}

reset {
    return old.levelInt != 1 && old.levelInt != 21 && current.levelInt == 1;
}
