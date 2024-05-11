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
	override string,double getpickupsprite(){return "BTTLD0",1;}
	override double weaponbulk(){
		return (ENC_BLUERUM*0.7)+(ENC_BLUERUM*0.04)*weaponstatus[BLUERUM_AMOUNT];
	}
	override string gethelptext(){LocalizeHelp();
		return LWPHELP_FIRE..StringTable.Localize("$HEALWH_FIRE");
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
		BTTL D 2 light("BLUERUM") A_SetTics(random(1,3)); //I guess it would have a light similar to a healthpotion? Debating on this. -Cozi
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
			booze.vel.x += frandom(-2,2);
			booze.vel.y += frandom[spawnstuff](-2,2);
			booze.vel.z += frandom[spawnstuff](1,2);
			booze.angle += frandom(0,360);
        }stop;
    }
}