//-------------------------------------------------
// WEAPONS
//-------------------------------------------------

// Musket
class COW_MusketReplacer : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'RedSphere':
				if (random[MusketRandom](0, 128) <= 14)
				{
					e.Replacement = "HD_MusketDropper";
					e.IsFinal = false;
				}
				break;
		}
	}
}

// Pipegun
class PipeGunInjector:EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'ShellBoxRandom':
				if (random[PipeRandom](0, 128) <= 24)
				{
					e.Replacement = "HD_PipegunDropper";
					e.IsFinal = true;
				}
				break;
		}
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		let PipeAmmo = HDAmmo(e.Thing);
		if (!PipeAmmo)
		{
			return;
		}

		switch (PipeAmmo.GetClassName())
		{
			case 'HDShellAmmo':
				PipeAmmo.ItemsThatUseThis.Push("HDPipeGunSG");
				break;
		}
	}
}

// Striker/Stryker/Whatever the fuck we call it
class SweepInjector:EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'SSGReplaces':
				if (random[StrikerRandom]() <= 24)
				{
					e.Replacement = "HD_StrikerDropper";
					e.IsFinal = true;
				}
				break;
			case 'ShotgunReplaces':
				if (random[StrikerRandom](0, 128) <= 14)
				{
					e.Replacement = "HD_StrikerDropper";
					e.IsFinal = true;
				}
				break;
		}
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		let SweepAmmo = HDAmmo(e.Thing);
		if (!SweepAmmo)
		{
			return;
		}

		switch (SweepAmmo.GetClassName())
		{
			case 'HDShellAmmo':
				SweepAmmo.ItemsThatUseThis.Push("HDStreetSweeper");
				break;
		}
	}
}

// Commando .355 Carbine
class Commando355Injector:EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'SSGReplaces':
				if (random[CommandoRandom](0, 128) <= 14)
				{
					e.Replacement = "HD_CommandoDropper";
					e.IsFinal = true;
				}
				break;
			case 'ChaingunReplaces':
				if (random[CommandoRandom]() <= 20)
				{
					e.Replacement = "HD_CommandoDropper";
					e.IsFinal = true;
				}
				break;
		}
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		let CommandoAmmo = HDAmmo(e.Thing);
		if (!CommandoAmmo)
		{
			return;
		}

		switch (CommandoAmmo.GetClassName())
		{
			case 'HDRevolverAmmo':
				CommandoAmmo.ItemsThatUseThis.Push("HDCommando");
				break;
		}
	}
}

// MAC-10
class MacInjector:EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'ChaingunReplaces':
				if (random[MacRandom](0, 128) <= 24)
				{
					e.Replacement = "HD_MAC11Dropper";
					e.IsFinal = true;
				}
				break;
		}
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		let MacAmmo = HDAmmo(e.Thing);
		if (!MacAmmo)
		{
			return;
		}

		switch (MacAmmo.GetClassName())
		{
			case 'HD45ACPAmmo':
				MacAmmo.ItemsThatUseThis.Push("HDMAC11");
				break;
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
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'PortableHealingItem':
				if (random[rumrandom](0, 128) <= 10)
				{
					e.Replacement = "UaS_Alcohol_OleRum";
				}
				break;
		}
	}
}

// Armor Patch Kit
class APKHandler : EventHandler {
	int alreadyspawned;
	int failspawn;

	override void WorldThingSpawned(WorldEvent e) {
		if(level.maptime > 1) { return; }
		if(!e.Thing) { return; }
		if(e.Thing is "Inventory" && Inventory(e.Thing).Owner) { return; }

		bool spawnable = (
			e.Thing.GetClassName() == "Lumberjack" ||
            e.Thing.GetClassName() == "HDArmour" ||
			e.Thing.GetClassName() == "DeadRifleman" ||
			e.Thing.GetClassName() == "ReallyDeadRifleman");

		int chance = 5 + (5 * failspawn) - (50 * alreadyspawned);
		chance = clamp(chance, 0, 100);

		if(spawnable) {
			if (random(0, 100) <= chance) {
				//console.printf("armor patch kit spawn chance %i, success", chance);
				let SpawnedAPK = Actor.Spawn('HDAPKSpawner', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
				SpawnedAPK.vel.x += frandom(-2,2);
				SpawnedAPK.vel.y += frandom[spawnstuff](-2,2);
				SpawnedAPK.vel.z += frandom[spawnstuff](1,2);
				alreadyspawned++;
			}
			else {
				//console.printf("armor patch kit spawn chance %i, fail", chance);
				failspawn++;
			}
		}
	}
}

class RadReplacementHandler : EventHandler
{
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'PortableRadsuit':
				if (random[RadRandom](0, 1) == 1)
				{
					e.Replacement = "HD_RadsuitPack";
				}
				break;
		}
	}
}

// Universal Reloader
class URLHandler : EventHandler {
	int alreadyspawned;
	int failspawn;

	override void WorldThingSpawned(WorldEvent e) {
		if(level.time > 1) { return; }
		if(!e.Thing) { return; }
		if(e.Thing is "Inventory" && Inventory(e.Thing).Owner) { return; }

		bool spawnable = (
			e.Thing.GetClassName() == "HDAmBox" ||
			e.Thing.GetClassName() == "HDAmBoxUnarmed" ||
			e.Thing.GetClassName() == "DeadRifleman" ||
			e.Thing.GetClassName() == "ReallyDeadRifleman");

		int chance = 5 + (5 * failspawn) - (50 * alreadyspawned);
		chance = clamp(chance, 0, 100);

		if(spawnable) {
			if (random(0, 100) <= chance) {
				//console.printf("URL spawn chance %i, success", chance);
				let SpawnedURL = Actor.Spawn('HDURLSpawner', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
				SpawnedURL.vel.x += frandom(-2,2);
				SpawnedURL.vel.y += frandom[spawnstuff](-2,2);
				SpawnedURL.vel.z += frandom[spawnstuff](1,2);
				alreadyspawned++;
			}
			else {
				//console.printf("URL spawn chance %i, fail", chance);
				failspawn++;
			}
		}
	}
}

// Logistic Bags
class HD_LogiBagSpawner : EventHandler {
	int alreadyspawned;
	int failspawn;

	override void WorldThingSpawned(WorldEvent e) {
		if(level.maptime > 1) { return; }
		if(!e.Thing) { return; }
		if(e.Thing is "Inventory" && Inventory(e.Thing).Owner) { return; }

		bool spawnable = (
			e.Thing.GetClassName() == "HDAmBox" ||
			e.Thing.GetClassName() == "DeadRifleman" ||
			e.Thing.GetClassName() == "ReallyDeadRifleman");

		int chance = 5 + (5 * failspawn) - (50 * alreadyspawned);
		chance = clamp(chance, 0, 100);

		if(spawnable) {
			if (random(0, 100) <= chance) {
				//console.printf("logi bag spawn chance %i, success", chance);
				let SpawnedPouch = Actor.Spawn('HD_WildLogiBag', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
				SpawnedPouch.vel.x += frandom(-2,2);
				SpawnedPouch.vel.y += frandom[spawnstuff](-2,2);
				SpawnedPouch.vel.z += frandom[spawnstuff](1,2);
				alreadyspawned++;
				if (e.Thing.GetClassName() == "HDAmBox") { e.Thing.destroy(); }
			}
			else {
				//console.printf("logi bag spawn chance %i, fail", chance);
				failspawn++;
			}
		}
	}
}

// Medical Bags
class HD_MediBagSpawner : EventHandler {
	int alreadyspawned;
	int failspawn;

	override void WorldThingSpawned(WorldEvent e) {
		if(level.maptime > 1) { return; }
		if(!e.Thing) { return; }
		if(e.Thing is "Inventory" && Inventory(e.Thing).Owner) { return; }

		bool spawnable = (
			e.Thing.GetClassName() == "PortableHealingItem" ||
			e.Thing.GetClassName() == "DeadRifleman" ||
			e.Thing.GetClassName() == "ReallyDeadRifleman");

		int chance = 5 + (5 * failspawn) - (50 * alreadyspawned);
		chance = clamp(chance, 0, 100);

		if(spawnable) {
			if (random(0, 100) <= chance) {
				//console.printf("logi bag spawn chance %i, success", chance);
				let SpawnedPouch = Actor.Spawn('HD_WildMediBag', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
				SpawnedPouch.vel.x += frandom(-2,2);
				SpawnedPouch.vel.y += frandom[spawnstuff](-2,2);
				SpawnedPouch.vel.z += frandom[spawnstuff](1,2);
				alreadyspawned++;
				if (e.Thing.GetClassName() == "PortableHealingItem") { e.Thing.destroy(); }
			}
			else {
				//console.printf("logi bag spawn chance %i, fail", chance);
				failspawn++;
			}
		}
	}
}

// Defib
class HD_DefibSpawner : EventHandler {
	int alreadyspawned;
	int failspawn;

	override void WorldThingSpawned(WorldEvent e) {
		if(level.maptime > 1) { return; }
		if(!e.Thing) { return; }
		if(e.Thing is "Inventory" && Inventory(e.Thing).Owner) { return; }

		bool spawnable = (
			e.Thing.GetClassName() == "PortableHealingItem" ||
			e.Thing.GetClassName() == "DeadRifleman" ||
			e.Thing.GetClassName() == "ReallyDeadRifleman");

		int chance = 5 + (5 * failspawn) - (50 * alreadyspawned);
		chance = clamp(chance, 0, 100);

		if(spawnable) {
			if (random(0, 100) <= chance) {
				//console.printf("defib spawn chance %i, success", chance);
				let SpawnedPouch = Actor.Spawn('HDefib', (e.Thing.pos.x, e.Thing.pos.y, e.Thing.pos.z + 5));
				SpawnedPouch.vel.x += frandom(-2,2);
				SpawnedPouch.vel.y += frandom[spawnstuff](-2,2);
				SpawnedPouch.vel.z += frandom[spawnstuff](1,2);
				alreadyspawned++;
				if (e.Thing.GetClassName() == "PortableHealingItem") { e.Thing.destroy(); }
			}
			else {
				//console.printf("defib spawn chance %i, fail", chance);
				failspawn++;
			}
		}
	}
}