class FAK_Fenris_PolyFrame : FAK_Upgrade
{
	override string GetItem() { return "HDFenris"; }
	override string GetDisplayName() { return "Poly Frame"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 0.75); }
}

class FAK_Fenris_Capacitor : FAK_Upgrade
{
	override string GetItem() { return "HDFenris"; }
	override string GetDisplayName() { return "Capacitor"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 0.75); }
}

class FAK_GFB_Capacitor : FAK_Upgrade
{
	override string GetItem() { return "HDGFBlaster"; }
	override string GetDisplayName() { return "Capacitor"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 0.8); }
}

class FAK_PD42_Slugger : FAK_Upgrade
{
	override string GetItem() { return "HDPDFour"; }
	override string GetDisplayName() { return "Slugger"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 0.75); }
}

class FAK_Six12_Barracuda : FAK_Upgrade
{
	override string GetItem() { return "HDSix12"; }
	override string GetDisplayName() { return "Barracuda"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp)
	{
		// [Ace] The framework was never meant for this. Ah well. It is now.
		Actor plr = wpn.owner;

		HDWeapon CurWeapon = wpn;
		int MagOne = CurWeapon.WeaponStatus[1];
		int MagTypeOne = CurWeapon.WeaponStatus[2];
		plr.DropInventory(CurWeapon);

		HDWeapon NewWeapon = HDWeapon(plr.FindInventory(CurWeapon.GetClass()));
		int MagTwo = NewWeapon.WeaponStatus[1];
		int MagTypeTwo = NewWeapon.WeaponStatus[2];
		plr.DropInventory(NewWeapon);

		CurWeapon.Destroy();
		NewWeapon.Destroy();

		Name cls = 'HDBarracuda';
		HDWeapon Barr;
		if (plr.FindInventory(cls))
		{
			Barr = HDWeapon(Actor.Spawn(cls, plr.pos + (0, 0, plr.height / 2)));
			Barr.angle = plr.angle;
			Barr.A_ChangeVelocity(1, 0, 1, CVF_RELATIVE);
		}
		else
		{
			Barr = HDWeapon(plr.GiveInventoryType(cls));
		}
		Barr.WeaponStatus[1] = MagOne;
		Barr.WeaponStatus[2] = MagTwo;
		if (MagTypeOne == 1)
		{
			Barr.WeaponStatus[3] |= 1 << 0;
		}
		if (MagTypeTwo == 1)
		{
			Barr.WeaponStatus[3] |= 1 << 1;
		}
	}
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return HUResult_Destructive; }
	override bool CheckPrerequisites(HDWeapon wpn, HDPickup pkp)
	{
		Name cls = 'HDBarracuda';
		return wpn.ActualAmount >= 2 && (class<Actor>)(cls);
	}
	override string GetFailMessage(HDWeapon wpn, HDPickup pkp, int type)
	{
		Name cls = 'HDBarracuda';
		if (type == FMType_Requirements)
		{
			return (class<Actor>)(cls) ? "You need two Six12 shotguns for upgrade." : "What the hell is a Barracuda?";
		}
		return Super.GetFailMessage(wpn, pkp, type);
	}
}

class FAK_MBR_Firemode : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Firemode Selector"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 4; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 4 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~4; GiveCore(wpn.owner, 0.5); }
}

class FAK_MBR_Scope : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Scope"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 8; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 0.7); }
}

class FAK_MBR_GL : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Grenade Launcher"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 16; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 16 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~16; GiveCore(wpn.owner, 0.7); }
}

class FAK_MBR_FactoryFrame : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Frame (Factory)"; }
	override int GetCost() { return 0; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[3] = 0; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[3] == 0 ? HUResult_Installed : HUResult_Unique; }
	override bool CanDowngrade() { return false; }
}

class FAK_MBR_CQCFrame : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Frame (CQC)"; }
	override int GetCost() { return 0; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[3] = 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[3] == 1 ? HUResult_Installed : HUResult_Unique; }
	override bool CanDowngrade() { return false; }
}

class FAK_MBR_DMRFrame : FAK_Upgrade
{
	override string GetItem() { return "HDMBR"; }
	override string GetDisplayName() { return "Frame (DMR)"; }
	override int GetCost() { return 0; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[3] = 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[3] == 2 ? HUResult_Installed : HUResult_Unique; }
	override bool CanDowngrade() { return false; }
}

class FAK_FoG_Efficiency : FAK_Upgrade
{
	override string GetItem() { return "HDFoG"; }
	override string GetDisplayName() { return "Efficency Upgrade"; }
	override int GetCost() { return 2; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 1.0); }
}

class FAK_Bitch_RapidFire : FAK_Upgrade
{
	override string GetItem() { return "HDBitch"; }
	override string GetDisplayName() { return "Rapid-Fire"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 2; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 2 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~2; GiveCore(wpn.owner, 0.8); }
}

class FAK_Bitch_GL : FAK_Upgrade
{
	override string GetItem() { return "HDBitch"; }
	override string GetDisplayName() { return "Grenade Launcher"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 8; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 8 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~8; GiveCore(wpn.owner, 0.8); }
}

class FAK_HEV_Repair : FAK_Upgrade
{
	override string GetItem() { return "HDHEVArmour"; }
	override string GetDisplayName() { return "Full Repair"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp)
	{
		let arm = HDArmour(pkp);
		arm.Mags[arm.Mags.Size() - 1] = 107;
	}
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return HUResult_Repeatable; }
}