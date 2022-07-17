//-------------------------------------------------
// WEAPONS
//-------------------------------------------------

// Musket
class COW_MusketReplacer : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = musket_blur_spawn_bias;
		isPersistent = musket_persistent_spawning;
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

	void trycreatemusket(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_MusketDropper(e.thing.Spawn("HD_MusketDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	
	let MuskAmmo = HDAmmo(e.Thing);
	if (!MuskAmmo)
	{
		return;
	}
	switch (MuskAmmo.GetClassName())
	{
		case 'HDShellAmmo':
			MuskAmmo.ItemsThatUseThis.Push("HD_Musket");
			break;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'BlurSphereReplacer':
				trycreatemusket(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Pipegun
class PipeGunInjector : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = pipegun_shell_spawn_bias;
		isPersistent = pipegun_persistent_spawning;
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

	void trycreatepipegun(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_PipegunDropper(e.thing.Spawn("HD_PipegunDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	
	let PipeAmmo = HDAmmo(e.Thing);
	if (!PipeAmmo)
	{
		return;
	}
	switch (PipeAmmo.GetClassName())
	{
		case 'HDShellAmmo':
			PipeAmmo.ItemsThatUseThis.Push("HDPipegunSG");
			break;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'ShellBoxRandom':
				trycreatepipegun(e, spawnBiasActual);
				break;
		}
	}
	}
}

class LevergatInjector : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = levergat_chaingun_spawn_bias;
		isPersistent = levergat_persistent_spawning;
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

	void trycreatelevergat(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_LevergatDropper(e.thing.Spawn("HD_LevergatDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	
	let LeverAmmo = HDAmmo(e.Thing);
	if (!LeverAmmo)
	{
		return;
	}
	switch (LeverAmmo.GetClassName())
	{
		case 'HD50AEAmmo':
			LeverAmmo.ItemsThatUseThis.Push("HDLeverGun");
			break;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'ChaingunReplaces':
				trycreatelevergat(e, spawnBiasActual);
				break;
		}
	}
	}
}

// Striker/Stryker/Whatever the fuck we call it
class SweepInjector : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActualsg;
	private int spawnBiasActualssg;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActualsg = stryk_shotgun_spawn_bias;
		spawnBiasActualSSG = stryk_ssg_spawn_bias;
		isPersistent = stryk_persistent_spawning;
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

	void trycreatestryk(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_StrikerDropper(e.thing.Spawn("HD_StrikerDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	
	let strykAmmo = HDAmmo(e.Thing);
	if (!strykAmmo)
	{
		return;
	}
	switch (strykAmmo.GetClassName())
	{
		case 'HDShellAmmo':
			strykAmmo.ItemsThatUseThis.Push("HDStreetSweeper");
			break;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'ChaingunReplaces':
				trycreatestryk(e, spawnBiasActualsg);
				break;
			case 'SSGReplaces':
				trycreatestryk(e, spawnBiasActualssg);
				break;
		}
	}
	}
}

// Commando .355 Carbine
class Commando355Injector : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActualCG;
	private int spawnBiasActualssg;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActualCG = c355_chaingun_spawn_bias;
		spawnBiasActualSSG = c355_ssg_spawn_bias;
		isPersistent = c355_persistent_spawning;
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

	void trycreatec355(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_CommandoDropper(e.thing.Spawn("HD_CommandoDropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	
	let c355Ammo = HDAmmo(e.Thing);
	if (!c355Ammo)
	{
		return;
	}
	switch (c355Ammo.GetClassName())
	{
		case 'HDRevolverAmmo':
			c355Ammo.ItemsThatUseThis.Push("HDCommando");
			break;
	}
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'ChaingunReplaces':
				trycreatec355(e, spawnBiasActualCG);
				break;
			case 'SSGReplaces':
				trycreatec355(e, spawnBiasActualSSG);
				break;
		}
	}
	}
}

// RAC-13/45 (it's a mac-10 but RAC-13 is kewler)
class MacInjector : EventHandler
{
	private bool cvarsAvailable;
	private int spawnBiasActual;
	private bool isPersistent;
	void init()
	{
		cvarsAvailable = true;
		spawnBiasActual = mac10_regulars_spawn_bias;
		isPersistent = mac10_persistent_spawning;
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

	void trycreatemac10(worldevent e, int chance)
	{
		if(giverandom(chance))
		{
			let sss = HD_MAC11Dropper(e.thing.Spawn("HD_MAC11Dropper", e.thing.pos, SXF_TRANSFERSPECIAL | SXF_NOCHECKPOSITION));
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
	if (!(level.maptime > 1) || isPersistent)
	{
		switch(e.Thing.GetClassName())
		{
			case 'ChaingunReplaces':
				trycreatemac10(e, spawnBiasActual);
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