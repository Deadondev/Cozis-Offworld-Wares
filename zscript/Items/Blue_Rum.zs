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
		tag "Blue Rum";
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