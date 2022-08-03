class FAK_Gungnir_Accelerator : FAK_Upgrade
{
	override string GetItem() { return "HDGungnir"; }
	override string GetDisplayName() { return "Accelerator"; }
	override int GetCost() { return 4; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 1.0); }
}

class FAK_Gungnir_Capacitor : FAK_Upgrade
{
	override string GetItem() { return "HDGungnir"; }
	override string GetDisplayName() { return "Capacitor"; }
	override int GetCost() { return 5; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 1.0); }
}

class FAK_Gungnir_Processor : FAK_Upgrade
{
	override string GetItem() { return "HDGungnir"; }
	override string GetDisplayName() { return "Processor"; }
	override int GetCost() { return 3; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 1.0); }
}

class FAK_Gungnir_AntiFrag : FAK_Upgrade
{
	override string GetItem() { return "HDGungnir"; }
	override string GetDisplayName() { return "Anti-Frag Containment Cell"; }
	override int GetCost() { return 3; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp)
	{
		wpn.WeaponStatus[0] |= 8;

		Name cls = 'HDFoG';
		Inventory fog = wpn.owner.FindInventory(cls);
		wpn.owner.DropInventory(fog);
		fog.Destroy();
	}
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 1.0); }
	override bool CheckPrerequisites(HDWeapon wpn, HDPickup pkp)
	{
		Name cls = 'HDFoG';
		return (class<Actor>)(cls) && wpn.owner.FindInventory(cls) && wpn.WeaponStatus[0] & 2;
	}
	override string GetFailMessage(HDWeapon wpn, HDPickup pkp, int type)
	{
		if (type == FMType_Requirements)
		{
			Name cls = 'HDFoG';
			if ((class<Actor>)(cls))
			{
				return wpn.WeaponStatus[0] & 2 ? "You need a Finger of God for this upgrade." : "You need to upgrade the capacitor first.";
			}
			return "This technology does not exist.";
		}
		return Super.GetFailMessage(wpn, pkp, type);
	}
}

class FAK_Redline_LockOn : FAK_Upgrade
{
	override string GetItem() { return "HDRedline"; }
	override string GetDisplayName() { return "Lock-On"; }
	override int GetCost() { return 3; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 1.0); }
}

class FAK_Viper_HeavyFrame : FAK_Upgrade
{
	override string GetItem() { return "HDViper"; }
	override string GetDisplayName() { return "Heavy Frame"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 0.60); }
}

class FAK_Viper_ExtendedBarrel : FAK_Upgrade
{
	override string GetItem() { return "HDViper"; }
	override string GetDisplayName() { return "Extended Barrel"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 8; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 0.50); }
}

class FAK_Majestic_Accelerator : FAK_Upgrade
{
	override string GetItem() { return "HDMajestic"; }
	override string GetDisplayName() { return "Accelerator"; }
	override int GetCost() { return 2; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 1.0); }
}

class FAK_Wyvern_Autoloader : FAK_Upgrade
{
	override string GetItem() { return "HDWyvern"; }
	override string GetDisplayName() { return "Autoloader"; }
	override int GetCost() { return 2; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 8; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 1.0); }
}

class FAK_Jackdaw_RapidFire : FAK_Upgrade
{
	override string GetItem() { return "HDJackdaw"; }
	override string GetDisplayName() { return "Rapid-Fire"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 0.65); }
}

class FAK_PSG_ExtraPoint : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "+1 Upgrade Point"; }
	override int GetCost() { return 5; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[9]++; wpn.Icon = TexMan.CheckForTexture(wpn.GetPickupSprite(), TexMan.Type_Any); }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[9] < 7 ? HUResult_Repeatable : HUResult_MaxedOut; }
}

class FAK_PSG_Repair : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "Repair 50% Degradation"; }
	override int GetCost() { return 2; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[7] /= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return HUResult_Repeatable; }
}

class FAK_PSG_Elemental : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "Elemental Protection"; }
	override int GetCost() { return 5; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 1.0); }
}

class FAK_PSG_Medical : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "Medical Field"; }
	override int GetCost() { return 6; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 1.0); }
}

class FAK_PSG_Shocking : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "Shock Field"; }
	override int GetCost() { return 3; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 1.0); }
}

class FAK_PSG_Cloaking : FAK_Upgrade
{
	override string GetItem() { return "HDPersonalShieldGenerator"; }
	override string GetDisplayName() { return "Cloaking Field"; }
	override int GetCost() { return 8; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 8; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 1.0); }
}

class FAK_Barricade_Repair : FAK_Upgrade
{
	override string GetItem() { return "HDDeployableBarricade"; }
	override string GetDisplayName() { return "Full Repair"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { pkp.Health = pkp.default.Health; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return HUResult_Repeatable; }
}

class FAK_DSD_ExtraCapacity : FAK_Upgrade
{
	override string GetItem() { return "DSDInterface"; }
	override string GetDisplayName() { return "+500 Capacity"; }
	override int GetCost() { return 1; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[1]++; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return HUResult_Repeatable; }
}

class FAK_Blackhawk_SemiAuto : FAK_Upgrade
{
	override string GetItem() { return "HDBlackhawk"; }
	override string GetDisplayName() { return "Semi-Auto"; }
	override int GetCost() { return 2; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; ; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 1.0); }
}