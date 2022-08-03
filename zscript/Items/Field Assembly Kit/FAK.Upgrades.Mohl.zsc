class FAK_500SWLeverRifle_Scope : FAK_Upgrade
{
	override string GetItem() { return "HD50SWLeverRifle"; }
	override string GetDisplayName() { return "Scope"; }
	override void DoUpgrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[12] = 1; }
	override int HasUpgrade(HDWeapon wpn, HDPickup pkp) { return wpn.WeaponStatus[12] == 1; }
	override void DoDowngrade(HDWeapon wpn, HDPickup pkp) { wpn.WeaponStatus[12] = 0; GiveCore(wpn.owner, 0.2); }
}