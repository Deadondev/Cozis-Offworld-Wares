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
				if (random[rumrandom]() <= 24)
				{
					e.Replacement = "HD_MusketDropper";
					e.IsFinal = true;
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
				if (random[rumrandom]() <= 24)
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
				if (random[rumrandom]() <= 24)
				{
					e.Replacement = "HD_StrikerDropper";
					e.IsFinal = true;
				}
				break;
			case 'ShotgunReplaces':
				if (random[rumrandom]() <= 14)
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
				if (random[rumrandom]() <= 14)
				{
					e.Replacement = "HD_CommandoDropper";
					e.IsFinal = true;
				}
				break;
			case 'ChaingunReplaces':
				if (random[rumrandom]() <= 20)
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
				if (random[rumrandom]() <= 24)
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
        		current_trites            = current_tritescvar;
				max_trites            = max_tritescvar;
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
	override void CheckReplacement(ReplaceEvent e)
	{
		if (!e.Replacement)
		{
			return;
		}

		switch (e.Replacement.GetClassName())
		{
			case 'HDBarrel':
				if (random[spiderrandom]() <= 25)
				{
					e.Replacement = "SpiderBarrel";
				}
				break;
		}
	}
}