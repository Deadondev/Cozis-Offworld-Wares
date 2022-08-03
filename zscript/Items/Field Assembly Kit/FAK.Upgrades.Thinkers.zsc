class FAK_UpgradeThinker : Thinker
{
	override void Tick()
	{
		let plr = HDPlayerPawn(players[PlayerNumber].mo);
		if (!plr || !plr.player || plr.Health <= 0 || plr.incapacitated > 0) // [Ace] Incap check is just in case.
		{
			return;
		}

		let wpn = HDWeapon(plr.player.ReadyWeapon);
		let psp = plr.player.GetPSprite(PSP_WEAPON);
		if (wpn is 'HDRevolver')
		{
			let rev = HDRevolver(wpn);
			if (rev.WeaponStatus[0] & 64 && rev.CylinderOpen && plr.player.cmd.buttons & BT_RELOAD && !(plr.player.oldbuttons & BT_RELOAD))
			{
				int totalRounds = 0;
				for (int i = BUGS_CYL1; i <= BUGS_CYL6; ++i)
				{
					if (wpn.WeaponStatus[i] > 0)
					{
						totalRounds++;
					}
				}
				if (totalRounds == 0)
				{
					for (int i = 0; i < 6; ++i)
					{
						bool useNineMil = (plr.player.cmd.buttons & BT_FIREMODE || plr.CountInv("HDRevolverAmmo") == 0);
						if (useNineMil && plr.CountInv("HDPistolAmmo") == 0)
						{
							break;
						}
						class<Inventory> ammotype = useNineMil ? 'HDPistolAmmo'  :'HDRevolverAmmo';
						plr.A_TakeInventory(ammotype, 1, TIF_NOTAKEINFINITE);
						rev.WeaponStatus[BUGS_CYL1] = useNineMil ? BUGS_NINEMIL : BUGS_MASTERBALL;
						plr.A_StartSound("weapons/deinoload", 8, CHANF_OVERLAP);
						rev.RotateCylinder();
					}
				}
			}
		}
		else if (wpn is 'Hunter' && wpn.WeaponStatus[0] & 256 && wpn.WeaponStatus[HUNTS_TUBE] < wpn.WeaponStatus[HUNTS_TUBESIZE] && wpn.WeaponStatus[SHOTS_SIDESADDLE] > 0)
		{
			wpn.WeaponStatus[HUNTS_TUBE]++;
			wpn.WeaponStatus[SHOTS_SIDESADDLE]--;
		}
		else if (wpn is 'Slayer' && wpn.WeaponStatus[0] & 256)
		{
			if (psp.CurState == wpn.FindState('reloadnopocket') && wpn.WeaponStatus[SHOTS_SIDESADDLE] > 0 && !(wpn.WeaponStatus[0] & SLAYF_FROMPOCKETS))
			{
				wpn.WeaponStatus[SHOTS_SIDESADDLE]--;
				wpn.WeaponStatus[SLAYS_CHAMBER1] = 2;
				if (wpn.WeaponStatus[SHOTS_SIDESADDLE] > 0)
				{
					wpn.WeaponStatus[SHOTS_SIDESADDLE]--;
					wpn.WeaponStatus[SLAYS_CHAMBER2] = 2;
				}
				psp.SetState(wpn.FindState('unloadend') + 3);
			}
		}
		else if (wpn is 'ZM66AssaultRifle')
		{
			if (wpn.WeaponStatus[ZM66S_FLAGS] & 2048)
			{
				wpn.DrainHeat(ZM66S_HEAT, 12);
			}
			if (wpn.WeaponStatus[ZM66S_FLAGS] & 4096)
			{
				// [Ace] Technically this should make the condition in brokenround() always false so the gun doesn't jam.
				wpn.WeaponStatus[ZM66S_BORESTRETCHED] = -200;
			}
		}
		else if (wpn is 'HDRL' && psp.CurState == wpn.FindState('Shoot') + 1)
		{
			if (wpn.WeaponStatus[RLS_STATUS] & 8)
			{
				psp.SetState(wpn.FindState('Chamber'));
			}
			if (wpn.WeaponStatus[RLS_STATUS] & 16)
			{
				if (!plr.gunbraced)
				{
					plr.A_MuzzleClimb((0, 0),
					(-frandom(1.2, 1.7), frandom(2, 2.5)) * 0.5,
					(-frandom(1.0, 1.2), frandom(2.5, 3)) * 0.5,
					(-frandom(0.6, 0.8), frandom(2, 3)) * 0.5);
				}
			}
		}
		else if (wpn is 'ThunderBuster')
		{
			if (wpn.WeaponStatus[TBS_FLAGS] & 128)
			{
				wpn.DrainHeat(TBS_HEAT, 12);
			}
			if (wpn.WeaponStatus[TBS_FLAGS] & 256 && wpn.WeaponStatus[TBS_FLAGS] & TBF_ALT)
			{
				if (LastBatteryCharge < wpn.WeaponStatus[TBS_BATTERY])
				{
					LastBatteryCharge = wpn.WeaponStatus[TBS_BATTERY];
				}
				else if (LastBatteryCharge == -1 && wpn.WeaponStatus[TBS_BATTERY] > -1)
				{
					LastBatteryCharge = wpn.WeaponStatus[TBS_BATTERY];
				}
				else if (wpn.WeaponStatus[TBS_BATTERY] < LastBatteryCharge)
				{
					if (!random(0, 2))
					{
						wpn.WeaponStatus[TBS_BATTERY]++;
					}
					LastBatteryCharge = wpn.WeaponStatus[TBS_BATTERY];
				}
			}
		}
		else if (wpn is 'BFG9K')
		{
			if (wpn.WeaponStatus[BFGS_STATUS] & 128)
			{
				// [Ace] First condition is charging, rest is shooting.
				if (psp.CurState == wpn.FindState('Charge') + 1 && psp.tics == 1)
				{
					wpn.WeaponStatus[BFGS_TIMER] += 2;
				}

				if (psp.CurState == wpn.FindState('chargeend') && psp.tics == 1)
				{
					wpn.WeaponStatus[BFGS_TIMER] += 2;
				}
				if (psp.CurState == wpn.FindState('Shoot') + 1)
				{
					wpn.WeaponStatus[BFGS_CRITTIMER] -= 2;
				}
			}
		}
		else if (wpn is 'MagManager')
		{
			let mm = MagManager(wpn);
			if (!(mm.thismag is 'HDBattery') && mm.thismag && wpn.WeaponStatus[0] & 16)
			{
				mm.thismag.inserttime = 1;
				mm.thismag.extracttime = 1;
			}
		}
	}

	// [Ace] The reference may go null, but the number stays the same.
	int PlayerNumber;

	private int LastBatteryCharge;
}