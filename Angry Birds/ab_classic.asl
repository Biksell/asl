// Made for the 4.0.0 version found in archive.org

state("AngryBirds") {
    float level: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x37C8;
    float birdsShot: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x4934;
    bool canShoot: "grgl2.dll", 0xCAEF8, 0x9C, 0xD8, 0x18, 0x10, 0x4638, 0x3C;
}

update {
    if (old.canShoot != current.canShoot) print("old.canShoot: " + old.canShoot + " current.canShoot: " + current.canShoot);
    if (old.level != current.level) print("old.level: " + old.level + " current.level: " + current.level);
    if (old.birdsShot != current.birdsShot) print("old.birdsShot: " + old.birdsShot + " current.birdsShot: " + current.birdsShot);
}

split {
    return old.level != current.level;
}

start {
    return current.birdsShot == 1 && old.canShoot && !current.canShoot;
}

reset {
    return old.level != 1 && old.level != 21 && current.level == 1;
}
