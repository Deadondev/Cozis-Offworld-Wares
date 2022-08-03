class FAK_ZM69_FullAuto : FAK_Upgrade
{
	override string GetItem() { return "ZM69Rifle"; }
	override string GetDisplayName() { return "Full-Auto"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] |= 32; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[0] & 32 > 0; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[0] &= ~16; wpn.WeaponStatus[0] &= ~32;  GiveCore(wpn.owner, 0.5); }
}