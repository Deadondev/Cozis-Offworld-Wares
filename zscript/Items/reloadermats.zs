// Loadout Codes.
const HD_URLBRASS="brs";
const HD_URLPOWDER="pdr";
const HD_URLPLASTIC="pst";
const HD_URLLEAD="led";

class HDRel_CraftingMaterial : HDAmmo abstract
{
	enum PType
	{
		PType_None,
		PType_Ball,
		PType_Pile
	}

	override void GetItemsThatUseThis()
	{
		ItemsThatUseThis.Push("HDUniversalReloader");
	}

	override string PickupMessage()
	{
		return Amount > 1 ? PileMessage : default.PickupMsg; 
	}

	override void SplitPickup()
	{
		int SplitAmount = min(Amount, random(4, 26));
		while (Amount > SplitAmount)
		{
			int SubSplit = min(Amount, random(4, 26));
			Actor a = Spawn(GetClass(), pos);
			a.vel += vel + (frandom(-1, 1), frandom(-1, 1), frandom(-1, 1));
			Inventory(a).Amount = SubSplit;
			Amount -= SubSplit;
		}

		if (amount < 1)
		{
			Destroy();
			return;
		}

		switch (PileType)
		{
			case PType_Pile:
				scale.y = default.scale.y * max(1.0, Amount * 0.1);
				if (Amount > 1)
				{
					Frame = 1;
				}
				break;
			case PType_Ball:
				scale = default.scale * max(1.0, Amount * 0.1);
				break;
		}
	}

	override void DoEffect()
	{
		if (Amount < 1)
		{
			Destroy();
			return;
		}
	}

	PType PileType;
	property PileType: PileType;

	string PileMessage;
	property PileMessage: PileMessage;

	Default
	{
		+FORCEXYBILLBOARD
		+HDPICKUP.MULTIPICKUP
	}
}

// [Ace] Just in case I want to change things individually later down the line.
class HDRel_CasingMaterial : HDRel_CraftingMaterial abstract { }
class HDRel_PowderMaterial : HDRel_CraftingMaterial abstract { }
class HDRel_ProjectileMaterial : HDRel_CraftingMaterial abstract { }

class HDRel_RawBrass : HDRel_CasingMaterial
{
	Default
	{
		Tag "Brass";
		hdpickup.refid HD_URLBRASS;
		Inventory.Icon "BRMTA0";
		Inventory.PickupMessage "Picked up some brass materials.";
		HDRel_CraftingMaterial.PileMessage "Picked up a ball of brass.";
		HDRel_CraftingMaterial.PileType PType_Ball;
		HDPickup.Bulk 0.20;
	}

	States
	{
		Spawn:
			BRMT A -1;
			Stop;
	}
}

class HDRel_RawPlastic : HDRel_CasingMaterial
{
	Default
	{
		Tag "Plastic";
		hdpickup.refid HD_URLPLASTIC;
		Inventory.Icon "PLTCA0";
		Inventory.PickupMessage "Picked up some plastic materials.";
		HDRel_CraftingMaterial.PileMessage "Picked up a pile of plastic.";
		HDRel_CraftingMaterial.PileType PType_None;
		HDPickup.Bulk 0.11;
		Scale 0.4;
	}

	States
	{
		Spawn:
			PLTC A -1;
			Stop;
	}
}

class HDRel_RawLead : HDRel_ProjectileMaterial 
{
	Default
	{
		Tag "Lead";
		hdpickup.refid HD_URLLEAD;
		Inventory.Icon "LEADA0";
		Inventory.PickupMessage "Picked up some lead materials.";
		HDRel_CraftingMaterial.PileMessage "Picked up a ball of lead.";
		HDRel_CraftingMaterial.PileType PType_Ball;
		HDPickup.Bulk 0.25;
		Scale 0.8;
	}

	States
	{
		Spawn:
			LEAD A -1;
			Stop;
	}
}

class HDRel_RawPowder : HDRel_PowderMaterial
{
	Default
	{
		Tag "Powder";
		hdpickup.refid HD_URLPOWDER;
		Inventory.Icon "PWDRA0";
		Inventory.PickupMessage "Picked up some powder.";
		HDRel_CraftingMaterial.PileMessage "Picked up a pile of powder.";
		HDRel_CraftingMaterial.PileType PType_Pile;
		HDPickup.Bulk 0.08;
	}

	States
	{
		Spawn:
			PWDR A -1;
			Stop;
	}
}

// [Ace] This is used for both crafting and disassembly.
class HDRel_Recipe
{
	class<HDAmmo> AmmoClass;
	class<HDRel_CraftingMaterial> Materials[HDUniversalReloader.MaterialCount];
	int Costs[HDUniversalReloader.MaterialCount];
	double Products[HDUniversalReloader.MaterialCount];
	double SpeedMult;

	static HDRel_Recipe TryCreate(string amcls, class<HDRel_ProjectileMaterial> projMat, int projCost, double projProd, class<HDRel_CasingMaterial> casingMat, int csgCost, double csgProd, class<HDRel_PowderMaterial> powderMat, int pwdCost, double pwdProd, double speed)
	{
		HDRel_Recipe Ret = new("HDRel_Recipe");
		
		Ret.AmmoClass = amcls;
		if (Ret.AmmoClass)
		{
			Ret.Materials[0] = projMat;
			Ret.Costs[0] = projCost;
			Ret.Products[0] = projProd;

			Ret.Materials[1] = casingMat;
			Ret.Costs[1] = csgCost;
			Ret.Products[1] = csgProd;

			Ret.Materials[2] = powderMat;
			Ret.Costs[2] = pwdCost;
			Ret.Products[2] = pwdProd;

			Ret.SpeedMult = speed;

			return Ret;
		}

		return null;
	}

	// [Ace] Can't assemble something that's missing a material.
	bool CanBeAssembled()
	{
		for (int i = 0; i < Materials.Size(); ++i)
		{
			if (!Materials[i])
			{
				return false;
			}
		}

		return true;
	}
}