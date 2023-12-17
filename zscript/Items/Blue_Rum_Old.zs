//-------------------------------------------------
// Blue Rum
//-------------------------------------------------
const HDLD_OLERUM="rum";
const ENC_BLUERUM=12;
//const BOTTLE_MAX=14;

	enum HDBlueRumNums{
	BLUERUM_AMOUNT=1,
	BLUERUM_ALCCONTENT=256,
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
	override string,double getpickupsprite(){return "BTTLD0",1.;}
	override double weaponbulk(){
		return (ENC_BLUERUM*0.7)+(ENC_BLUERUM*0.04)*weaponstatus[BLUERUM_AMOUNT];
	}
	override string gethelptext(){LocalizeHelp();
		return LWPHELP_FIRE..StringTable.Localize("$HEALWH_FIRE")
		..LWPHELP_USE.." + "..LWPHELP_USE..StringTable.Localize("$HEALWH_USE")
		;
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
		patient.GiveInventory("RumDrug",BLUERUM_ALCCONTENT); //BlueRum.BLUERUM_HEALZ
		patient.GiveInventory("UasAlcohol_Offworld_IntoxToken",BLUERUM_ALCCONTENT);
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////
	states(actor){
	spawn:
		TNT1 A 1 nodelay A_JumpIf(weaponstatus[INJECTS_AMOUNT]>0,"jiggling");
		BTTL D 0{
			actor a=null;
			a=spawn("SpentRumBottle",pos,ALLOW_REPLACE);
			a.A_StartSound("potion/open",CHAN_BODY);
			a.angle=angle;a.pitch=pitch;a.target=target;a.vel=vel;

			let aa=spawn("SpentCork",pos,ALLOW_REPLACE);
			aa.angle=angle+3;
			aa.vel=vel+(frandom(-1,1),frandom(-1,1),frandom(0,1));
		}
		stop;
	jiggling:
		BTTL D 2 light("HEALTHPOTION") A_SetTics(random(1,3)); //I guess it would have a light similar to a healthpotion? Debating on this. -Cozi
		loop;
	death:
	BTTL D 0 {A_StartSound("rum/break",CHAN_BODY,CHANF_OVERLAP);
	A_FaceTarget();
	//A_SpawnItemEx("WallChunker",0,0,0,frandom(-1,-15),frandom(-1,1),frandom(-1,1));
	//A_SpawnItemEx("HugeWallChunk",0,0,4,frandom(6,12),0,frandom(-1.5,6)*1,frandom(0,180),SXF_NOCHECKPOSITION);
	//A_SpawnItemEx("BigWallChunk",0,0,4,frandom(7,18),0,frandom(-1.5,7)*1,frandom(0,180),SXF_NOCHECKPOSITION);
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
			A_StartSound("potion/swish",8,CHANF_OVERLAP);
		}
		goto super::select;
	deselect:
		TNT1 A 10{
			if(invoker.weaponstatus[BLUERUM_AMOUNT]<1){
				DropInventory(invoker);
				return;
			}
			A_StartSound("potion/swish",8,CHANF_OVERLAP);
		}
		TNT1 A 0 A_Lower(999);
		wait;
	fire:
		TNT1 A 0{
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
				HDF.Give(self,"UasAlcohol_Offworld_IntoxToken", BLUERUM_ALCCONTENT);
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
				angle,42,pitch,
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
			//HDF.Give(self,"HealingMagic",4);
			HDF.Give(self,"UasAlcohol_Offworld_IntoxToken", 256);
		}stop;
	}
}

class RumDrug:HDDrug{ //This is designed to work in tandem with the Alcohol handler and do what it cannot, This seems terrible to run two at once, so if anyone has any better ideas lmk - Cozi
	enum RumAmounts{
		HDRUM_BLACKOUT=2000,
		HDRUM_BLACKOUTTIME=50,
	}
	int blackout_amount;
	override void DoEffect(){
		let hdp=hdplayerpawn(owner);
		double ret=min(0.1,amount*0.006);
	
		if(hdp.countinv("RumDrug")>RumDrug.HDRUM_BLACKOUT){//Passing out drunk? In my Hideous? More likely than you think...
		hdp.Disarm(hdp);
		hdp.A_SelectWeapon("HDFist");
		hdp.muzzleclimb1+=(0,frandom(8,4));
		hdp.incaptimer+=(3);
		if(hdp.stunned<40)hdp.stunned+=3;
		//if(hdp.fatigue<HDCONST_SPRINTFATIGUE)hdp.fatigue++;
		hdp.beatcap==10; //Slow your heartrate to allow healing.
		// DREAM STUFF
		if(!random[rumbs](0,70)){
				string rumbs[]={"$RUM_BLACKOUT1","$RUM_BLACKOUT2","$RUM_BLACKOUT3","$RUM_BLACKOUT4","$RUM_BLACKOUT5","$RUM_BLACKOUT6","$RUM_BLACKOUT7","$RUM_BLACKOUT8","$RUM_BLACKOUT9","$RUM_BLACKOUT10","$RUM_BLACKOUT11","$RUM_BLACKOUT12","$RUM_BLACKOUT13","$RUM_BLACKOUT14","$RUM_BLACKOUT15"};
				string rumcolor[]={"\cn","\ch","\cq","\ct","\cq","\cp","\cw","\cx"};
				A_Log(Stringtable.Localize(rumcolor[random(0,rumcolor.size()-1)]) ..Stringtable.Localize(rumbs[random(0,rumbs.size()-1)]));
			}
		hdp.AddBlackout(256,2,4,24);
		if(hd_debug>=4)console.printf("Passed out for "..amount);
		
		}
	}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;

		if(hdp.countinv("RumDrug")>RumDrug.HDRUM_BLACKOUT){
		}
		double ret=min(0.15,amount*0.003);
		//this is to help make sure you can actually get up, also a little bit of the potion!
			if(
				hdp.burncount>100
				||hdp.oldwoundcount>65
				||hdp.aggravateddamage>50
			){
				hdp.burncount--;
				hdp.oldwoundcount--;
				hdp.aggravateddamage--;
				amount--;
			}
		if(hdp.strength<1.+ret)hdp.strength+=0.003; //Now, this one allows you to slightly carry more, BUT there's literally nothing else the stim provides in this, nor does being drunk really help you carry anything.

		if(hdp.countinv("HDStim")){
			hdp.A_TakeInventory("HDStim",2); //half the taking bc its dilluted
			amount--;
		}
		
		blackout_amount--;
		amount--;
		}
}


// Alcohol consumable class.

class BlueRum_Alcohol : UaS_Consumable
{
	int intox_per_bulk;
	property IntoxPerbulk : intox_per_bulk;


	int prevbulk;

	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		prevbulk = weaponbulk();
	}
	override void Tick()
	{
		super.tick();
		//weaponstatus[UGCS_SPOILAGE] = 0; // no spoiling

		if(!tracker || !tracker.owner)
			return;
		HDPlayerPawn hdp = HDPlayerPawn(tracker.owner);
		int bulk = prevbulk - weaponbulk();
		if(bulk > 0){
			hdp.GiveInventory("UasAlcohol_Offworld_IntoxToken", intox_per_bulk * bulk);
			hdp.GiveInventory("HealingMagic", 8);
		}
		prevbulk = weaponbulk();
	}
}



class SpentRumBottle:SpentStim{
	default{
		alpha 0.6;renderstyle "translucent";
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
        }stop;
    }
}