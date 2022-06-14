class HDArmorPatchKit : HDWeapon
{
	enum KitAction
	{
		KAction_Repair,
		KAction_Strip
	}

	enum KitProperties
	{
		KProp_UseOffset,
		KProp_Durability
	}

	action void A_AddOffset(int ofs)
	{
		invoker.WeaponStatus[KProp_UseOffset] += ofs;
	}

	override string GetHelpText()
	{
		return WEPHELP_FIRE.." (Hold)".."+"..WEPHELP_RELOAD.."  Repair armor\n"
		..WEPHELP_ALTFIRE.." (Hold)".."+"..WEPHELP_RELOAD.."  Disassemble armor\n"
		..WEPHELP_FIREMODE.."+"..WEPHELP_FIRE.."/"..WEPHELP_ALTFIRE.."  Cycle armors\n";
	}
	override string, double GetPickupSprite(){ return "APKTA0", 1.0; }
	override double GunMass() { return 0; }
	override double WeaponBulk() { return 40 * Amount; }
	override bool AddSpareWeapon(actor newowner) { return AddSpareWeaponRegular(newowner); }
	override HDWeapon GetSpareWeapon(actor newowner, bool reverse, bool doselect) { return GetSpareWeaponRegular(newowner, reverse, doselect); }
	override void InitializeWepStats(bool idfa) { WeaponStatus[KProp_Durability] = KitDurability; }
	override void LoadoutConfigure(string input) { WeaponStatus[KProp_Durability] = KitDurability; }

	protected int GetSelectedArmorDurability()
	{
		let Armor = HDArmour(owner.FindInventory("HDArmour"));
		if (Armor)
		{
			return Armor.Mags[Armor.Mags.Size() - 1];
		}

		return -1;
	}

	override void DropOneAmmo(int amt)
	{
		if (owner)
		{
			owner.A_DropInventory(GetPatchType(false), 1);
			owner.Angle += 10;
			owner.A_DropInventory(GetPatchType(true), 1);
			owner.Angle -= 10;
		}
	}

	protected class<HDAPK_ArmorPatch> GetPatchType(bool isMega) const
	{
		return isMega ? "HDAPK_BattlePatch" : "HDAPK_GarrisonPatch";
	}

	override void DrawHUDStuff(HDStatusBar sb, HDWeapon hdw, HDPlayerPawn hpl)
	{
		// [Ace] Durability display.
		sb.DrawRect(-30, -16, 4, 5); // Vertical.
		sb.DrawRect(-32, -17, 8, 3); // Horizontal.
		sb.DrawWepNum(hdw.WeaponStatus[KProp_Durability], KitDurability);

		vector2 bob = hpl.hudbob * 0.3;
		int Offset = WeaponStatus[KProp_UseOffset];
		bob.y += Offset;
		int BaseYOffset = -70;
		
		sb.DrawImage("APKTA0", (0, BaseYOffset) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, 1.0, scale:(2, 2));

		if (Offset > 95)
		{
			return;
		}

		string GreenPatchIcon = TexMan.GetName(GetDefaultByType("HDAPK_GarrisonPatch").Icon);
		string BattlePatchIcon = TexMan.GetName(GetDefaultByType("HDAPK_BattlePatch").Icon);
		double GreenAlpha = 0.6, BlueAlpha = 0.6;

		// [Ace] The Armor pointer technically refers to Armor.Mags[Mags.Size() - 1].
		let Armor = HDArmour(hpl.FindInventory("HDArmour"));
		if (Armor)
		{
			int ArmorCount = Armor.Mags.Size();
			for (int i = 0; i < 3 && i < ArmorCount; ++i)
			{
				bool IsMega = Armor.Mags[i] > 1000 || i == ArmorCount - 1 && Armor.Mega;

				string ArmorFullIcon = IsMega ? "ARMCA0" : "ARMSA0";
				string ArmorEmptyIcon = IsMega ? "ARMER1" : "ARMER0";
				int ArmorDurability = Armor.Mags[i] > 1000 ? Armor.Mags[i] - 1000 : Armor.Mags[i];

				bool IsSelected = i == ArmorCount - 1;

				int XOffset = IsSelected ? 0 : (i == 0 ? 40 : -40);
				sb.DrawBar(ArmorFullIcon, ArmorEmptyIcon, ArmorDurability, IsMega ? 70 : 144, (XOffset, BaseYOffset - 60) + bob, -1, 2, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, IsSelected ? 1.0 : 0.6);
				if (IsSelected)
				{
					sb.DrawString(sb.pSmallFont, IsMega ? "Battle Armor" : "Garrison Armor", (0, BaseYOffset - 45) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, IsMega ? Font.CR_BLUE : Font.CR_GREEN);
					sb.DrawString(sb.pSmallFont, sb.FormatNumber(ArmorDurability, 1, 3), (0, BaseYOffset - 35) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);

					if (IsMega)
					{
						BlueAlpha = 1.0;
					}
					else
					{
						GreenAlpha = 1.0;
					}
				}
			}
		}
		else
		{
			sb.DrawString(sb.pSmallFont, "No armors found.", (0, BaseYOffset - 40) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_GOLD);
		}

		sb.DrawImage(GreenPatchIcon, (-60, BaseYOffset) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, GreenAlpha, scale:(2, 2));
		sb.DrawString(sb.pSmallFont, sb.FormatNumber(sb.GetAmount("HDAPK_GarrisonPatch"), 1, 4), (-60, BaseYOffset + 10) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE, GreenAlpha);

		sb.DrawImage(BattlePatchIcon, (60, BaseYOffset) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, BlueAlpha, scale:(2, 2));
		sb.DrawString(sb.pSmallFont, sb.FormatNumber(sb.GetAmount("HDAPK_BattlePatch"), 1, 4), (60, BaseYOffset + 10) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE, BlueAlpha);
	}

	protected action void A_TryKitAction(KitAction act)
	{
		HDArmour Armor = HDArmour(FindInventory("HDArmour"));
		if (!Armor)
		{
			return;
		}

		if (invoker.WeaponStatus[KProp_Durability] <= 0)
		{
			A_WeaponMessage("Your patching tools have been dulled out.");
			return;
		}

		switch (act)
		{
			int ArmorDurability;

			case KAction_Repair:
				int PatchKits = CountInv(invoker.GetPatchType(Armor.Mega));
				if (PatchKits <= 0)
				{
					A_Log("You don't have any patch kits left.", true);
					return;
				}

				ArmorDurability = invoker.GetSelectedArmorDurability();
				if (Armor.Mega && ArmorDurability < 1000 + 70 * 0.75 || !Armor.Mega && ArmorDurability < 144 * 1.0)
				{
					static const string RepairStrings[] =
					{
						"Applied some patches.",
						"That's better.",
						"Could use some more patches.",
						"Applied some fixes here and there.",
						"Applied some more fixes here and there."
					};

					if (!random(0, 15))
					{
						A_StartSound("APK/Patch", CHAN_WEAPON);
						A_Log(RepairStrings[random(0, RepairStrings.Size() - 1)], true);
						A_TakeInventory(invoker.GetPatchType(Armor.Mega), 1);
						Armor.Mags[Armor.Mags.Size() - 1] += random(5, 10);
						invoker.WeaponStatus[KProp_Durability]--;
					}
					else
					{
						A_StartSound("APK/Patch", CHAN_WEAPONBODY, CHANF_OVERLAP, frandom(0.6, 1.0), pitch: frandom(1.0, 1.4));
					}
				}
				else
				{
					A_Log("Cannot repair this armor any further.", true);
				}
				break;
				
			case KAction_Strip:
				if (!random(0, 3))
				{
					A_StartSound("APK/Patch", CHAN_WEAPON);
					A_SpawnItemEx(invoker.GetPatchType(Armor.Mega), 0, 0, height / 2 + 8, 3, angle: frandom(-5.0, 5.0));
					Armor.Mags[Armor.Mags.Size() - 1] -= random(12, 18);
					if (!random(0, 4))
					{
						invoker.WeaponStatus[KProp_Durability]--;
					}

					ArmorDurability = invoker.GetSelectedArmorDurability();
					if (Armor.Mega && ArmorDurability <= 1000 || !Armor.Mega && ArmorDurability <= 0)
					{
						A_Log("That armor is done for.", true);
						invoker.StopDisassembly = true;
						Armor.TakeMag(false);
						Armor.SyncAmount();
					}
					else
					{
						static const string StripStrings[] =
						{
							"You strip part of the armor for patches.",
							"Took apart some of the armor.",
							"Ripped and tore some bits and pieces."
						};
						A_Log(StripStrings[random(0, StripStrings.Size() - 1)], true);
					}
					
					for (int i = 0; i < 5; ++i)
					{
						Actor a = spawn("WallChunk", pos + (0, 0, height - 24), ALLOW_REPLACE);
						vector3 offspos = (frandom(-12, 12), frandom(-12, 12), frandom(-16, 4));
						a.SetOrigin(a.pos + offspos,  false);
						a.vel = vel + offspos * frandom(0.3, 0.6);
						a.Scale *= frandom(0.8, 2.0);
					}
				}
				else
				{
					A_StartSound("APK/Patch", CHAN_WEAPONBODY, CHANF_OVERLAP, frandom(0.6, 1.0), pitch: frandom(1.0, 1.4));
				}
				break;
		}

		A_MuzzleClimb(frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(-1.0, 1.0), frandom(0.0, 1.0));
	}

	const KitDurability = 30;
	bool StopDisassembly;

	Default
	{
		+WEAPON.WIMPY_WEAPON
		+INVENTORY.INVBAR
		+HDWEAPON.FITSINBACKPACK
		Inventory.PickupSound "weapons/pocket";
		Inventory.PickupMessage "Picked up an armor patch kit.";
		Scale 0.6;
		HDWeapon.RefId "ark";
		Tag "Armor patch kit";
	}

	States
	{
		Spawn:
			APKT A -1;
			Stop;
		Select:
			TNT1 A 0 A_AddOffset(100);
			Goto Super::Select;
		Ready:
			TNT1 A 1
			{
				if (PressingUser3())
				{
					A_MagManager("PickupManager");
					return;
				}

				let Armor = HDArmour(FindInventory("HDArmour"));
				if (Armor && player.cmd.buttons & BT_USER2)
				{
					if (JustPressed(BT_ATTACK))
					{
						Armor.LastToFirst();
						Armor.SyncAmount();
					}
					else if (JustPressed(BT_ALTATTACK))
					{
						Armor.FirstToLast();
						Armor.SyncAmount();
					}
					return;
				}

				int off = invoker.WeaponStatus[KProp_UseOffset];
				if (off > 0)
				{
					invoker.WeaponStatus[KProp_UseOffset] = off * 2 / 3;
				}

				if (invoker.StopDisassembly)
				{
					invoker.StopDisassembly = false;
				}
				else if (PressingFire() || PressingAltFire())
				{
					SetWeaponState("Lower");
					return;
				}

				A_WeaponReady(WRF_ALLOWUSER3 | WRF_NOFIRE | WRF_ALLOWRELOAD);
			}
			Goto ReadyEnd;

		Lower:
			TNT1 AA 1 A_AddOffset(4);
			TNT1 AAAA 1 A_AddOffset(9);
			TNT1 AAAA 1 A_AddOffset(20);
			TNT1 A 0 A_JumpIf(!PressingFire() && !PressingAltFire(), "Ready");
		ReadyToBash:
			TNT1 A 1
			{
				if (invoker.StopDisassembly || !PressingFire() && !PressingAltFire())
				{
					SetWeaponState("Nope");
				}
				else if (JustPressed(BT_RELOAD))
				{
					if (PressingFire())
					{
						SetWeaponState("RepairBash");
					}
					else
					{
						SetWeaponState("StripBash");
					}
				}
			}
			Wait;
		RepairBash:
			TNT1 A 5 A_TryKitAction(KAction_Repair);
			Goto ReadyToBash;
		StripBash:
			TNT1 A 5 A_TryKitAction(KAction_Strip);
			Goto ReadyToBash;

		User3:
			#### A 0 A_SelectWeapon("PickupManager");
			Goto Ready;
	}
}

class HDAPK_ArmorPatch : HDAmmo
{
	override void GetItemsThatUseThis()
	{
		ItemsThatUseThis.Push("HDArmorPatchKit");
	}

	Default
	{
		-HDPICKUP.DROPTRANSLATION
	}
}

class HDAPK_GarrisonPatch : HDAPK_ArmorPatch
{
	Default
	{
		Tag "Garrison armor Patch";
		Inventory.Icon "APCGA0";
		Inventory.PickupMessage "Picked up some garrison armor patches.";
		HDPickup.Bulk 2.00;
	}

	States
	{
		Spawn:
			APCG A -1 NoDelay
			{
				frame = random(0, 3);
				A_SetScale(0.70, 1.0);
			}
			Stop;
	}
}

class HDAPK_BattlePatch : HDAPK_ArmorPatch
{
	Default
	{
		Tag "Battle armor patch";
		Inventory.Icon "APCBA0";
		Inventory.PickupMessage "Picked up some battle armor patches.";
		HDPickup.Bulk 3.00;
	}

	States
	{
		Spawn:
			APCB A -1 NoDelay
			{
				frame = random(0, 3);
				A_SetScale(0.70, 1.0);
			}
			Stop;
	}
}

class HDAPKSpawner:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
		A_SpawnItemEx("HDArmorPatchKit",1,1,flags:SXF_NOCHECKPOSITION);
		if(random(0,2))A_SpawnItemEx("HDAPK_GarrisonPatch",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		if(random(0,2)){
			A_SpawnItemEx("HDAPK_GarrisonPatch",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDAPK_GarrisonPatch",2,2,flags:SXF_NOCHECKPOSITION);
		}else A_SpawnItemEx("HDAPK_BattlePatch",2,2,flags:SXF_NOCHECKPOSITION);
        }stop;
    }
}