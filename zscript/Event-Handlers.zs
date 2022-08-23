//-------------------------------------------------
// WEAPONS
//-------------------------------------------------

// Handler for the Musket, controls spawning.
class MusketHandler : eventhandler
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
		spawnBiasActual = musket_blur_spawn_bias;
		isPersistent = musket_persistent_spawning;
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

	void trycreatemsk(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let msk = HD_MusketDropper(e.thing.Spawn("HD_MusketDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
			
			if(msk)
			{
				// Remove the original item. 
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
			case 'BlurSphereReplacer':
				trycreatemsk(e, spawnBiasActual);
				break;
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

// Rum
class OleRumEventHandler : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = rum_pmi_spawn_bias;
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

	void trycreaterum(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = UaS_Alcohol_OleRum(e.thing.Spawn("UaS_Alcohol_OleRum", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
			case 'PortableHealingItem':
				trycreaterum(e, spawnBiasActual);
				break;
		}
	}
	}
}

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

//-------------------------------------------------
// ITEMS
//-------------------------------------------------

class AmmoHandler : EventHandler
{
	override void worldthingspawned(worldevent e)
	{
	let OffworldAmmo = HDAmmo(e.Thing);
	if (!OffworldAmmo)
	{
		return;
	}
		switch (OffworldAmmo.GetClassName())
		{
			case 'HDShellAmmo':
				OffworldAmmo.ItemsThatUseThis.Push("HDMusket");
				break;
		}
	}
}