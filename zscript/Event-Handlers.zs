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

// Rum
    Array<WaresSpawnItemEntry> spawns_rum;
		spawns_rum.push(additementry('PortableStimpack', rum_pmi_spawn_bias));
		additem('UaS_Alcohol_OleRum', spawns_rum, rum_persistent_spawning); // Weapon Replacer
	}
	
	//fill above with entries for each weapon
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

//-------------------------------------------------
// ITEMS
//-------------------------------------------------


// Radsuit Packages
class RadReplacementHandler : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = suit_replacement_spawn_bias;
		isPersistent = rum_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreatesuit(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_RadsuitPack(e.thing.Spawn("HD_RadsuitPack", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
			if(sss)
			{
				
				e.thing.destroy();
			}

		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'PortableRadsuit':
				trycreatesuit(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Armor Patch Kit
class APKHandler : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = apk_replacement_spawn_bias;
		isPersistent = apk_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreateapk(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let SpawnedAPK = Actor.Spawn('HDAPKSpawner', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
			SpawnedAPK.vel.x += frandom(-2,2);
			SpawnedAPK.vel.y += frandom[spawnstuff](-2,2);
			SpawnedAPK.vel.z += frandom[spawnstuff](1,2);
		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'Lumberjack':
				trycreateapk(e, spawnBiasActual);
				break;
			case 'HDArmour':
				trycreateapk(e, spawnBiasActual);
				break;
			case 'DeadRifleman':
				trycreateapk(e, spawnBiasActual);
				break;
			case 'ReallyDeadRifleman':
				trycreateapk(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Universal Reloader
class URLHandler : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = url_replacement_spawn_bias;
		isPersistent = url_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreateurl(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let SpawnedURL = Actor.Spawn('HDURLSpawner', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
			SpawnedURL.vel.x += frandom(-2,2);
			SpawnedURL.vel.y += frandom[spawnstuff](-2,2);
			SpawnedURL.vel.z += frandom[spawnstuff](1,2);
		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'HDAmBox':
				trycreateurl(e, spawnBiasActual);
				break;
			case 'DeadRifleman':
				trycreateurl(e, spawnBiasActual);
				break;
			case 'ReallyDeadRifleman':
				trycreateurl(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Logistic Bags
class HD_LogiBagSpawner : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = lgb_replacement_spawn_bias;
		isPersistent = lgb_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreatelgb(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let SpawnedLBag = Actor.Spawn('HD_WildLogiBag', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
			SpawnedLBag.vel.x += frandom(-2,2);
			SpawnedLBag.vel.y += frandom[spawnstuff](-2,2);
			SpawnedLBag.vel.z += frandom[spawnstuff](1,2);
		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'HDAmBox':
				trycreatelgb(e, spawnBiasActual);
				break;
			case 'DeadRifleman':
				trycreatelgb(e, spawnBiasActual);
				break;
			case 'ReallyDeadRifleman':
				trycreatelgb(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Medical Bags
class HD_MediBagSpawner : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = mdb_replacement_spawn_bias;
		isPersistent = lgb_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreatemdb(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let SpawnedMDB = Actor.Spawn('HD_WildMediBag', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
			SpawnedMDB.vel.x += frandom(-2,2);
			SpawnedMDB.vel.y += frandom[spawnstuff](-2,2);
			SpawnedMDB.vel.z += frandom[spawnstuff](1,2);
			if (e.Thing.GetClassName() == "PortableHealingItem") { e.Thing.destroy(); }
		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'PortableHealingItem':
				trycreatemdb(e, spawnBiasActual);
				break;
			case 'DeadRifleman':
				trycreatemdb(e, spawnBiasActual);
				break;
			case 'ReallyDeadRifleman':
				trycreatemdb(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Defib
class HD_DefibSpawner : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = dfb_replacement_spawn_bias;
		isPersistent = dfb_persistent_spawning;
	}

	override void WorldLoaded(WorldEvent e)
	{
		init();
		super.WorldLoaded(e);
	}

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

	void trycreatedfb(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let SpawnedPouch = Actor.Spawn('HDefib', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
			SpawnedPouch.vel.x += frandom(-2,2);
			SpawnedPouch.vel.y += frandom[spawnstuff](-2,2);
			SpawnedPouch.vel.z += frandom[spawnstuff](1,2);
			if (e.Thing.GetClassName() == "PortableHealingItem") { e.Thing.destroy(); }
		}
	}
override void worldthingspawned(worldevent e)
  {
	if(!cvarsAvailable)
		init();
	if(!e.Thing)
	{
		return;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'PortableHealingItem':
				trycreatedfb(e, spawnBiasActual);
				break;
			case 'DeadRifleman':
				trycreatedfb(e, spawnBiasActual);
				break;
			case 'ReallyDeadRifleman':
				trycreatedfb(e, spawnBiasActual);
				break;
		}
	}
	}
}