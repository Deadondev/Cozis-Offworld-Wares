//-------------------------------------------------
// Blue Rum
//-------------------------------------------------
const HDLD_OLERUM="rum";
const HDLD_MOLOTOV="mol";
const ENC_BLUERUM=12;
const ENC_MOLOTOV=16; //This is basically the math done for HD to keep a molotov equal to a full bottle
//const BOTTLE_MAX=14;

	enum HDBlueRumNums{
	BLUERUM_AMOUNT=1,
	BLUERUM_ALCCONTENT=512, //512
	BLUERUM_HEALZ=8,
	BLUERUM_SPAWN=14,
}

class BlueRum:HDWeapon{
	default{
		//$Category "Items/Hideous Destructor/Magic"
		//$Title "Blue Rum"
		//$Sprite "BTTLD0"

		+inventory.ishealth
		+weapon.wimpy_weapon
		+weapon.no_auto_switch
		+inventory.invbar
		+hdweapon.fitsinbackpack
		weapon.selectionorder 1000;
		inventory.pickupmessage "You got some old rum!";
		inventory.pickupsound "potion/swish";
		tag "$TAG_BLUERUM";
		inventory.icon "BTTLD0";
		hdweapon.refid HDLD_OLERUM;
		scale 0.38;
		+SHOOTABLE; +NOBLOOD;
		health 1;
		damagefactor "melee",0;
		damagefactor "Balefire",0;
		damagefactor "electrical",0;
		damagefactor "hot",0;
		damagefactor "cold",0;
		damagefactor "bashing",0;
	}
	override string,double getpickupsprite(){return "BTTLD0",1;}
	override double weaponbulk(){
		return (ENC_BLUERUM*0.7)+(ENC_BLUERUM*0.04)*weaponstatus[BLUERUM_AMOUNT];
	}
	override string gethelptext(){LocalizeHelp();
		return LWPHELP_FIRE..StringTable.Localize("$HEALWH_FIRE")
		..LWPHELP_ALTFIRE..StringTable.Localize("$HEALWH_ALTFIRE")
		..LWPHELP_RELOAD.."+"..LWPHELP_FIRE.. StringTable.Localize("$RUM_MAKERUM");
	}
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		sb.drawimage(
			"BTTLD0",(-23,-7),
			sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
		);
		sb.drawwepnum(hdw.weaponstatus[BLUERUM_AMOUNT],BLUERUM_SPAWN);
	}
	override int getsbarnum(int flags){
		return weaponstatus[BLUERUM_AMOUNT];
	}
	override void InitializeWepStats(bool idfa){
		weaponstatus[BLUERUM_AMOUNT]=14;
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){
		if(weaponstatus[INJECTS_AMOUNT]<1)doselect=false;
		return GetSpareWeaponRegular(newowner,reverse,doselect);
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	action void A_InjectorInject(actor agent,actor patient){invoker.InjectorInject(agent,patient);}
	virtual void InjectorInject(actor agent,actor patient){

		let hdp=hdplayerpawn(patient);
		if(hdp){
			hdp.A_StartSound("potion/chug",CHAN_VOICE);
			hdp.A_MuzzleClimb((0,-2),(0,0),(0,0),(0,0));
		}
		else patient.A_StartSound("potion/swish",CHAN_VOICE);

		A_InjectorEffect(patient);

	}
	action void A_InjectorEffect(actor patient){invoker.InjectorEffect(patient);}
	virtual void InjectorEffect(actor patient){
		//patient.GiveInventory("RumDrug",BLUERUM_ALCTENT); //BlueRum.BLUERUM_HEALZ
		patient.GiveInventory("UasAlcohol_Offworld_IntoxToken",BLUERUM_ALCCONTENT-owner.height); //BLUERUM_ALCCONTENT HDCONST_PLAYERHEIGHT
	}
	/*override inventory createtossable(){
		let ctt=BlueRum(super.createtossable());
		if(!ctt)return null;
		if(ctt.bmissile){
			spawn("SpentRumBottle",pos,ALLOW_REPLACE);
			//A_StartSound("potion/open",CHAN_BODY);
		}
		return ctt;
	}*/
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	states(actor){
	/*spawn:
		TNT1 A 1 nodelay A_JumpIf(weaponstatus[INJECTS_AMOUNT]>0 && owner.player.crouchfactor>0,"jiggling");
		BTTL D 0{
			if(!weaponstatus[0]&INJECTF_SPENT){
			actor a=null;
			a=spawn("SpentRumBottle",pos,ALLOW_REPLACE);
			a.A_StartSound("potion/open",CHAN_BODY);
			a.angle=angle;a.pitch=pitch;a.target=target;a.vel=vel;

			let aa=spawn("SpentCork",pos,ALLOW_REPLACE);
			aa.angle=angle+3;
			aa.vel=vel+(frandom(-1,1),frandom(-1,1),frandom(0,1));
		}}
		stop;*/
	spawn://jiggling:
		BTTL D 2 light("BLUERUM") A_SetTics(random(1,3));
		BTTL D 0 nodelay {if(self.bmissile){let aa=spawn("SpentRumBottle",pos,ALLOW_REPLACE);aa.vel=vel;aa.angle=angle;self.destroy();}}
		loop;
	death:
	BTTL D 0 {A_StartSound("rum/break",CHAN_BODY,CHANF_OVERLAP);
	A_FaceTarget();
	A_SpawnItemEx("HugeWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,6)*1,frandom(6,12),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("BigWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,7)*1,frandom(7,18),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("HugeWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,6)*1,frandom(6,12),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("BigWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,7)*1,frandom(7,18),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("HugeWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,6)*1,frandom(6,12),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("BigWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,7)*1,frandom(7,18),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("HugeWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,6)*1,frandom(6,12),SXF_NOCHECKPOSITION);
	A_SpawnItemEx("BigWallChunk",0,0,4,frandom(0,-18),0,frandom(-1.5,7)*1,frandom(7,18),SXF_NOCHECKPOSITION);
	}
	stop;
	}
	states{
	select:
		TNT1 A 0{
			if(DoHelpText())A_WeaponMessage(Stringtable.Localize("Some REALLY old aged rum. The alcohol amount would probably kill you if it wasn't watered down with a magical tonic. Drink up!"));
			if(invoker.weaponstatus[BLUERUM_AMOUNT]>0)A_StartSound("potion/swish",8,CHANF_OVERLAP);
		}
		goto super::select;
	deselect:
		TNT1 A 10{
			if(invoker.weaponstatus[BLUERUM_AMOUNT]>0)A_StartSound("potion/swish",8,CHANF_OVERLAP);	
		}
		TNT1 A 0 A_Lower(999);
		wait;
	fire:
		TNT1 A 0{
			A_JumpIf(pressingreload(),"makemolotov");
			let blockinv=HDWoundFixer.CheckCovered(self,CHECKCOV_CHECKFACE);
			if(blockinv){
				A_TakeOffFirst(blockinv.gettag(),2);
				A_Refire("nope");
			}
		}
		TNT1 A 4 A_WeaponReady(WRF_NOFIRE);
		TNT1 A 1{
			A_StartSound("potion/open",CHAN_WEAPON);
			A_Refire();
		}
		TNT1 A 0 A_StartSound("potion/swish",8);
		goto nope;
	hold:
		TNT1 A 1;
		TNT1 A 0{
			A_WeaponBusy();
			let blockinv=HDWoundFixer.CheckCovered(self,CHECKCOV_CHECKFACE);
			if(blockinv){
				A_TakeOffFirst(blockinv.gettag(),2);
				A_Refire("nope");
			}else if(pitch>-55){
				A_MuzzleClimb(0,-8);
				A_Refire();
			}else{
				A_Refire("inject");
			}
		}
		TNT1 A 0 A_StartSound("potion/away",CHAN_WEAPON,volume:0.4);
		goto nope;
	inject:
		TNT1 A 7{
			A_MuzzleClimb(0,-2);
			if(invoker.weaponstatus[BLUERUM_AMOUNT]>0){
				invoker.weaponstatus[BLUERUM_AMOUNT]--;
				A_StartSound("potion/chug",CHAN_VOICE);
				HDF.Give(self,"RumDrug",BLUERUM_ALCCONTENT); //BlueRum.BLUERUM_HEALZ or HealingMagic
				HDF.Give(self,"UasAlcohol_Offworld_IntoxToken", BLUERUM_ALCCONTENT-((self.height-43.2)*21));// 426 BLUERUM_ALCCONTENT self.height *14
				if(hd_debug>=4)console.printf("Handler: You're about "..self.height);
			}
		}
		TNT1 AAAAA 1 A_MuzzleClimb(0,0.5);
		TNT1 A 5 A_JumpIf(!pressingfire(),"injectend");
		goto hold;
	injectend:
		TNT1 A 6;
		TNT1 A 0{
			if(invoker.weaponstatus[BLUERUM_AMOUNT]>0)A_StartSound("potion/away",CHAN_WEAPON,volume:0.4);
		}
		goto nope;
	altfire:
		TNT1 A 10;
		TNT1 A 0 A_Refire();
		goto nope;
	althold:
		TNT1 A 8{
			bool helptext=DoHelpText();
			flinetracedata injectorline;
			linetrace(
				angle,64,pitch, //was 42 but we need some more
				offsetz:gunheight()-2,
				data:injectorline
			);
			let c=HDPlayerPawn(injectorline.hitactor);
			if(!c){
				let ccc=HDHumanoid(injectorline.hitactor);
					invoker.weaponstatus[0]|=INJECTF_SPENT;
					//ccc.stunned=max(0,ccc.stunned>>1);
					return resolvestate("injected");
				if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_NOTHINGTOBEDONE"));
				return resolvestate("nope");
			}
			if(IsMoving.Count(c)>4){
				return resolvestate("nope");
			}

			//and now...
			if(invoker.weaponstatus[BLUERUM_AMOUNT]>0){
			invoker.weaponstatus[BLUERUM_AMOUNT]--;
			A_InjectorInject(self,c);
			}
			return resolvestate("injectend");
		}
		injected:
		TNT1 A 8;
		goto nope;
		reload:
		TNT1 A 1 A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
		TNT1 A 0 A_JumpIf(pressingfire(),"makemolotov");
		TNT1 A 0 A_JumpIf(pressingreload(),"reloadhold");
		goto nope;
		reloadhold:
		TNT1 A 1 A_JumpIf(pressingfire(),"makemolotov");
		TNT1 A 0 A_JumpIf(pressingreload(),"reloadhold");
		goto nope;
		makemolotov:
		TNT1 A 7{
		//A_StartSound("cig/try",CHAN_WEAPON,CHANF_OVERLAP);
		//if(random(0,3))return resolvestate("reloadhold"); //Random chance for your lighter to not light - Cozi
		////////////////////////////////////////////////////
		flinetracedata injectorline;
			linetrace(
				angle,42,pitch,
				offsetz:gunheight()-2,
				data:injectorline
			);
			let c=HDFireCan(injectorline.hitactor);
			if(!c){
				let ccc=HDFireCan(injectorline.hitactor);
				return resolvestate("nope");
			}
		////////////////////////////////////////////////////
		//if(!invoker.countinv("PowerIronFeet")){
		if(!invoker.findinventory("WornRadsuit")){
				A_GiveInventory("Heat",200);
				//damagemobj(invoker,self,100,"hot");
				if(hd_debug){A_Log("\cgYou Idiot!");}
			}
		////////////////////////////////////////////////////
		A_StartSound("potion/swish",CHAN_VOICE);
		invoker.weaponstatus[0]|=INJECTF_SPENT;
		DropInventory(invoker);
		HDF.Give(self,"MolotovAmount", invoker.weaponstatus[BLUERUM_AMOUNT]);
		HDF.Give(self,"MolotovGrenadeAmmo", 1);
		A_SelectWeapon("BlueRumMolotov");
		
		
		int sillyamount;
		sillyamount = 14;//sillyamount = countinv("MolotovAmount");
		if(hd_debug){A_Log("you have " ..sillyamount.. " now!");}
		return resolvestate("nope");
		}
		goto nope;
		}
	}

class BlueRumDummy:IdleDummy{
	hdplayerpawn tg;
	states{
	spawn:
		TNT1 A 6 nodelay{
			tg=HDPlayerPawn(target);
			if(!tg||tg.bkilled){destroy();return;}
			if(tg.countinv("HDZerk")>HDZerk.HDZERK_COOLOFF)tg.aggravateddamage+=int(ceil(accuracy*0.01*random(1,3)));
		}
		TNT1 A 1{
			if(!target||target.bkilled){destroy();return;}
			HDF.Give(self,"UasAlcohol_Offworld_IntoxToken", 256);
		}stop;
	}
}

class RumDrug:HDDrug{ //This is designed to work in tandem with the Alcohol handler and do what it cannot, This seems terrible to run two at once, so if anyone has any better ideas lmk - Cozi
	enum RumAmounts{
		HDRUM_BLACKOUT=2000,
		HDRUM_BLACKOUTTIME=50,
	}
	int healtiming;
	override void DoEffect(){
		let hdp=hdplayerpawn(owner);
		}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;
		
		//Instead of the usual amount loss, we're gonna tie this bitch to the alcohol handler, makes it easier to keep them even. - Cozi
		amount = hdp.countinv("UasAlcohol_Offworld_IntoxToken");
		if(hd_debug>=4)console.printf("Handler: Drunk at about "..amount);

		if(hdp.countinv("HDStim")>HDStim.HDSTIM_MAX){
			hdp.A_TakeInventory("UasAlcohol_Offworld_IntoxToken",10);
		}
		//else{
		//Stumble Code!
		double ret=min(0.15,amount*0.003);
		if(hdp.fatigue>=(20-(amount*0.01))){
			hdp.strength-=(random(1,2));
			if(hd_debug>=1)console.printf("\cfStumbled!");
		} else {
			if(hdp.strength<1.+ret)hdp.strength+=(hdp.countinv("UasAlcohol_Offworld_IntoxToken")*0.0001); //You're gonna be stronger the drunker you are.
		}
		if(hdp.stunned>0){
				hdp.stunned-=(hdp.countinv("UasAlcohol_Offworld_IntoxToken")*0.00001);
				hdp.fatigue+=0.1;
				} //And less stunned!
		
		//Positive Things!
			if(healtiming==8){ //super delay of healing
			hdp.burncount--;
			hdp.aggravateddamage--;
			healtiming = 0;
			} else{healtiming++;}
			hdp.bloodloss--;
		}

	void Travelled(hdplayerpawn hdp)
	{
		hdp.TakeInventory("UasAlcohol_Offworld_IntoxToken",9999);
		amount=0;
	}
}

class BlackoutDrug:HDDrug{
	override void DoEffect(){
		let hdp=hdplayerpawn(owner);
		double ret=min(0.1,amount*0.006);
		//if(hdp.incaptimer<hdp.maxincaptimerstand)hdp.incaptimer++;
		
		//if(amount<250){
		hdp.beatcap==10;
		hdp.Disarm(hdp);
		hdp.A_SelectWeapon("HDIncapWeapon");
		hdp.incapacitated++;
		hdp.incaptimer=10; //This is my hacky "stay down" fix, please don't mess with it - Cozi
		hdp.muzzleclimb1+=(0,frandom(8,4));
		hdp.stunned++;
		hdp.AddBlackout(256,2,4,24);
		// DREAM STUFF
		/*if(!random[rumbs](0,70)){
				string rumbs[]={"$RUM_BLACKOUT1","$RUM_BLACKOUT2","$RUM_BLACKOUT3","$RUM_BLACKOUT4","$RUM_BLACKOUT5","$RUM_BLACKOUT6","$RUM_BLACKOUT7","$RUM_BLACKOUT8","$RUM_BLACKOUT9","$RUM_BLACKOUT10","$RUM_BLACKOUT11","$RUM_BLACKOUT12","$RUM_BLACKOUT13","$RUM_BLACKOUT14","$RUM_BLACKOUT15"};
				string rumcolor[]={"\cn","\ch","\cq","\ct","\cq","\cp","\cw","\cx"};
				A_Log(Stringtable.Localize(rumcolor[random(0,rumcolor.size()-1)]) ..Stringtable.Localize(rumbs[random(0,rumbs.size()-1)]));
			}*/
		}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;
		amount--;
		if(hd_debug>=4)console.printf("Passed out for "..amount); //DEBUG STUFF
		if(hd_debug>=4)console.printf("Intox Token: "..hdp.countinv("UasAlcohol_Offworld_IntoxToken"));
		}
	void Travelled(hdplayerpawn hdp)
	{
		amount=0;
	}
}

// Addiction consumable class.
class RumAddictDrug:HDDrug{
	override void DoEffect(){
		let hdp=hdplayerpawn(owner);
		double ret=min(0.1,amount*0.006);
		}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;
		if(!hdp.countinv("RumDrug")){
		amount--;
		hdp.fatigue+=1;
		hdp.stunned+=2;
		if(hdp.beatcap<30)hdp.beatcap++;
		}
		if(hd_debug>=4)console.printf("Going through withdrawals for "..amount);
		}
	void Travelled(hdplayerpawn hdp)
	{
		amount=0;
	}
}

class SpentRumBottle:SpentStim{
	default{
		//alpha 0.6;renderstyle "translucent";
		bouncesound "rum/break";bouncefactor 0;scale 0.38;
		translation "10:15=241:243","150:151=206:207";
		+shootable; -noteleport; +missile; +solid; -bounceonactors;
		damagetype "slashing"; damage 2;
	}
	override void ondestroy(){
		actor.ondestroy();
	}
	states{
	spawn:
		BTTL D 0;
		goto spawn2;
	xdeath:
	death:
		---- D 0{
			if(frandom(0.1,0.9)<alpha){
				angle+=random(-12,12);pitch=random(45,90);
				actor a=spawn("HDGunSmoke",pos,ALLOW_REPLACE);
				a.scale=(0.4,0.4);a.angle=angle;
			}
			A_SpawnItemEx("HugeWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(6,12),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("BigWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(7,18),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HugeWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(6,12),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("BigWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(7,18),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HugeWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(6,12),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("BigWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(7,18),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("HugeWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(6,12),SXF_NOCHECKPOSITION);
			A_SpawnItemEx("BigWallChunk",0,0,0,frandom(0,-18),frandom(0,-18),0,frandom(7,18),SXF_NOCHECKPOSITION);
		}stop;
	}
}
/*class SpentRumCork:SpentBottle{
	default{
		bouncesound "misc/casing3";scale 0.6;
		translation "224:231=64:71";
	}
	override void ondestroy(){
		plantbit.spawnplants(self,1,0);
		actor.ondestroy();
	}
	states{
	spawn:
		PBRS A 0 nodelay{
			if(Wads.CheckNumForName("freedoom",0)!=-1){
				A_SetTranslation("SquadGhost");
				A_SetRenderStyle(1.,STYLE_Add);
			}
		}
		PBRS A 2 A_SetRoll(roll+90,SPF_INTERPOLATE);
		wait;
	}
}*/

class HD_RumDropper:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
			let booze=BlueRum(spawn("BlueRum",pos,ALLOW_REPLACE));
			booze.weaponstatus[BLUERUM_AMOUNT]=random(1,14);
			booze.vel.x += frandom(-2,2);
			booze.vel.y += frandom[spawnstuff](-2,2);
			booze.vel.z += frandom[spawnstuff](1,2);
			booze.angle += frandom(0,360);
        }stop;
    }
}

//-------------------------------------------------
// Blue Rum Molotov!
//-------------------------------------------------
class BlueRumMolotov:HDGrenadethrower{
	int fuze;
	override void AttachToOwner(Actor other)
{
    super.AttachToOwner(other);
    // This block is only run if the item got
    // successfully placed in the other's
    // inventory:
    if (owner)
    {
        while(countinv("MolotovAmount")){weaponstatus[FRAGS_TIMER]++;A_TakeInventory("MolotovAmount",1,TIF_NOTAKEINFINITE);}
    }
}
	void TossGrenade(bool oshit=false){
		if(!owner)return;
		int garbage;actor ggg;
		double cpp=cos(owner.pitch);
		double spp=sin(owner.pitch);

		//create the spoon
		if(!(weaponstatus[0]&FRAGF_SPOONOFF)){
			[garbage,ggg]=owner.A_SpawnItemEx(
				spoontype,cpp*-4,-3,owner.height*0.88-spp*-4,
				cpp*3,0,-sin(owner.pitch+random(10,20))*3,
				frandom(33,45),SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
			);
			ggg.vel+=owner.vel;
		}

		//create the grenade
		[garbage,ggg]=owner.A_SpawnItemEx("MolotovGrenade",
			0,0,owner.height*0.88,
			cpp*4,
			0,
			-spp*4,
			0,SXF_NOCHECKPOSITION|SXF_TRANSFERPITCH
		);
		ggg.vel+=owner.vel;

		//force calculation
		double gforce=clamp(weaponstatus[FRAGS_FORCE]*0.5,1,40+owner.health*0.1);
		if(oshit)gforce=min(gforce,frandom(4,20));
		if(hdplayerpawn(owner))gforce*=hdplayerpawn(owner).strength;

		let grenade=HDFragGrenade(ggg);if(!grenade)return;
		grenade.fuze=weaponstatus[FRAGS_TIMER];

		if(owner.player){
			grenade.vel+=SwingThrow()*gforce;
		}
		grenade.a_changevelocity(
			cpp*gforce*0.6,
			0,
			-spp*gforce*0.6,
			CVF_RELATIVE
		);
		weaponstatus[FRAGS_FORCE]=0;
		weaponstatus[0]&=~FRAGF_PINOUT;
		weaponstatus[0]&=~FRAGF_SPOONOFF;
		weaponstatus[FRAGS_REALLYPULL]=0;

		weaponstatus[0]&=~FRAGF_INHAND;
		weaponstatus[0]|=FRAGF_JUSTTHREW;
		while(countinv("MolotovAmount"))A_TakeInventory("MolotovAmount",1,TIF_NOTAKEINFINITE);
	}
	default{
		weapon.selectionorder 1010;
		weapon.slotpriority 1.1;
		weapon.slotnumber 0;
		tag "Molotov";
		hdgrenadethrower.ammotype "MolotovGrenadeAmmo";
		hdgrenadethrower.throwtype "MolotovGrenade";
		hdgrenadethrower.spoontype "SpentCork";
		hdgrenadethrower.wiretype "MolotovTripwire";
		hdgrenadethrower.pinsound "weapons/fragpinout";
		hdgrenadethrower.spoonsound "weapons/fragspoonoff";
		inventory.icon "BTTLG0";
	}

	override string gethelptext(){
		if(weaponstatus[0]&FRAGF_SPOONOFF)return
		WEPHELP_FIRE.."  Wind up, release to throw\n(\cxSTOP READING AND DO THIS"..WEPHELP_RGCOL..")";
		return
		WEPHELP_FIRE.."  Light cloth/wind up (release to throw)\n"
		//..WEPHELP_ALTFIRE.."  Pull pin, again to drop spoon\n"
		..WEPHELP_RELOAD.."  Abort/put out flame\n"
		..WEPHELP_ZOOM.."  Start planting tripwire traps"
		;
	}

override void DoEffect(){
		if(weaponstatus[0]&FRAGF_SPOONOFF && owner.health<1){
			TossGrenade(true);
		}else if(
			weaponstatus[0]&FRAGF_INHAND
			&&weaponstatus[0]&FRAGF_PINOUT
			&&owner.player.cmd.buttons&BT_ATTACK
			&&owner.player.cmd.buttons&BT_ALTFIRE
			&&!(owner.player.oldbuttons&BT_ALTFIRE)
		){
			return;
		}
		super.doeffect();
	}
	
	override string,double getpickupsprite(){return "BTTLG0",0.6;}
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		if(sb.hudlevel==1){
			sb.drawimage(
				(weaponstatus[0]&FRAGF_PINOUT)?"BTTLG0":"BTTLG0",
				(-52,-4),sb.DI_SCREEN_CENTER_BOTTOM,scale:(0.6,0.6)
			);
			sb.drawnum(hpl.countinv("MolotovGrenadeAmmo"),-45,-8,sb.DI_SCREEN_CENTER_BOTTOM);
			//sb.drawnum(hdw.weaponstatus[FRAGS_TIMER],-45,-16,sb.DI_SCREEN_CENTER_BOTTOM);
		}
		sb.drawwepnum(
			hpl.countinv("MolotovGrenadeAmmo"),
			(HDCONST_MAXPOCKETSPACE/ENC_FRAG)
		);
		sb.drawwepnum(hdw.weaponstatus[FRAGS_FORCE],50,posy:-10,alwaysprecise:true);
		if(!(hdw.weaponstatus[0]&FRAGF_SPOONOFF)){
			sb.drawrect(-21,-19,5,4);
			if(!(hdw.weaponstatus[0]&FRAGF_PINOUT))sb.drawrect(-25,-18,3,2);
		}
	}
	
	override void ForceBasicAmmo(){
		owner.A_SetInventory("MolotovGrenadeAmmo",1);
	}
	
	states
	{
	//spawn(actor):
	//TNT1 A 1 {self.fuze=master.weaponstatus[BLUERUM_AMOUNT];}
	ready:
		FRGG B 0{
			invoker.weaponstatus[FRAGS_FORCE]=0;
			invoker.weaponstatus[FRAGS_REALLYPULL]=0;
		}
		FRGG B 1 A_WeaponReady(WRF_NOSECONDARY|WRF_ALLOWRELOAD|WRF_ALLOWZOOM|WRF_ALLOWUSER1|WRF_ALLOWUSER2|WRF_ALLOWUSER3|WRF_ALLOWUSER4);
		goto ready3;
	deselectinstant:
		TNT1 A -1 A_TakeInventory("BlueRumMolotov", 1);
		stop;
	startpull:
		FRGG B 1{
			if(invoker.weaponstatus[FRAGS_REALLYPULL]>=26)setweaponstate("endpull");
			else invoker.weaponstatus[FRAGS_REALLYPULL]++;
		}
		FRGG B 0 A_Refire();
		goto ready;
	endpull:
		FRGG B 1 offset(0,34);
		TNT1 A 0;
		TNT1 A 0 A_PullPin();
		TNT1 A 0 A_Refire();
		goto ready;
	fire:
		TNT1 A 0 A_JumpIf(invoker.weaponstatus[0]&FRAGF_JUSTTHREW,"nope");
		TNT1 A 0 A_JumpIf(NoFrags(),"selectinstant");
		TNT1 A 0 A_JumpIfInventory("PowerStrength",1,3);
		FRGG B 1 offset(0,34);
		FRGG B 1 offset(0,36);
		FRGG B 1 offset(0,38);
		TNT1 A 0 A_Refire();
		goto ready;
	hold:
		TNT1 A 0 A_JumpIf(invoker.weaponstatus[0]&FRAGF_JUSTTHREW,"nope");
		//TNT1 A 0 A_JumpIf(invoker.weaponstatus[0]&FRAGF_PINOUT,"hold2");
		TNT1 A 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=1,"hold2");
		TNT1 A 0 A_JumpIfInventory("PowerStrength",1,1);
		TNT1 A 0 A_JumpIf(NoFrags(),"selectinstant");
		TNT1 A 3 A_PullPin();
	hold2:
		TNT1 A 0 A_JumpIf(NoFrags(),"selectinstant");
		FRGG E 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=40,"hold3a");
		FRGG D 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=30,"hold3a");
		FRGG C 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=20,"hold3");
		FRGG B 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=10,"hold3");
		goto hold3;
	hold3a:
		FRGG # 0{
			if(invoker.weaponstatus[FRAGS_FORCE]<50)invoker.weaponstatus[FRAGS_FORCE]++;
		}
	hold3:
		FRGG # 1{
			A_WeaponReady(
				invoker.weaponstatus[0]&FRAGF_SPOONOFF?WRF_NOFIRE:WRF_NOFIRE|WRF_ALLOWRELOAD
			);
			if(invoker.weaponstatus[FRAGS_FORCE]<50)invoker.weaponstatus[FRAGS_FORCE]++;
		}
		TNT1 A 0 A_Refire();
		goto throw;
	throw:
		TNT1 A 0 A_JumpIf(NoFrags(),"selectinstant");
		FRGG A 1 offset(0,34) A_TossGrenade();
		FRGG A 1 offset(0,38);
		FRGG A 1 offset(0,48);
		FRGG A 1 offset(0,52);
		FRGG A 0 A_Refire();
		goto ready;
		reload:
		TNT1 A 0 A_JumpIf(NoFrags(),"selectinstant");
		TNT1 A 0 A_JumpIf(invoker.weaponstatus[FRAGS_FORCE]>=1,"pinbackin");
		TNT1 A 0 A_JumpIf(invoker.weaponstatus[0]&FRAGF_PINOUT,"altpinbackin");
		goto ready;
	pinbackin:
		FRGG B 1 offset(0,34) A_ReturnHandToOwner();
		FRGG B 1 offset(0,36);
		FRGG B 1 offset(0,38);
	altpinbackin:
		FRGG A 0 A_JumpIf(invoker.weaponstatus[FRAGS_TIMER]>0,"juststopthrowing");
		TNT1 A 1 A_ReturnHandToOwner();
		TNT1 A 0 A_Refire("nope");
		FRGG B 1 offset(0,38);
		FRGG B 1 offset(0,36);
		FRGG B 1 offset(0,34);
		goto ready;
	}
}

class MolotovTripwire:Tripwire{
	default{
		weapon.selectionorder 1011;
		tripwire.ammotype "MolotovGrenadeAmmo";
		tripwire.throwtype "MolotovTrippingFrag";
		tripwire.spoontype "SpentCork";
		tripwire.weptype "BlueRumMolotov";
	}
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		if(sb.hudlevel==1){
			sb.drawimage("BTTLG0",(-52,-4),sb.DI_SCREEN_CENTER_BOTTOM,scale:(0.6,0.6));
			sb.drawnum(hpl.countinv("MolotovGrenadeAmmo"),-45,-8,sb.DI_SCREEN_CENTER_BOTTOM);
		}
		sb.drawwepnum(
			hpl.countinv("MolotovGrenadeAmmo"),
			(ENC_FRAG/HDCONST_MAXPOCKETSPACE)
		);
		sb.drawwepnum(hdw.weaponstatus[FRAGS_FORCE],50,posy:-10,alwaysprecise:true);
		if(!(hdw.weaponstatus[0]&FRAGF_SPOONOFF)){
			sb.drawrect(-21,-19,5,4);
			if(!(hdw.weaponstatus[0]&FRAGF_PINOUT))sb.drawrect(-25,-18,3,2);
		}
	}
}

class MolotovTrippingFrag:TrippingGrenade{
	default{
		//$Category "Misc/Hideous Destructor/Traps"
		//$Title "Tripwire Grenade"
		//$Sprite "FRAGA0"

		scale 0.38;
		trippinggrenade.rollertype "MolotovGrenadeRoller";
		trippinggrenade.spoontype "SpentCork";
		trippinggrenade.droptype "MolotovGrenadeAmmo";
		hdupk.pickuptype "MolotovGrenadeAmmo";
	}
	override void postbeginplay(){
		super.postbeginplay();
		pickupmessage=getdefaultbytype("MolotovGrenadeAmmo").pickupmessage();
	}
	states{
	spawn:
		BTTL G 1 nodelay A_TrackStuckHeight();
		wait;
	}
}
class MolotovGrenadeRoller:HDFragGrenadeRoller{
	//int fuze; //For some reason this stops the game from thinking I need this to go up as it travels, no idea why the fuck that would happen but ok.
	int rollerfuze;
	int amountleft;
	vector3 keeprolling;
	default{
		-noextremedeath -floorclip +shootable +noblood +forcexybillboard
		+activatemcross -noteleport +noblockmonst +explodeonwater
		+missile +bounceonactors +usebouncestate
		+rollsprite; +rollcenter;
			bouncetype "doom";bouncesound "misc/fragknock";
		radius 4;height 4;damagetype "none";
		scale 0.38;
		obituary "%o was molotov'd by %k.";
		radiusdamagefactor 0.04;pushfactor 1.4;maxstepheight 2;mass 30;
		health 1;
	}
	override bool used(actor user){
		angle=user.angle;
		A_StartSound(bouncesound);
		if(hdplayerpawn(user)&&hdplayerpawn(user).incapacitated)A_ChangeVelocity(4,0,1,CVF_RELATIVE);
		else A_ChangeVelocity(12,0,4,CVF_RELATIVE);
		return true;
	}
	states{
	spawn:
		BTTL G 2 {A_SetRoll(roll+60,SPF_INTERPOLATE);A_SpawnItemEx("HDFlameRed",frandom(-0.1,0.1),frandom(-0.1,0.1),8,frandom(-5,5),frandom(-5,5),0,frandom(0,360));}
		Loop;
	spawn2:
	bounce:
	death:
	destroy:
		TNT1 A 1{
			rollerfuze=14; //this may change if i ever make molotovs creatable, we'll see. -[Cozi]
			bsolid=false;bpushable=false;bmissile=false;bnointeraction=true;bshootable=false;
			A_StartSound("world/explode",CHAN_AUTO);
			A_AlertMonsters();
			actor xpl=spawn("WallChunker",self.pos-(0,0,1),ALLOW_REPLACE);
				xpl.target=target;xpl.master=master;xpl.stamina=stamina;
			xpl=spawn("HDExplosion",self.pos-(0,0,1),ALLOW_REPLACE);
				xpl.target=target;xpl.master=master;xpl.stamina=stamina;
			if(hd_debug){A_Log("The roller fuze was " ..rollerfuze.. "");} //debug message
			while(rollerfuze>=4){A_SpawnItemEx("MolotovFlame",frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(-10,10),frandom(-10,10),0,frandom(0,360));rollerfuze-=4;}
		}
		stop;
	}
	override void tick(){
		if(isfrozen())return;
		else if(bnointeraction){
			NextTic();
			return;
		}else super.tick();
	}
}
class MolotovGrenade:HDFragGrenade{
	int amountleft;
	vector3 keeprolling;
	class<actor> rollertype;
	property rollertype:rollertype;
	default{
		-noextremedeath -floorclip +bloodlessimpact
		+shootable -noblockmap +noblood
		+activatemcross -noteleport;
		+rollsprite; +rollcenter;
		radius 5;height 5;damagetype "none";
		scale 0.38;
		obituary "%o was molotov'd by %k.";
		mass 1500;
		health 1;
		MolotovGrenade.rollertype "MolotovGrenadeRoller";
	}
	static void FragBlast(HDActor caller){
		distantnoise.make(caller,"world/rocketfar");
		DistantQuaker.Quake(caller,4,35,512,10);
		caller.A_StartSound("world/explode",CHAN_BODY,CHANF_OVERLAP);
		caller.A_AlertMonsters();
		caller.A_SpawnChunksFrags();
		caller.A_HDBlast(
			pushradius:256,pushamount:128,fullpushradius:96,
			fragradius:HDCONST_ONEMETRE*12
		);
	}
	override void tick(){
		ClearInterpolation();
		if(isfrozen())return;
		if(!bmissile){
			hdactor.tick();return;
		}else{
			if(inthesky){
				FragBlast(self);
				destroy();return;
			}
			let gr=MolotovGrenadeRoller(spawn("MolotovGrenadeRoller",pos,ALLOW_REPLACE));
			gr.target=self.target;gr.master=self.master;gr.vel=self.vel;
			gr.rollerfuze=fuze;
			if(hd_debug){A_Log("The fuze being created is " ..gr.rollerfuze.. " from " ..fuze.. "");} //debug message
			destroy();return;
		}
	}
	override void postbeginplay(){
		hdactor.postbeginplay();
		divrad=1./(radius*1.9);
		grav=getgravity();
		if(hd_debug){A_Log("non-roller is " ..fuze.. "");}
	}
	states{
	spawn:
		BTTL G 2 {A_SetRoll(roll+60,SPF_INTERPOLATE);}
		loop;
	death:
		TNT1 A 10{
			bmissile=false;
			let gr=HDFragGrenadeRoller(spawn(rollertype,self.pos,ALLOW_REPLACE));
			if(!gr)return;
			gr.target=self.target;gr.master=self.master;
			gr.fuze=self.fuze;
			gr.vel=self.keeprolling;
			gr.keeprolling=self.keeprolling;
			gr.A_StartSound("misc/fragknock",CHAN_BODY);
			HDMobAI.Frighten(gr,512);
		}stop;
	}
}
class MolotovGrenadeAmmo:HDAmmo{
	int fuze;
	default{
		//+forcexybillboard
		inventory.icon "BTTLGA0";
		inventory.amount 1;
		scale 0.38;
		inventory.maxamount 50;
		inventory.pickupmessage "Picked up a Molotov.";
		inventory.pickupsound "weapons/pocket";
		tag "Molotov";
		hdpickup.bulk ENC_MOLOTOV;
		hdpickup.refid HDLD_MOLOTOV;
		+INVENTORY.KEEPDEPLETED
	}
	override bool IsUsed(){return true;}
	override void AttachToOwner(Actor user)
	{
		user.GiveInventory("BlueRumMolotov", 1);
		super.AttachToOwner(user);
	}
	override void DetachFromOwner()
	{
		if(!(owner.player.ReadyWeapon is "BlueRumMolotov"))
		{
			TakeInventory("BlueRumMolotov", 1);
		}
		super.DetachFromOwner();
	}
	states{
	spawn:
		BTTL G -1;stop;
	}
}

/*class MolotovP:HDUPK{
	int fuze;
	default{
		//+forcexybillboard
		scale 0.3;height 3;radius 3;
		hdupk.amount 1;
		hdupk.pickuptype "MolotovGrenadeAmmo";
		hdupk.pickupmessage "Picked up a Molotov.";
		hdupk.pickupsound "weapons/rifleclick2";
		stamina 1;
	}
	override void postbeginplay(){
		super.postbeginplay();
		pickupmessage=getdefaultbytype("MolotovGrenadeAmmo").pickupmessage();
	}
	states{
	spawn:
		BTTL G -1;
	}
}

class MolotovGrenadePickup:MolotovP{
	override void postbeginplay(){
		super.postbeginplay();
		A_SpawnItemEx("MolotovP",5,5,flags:SXF_NOCHECKPOSITION);
		A_SpawnItemEx("MolotovP",5,0,flags:SXF_NOCHECKPOSITION);
		A_SpawnItemEx("MolotovP",0,5,flags:SXF_NOCHECKPOSITION);
		A_SpawnItemEx("MolotovP",-5,5,flags:SXF_NOCHECKPOSITION);
		A_SpawnItemEx("MolotovP",-5,0,flags:SXF_NOCHECKPOSITION);
	}
}*/

class MolotovFlame:HDActor{
	int burntiming;
	default{
		//+nointeraction
		+bright
		-nogravity;
		renderstyle "add";
		height 0;radius 0;
		damagetype "hot";
		gravity 1;
	}
	states{
	spawn:
		FIRE A 2 light("HELL");
		FIRE B 2 A_StartSound("misc/firecrkl",CHAN_BODY,CHANF_OVERLAP,volume:0.4,attenuation:6.); //A_StartSound("vile/firecrkl",CHAN_VOICE);
		FIRE AB random(1,2) light("HELL"); //ABABCDCDEDEF
		FIRE GHGHGHGH 3 light("HELL") {
			if(burntiming<120){
				A_HDBlast(128,blastdamage:66,16,"hot",immolateradius:64,immolateamount:random(6,12),immolatechance:42,true);
				//A_RadiusGive("Heat",64,RGF_KILLED,20);
				HDMobAI.Frighten(self,512);
				A_SpawnItemEx("HDFlameRed",frandom(-0.1,0.1),frandom(-0.1,0.1),8,frandom(-5,5),frandom(-5,5),0,frandom(0,360));
				SetState(FindState("spawn"));
				burntiming++;}}
		//goto death;
	death:
		FIRE FGFGH 2 light("HELL");
		FIRE GHFGHGHGH 2 A_FadeOut(0.12);
		stop;
	}
}

class MolotovAmount : Inventory
{
	default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 14;
	}
}