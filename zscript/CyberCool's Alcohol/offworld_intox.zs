// Intoxication code from cyb3r_c001's UaS Deus Ex pack.

class UasAlcohol_Offworld_IntoxToken : Inventory
{
	default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 2500; // lasts 3 minutes at max
	}

	const min_effect_amt = 300;
	const max_effect_amt = 2500; // don't raise this or any shader effects higher than they are already
	const txshd_freq = 35; // blur radius change per tick

	const min_sttr_chance = 0.0005; // chance per tick to stutter (random camera angle + pitch shift)
	const max_sttr_chance = 0.035;
	const angle_sttr = 1.05; // maximum angle/pitch shift when stuttering
	const pitch_sttr = 0.85;

	const min_move_chance = 0.0001; // chance per tick to randomly move
	const max_move_chance = 0.04;
	const move_amt = 2.1; // random movement velocity

	const bpinc_min_chance = 0.007; // chance of blood pressure increasing by 1 every tick
	const bpinc_max_chance = 0.07; // chance of blood pressure increasing by 1 every tick
	const bp_max = 180; // maximum blood pressure

	const min_snd_chance = 0.0002; // chance per tick to emit a random sound (grunt/med/taunt)
	const max_snd_chance = 0.001;


	const hp_regen_threshold = 35;
	const hp_regen_min_chance = 0.01; // chance to regenerate 1 point of hp per tick, if below hp regeneration threshold
	const hp_regen_max_chance = 0.055;

	const incap_regen_min = 0; // incap timer reduction per tick (from 1x to 4x speed)
	const incap_regen_max = 3;

	const fatigue_regen_min = 0;
	const fatigue_regen_max = 2; // fatigue reduction per second

	const dmg_fact_min = 1.0;
	const dmg_fact_max = 0.4;

	const melee_dmg_fact_min = 1.35;
	const melee_dmg_fact_max = 3.75;


	const tox_heal_rate_max = 7; // intoxication heal rate, per second
	const tox_heal_rate_min = 3;

	//////////////////////////////////////////////////////////////////

	// Rum Stuff
	const rum_blackout_threshold = 2000;

	// Shader stuff

	int txshd_minr;
	int txshd_maxr;
	int txshd_r;
	int txshd_dir;

	bool intoxsh_enabled;

	void IntoxShader_Enable(PlayerInfo pl)
	{
		Shader.SetUniform1i(pl, "UASAlcohol_Intoxication", "res_w", CVar.getCVar("menu_resolution_custom_width", pl).GetInt());
		Shader.SetUniform1i(pl, "UASAlcohol_Intoxication", "res_h", CVar.getCVar("menu_resolution_custom_height", pl).GetInt());
		Shader.SetEnabled(pl, "UASAlcohol_Intoxication", true);
	}
	void IntoxShader_Disable(PlayerInfo pl)
	{
		Shader.SetEnabled(pl, "UASAlcohol_Intoxication", false);
	}
	void IntoxShader_SetRadius(PlayerInfo pl, int r)
	{
		Shader.SetUniform1i(pl, "UASAlcohol_Intoxication", "radius", r);
	}

	override void Travelled()
	{
		self.amount==0;
	}

	override void Tick()
	{
		super.tick();

		if(!owner || !(owner is "HDPlayerPawn"))
			return;

		double intox_perc = double(self.amount) / max_effect_amt;
		HDPlayerPawn hdp = HDPlayerPawn(owner);

		// ----------------------
		// Intoxication self-cure
		// ----------------------

		if(self.amount > 1 && !(level.time % 35)){
			int tox_heal_rate = tox_heal_rate_min + ceil((tox_heal_rate_max - tox_heal_rate_min) * intox_perc);
			self.amount -= tox_heal_rate;
		}

		// ----------------
		// Negative effects
		// ----------------

		// Looping between min and max blur shader radius

		IntoxShader_SetRadius(owner.player, 1);

		if(!intoxsh_enabled && self.amount >= min_effect_amt)
			IntoxShader_Enable(owner.player);
		else if(intoxsh_enabled && self.amount < min_effect_amt)
			IntoxShader_Disable(owner.player);

		if(txshd_dir == 0)
			txshd_dir = 1;
		txshd_minr = intox_perc * 2;
		txshd_maxr = intox_perc * 7;

		if(level.time % txshd_freq == 0)
			txshd_r += txshd_dir;

		if(txshd_r >= txshd_maxr)
			txshd_dir = -1;
		if(txshd_r <= txshd_minr)
			txshd_dir = 1;
		
		IntoxShader_SetRadius(owner.player, txshd_r);


		// Stuttering and moving

		if(self.amount < min_effect_amt || hdp.Incapacitated>0 || hdp.player.crouchfactor<1) //Crouching and being incapped no longer jitters you around, bc this is simulating difficulty holding balance, if you crouch or lay down, that's mitigated - [Cozi]
			return;

		double sttr_chance = min_sttr_chance + (max_sttr_chance - min_sttr_chance) * intox_perc;
		if(frandom(0.0, 1.0) < sttr_chance){
			owner.angle += frandom(-angle_sttr, angle_sttr);
			owner.pitch += frandom(-pitch_sttr, pitch_sttr);
		}
		double move_chance = min_move_chance + (max_move_chance - min_move_chance) * intox_perc;
		if(frandom(0.0, 1.0) < move_chance){
			owner.A_ChangeVelocity(frandom(-move_amt, move_amt), frandom(-move_amt, move_amt));
		}


		// Blood pressure increase

		double bpinc_chance = bpinc_min_chance + (bpinc_max_chance - bpinc_min_chance) * intox_perc;
		if(hdp.bloodpressure <= bp_max && frandom(0.0, 1.0) < bpinc_chance)
			hdp.bloodpressure++;


		double snd_chance = min_snd_chance + (max_snd_chance - min_snd_chance) * intox_perc;
		if(frandom(0.0, 1.0) < snd_chance)
		{
			int type = frandom(0, 7);
			if(type < 4)
				owner.A_StartSound(hdp.gruntsound);
			else if(type < 7)
				owner.A_StartSound(hdp.medsound);
			else
				owner.A_StartSound(hdp.tauntsound);
		}

		// ----------------
		// Rum Effects
		// ----------------
		if(hd_debug>=4)console.printf("Handler: Drunk at about "..amount);

		if(self.amount>rum_blackout_threshold && !hdp.incapacitated){//Passing out drunk? In my Hideous? More likely than you think...
		hdp.giveInventory("BlackoutDrug", 30);
		}
		// ----------------
		// Positive effects
		// ----------------

		if(hdp.health <= hp_regen_threshold)
		{
			double hp_regen_chance = hp_regen_min_chance + (hp_regen_max_chance - hp_regen_min_chance) * intox_perc;
			if(frandom(0.0, 1.0) < hp_regen_chance)
				hdp.giveInventory("Health", 1);
		}
		if(hdp.incaptimer > 1)
		{
			int incap_regen = incap_regen_min + (incap_regen_max - incap_regen_min) * intox_perc;
			hdp.incaptimer -= incap_regen;
		}
		if(hdp.fatigue > 0 && !(level.time % 35))
		{
			int fatigue_regen = fatigue_regen_min + (fatigue_regen_max - fatigue_regen_min) * intox_perc;
			hdp.fatigue -= fatigue_regen;
		}
	}

	override void ModifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if(passive)
		{
			double intox_perc = double(self.amount) / max_effect_amt;

			double dmgfact = dmg_fact_min - (dmg_fact_min - dmg_fact_max) * intox_perc;
			double newdmg = damage * dmgfact;
			if(newdmg < 1 && damage > 1)
				newdmg = 1.0;
			newDamage = newdmg;
		}
		else if(owner && owner.player.readyWeapon && owner.player.readyWeapon is "HDFist")
		{
			double intox_perc = double(self.amount) / max_effect_amt;

			double melee_dmgfact = melee_dmg_fact_min - (melee_dmg_fact_min - melee_dmg_fact_max) * intox_perc;
			newDamage = damage * melee_dmgfact;
		}
	}
}
