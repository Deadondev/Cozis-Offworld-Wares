class HDUniversalReloader : HDWeapon
{
	// [Ace] Now I'm starting to understand why Matt used an array for WeaponStatus. It allows transferring data between spare weapons. Neat.
	enum RProperty
	{
		RProperty_SelectedRecipe
	}

	enum FAction
	{
		FAction_None,
		FAction_Assemble,
		FAction_Disassemble
	}

	override void BeginPlay()
	{
		Super.BeginPlay();
		
		// [Ace] Note to self: never, for any reason, and no matter the torture, do this atrocity ever again. It may be cleaner, but it's absolutely fucking TRASH.
		// I have to rereate the objects every time I change a number. Do NOT, I repeat, DO NOT FUCKING DO THIS AGAIN. Words cannot describe how mad I am for doing it this way.
		// It also unnecessarily creates a problem when it comes to mod support.
		// I didn't know better at the time.
		// But I wish I did.
		// I really do.
		// Fuck.

		HDRel_Recipe r;
		if (r = HDRel_Recipe.TryCreate("HDPistolAmmo",        "HDRel_RawLead", 2, 1.00,   "HDRel_RawPlastic", 1, 0.75,   "HDRel_RawPowder", 1, 0.50,    1.50)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("HDRevolverAmmo",      "HDRel_RawLead", 2, 1.00,   "HDRel_RawPlastic", 1, 0.70,   "HDRel_RawPowder", 2, 1.25,    1.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("HDShellAmmo",         "HDRel_RawLead", 4, 3.00,   "HDRel_RawPlastic", 2, 1.00,   "HDRel_RawPowder", 1, 0.50,    1.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("FourMilAmmo",         "HDRel_RawLead", 0, 1.00,   null,               0, 0.00,   "HDRel_RawPowder", 0, 1.00,    5.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("SevenMilAmmo",        "HDRel_RawLead", 2, 1.50,   "HDRel_RawBrass",   2, 1.75,   "HDRel_RawPowder", 4, 2.50,    1.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("SevenMilBrass",       null,            0, 0.00,   "HDRel_RawBrass",   0, 1.75,   null,              0, 0.00,    1.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("SevenMilAmmoRecast",  "HDRel_RawLead", 2, 0.75,   "HDRel_RawBrass",  1.0, 0.35,  "HDRel_RawPowder", 4, 2.75,    1.00)) Recipes.Push(r); // Vanilla HD
		if (r = HDRel_Recipe.TryCreate("HD50AEAmmo",          "HDRel_RawLead", 3, 2.25,   "HDRel_RawBrass",   2, 1.25,   "HDRel_RawPowder", 2, 1.25,    0.75)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HD45ACPAmmo",         "HDRel_RawLead", 3, 1.50,   "HDRel_RawBrass",   1, 1.00,   "HDRel_RawPowder", 3, 1.00,    0.75)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HD500SWLightAmmo",    "HDRel_RawLead", 3, 2.25,   "HDRel_RawBrass",   2, 1.25,   "HDRel_RawPowder", 2, 1.00,    0.75)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HD500SWHeavyAmmo",    "HDRel_RawLead", 4, 3.00,   "HDRel_RawBrass",   2, 1.25,   "HDRel_RawPowder", 2, 1.00,    0.75)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HDNDMLoose",          "HDRel_RawLead", 4, 2.75,   "HDRel_RawPlastic", 1, 0.75,   "HDRel_RawPowder", 2, 1.00,    1.00)) Recipes.Push(r); // Peppergrinder
		if (r = HDRel_Recipe.TryCreate("HDAurochsAmmo",       "HDRel_RawLead", 2, 1.75,   "HDRel_RawBrass",   2, 1.25,   "HDRel_RawPowder", 2, 1.00,    1.00)) Recipes.Push(r); // Peppergrinder
		if (r = HDRel_Recipe.TryCreate("HD069BoreAmmo",       "HDRel_RawLead", 4, 2.75,   "HDRel_RawPlastic", 2, 1.5,    "HDRel_RawPowder", 1, 0.50,    1.00)) Recipes.Push(r); // Peppergrinder
		if (r = HDRel_Recipe.TryCreate("HDSlugAmmo",          "HDRel_RawLead", 5, 3.00,   "HDRel_RawPlastic", 1, 0.75,   "HDRel_RawPowder", 2, 1.00,    1.00)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HD50OMGAmmo",         "HDRel_RawLead", 5, 3.80,   "HDRel_RawBrass",   4, 3.00,   "HDRel_RawPowder", 6, 4.00,    0.50)) Recipes.Push(r); // BulletLib
		if (r = HDRel_Recipe.TryCreate("HD50AM_Ammo",         "HDRel_RawLead", 3, 2.25,   "HDRel_RawBrass",   2, 1.25,   "HDRel_RawPowder", 2, 1.00,    0.75)) Recipes.Push(r); // PB's weapon pack
		if (r = HDRel_Recipe.TryCreate("HD5mm_Ammo",          "HDRel_RawLead", 1, 0.25,   "HDRel_RawPlastic", 1, 0.25,   "HDRel_RawPowder", 1, 0.5,     0.75)) Recipes.Push(r); // PB's weapon pack
		if (r = HDRel_Recipe.TryCreate("HD6mmFlechetteAmmo",  "HDRel_RawLead", 0, 1.75,    null,               0, 0.00,   "HDRel_RawPowder", 0, 1.00,    5.00)) Recipes.Push(r); // PB's weapon pack
		if (r = HDRel_Recipe.TryCreate("ThirtyAughtSixAmmo",  "HDRel_RawLead", 3, 2.25,   "HDRel_RawBrass",   2, 1.75,   "HDRel_RawPowder", 4, 2.50,    0.90)) Recipes.Push(r); // .30-06, HexaDoken's Garand
		if (r = HDRel_Recipe.TryCreate("ThirtyAughtSixBrass", null,            0, 0.00,   "HDRel_RawBrass",   0, 1.75,   null,              0, 0.00,    0.90)) Recipes.Push(r); // .30-06, HexaDoken's Garand
		if (r = HDRel_Recipe.TryCreate("HDBallAmmo",          "HDRel_RawLead", 12, 9.85,  "HDRel_RawPlastic", 0, 0,      "HDRel_RawPowder", 0, 0.0,     1.00)) Recipes.Push(r); // .56 Caliber Musket Balls, Offworld Wares
		if (r = HDRel_Recipe.TryCreate("HD10mAmmo",           "HDRel_RawLead", 3, 1.75,   "HDRel_RawBrass",   1, 0.75,   "HDRel_RawPowder", 2, 1.0,     1.00)) Recipes.Push(r); // Rad-Tech Weapon Pack
		if (r = HDRel_Recipe.TryCreate("TenMilBrass",         null,            0, 0.00,   "HDRel_RawBrass",   0, 1.75,   null,              0, 0.00,    0.90)) Recipes.Push(r); // Rad-Tech Weapon Pack
		if (r = HDRel_Recipe.TryCreate("HDFlareAmmo",         null,            0, 0.00,   "HDRel_RawPlastic", 0, 2.00,   "HDRel_RawPowder", 0, 0.50,    0.90)) Recipes.Push(r); // Rad-Tech Weapon Pack
		if (r = HDRel_Recipe.TryCreate("HD45LCAmmo",          "HDRel_RawLead", 3, 1.75,   "HDRel_RawBrass",   1, 1.00,   "HDRel_RawPowder", 3, 1.25,    0.75)) Recipes.Push(r); // Rad-Tech Weapon Pack
		if (r = HDRel_Recipe.TryCreate("HDExplosiveShellAmmo","HDRel_RawLead", 1, 0.75,   "HDRel_RawPlastic", 1, 1.00,   "HDRel_RawPowder", 3, 1.5,     0.75)) Recipes.Push(r); // Rad-Tech Weapon Pack
		if (r = HDRel_Recipe.TryCreate("HD4GSAmmo",           "HDRel_RawLead", 4, 3.50,   "HDRel_RawPlastic", 3, 1.50,   "HDRel_RawPowder", 4, 2.5,     0.75)) Recipes.Push(r); // Khan's 4-Gauge Pack
	}

	override string, double GetPickupSprite() { return "URLDA0", 1.0; }
	override string GetHelpText()
	{
		return WEPHELP_FIRE.."/"..WEPHELP_ALTFIRE.."  Cycle ammo\n"
		..WEPHELP_RELOAD.."  Drop in assemble mode\n"
		..WEPHELP_UNLOAD.."  Drop in disassemble mode";
	}
	override double GunMass() { return 0; }
	override double WeaponBulk() { return 65 * Amount; }
	override bool AddSpareWeapon(actor newowner) { return AddSpareWeaponRegular(newowner); }
	override HDWeapon GetSpareWeapon(actor newowner, bool reverse, bool doselect) { return GetSpareWeaponRegular(newowner, reverse, doselect); }

	override void Tick()
	{
		Super.Tick();

		if (!owner && !IsFrozen() && FactoryAction != FAction_None && !IsBeingPickedUp)
		{
			if (ChargeUp < 360 && vel.length() <= 0.4)
			{
				ChargeUp += 10;
			}
			for (int i = 0; i < ChargeUp; ++i)
			{
				A_SpawnParticle(FactoryAction == FAction_Assemble ? 0x00DDFF : 0x4444FF, SPF_RELATIVE | SPF_FULLBRIGHT, 1, 10, -i, SearchRange, 0, floorz - pos.z, startalphaf: 0.10);
			}			
		}
	}

	override bool OnGrab(Actor other)
	{
		IsBeingPickedUp = true;

		return Super.OnGrab(other);
	}

	override void ActualPickup(actor other, bool silent)
	{
		Super.ActualPickup(other, silent);

		if (!owner)
		{
			return;
		}

		ChugTicker = 0;
		HDRel_Recipe selRecipe = GetSelectedRecipe();
		switch (FactoryAction)
		{
			case FAction_Assemble:
			{
				for (int i = 0; i < MaterialCount; ++i)
				{
					while (LoadedMats[i] > 0)
					{
						LoadedMats[i]--;
						if (owner.A_JumpIfInventory(selRecipe.Materials[i], 0, "null"))
						{
							owner.A_SpawnItemEx(selRecipe.Materials[i], 0, 0, owner.height - 16, 2, 0, 1);
						}
						else
						{
							HDF.Give(owner, selRecipe.Materials[i], 1);
						}
					}
				}
				break;
			}
			case FAction_Disassemble:
			{
				while (LoadedRounds > 0)
				{
					LoadedRounds--;
					if (owner.A_JumpIfInventory(selRecipe.AmmoClass, 0, "null"))
					{
						owner.A_SpawnItemEx(selRecipe.AmmoClass, 0, 0, owner.height - 16, 2, 0, 1);
					}
					else
					{
						HDF.Give(owner, selRecipe.AmmoClass, 1);
					}
				}
				break;
			}
		}
		FactoryAction = FAction_None;
		Active = false;
		IsBeingPickedUp = false;
	}

	protected clearscope HDRel_Recipe GetSelectedRecipe()
	{
		int Size = Recipes.Size();
		int SelIndex = WeaponStatus[RProperty_SelectedRecipe];
		if (Size > 0 && SelIndex < Size)
		{
			return Recipes[SelIndex];
		}

		return null;
	}

	override void DropOneAmmo(int amt)
	{
		if (owner)
		{
			static const int ThrowAngles[] = { 0, 30, -30 };

			double OriginalAngle = owner.Angle;
			let selRecipe = GetSelectedRecipe();

			for (int i = 0; i < MaterialCount; ++i)
			{
				if (owner.CheckInventory(selRecipe.Materials[i], 1))
				{
					owner.Angle = OriginalAngle + ThrowAngles[i];
					owner.A_DropInventory(selRecipe.Materials[i], random(5, 15));
				}
			}
			owner.Angle = OriginalAngle;
		}
	}

	override void DrawHUDStuff(HDStatusBar sb, HDWeapon hdw, HDPlayerPawn hpl)
	{
		vector2 bob = hpl.wepbob * 0.3;
		int BaseYOffset = -182;
		
		sb.DrawImage("URLDA0", (0, BaseYOffset + 68) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, alpha: 1.0, scale:(2, 2));
		let recipe = GetSelectedRecipe();
		if (recipe)
		{
			bool canAssemble = recipe.CanBeAssembled();

			let AmmoClass = GetDefaultByType(recipe.AmmoClass);
			string icon = TexMan.GetName(AmmoClass.Icon);
			string tag = AmmoClass.GetTag();

			sb.DrawImage(icon, (0, BaseYOffset + 4) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, 1.0, (-1, 20), (2.5, 2.5));

			string invAmt = sb.FormatNumber(sb.GetAmount(AmmoClass.GetClass()), 1, 4);
			sb.DrawString(sb.pSmallFont, invAmt, (0, BaseYOffset + 20) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
			sb.DrawString(sb.pSmallFont, tag, (0, BaseYOffset + 28) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_DARKGRAY);
			if (!canAssemble)
			{
				sb.DrawString(sb.pSmallFont, "Cannot be assembled", (0, BaseYOffset + 36) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_RED);
			}

			for (int i = 0; i < MaterialCount; ++i)
			{
				if (!recipe.Materials[i])
				{
					continue;
				}

				let mat = GetDefaultByType(recipe.Materials[i]);
				sb.DrawImage(TexMan.GetName(mat.Icon), (-80 + 80 * i, BaseYOffset + 96) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_ITEM_CENTER, alpha: 1.0, scale: (2.5, 2.5));
				
				string cost = sb.FormatNumber(recipe.Costs[i], 1, 2);
				double amt = recipe.Products[i];
				string prod = String.Format(amt % 1.0 ~== 0 ? "%i" : "%.2F", amt);
				sb.DrawString(sb.pSmallFont, canAssemble ? cost.."/"..prod : prod, (-80 + 80 * i, BaseYOffset + 106) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
				
				sb.DrawString(sb.pSmallFont, "("..sb.GetAmount(mat.GetClass())..")", (-80 + 80 * i, BaseYOffset + 116) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE);
				sb.DrawString(sb.pSmallFont, mat.GetTag(), (-80 + 80 * i, BaseYOffset + 126) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_DARKGRAY, 1.0, 80, 1);
			}
		}
		else
		{
			sb.DrawString(sb.pSmallFont, "No recipe selected.", (0, BaseYOffset + 96) + bob, sb.DI_SCREEN_CENTER_BOTTOM | sb.DI_TEXT_ALIGN_CENTER, Font.CR_GOLD);
		}
	}

	protected virtual int GetChugSpeed(FAction fact, double mult) const
	{
		int BaseSpeed;
		switch (fact)
		{
			default: return 1;
			case FAction_Assemble: BaseSpeed = 5; break;
			case FAction_Disassemble: BaseSpeed = 4; break;
		}

		int ActualSpeed = int(BaseSpeed / mult);
		if (frandom[chugrand](0.01, 1.00) < mult % 1.0)
		{
			ActualSpeed++;
		}

		return max(1, ActualSpeed);
	}

	protected action void A_CheckCycle(int cycleDir)
	{
		int SelIndex = invoker.WeaponStatus[RProperty_SelectedRecipe];
		switch (cycleDir)
		{
			case 1:
				++SelIndex %= invoker.Recipes.Size();
				break;
			case -1:
				SelIndex = SelIndex == 0 ? invoker.Recipes.Size() - 1 : SelIndex - 1;
				break;
		}
		invoker.WeaponStatus[RProperty_SelectedRecipe] = SelIndex;
	}

	protected action bool A_IsBeingTethered(Actor other)
	{
		if (invoker.TractoredBox == other)
		{
			return true;
		}
		for (int i = 0; i < invoker.TractoredRounds.Size(); ++i)
		{
			if (invoker.TractoredRounds[i] && invoker.TractoredRounds[i] == other)
			{
				return true;
			}
		}
		for (int i = 0; i < invoker.TractoredMaterials.Size(); ++i)
		{
			if (invoker.TractoredMaterials[i] && invoker.TractoredMaterials[i] == other)
			{
				return true;
			}
		}
		return false;
	}

	const MaterialCount = 3;

	const SearchRange = HDCONST_ONEMETRE;
	private bool Active;
	private int LoadedMats[MaterialCount];
	private int LoadedRounds;
	protected FAction FactoryAction;
	protected Array<HDRel_Recipe> Recipes; // [Ace] This is never checked for Size() > 0, but it's virtually impossible to abort unless Matt changes all the class names overnight.
	private int ChugTicker;
	private int ChargeUp;
	private bool IsBeingPickedUp;
	private HDRel_CraftingMaterial TractoredMaterials[MaterialCount];
	private HDAmmo TractoredRounds[3];
	private HDUPK TractoredBox;

	Default
	{
		MaxStepHeight 4;
		+WEAPON.WIMPY_WEAPON
		+INVENTORY.INVBAR
		+HDWEAPON.FITSINBACKPACK
		+HDWEAPON.DONTFISTONDROP
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "Picked up a universal reloading device.";
		Scale 0.6;
		HDWeapon.RefId "url";
		Tag "Universal reloading device";
	}

	States
	{
		Spawn:
			URLD A -1 NoDelay A_JumpIf(invoker.FactoryAction > FAction_None, "LookForStuff");
			Stop;
		Select0:
			TNT1 A 0 A_Raise(999);
			Wait;
		Deselect0:
			TNT1 A 0 A_Lower(999);
			Wait;
		Ready:
			TNT1 A 1 A_WeaponReady(WRF_ALLOWRELOAD | WRF_ALLOWUSER3 | WRF_ALLOWUSER4);
			Goto ReadyEnd;
		Fire:
			TNT1 A 5 A_CheckCycle(1);
			Goto Ready;
		AltFire:
			TNT1 A 5 A_CheckCycle(-1);
			Goto Ready;
		Reload:
			TNT1 A 5
			{
				if (invoker.GetSelectedRecipe().CanBeAssembled())
				{
					invoker.ChargeUp = 0;
					invoker.FactoryAction = FAction_Assemble;
					DropInventory(invoker);
				}
			}
			Goto Ready;
		Unload:
			TNT1 A 5
			{
				invoker.ChargeUp = 0;
				invoker.FactoryAction = FAction_Disassemble;
				DropInventory(invoker);
			}
			Goto Ready;
		LookForStuff:
			#### A 1
			{
				if (invoker.Active)
				{
					return ResolveState('Chug');
				}
				if (invoker.ChargeUp < 360)
				{
					return ResolveState(null);
				}

				let selRecipe = invoker.GetSelectedRecipe();
				switch (invoker.FactoryAction)
				{
					case FAction_Assemble:
					{
						BlockThingsIterator it = BlockThingsIterator.Create(self, SearchRange);
						while (it.Next())
						{
							if (!(it.thing is 'HDRel_CraftingMaterial'))
							{
								continue;
							}
							
							for (int i = 0; i < MaterialCount; ++i)
							{
								if (it.thing.GetClass() != selRecipe.Materials[i])
								{
									continue;
								}
								
								let mat = HDRel_CraftingMaterial(it.thing);
								if (invoker.LoadedMats[i] == selRecipe.Costs[i] || invoker.Distance3D(mat) > SearchRange || mat.vel.length() > 0.4 || abs(invoker.pos.z - mat.pos.z) > 0.5)
								{
									continue;
								}

								if (!A_IsBeingTethered(mat) && !invoker.TractoredMaterials[i])
								{
									invoker.TractoredMaterials[i] = mat;
								}
							}
						}
						for (int i = 0; i < invoker.TractoredMaterials.Size(); ++i)
						{
							if (!invoker.TractoredMaterials[i])
							{
								continue;
							}

							double dist = invoker.Distance3D(invoker.TractoredMaterials[i]);
							if (dist <= SearchRange)
							{
								if (dist > 8)
								{
									AceCore.Tether(invoker, invoker.TractoredMaterials[i]);
								}
								else
								{
									int toTake = min(selRecipe.Costs[i] * 3 - invoker.LoadedMats[i], invoker.TractoredMaterials[i].Amount);
									invoker.LoadedMats[i] += toTake;
									invoker.TractoredMaterials[i].Amount -= toTake;
									if (invoker.TractoredMaterials[i].Amount == 0)
									{
										invoker.TractoredMaterials[i].Destroy();
									}
								}
							}
							else
							{
								invoker.TractoredMaterials[i] = null;
							}
						}
						int fullMats = 0;
						for (int i = 0; i < MaterialCount; ++i)
						{
							if (invoker.LoadedMats[i] >= selRecipe.Costs[i])
							{
								fullMats++;
							}
						}
						if (fullMats == 3)
						{
							fullMats = 0;
							invoker.Active = true;
						}
						break;
					}
					case FAction_Disassemble:
					{
						BlockThingsIterator it = BlockThingsIterator.Create(invoker, SearchRange);
						while (it.Next())
						{
							let am = HDAmmo(it.thing);
							let upkp = HDUPK(it.thing);
							if (invoker.Distance3D(it.thing) > SearchRange || it.thing.vel.length() > 0.4 || am && am.GetClass() != selRecipe.AmmoClass || upkp && upkp.pickuptype != selRecipe.AmmoClass || !am && !upkp)
							{
								continue;
							}

							if (upkp && !invoker.TractoredBox)
							{
								invoker.TractoredBox = upkp;
							}
							else if (am && !A_IsBeingTethered(am))
							{
								for (int i = 0; i < invoker.TractoredRounds.Size(); ++i)
								{
									if (!invoker.TractoredRounds[i])
									{
										invoker.TractoredRounds[i] = am;
										break;
									}
								}
							}
						}

						// [Ace] Prioritize boxes.
						if (invoker.TractoredBox)
						{
							double dist = invoker.Distance3D(invoker.TractoredBox);
							if (dist <= SearchRange)
							{
								if (dist > 8)
								{
									AceCore.Tether(invoker, invoker.TractoredBox);
								}
								else
								{
									int toTake = min(5, invoker.TractoredBox.Amount);
									invoker.TractoredBox.Amount -= toTake;
									invoker.LoadedRounds += toTake;
									if (invoker.TractoredBox.Amount == 0)
									{
										invoker.TractoredBox.Destroy();
									}
									invoker.Active = true;
								}
							}
							else
							{
								invoker.TractoredBox = null;
							}
						}
						else for (int i = 0; i < invoker.TractoredRounds.Size(); ++i)
						{
							if (!invoker.TractoredRounds[i])
							{
								continue;
							}

							double dist = invoker.Distance3D(invoker.TractoredRounds[i]);
							if (dist <= SearchRange)
							{
								if (dist > 8)
								{
									AceCore.Tether(invoker, invoker.TractoredRounds[i]);
								}
								else
								{
									int toTake = min(5, invoker.TractoredRounds[i].Amount);
									invoker.TractoredRounds[i].Amount -= toTake;
									invoker.LoadedRounds += toTake;
									if (invoker.TractoredRounds[i].Amount == 0)
									{
										invoker.TractoredRounds[i].Destroy();
									}
									invoker.Active = true;
								}
							}
							else
							{
								invoker.TractoredRounds[i] = null;
							}
						}
						break;
					}
				}
				return ResolveState(null);
			}
			Loop;
		Chug:
			#### A 0
			{
				A_StartSound("roundmaker/chug1", 8);
				A_StartSound("roundmaker/chug2", 9);
				vel.z += frandompick(-0.4, 0.4);
				vel.xy += (frandom(-0.05, 0.05), frandom(-0.05, 0.05));

				if (invoker.ChugTicker++ >= invoker.GetChugSpeed(invoker.FactoryAction, invoker.GetSelectedRecipe().SpeedMult))
				{
					invoker.ChugTicker = 0;
					return ResolveState("Blargh");
				}

				return ResolveState(null);
			}
			#### A 3;
			Loop;
		Blargh:
			#### A 2 //I think this is the delay, was 10 now 2
			{
				A_StartSound("roundmaker/pop", 10);
				HDRel_Recipe selRecipe = invoker.GetSelectedRecipe();
				switch (invoker.FactoryAction)
				{
					case FAction_Assemble:
					{
						for (int i = 0; i < MaterialCount; ++i)
						{
							invoker.LoadedMats[i] -= selRecipe.Costs[i];
						}
						if (random(1, 100) <= 4)
						{
							A_SpawnItemEx("HDExplosion");
							A_Explode(32, 32);
						}
						else
						{
							A_SpawnItemEx(selRecipe.AmmoClass, 0, 0, 0, -0.5, 1, 3, 0, SXF_NOCHECKPOSITION);
						}
						invoker.Active = false;
						break;
					}
					case FAction_Disassemble:
					{
						invoker.LoadedRounds--;
						if (selRecipe.Materials[2] != null && random(1, 100) <= 3)
						{
							A_SpawnItemEx("HDExplosion");
							A_Explode(32, 32);
						}
						else
						{
							for (int i = 0; i < MaterialCount; ++i)
							{
								if (!selRecipe.Materials[i])
								{
									continue;
								}
								Actor a; bool success;
								[success, a] = A_SpawnItemEx(selRecipe.Materials[i], 0, 0, 0, 0.5, 1, 3, 90 * i, SXF_NOCHECKPOSITION);
								Inventory mat = Inventory(a);
								int ActualAmount = int(selRecipe.Products[i]);
								if (frandom[prodrand](0.01, 1.00) < selRecipe.Products[i] % 1.0)
								{
									ActualAmount++;
								}
								mat.Amount = ActualAmount;
							}
						}
						if (invoker.LoadedRounds == 0)
						{
							invoker.Active = false;
						}
						break;
					}
				}
			}
			#### A 0 A_Jump(256, "Spawn");
			Stop;
	}
}

class HDURLSpawner:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
		A_SpawnItemEx("HDUniversalReloader",1,1,flags:SXF_NOCHECKPOSITION);
		if(random[URLRandom](0,10) == 0)
		{
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 1)
		{
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 2)
		{
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 3)
		{
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 4)
		{
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HD45ACPAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 5)
		{
			A_SpawnItemEx("HD50AEBoxPickup",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 6)
		{
			A_SpawnItemEx("HDSlugAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDSlugAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDSlugAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDSlugAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDSlugAmmo",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawLead",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 7)
		{
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPlastic",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 8)
		{
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawBrass",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		if(random[URLRandom](0,10) == 9)
		{
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HDRel_RawPowder",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
		}
		else A_SpawnItemEx("HD_WildLogiBag",frandom(-3,3),frandom(-3,3),flags:SXF_NOCHECKPOSITION);
	    } 
		stop;
    }
}