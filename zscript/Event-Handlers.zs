//-------------------------------------------------
// WEAPONS
//-------------------------------------------------

// Struct for itemspawn information. 
class WaresSpawnItem play
{
	string    		           spawnname;            // ID by string for spawner
	Array<WaresSpawnItemEntry>    spawnreplaces;        // ID by string for spawnees
	int 	                   spawnreplacessize;    // Cached size of the above array
	bool                       isPersistent;         // Whether or not to persistently spawn.
}

class WaresSpawnItemEntry play
{
	string name;
	int    chance;
}

// Struct for passing useinformation to ammunition. 
class WaresSpawnAmmo play
{
	string		  ammoname;		   // ID by string for the header ammo.
	Array<string> weaponnames;     // ID by string for weapons using that ammo.
	int           weaponnamessize; // Cached size of the above array
}



// One handler to rule them all. 
class OffworldWaresHandler : EventHandler
{
	// List of weapon-ammo associations.
	// Used for ammo-use association on ammo spawn (happens very often). 
	array<WaresSpawnAmmo> ammospawnlist;
	int ammospawnlistsize;
	
	// List of item-spawn associations.
	// used for item-replacement on mapload. 
	array<WaresSpawnItem> itemspawnlist;
	int itemspawnlistsize;
	
	
	// appends an entry to itemspawnlist;
	void additem(string name, Array<WaresSpawnItemEntry> replacees, bool persists)
	{
		// Creates a new struct;
		WaresSpawnItem spawnee = WaresSpawnItem(new('WaresSpawnItem'));
		
		// Populates the struct with relevant information,
		spawnee.spawnname = name;
		spawnee.isPersistent = persists;
		for(int i = 0; i < replacees.size(); i++)
		{
			spawnee.spawnreplaces.push(replacees[i]);
			spawnee.spawnreplacessize++;
		}
		
		// Pushes the finished struct to the array. 
		itemspawnlist.push(spawnee);
		itemspawnlistsize++;
	}


	WaresSpawnItemEntry additementry(string name, int chance)
	{
		// Creates a new struct;
		WaresSpawnItemEntry spawnee = WaresSpawnItemEntry(new('WaresSpawnItemEntry'));
		spawnee.name = name;
		spawnee.chance = chance;
		return spawnee;
		
	}


	// appends an entry to ammospawnlist;
	void addammo(string name, Array<string> weapons)
	{
	
		// Creates a new struct;
		WaresSpawnAmmo spawnee = WaresSpawnAmmo(new('WaresSpawnAmmo'));
		spawnee.ammoname = name;
		
		// Populates the struct with relevant information,
		for(int i = 0; i < weapons.size(); i++)
		{
			spawnee.weaponnames.push(weapons[i]);
			spawnee.weaponnamessize++;
		}
		
		// Pushes the finished struct to the array. 
		ammospawnlist.push(spawnee);
		ammospawnlistsize++;
	}
	
	
	bool cvarsAvailable;
	
	// Populates the replacement and association arrays. 
	void init()
	{
		cvarsAvailable = true;

	// Musket
    Array<WaresSpawnItemEntry> spawns_musket;
		spawns_musket.push(additementry('SquadSummoner', musket_blur_spawn_bias));
		
		Array<string> wep_musket;
		wep_musket.push("HD_Musket");

		additem('HD_MusketDropper', spawns_musket, musket_persistent_spawning); // Weapon Replacer
		addammo('HDShellAmmo', wep_musket);  //adds to ammo whitelist

	// Flintlock
    Array<WaresSpawnItemEntry> spawns_flint;
		spawns_flint.push(additementry('Lumberjack', flint_saw_spawn_bias));
		spawns_flint.push(additementry('HunterRandom', flint_shotguns_spawn_bias));
		spawns_flint.push(additementry('SlayerRandom', flint_shotguns_spawn_bias));
		
		Array<string> wep_flint;
		wep_flint.push("HD_FlintlockPistol");

		additem('HD_FlintlockPistol', spawns_flint, flint_persistent_spawning); // Weapon Replacer

	// Rum
    Array<WaresSpawnItemEntry> spawns_rum;
		spawns_rum.push(additementry('PortableStimpack', rum_pmi_spawn_bias));
		additem('UaS_Alcohol_OleRum', spawns_rum, rum_persistent_spawning); // Weapon Replacer

	// Radsuit Packages
    Array<WaresSpawnItemEntry> spawns_radpack;
		spawns_radpack.push(additementry('Radsuit', suit_replacement_spawn_bias));
		additem('HD_RadsuitPack', spawns_radpack, rum_persistent_spawning); // Weapon Replacer

	// Armor Patch Kit
    Array<WaresSpawnItemEntry> spawns_apk;
		spawns_apk.push(additementry('HDArmour', apk_replacement_spawn_bias));
		spawns_apk.push(additementry('DeadRifleman', apk_replacement_spawn_bias));
		spawns_apk.push(additementry('ReallyDeadRifleman', apk_replacement_spawn_bias));
		spawns_apk.push(additementry('Lumberjack', apk_replacement_spawn_bias));
		additem('HDAPKSpawner', spawns_apk, apk_persistent_spawning); // Weapon Replacer
	
	// Universal Reloader
	Array<WaresSpawnItemEntry> spawns_url;
		spawns_url.push(additementry('HDAmBox', url_replacement_spawn_bias));
		spawns_url.push(additementry('DeadRifleman', url_replacement_spawn_bias));
		spawns_url.push(additementry('ReallyDeadRifleman', url_replacement_spawn_bias));
		additem('HDURLSpawner', spawns_url, url_persistent_spawning); // Weapon Replacer
	
	// Logistics Bag
	Array<WaresSpawnItemEntry> spawns_logibag;
		spawns_logibag.push(additementry('HDAmBox', lgb_replacement_spawn_bias));
		spawns_logibag.push(additementry('DeadRifleman', lgb_replacement_spawn_bias));
		spawns_logibag.push(additementry('ReallyDeadRifleman', lgb_replacement_spawn_bias));
		additem('HD_WildLogiBag', spawns_logibag, lgb_persistent_spawning); // Weapon Replacer

	// Medical Backpack
	Array<WaresSpawnItemEntry> spawns_medibag;
		spawns_medibag.push(additementry('PortableMedikit', mdb_replacement_spawn_bias));
		spawns_medibag.push(additementry('DeadRifleman', mdb_replacement_spawn_bias));
		spawns_medibag.push(additementry('ReallyDeadRifleman', mdb_replacement_spawn_bias));
		additem('HD_WildMediBag', spawns_medibag, lgb_persistent_spawning); // Weapon Replacer

	// Defib
	Array<WaresSpawnItemEntry> spawns_defib;
		spawns_defib.push(additementry('PortableMedikit', dfb_replacement_spawn_bias));
		spawns_defib.push(additementry('DeadRifleman', dfb_replacement_spawn_bias));
		spawns_defib.push(additementry('ReallyDeadRifleman', dfb_replacement_spawn_bias));
		additem('HDefib', spawns_defib, dfb_persistent_spawning); // Weapon Replacer
	}
	
	// Fill above with entries for each weapon
	// Random stuff, stores it and forces negative values just to be 0.
	bool giverandom(int chance)
	{
		bool result = false;
		int iii = random(0, chance);
		if(iii < 0)
			iii = 0;
		if (iii == 0)
		{
			if(chance > -1)
				result = true;
		}
		return result;
	}

	// Tries to create the item via random spawning.
	bool trycreateitem(worldevent e, WaresSpawnItem f, int g)
	{
		bool result = false;
		if(giverandom(f.spawnreplaces[g].chance))
		{
			vector3 spawnpos = e.thing.pos;
			let spawnitem = Actor.Spawn(f.spawnname, (spawnpos.x, spawnpos.y, spawnpos.z));
			if(spawnitem)
			{
				e.thing.destroy();
				result = true;
			}
		}
		return result;
	}
	
	override void worldthingspawned(worldevent e)
	 {
		string candidatename;
		
		// loop controls.
		int i, j;
		bool isAmmo = false;
		
		// Populates the main arrays if they haven't been already. 
		if(!cvarsAvailable)
			init();
		
		// Checks for null events. 
		if(!e.Thing)
		{
			return;
		}

		candidatename  = e.Thing.GetClassName();
		let ammo_ptr   = HDAmmo(e.Thing);
		
		if(ammo_ptr)
		{
			for(i = 0; i < ammospawnlistsize; i++)
			{
				if(candidatename == ammospawnlist[i].ammoname)
				{
					for(j = 0; j < ammospawnlist[i].weaponnamessize; j++)
					{
						ammo_ptr.ItemsThatUseThis.Push(ammospawnlist[i].weaponnames[j]);
					}
				}
			}
		}
		
		// Iterates through the list of item candidates for e.thing.
		for(i = 0; i < itemspawnlistsize; i++)
		{
			// Checks if the item in question is owned. 
			let thing_inv_ptr = Inventory(e.thing);
			bool owned    = thing_inv_ptr && (thing_inv_ptr.owner);

			// Checks if the level has been loaded more than 1 tic.
			bool prespawn = !(level.maptime > 1);
			
			// Checks if persistent spawning is on.
			bool persist  = (itemspawnlist[i].isPersistent);
			
			bool validammo = prespawn && ammo_ptr;
			
			// if an item is owned or is an ammo (doesn't retain owner ptr), 
			// do not replace it. 
			if ((prespawn || persist) && (!owned || validammo))
			{
				int original_i = i;
				for(j = 0; j < itemspawnlist[original_i].spawnreplacessize; j++)
				{
					if(itemspawnlist[i].spawnreplaces[j].name == candidatename)
					{
						if(trycreateitem(e, itemspawnlist[i], j))
						{
							j = itemspawnlist[i].spawnreplacessize;
							i = itemspawnlistsize;
						}
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
		if(e.thing && e.thing is "Trite")current_trites++; // this line of code wouldn't propegate properly to all of the spawners. You'd need to give each spawner a maximum number they can spawn. 
        let sss=SpiderBarrel(e.thing);
        //if(sss)sss.maxtospawn = current_trites;
		
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
		spawnBiasActual            = sbrl_regulars_spawn_bias;
		isPersistent               = sbrl_persistent_spawning;
	}

	// 'Initalizes' the event handler,
	// In my testing, this is called after events are fired. 
	override void WorldLoaded(WorldEvent e)
	{
		// always calls init.
		init();
		super.WorldLoaded(e);
	}

	bool giverandom(int chance)
	{
		bool result = false;
		
		// temp storage for the random value. 
		int iii = random(0, chance);
		
		// force negative values to be 0. 
		if(iii < 0)
			iii = 0;
			
		
		if (iii == 0)
		{
			if(chance > -1)
				result = true;
		}
		
		return result;
	}

	void trycreatebarrel(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = SpiderBarrel(e.thing.Spawn("SpiderBarrel", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
			if(sss)
			{
				
				e.thing.destroy();
			}
		}
	}


override void worldthingspawned(worldevent e)
  {
	// Makes sure the values are always loaded before
	// taking in events.
	if(!cvarsAvailable)
		init();
		
 	// in case it's not real. 
	if(!e.Thing)
	{
		return;
	}
	
	// Don't spawn anything if the level has been loaded more than a tic. 
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'HDBarrel':
				trycreatebarrel(e, spawnBiasActual);
				break;
		}
	}
	}
}