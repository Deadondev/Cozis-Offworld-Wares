class FAK_AutoMag_SelectFire : FAK_Upgrade
{
	override string GetItem() { return "HD_AutoMag"; }
	override string GetDisplayName() { return "Select-Fire"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 1 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~1; GiveCore(wpn.owner, 0.2); }
}

class FAK_Colt355_Masterkey : FAK_Upgrade
{
	override string GetItem() { return "HD_Colt355"; }
	override string GetDisplayName() { return "Masterkey"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[7] = 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[7] == 1; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[7] = 0; GiveCore(wpn.owner, 0.45); }
}

class FAK_Aug9mm_Masterkey : FAK_Upgrade
{
	override string GetItem() { return "HD_Aug9mm"; }
	override string GetDisplayName() { return "Masterkey"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[7] = 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[7] == 1; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[7] = 0; GiveCore(wpn.owner, 0.45); }
}