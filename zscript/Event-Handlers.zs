// Struct for itemspawn information.
class WaresSpawnItem play {

    // ID by string for spawner
    string spawnName;

    // ID by string for spawnees
    Array<WaresSpawnItemEntry> spawnReplaces;

    // Whether or not to persistently spawn.
    bool isPersistent;

    // Whether or not to replace the original item.
    bool replaceItem;

    string toString() {

        let replacements = "[";

        foreach (spawnReplace : spawnReplaces) replacements = replacements..", "..spawnReplace.toString();

        replacements = replacements.."]";

        return String.format("{ spawnName=%s, spawnReplaces=%s, isPersistent=%b, replaceItem=%b }", spawnName, replacements, isPersistent, replaceItem);
    }
}

class WaresSpawnItemEntry play {

    string name;
    int    chance;

    string toString() {
        return String.format("{ name=%s, chance=%s }", name, chance >= 0 ? "1/"..(chance + 1) : "never");
    }
}

// Struct for passing useinformation to ammunition.
class WaresSpawnAmmo play {

    // ID by string for the header ammo.
    string ammoName;

    // ID by string for weapons using that ammo.
    Array<string> weaponNames;

    string toString() {

        let weapons = "[";

        foreach (weaponName : weaponNames) weapons = weapons..", "..weaponName;

        weapons = weapons.."]";

        return String.format("{ ammoName=%s, weaponNames=%s }", ammoName, weapons);
    }
}



// One handler to rule them all.
class OffworldWaresHandler : EventHandler {

    // List of persistent classes to completely ignore.
    // This -should- mean this mod has no performance impact.
    static const string blacklist[] = {
        'HDSmoke',
        'BloodTrail',
        'CheckPuff',
        'WallChunk',
        'HDBulletPuff',
        'HDFireballTail',
        'ReverseImpBallTail',
        'HDSmokeChunk',
        'ShieldSpark',
        'HDFlameRed',
        'HDMasterBlood',
        'PlantBit',
        'HDBulletActor',
        'HDLadderSection'
    };

    // List of CVARs for Backpack Spawns
    array<Class <Inventory> > backpackBlacklist;

    // Cache of Ammo Box Loot Table
    private HDAmBoxList ammoBoxList;

    // List of weapon-ammo associations.
    // Used for ammo-use association on ammo spawn (happens very often).
    array<WaresSpawnAmmo> ammoSpawnList;

    // List of item-spawn associations.
    // used for item-replacement on mapload.
    array<WaresSpawnItem> itemSpawnList;

    bool cvarsAvailable;

    // appends an entry to itemSpawnList;
    void addItem(string name, Array<WaresSpawnItemEntry> replacees, bool persists, bool rep=true) {

        if (hd_debug) {

            let msg = "Adding "..(persists ? "Persistent" : "Non-Persistent").." Replacement Entry for "..name..": [";

            foreach (replacee : replacees) msg = msg..", "..replacee.toString();

            console.printf(msg.."]");
        }

        // Creates a new struct;
        WaresSpawnItem spawnee = WaresSpawnItem(new('WaresSpawnItem'));

        // Populates the struct with relevant information,
        spawnee.spawnName = name;
        spawnee.isPersistent = persists;
        spawnee.replaceItem = rep;
        spawnee.spawnReplaces.copy(replacees);

        // Pushes the finished struct to the array.
        itemSpawnList.push(spawnee);
    }

    WaresSpawnItemEntry addItemEntry(string name, int chance) {

        // Creates a new struct;
        WaresSpawnItemEntry spawnee = WaresSpawnItemEntry(new('WaresSpawnItemEntry'));
        spawnee.name = name;
        spawnee.chance = chance;
        return spawnee;
    }

    // appends an entry to ammoSpawnList;
    void addAmmo(string name, Array<string> weapons) {

        if (hd_debug) {
            let msg = "Adding Ammo Association Entry for "..name..": [";

            foreach (weapon : weapons) msg = msg..", "..weapon;

            console.printf(msg.."]");
        }

        // Creates a new struct;
        WaresSpawnAmmo spawnee = WaresSpawnAmmo(new('WaresSpawnAmmo'));
        spawnee.ammoName = name;
        spawnee.weaponNames.copy(weapons);
        
        // Pushes the finished struct to the array. 
        ammoSpawnList.push(spawnee);
    }
    

    // Populates the replacement and association arrays. 
    void init() {

        cvarsAvailable = true;

        //-----------------
        // Backpack Spawns
        //-----------------

        if (!flint_allowBackpacks)  backpackBlacklist.push((Class<Inventory>)('HD_FlintlockPistol'));
        if (!musket_allowBackpacks) backpackBlacklist.push((Class<Inventory>)('HD_Musket'));

        //------------
        // Ammunition
        //------------

        // Lead Musket Balls
        Array<string> wep_musketball;
        wep_musketball.push('HD_FlintlockPistol');
        wep_musketball.push('HD_Musket');
        addAmmo('HDBallAmmo', wep_musketball);


        //------------
        // Weaponry
        //------------

        // Flintlock
        Array<WaresSpawnItemEntry> spawns_flint;
        spawns_flint.push(addItemEntry('ClipBoxPickup', flint_clipbox_spawn_bias));
        addItem('HD_FlintlockPistol', spawns_flint, flint_persistent_spawning);

        // Musket
        Array<WaresSpawnItemEntry> spawns_musket;
        spawns_musket.push(addItemEntry('ClipBoxPickup', musket_clipbox_spawn_bias));
        addItem('HD_MusketDropper', spawns_musket, musket_persistent_spawning);


        // --------------------
        // Items
        // --------------------


        // Rum
        Array<WaresSpawnItemEntry> spawns_rum;
        spawns_rum.push(addItemEntry('PortableStimpack', rum_pmi_spawn_bias));
        spawns_rum.push(addItemEntry('PortableMedikit', rum_pmi_spawn_bias));
        spawns_rum.push(addItemEntry('DeadRifleman', rum_pmi_spawn_bias));
        addItem('HD_RumDropper', spawns_rum, rum_persistent_spawning, false);

        // Cigarette Boxes
        Array<WaresSpawnItemEntry> spawns_cpk;
        spawns_cpk.push(addItemEntry('PortableStimpack', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('PortableMedikit', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('DeadRifleman', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('ReallyDeadRifleman', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('DeadZombieShotgunner', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('DeadZombieStormtrooper', cpk_pmi_spawn_bias));
        //spawns_cpk.push(addItemEntry('DeadImpSpawner', cpk_pmi_spawn_bias));
        spawns_cpk.push(addItemEntry('DeadDoomImp', cpk_pmi_spawn_bias));
        addItem('HD_CigaretteBoxDropper', spawns_cpk, cpk_persistent_spawning, false);

        // Cigarette
        Array<WaresSpawnItemEntry> spawns_cigarette;
        spawns_cigarette.push(addItemEntry('PortableStimpack', cig_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('PortableMedikit', cig_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('DeadRifleman', cig_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('ReallyDeadRifleman', cig_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('DeadZombieShotgunner', cig_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('DeadZombieStormtrooper', cig_pmi_spawn_bias));
        //spawns_cpk.push(addItemEntry('DeadImpSpawner', cpk_pmi_spawn_bias));
        spawns_cigarette.push(addItemEntry('DeadDoomImp', cig_pmi_spawn_bias));
        addItem('HD_CigaretteDropper', spawns_cigarette, cig_persistent_spawning, false);

        // Cleanser
        Array<WaresSpawnItemEntry> spawns_cln;
        spawns_cln.push(addItemEntry('PortableMedikit', cleanser_pmi_spawn_bias));
        addItem('HD_CleanserDropper', spawns_cln, cleanser_persistent_spawning, false);
        
        // Radsuit Packages
        Array<WaresSpawnItemEntry> spawns_radpack;
        spawns_radpack.push(addItemEntry('Radsuit', suit_replacement_spawn_bias));
        addItem('HD_RadsuitPack', spawns_radpack, rum_persistent_spawning, false);
        /*
        // Armor Patch Kit
          Array<WaresSpawnItemEntry> spawns_apk;
        spawns_apk.push(addItemEntry('GarrisonArmour', apk_replacement_spawn_bias));
        spawns_apk.push(addItemEntry('BattleArmour', apk_replacement_spawn_bias));
        spawns_apk.push(addItemEntry('DeadRifleman', apk_replacement_spawn_bias));
        spawns_apk.push(addItemEntry('ReallyDeadRifleman', apk_replacement_spawn_bias));
        spawns_apk.push(addItemEntry('ChainsawReplaces', apk_replacement_spawn_bias));
        addItem('HDAPKSpawner', spawns_apk, apk_persistent_spawning, false);
    
        // Universal Reloader
        Array<WaresSpawnItemEntry> spawns_url;
        spawns_url.push(addItemEntry('HDAmBox', url_replacement_spawn_bias));
        spawns_url.push(addItemEntry('HDAmBoxUnarmed', url_replacement_spawn_bias));
        spawns_url.push(addItemEntry('DeadRifleman', url_replacement_spawn_bias));
        spawns_url.push(addItemEntry('ReallyDeadRifleman', url_replacement_spawn_bias));
        addItem('HDUniversalReloader', spawns_url, url_persistent_spawning, false);
    
        // Logistics Bag
        Array<WaresSpawnItemEntry> spawns_logibag;
        spawns_logibag.push(addItemEntry('HDAmBox', lgb_replacement_spawn_bias));
        spawns_logibag.push(addItemEntry('HDAmBoxUnarmed', lgb_replacement_spawn_bias));
        spawns_logibag.push(addItemEntry('DeadRifleman', lgb_replacement_spawn_bias));
        spawns_logibag.push(addItemEntry('ReallyDeadRifleman', lgb_replacement_spawn_bias));
        addItem('HD_WildLogiBag', spawns_logibag, lgb_persistent_spawning, false);

        // Medical Backpack
        Array<WaresSpawnItemEntry> spawns_medibag;
        spawns_medibag.push(addItemEntry('PortableMedikit', mdb_replacement_spawn_bias));
        spawns_medibag.push(addItemEntry('DeadRifleman', mdb_replacement_spawn_bias));
        spawns_medibag.push(addItemEntry('ReallyDeadRifleman', mdb_replacement_spawn_bias));
        addItem('HD_WildMediBag', spawns_medibag, lgb_persistent_spawning, false);

        // Defib
        Array<WaresSpawnItemEntry> spawns_defib;
        spawns_defib.push(addItemEntry('PortableMedikit', dfb_replacement_spawn_bias));
        spawns_defib.push(addItemEntry('DeadRifleman', dfb_replacement_spawn_bias));
        spawns_defib.push(addItemEntry('ReallyDeadRifleman', dfb_replacement_spawn_bias));
        addItem('HDefib', spawns_defib, dfb_persistent_spawning, false);
        */
    }
    
    // Fill above with entries for each weapon
    // Random stuff, stores it and forces negative values just to be 0.
    bool giveRandom(int chance) {
        if (chance > -1) {
            let result = random(0, chance);

            if (hd_debug) console.printf("Rolled a "..(result + 1).." out of "..(chance + 1));

            return result == 0;
        }

        return false;
    }

    // Tries to replace the item during spawning.
    bool tryReplaceItem(ReplaceEvent e, string spawnName, int chance) {
        if (giveRandom(chance)) {
            if (hd_debug) console.printf(e.replacee.getClassName().." -> "..spawnName);

            e.replacement = spawnName;

            return true;
        }

        return false;
    }

    // Tries to create the item via random spawning.
    bool tryCreateItem(Actor thing, string spawnName, int chance) {
        if (giveRandom(chance)) {
            if (hd_debug) console.printf(thing.getClassName().." + "..spawnName);

            Actor.Spawn(spawnName, thing.pos);

            return true;
        }

        return false;
    }

    override void worldLoaded(WorldEvent e) {

        // Populates the main arrays if they haven't been already. 
        if (!cvarsAvailable) init();

        foreach (bl : backpackBlacklist) {
            if (hd_debug) console.printf("Removing "..bl.getClassName().." from Backpack Spawn Pool");
                
            BPSpawnPool.removeItem(bl);
        }
    }

    override void checkReplacement(ReplaceEvent e) {

        // Populates the main arrays if they haven't been already.
        if (!cvarsAvailable) init();

        // If there's nothing to replace or if the replacement is final, quit.
        if (!e.replacee || e.isFinal) return;

        // If thing being replaced is blacklisted, quit.
        foreach (bl : blacklist) if (e.replacee is bl) return;

        string candidateName = e.replacee.getClassName();

        // If current map is Range, quit.
        if (level.MapName == 'RANGE') return;

        handleWeaponReplacements(e, candidateName);
    }

    override void worldThingSpawned(WorldEvent e) {

        // Populates the main arrays if they haven't been already.
        if (!cvarsAvailable) init();

        // If thing spawned doesn't exist, quit
        if (!e.thing) return;

        // If thing spawned is blacklisted, quit
        foreach (bl : blacklist) if (e.thing is bl) return;

        // Handle Ammo Box Loot Table Filtering
        if (e.thing is 'HDAmBox' && !ammoBoxList) handleAmmoBoxLootTable();

        string candidateName = e.thing.getClassName();

        // Pointers for specific classes.
        let ammo = HDAmmo(e.thing);
        
        // If the thing spawned is an ammunition, add any and all items that can use this.
        if (ammo) handleAmmoUses(ammo, candidateName);

        // Return if range before replacing things.
        if (level.MapName == 'RANGE') return;

        handleWeaponSpawns(e.thing, ammo, candidateName);
    }

    private void handleAmmoBoxLootTable() {
        ammoBoxList = HDAmBoxList.Get();

        foreach (bl : backpackBlacklist) {
            let index = ammoBoxList.invClasses.find(bl.getClassName());

            if (index != ammoBoxList.invClasses.Size()) {
                if (hd_debug) console.printf("Removing "..bl.getClassName().." from Ammo Box Loot Table");

                ammoBoxList.invClasses.Delete(index);
            }
        }
    }

    private void handleAmmoUses(HDAmmo ammo, string candidateName) {
        foreach (ammoSpawn : ammoSpawnList) if (candidateName ~== ammoSpawn.ammoName) {
            if (hd_debug) {
                console.printf("Adding the following to the list of items that use "..ammo.getClassName().."");
                foreach (weapon : ammoSpawn.weaponNames) console.printf("* "..weapon);
            }

            ammo.itemsThatUseThis.append(ammoSpawn.weaponNames);
        }
    }

    private void handleWeaponReplacements(ReplaceEvent e, string candidateName) {

        // Checks if the level has been loaded more than 1 tic.
        bool prespawn = !(level.maptime > 1);

        // Iterates through the list of item candidates for e.thing.
        foreach (itemSpawn : itemSpawnList) {

            if ((prespawn || itemSpawn.isPersistent) && itemSpawn.replaceItem) {
                foreach (spawnReplace : itemSpawn.spawnReplaces) {
                    if (spawnReplace.name ~== candidateName) {
                        if (hd_debug) console.printf("Attempting to replace "..candidateName.." with "..itemSpawn.spawnName.."...");

                        if (tryReplaceItem(e, itemSpawn.spawnName, spawnReplace.chance)) return;
                    }
                }
            }
        }
    }

    private void handleWeaponSpawns(Actor thing, HDAmmo ammo, string candidateName) {

        // Checks if the level has been loaded more than 1 tic.
        bool prespawn = !(level.maptime > 1);

        // Iterates through the list of item candidates for e.thing.
        foreach (itemSpawn : itemSpawnList) {

            // if an item is owned or is an ammo (doesn't retain owner ptr),
            // do not replace it.
            let item = Inventory(thing);
            if (
                (prespawn || itemSpawn.isPersistent)
             && (!(item && item.owner) && (!ammo || prespawn))
             && !itemSpawn.replaceItem
            ) {
                foreach (spawnReplace : itemSpawn.spawnReplaces) {
                    if (spawnReplace.name ~== candidateName) {
                        if (hd_debug) console.printf("Attempting to spawn "..itemSpawn.spawnName.." with "..candidateName.."...");

                        if (tryCreateItem(thing, itemSpawn.spawnName, spawnReplace.chance)) return;
                    }
                }
            }
        }
    }
}

//-------------------------------------------------
// MONSTERS
//-------------------------------------------------

// Trite controller
class TriteHandler : EventHandler
{
    private int current_trites;
    private int max_trites;
    private int maxtospawn;

    void init()
    {
        current_trites = current_tritescvar;
        max_trites = max_tritescvar;
    }

    override void WorldLoaded(WorldEvent e)
    {
        // always calls init.
        init();
        super.WorldLoaded(e);
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        if (e.thing && e.thing is "Trite")current_trites++; // this line of code wouldn't propegate properly to all of the spawners. You'd need to give each spawner a maximum number they can spawn.
        let sss=TriteBarrel(e.thing);
        //if (sss)sss.maxtospawn = current_trites;
    }
}

// Trite Barrels
class SpiderBarrelEventHandler : EventHandler
{
    private bool cvarsAvailable;

    private int spawnBiasActual;
    private bool isPersistent;

    // Shoves cvar values into their non-cvar shaped holes.
    // I have no idea why names for cvars become reserved here.
    // But, this works. So no complaints.
    void init()
    {
        cvarsAvailable = true;
        spawnBiasActual = sbrl_regulars_spawn_bias;
        isPersistent = sbrl_persistent_spawning;
    }

    bool giveRandom(int chance)
    {
        if (chance > -1)
        {
            let result = random(0, chance);

            if (hd_debug) console.printf("Rolled a "..result.." out of "..(chance + 1));

            return result == 0;
        }

        return false;
    }

    bool tryCreateBarrel(worldevent e, int chance)
    {
        if (giveRandom(chance))
        {
            if (Actor.Spawn("TriteBarrel", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION))
            {
                if (hd_debug) console.printf(e.thing.GetClassName().." -> TriteBarrel");

                e.thing.destroy();

                return true;
            }
        }

        return false;
    }

    override void worldthingspawned(worldevent e)
    {
        // Makes sure the values are always loaded before
        // taking in events.
        if (!cvarsAvailable) init();

        // in case it's not real.
        if (!e.Thing) return;

        // Checks if the level has been loaded more than 1 tic.
        bool prespawn = !(level.maptime > 1);

        // Don't spawn anything if the level has been loaded more than a tic.
        if (prespawn || isPersistent)
        {

            switch(e.Thing.GetClassName())
            {
                case 'HDBarrel':
                    if (hd_debug) console.printf("Attempting to replace "..e.Thing.GetClassName().." with TriteBarrel...");
                    tryCreateBarrel(e, spawnBiasActual);
                    break;
            }
        }
    }
}
