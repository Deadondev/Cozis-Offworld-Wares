// Generic beverage class - resealable, usually bottled, can range from medium, large, or really big.
mixin class Uas_AlcoholMixin
{
	default
	{
		Uas_Consumable.Calories 30;
		Uas_Consumable.Fluid 380;
		Uas_Consumable.Bulk 8;

		+Uas_Consumable.DRINKABLE;
		+Uas_Consumable.PACKAGED;
		+UaS_Consumable.RESEALABLE;
		
		Inventory.PickupMessage "Picked up an alcoholic liquids package.";

		Inventory.Icon "BTTLE0";
		scale 0.8;
	}
}

// Alcohol consumable class.

class BlueRum_Alcohol : UaS_Consumable
{
	int intox_per_bulk;
	property IntoxPerbulk : intox_per_bulk;


	int prevbulk;

	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		prevbulk = weaponbulk();
	}
	override void Tick()
	{
		super.tick();
		weaponstatus[UGCS_SPOILAGE] = 0; // no spoiling

		if(!tracker || !tracker.owner)
			return;
		HDPlayerPawn hdp = HDPlayerPawn(tracker.owner);
		int bulk = prevbulk - weaponbulk();
		if(bulk > 0){
			hdp.GiveInventory("UaSAlcohol_IntoxToken", intox_per_bulk * bulk);
			hdp.GiveInventory("HealingMagic", 8);
		}
		prevbulk = weaponbulk();
	}
}

/// Alcoholic drinks.

// Resealable alcoholic drinks. (Cork, lid, cap, etc.)

class UaS_Alcohol_OleRum : BlueRum_Alcohol
{mixin Uas_AlcoholMixin;
	

	default
	{
		UaS_Consumable.Calories 652;
		UaS_Consumable.Fluid 701;
		UaS_Consumable.Bulk 12;
		UaS_Consumable.OpenSound "mre/cork";
		
		Inventory.Icon "BTTLD0";
		Inventory.PickupMessage "Picked up a bottle o' rum.";

		tag "Ole Rum";
		Uas_Consumable.Description "Some REALLY old aged rum. The alcohol amount would probably kill you if it wasn't watered down with a magical tonic. Drink up!";
		BlueRum_Alcohol.IntoxPerBulk 208;

		scale 0.38;
	}
	override void Messages()
	{
		AddOpenText("Strong smell, but it's good.");
		AddConsumeText("This should numb enough.");
		AddConsumeText("Down the hatch.");
		AddConsumeText("Sweet liquor eases the pain.");
	}
	
	states
	{
		Spawn:
			BTTL E -1;
			Stop;
	}
}

const HDLD_OLERUM="rum";
class HD_OldRum:HDPickup{
	default{
		-hdpickup.fitsinbackpack
		hdpickup.refid HDLD_OLERUM;
		tag "Magician Jim's Ole Rum";
	}
	states{
	spawn:
		TNT1 A 0; stop;
	pickup:
		TNT1 A 0{
			A_GiveInventory("UaS_Alcohol_OleRum", invoker.amount);
		}fail;
	}
}

class COW_OffworldLockbox : UaS_Consumable
{
	default
	{	
		Inventory.PickupMessage "Picked up an old strongbox.";
		tag "Offworld Lockbox";
		Uas_Consumable.Description "An old strongbox, containing some weird offworld items. Fancy.";
		
		Inventory.Icon "COWCA0";
		
		scale 1.65;
	}
	override void Contents()
	{
		AddItem("HD_Musket", 1);
		AddItem("HDCommando");
		AddItem("HDUniversalReloader", 1);
		AddItem("UaS_Alcohol_OleRum", 2);
	}
	
	states
	{
		Spawn:
			COWC A -1;
			Stop;
	}
}

class COW_Rat_HardTack : UaS_Consumable
{
	default
	{
		Uas_Consumable.Calories 82;
		Uas_Consumable.Fluid -55;
		Uas_Consumable.Bulk 8;
		UaS_Consumable.SpoilRate 0.01;

		+UaS_Consumable.PACKAGED;
		-Uas_Consumable.RESEALABLE;
		
		Inventory.PickupMessage "Picked up an MRE pouch.";
		tag "Hardtack";
		UaS_Consumable.Description "A piece of Hardtack from too long ago, likely still perfectly edible though. If you can consider it edible in the first place.";

		Inventory.PickupMessage "Picked up some sort of paper wrapped food.";

		scale 0.6;
	}
		override void Messages()
	{
		AddConsumeText("Tastes like... plain.");
		AddConsumeText("You contemplate if eating this is worth it before taking a bite.");
		AddConsumeText("Tastes pretty plain, yet better than eating nothing. Kind of.");
		AddConsumeText("Incredibly salty.");
		AddConsumeText("You feel like you chip your tooth trying to take a bite.");
		AddConsumeText("At least it's not plastic. You think.");
		AddOpenText("You dip it in some water and it still doesn't soften up.");
		AddOpenText("Hmm, this one's already been recently soaked.");
		AddOpenText("You wet the hardtack with some of your canteen water.");
	}
}

class COW_Rat_HolyHardTack : BlueRum_Alcohol
{
	default
	{
		Uas_Consumable.Calories 429;
		Uas_Consumable.Fluid 125;
		Uas_Consumable.Bulk 6;

		+UaS_Consumable.PACKAGED;
		-Uas_Consumable.RESEALABLE;
		
		Inventory.PickupMessage "Picked up an MRE pouch.";
		tag "Holy Hardtack";
		UaS_Consumable.Description "A piece of Hardtack from too long ago, though this one's been soaked in some sort of alcohol. It has 'holy' written on it.";
		
		Inventory.Icon "BTTLD0";
		Inventory.PickupMessage "Picked up some sort of paper wrapped food.";
		BlueRum_Alcohol.IntoxPerBulk 128;

		scale 0.8;
	}
		override void Messages()
	{
		AddConsumeText("Tastes like... rum..?");
		AddConsumeText("You gag a bit as you take a bite of the soggy mixture.");
		AddConsumeText("Despite the hardtack being drenched in alcohol, it still tastes very salty.");
		AddConsumeText("Incredibly salty.");
		AddConsumeText("You feel the hardtack stick to your teeth as you try to eat it.");
		AddConsumeText("Your tongue tingles as you take bites of the Hardtack.");
		AddOpenText("Eugh, reeks like alcohol.");
		AddOpenText("The piece of hardtack is soaked in some sort of... blue liquid and reeks like alcohol.");
		AddOpenText("The hardtack inside is drenched in alcohol and reeks.");
	}
}

class COW_Rat_SaltedCod : UaS_Consumable
{
	default
	{
		Uas_Consumable.Calories 482;
		Uas_Consumable.Fluid -213;
		Uas_Consumable.Bulk 12;
		UaS_Consumable.SpoilRate 0.35;

		+UaS_Consumable.PACKAGED;
		-Uas_Consumable.RESEALABLE;
		
		Inventory.PickupMessage "Picked up a paper-wrapped good.";
		tag "Salted Cod";
		UaS_Consumable.Description "An old piece of salted cod, likely still perfectly edible though, even if it's incredibly salty..";

		scale 0.6;
	}
		override void Messages()
	{
		AddConsumeText("You gag a bit from the salt.");
		AddConsumeText("Your stomach turns from all of the salt inside.");
		AddConsumeText("You feel like you won't have to drink for a while.");
		AddConsumeText("Incredibly salty.");
		AddConsumeText("Your eyes start watering from how much salt is on the cod.");
		AddConsumeText("This makes the standard issue MREs taste salt-free.");
		AddOpenText("It reeks like fish and salt.");
		AddOpenText("Dangerously salty.");
		AddOpenText("You gag a bit as you look at the cod.");
	}
}

class HD_RadsuitPack : UaS_Consumable
{
	default
	{	
		Inventory.PickupMessage "Picked up a radsuit package.";
		tag "Radsuit Package";
		Uas_Consumable.Description "A 6-pack of radsuits for industrial usage.";
		
		Inventory.Icon "ARSPA0";
		
		scale 0.65;
	}
	override void Contents()
	{
		AddItem("PortableRadsuit", 6);
	}
	
	states
	{
		Spawn:
			ARSP A -1;
			Stop;
	}
}