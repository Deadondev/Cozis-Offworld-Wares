const HDLD_CIGARETTE="cig";
const HDLD_CIGARETTEPACK= "cpk"; //Yes, this name sucks. I know. -Cozi
const ENC_CIGARETTE=1; //Stims are 7
const ENC_CIGARETTEPACK=5; //this is so theres a good reason to keep the pack as is, 20 cigs outside of it should be shittier than it unopened
//-------------------------------------------------
// Pack of Cigarettes
//-------------------------------------------------
enum CigPack{
		HDCIGPACK_AMOUNT=0,
	}
class CigarettePack:HDWeapon{
	class<inventory> inventorytype;
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Pack of Cigarettes"
		//$Sprite "CIGPA0"

		+weapon.wimpy_weapon
		+inventory.invbar
		+hdweapon.fitsinbackpack
		inventory.pickupsound "misc/w_pkup";
		inventory.pickupmessage "Picked up a pack of cigs.";
		inventory.icon "CIGPA0";
		scale 0.4;
		hdweapon.refid HDLD_CIGARETTEPACK;
		tag "Heartstopper Cigarette Pack";
	}
	override double gunmass(){return 0;}
	override double weaponbulk(){
		return (ENC_CIGARETTEPACK);
	}
	override void PostBeginPlay(){
		weaponstatus[HDCIGPACK_AMOUNT]=random(1,20);
	}
	override void InitializeWepStats(bool idfa){
		weaponstatus[HDCIGPACK_AMOUNT]=20;
	}
	override int getsbarnum(int flags){
		return weaponstatus[HDCIGPACK_AMOUNT];
	}
		override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		vector2 bob=hpl.wepbob*0.3;
		int cigarettesleft=weaponstatus[HDCIGPACK_AMOUNT];
		sb.drawimage("CIGPA0",(0,-64)+bob,
			sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER,
			alpha:255,scale:(2.5,2.5)
		);
		sb.drawstring(
			sb.psmallfont,""..cigarettesleft,(0,-108)+bob,
			sb.DI_TEXT_ALIGN_CENTER|sb.DI_SCREEN_CENTER_BOTTOM,
			cigarettesleft?Font.CR_GRAY:Font.CR_DARKGRAY,alpha:255
		);
	}
	override string gethelptext(){
		return
		WEPHELP_FIRE.."  Pull out a cigarette\n"
		..WEPHELP_ALTFIRE.."  Put back a cigarette";
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){return GetSpareWeaponRegular(newowner,reverse,doselect);}
	states{
	spawn:
		CIGP A -1;
		wait;
	select0:
		TNT1 A 0 A_Raise(999);
		wait;
	ready:
		TNT1 A 1 A_WeaponReady(WRF_ALLOWUSER3|WRF_ALLOWUSER4);
		goto readyend;
	deselect0:
		TNT1 A 0 A_Lower(999);
		wait;
	fire:
		TNT1 A 0{
			if(invoker.weaponstatus[HDCIGPACK_AMOUNT]==0){
				A_StartSound("weapons/pocket",9);
				A_Log("No cigarettes are in the box!");
				/*actor a=spawn("EmptyCigarettePack",pos,ALLOW_REPLACE);
				a.target=invoker;
				a.angle=invoker.angle;a.vel=invoker.vel;a.A_ChangeVelocity(-2,1,4,CVF_RELATIVE);
				a.A_StartSound("weapons/grenopen",CHAN_VOICE);*/
			}
			if(invoker.weaponstatus[HDCIGPACK_AMOUNT]>=1){
				let mdk=HDWeapon(spawn("Cigarette",pos));
				mdk.actualpickup(self,true);
				invoker.weaponstatus[HDCIGPACK_AMOUNT]--;
				A_StartSound("weapons/pocket",9);
				A_Log("There are " ..invoker.weaponstatus[HDCIGPACK_AMOUNT].. " left in the box");
			}
		}
		TNT1 A 10;
		goto ready;
	altfire:
		TNT1 A 0{
			if(invoker.weaponstatus[HDCIGPACK_AMOUNT]==20){
				A_StartSound("weapons/pocket",9);
				A_Log("The box is full!");
				resolvestate("nope");
			}
			if(countinv("Cigarette")<1){
				A_Log("No cigarettes to put away!");
				resolvestate("nope");
			} else {
				let iii=HDWeapon(findinventory("Cigarette"));
			if(!!iii){
				iii.weaponstatus[0]|=INJECTF_SPENT;
				DropInventory(iii,1);
				invoker.weaponstatus[HDCIGPACK_AMOUNT]++;
				A_StartSound("weapons/pocket",9);
			}
			}
		}
		TNT1 A 10;
		goto ready;
	}
}

class Cigarette:HDWeapon{
	string mainhelptext;property mainhelptext:mainhelptext;
	class<actor> spentinjecttype;property spentinjecttype:spentinjecttype;
	class<actor> injecttype;property injecttype:injecttype;

	override string gethelptext(){LocalizeHelp();return LWPHELP_INJECTOR;}
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		sb.drawimage(
			texman.getname(icon),(-23,-7),
			sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
		);
	}
	override double weaponbulk(){
		return ENC_CIGARETTE;
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){
		if(weaponstatus[0]&INJECTF_SPENT)doselect=false;
		return GetSpareWeaponRegular(newowner,reverse,doselect);
	}
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Cigarettes"
		//$Sprite "CIGAA0"

		scale 0.3;
		inventory.pickupmessage "Picked up a Cigarette.";
		inventory.icon "CIGAA0";
		tag "$TAG_CIGARETTE";
		hdweapon.refid HDLD_CIGARETTE;
		+inventory.invbar
		+weapon.wimpy_weapon
		+weapon.no_auto_switch
		+hdweapon.fitsinbackpack
		inventory.pickupSound "weapons/pocket";

		weapon.selectionorder 1004;

		cigarette.mainhelptext "\cr*** \caHEARTSTOPPER CIGARETTES \cr***\c-\n\n\nCigarettes help lower your heart rate, \crwatch out for aggro!.\n\n\Please don't smoke IRL.";
		cigarette.spentinjecttype "BurntCig";
		cigarette.injecttype "CigaretteDrug";
	}
	states(actor){
	spawn:
		TNT1 A 1; //DO NOT REMOVE DELAY
		TNT1 A 0{
			if(weaponstatus[0]&INJECTF_SPENT){
				resolvestate("death");
			}else setstatelabel("spawn2");
		}
		stop;
	spawn2:
		CIGA A 0;
		stop;
	death:
	TNT1 A 0;
	stop;
	}

	states{
	select:
		TNT1 A 8{
			if(DoHelpText())A_WeaponMessage(Stringtable.Localize(invoker.mainhelptext));
			A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
		}
		goto super::select;
	deselect:
		TNT1 A 0{
			if(invoker.weaponstatus[0]&INJECTF_SPENT){
				DropInventory(invoker);
				return;
			}
		}
		TNT1 A 5 A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
		TNT1 A 0 A_Lower(999);
		wait;
	ready:
		TNT1 A 0{
			if(invoker.weaponstatus[0]&INJECTF_SPENT)DropInventory(invoker);
		}
		goto super::ready;
	fire:
	hold:
		TNT1 A 1;
		TNT1 A 0{
			if(invoker.weaponstatus[0]&INJECTF_SPENT){
				return resolvestate("nope");
			}
			if(invoker.countinv("CigaretteDrug")){
				A_WeaponMessage("\cgYou're already smoking!",100);
				return resolvestate(null);
			}
			if(invoker.countinv("Heat")){
			A_WeaponMessage("\cgYou can't smoke in a radsuit!",100);
				return resolvestate(null);
			}
			if(hdplayerpawn(self))hdplayerpawn(self).gunbraced=false;
			let blockinv=HDWoundFixer.CheckCovered(self,CHECKCOV_ONLYFULL);
			if(blockinv){
				A_TakeOffFirst(blockinv.gettag(),2);
				return resolvestate("nope");
			}
			if(pitch<55){
				A_MuzzleClimb(0,8);
				A_Refire();
				return resolvestate(null);
			}
			A_StartSound("cig/try",CHAN_WEAPON,CHANF_OVERLAP);
			if(random(0,3))return resolvestate("nope"); //Random chance for your lighter to not light - Cozi
			return resolvestate("inject");
			
		}goto nope;
	inject:
		TNT1 A 1{
			A_MuzzleClimb(0,2);
			invoker.weaponstatus[0]|=INJECTF_SPENT;
			A_GiveInventory("CigaretteDrug",CigaretteDrug.HDCIG_DOSE);
			A_SelectWeapon("HDFist");
		}
		TNT1 AAAA 1 A_MuzzleClimb(0,-0.5);
		TNT1 A 6;
		goto nope;
	altfire:
	althold:
		TNT1 A 10;
		TNT1 A 0 A_Refire();
		goto nope;
}
	}
class CigaretteDummy:IdleDummy{
	hdplayerpawn tg;
	states{
	spawn:
		TNT1 A 6 nodelay{
			tg=HDPlayerPawn(target);
			if(!tg||tg.bkilled){destroy();return;}
		}
		TNT1 A 1{
			if(!target||target.bkilled){destroy();return;}
			HDF.Give(target,"CigaretteDrug",CigaretteDrug.HDCIG_DOSE);
		}stop;
	}
}
class CigaretteDrug:HDDrug{
	enum CigAmounts{
		HDCIG_DOSE=600, //It's long because it's a cigarette, 6 minutes - Cozi
		HDCIG_NOCIG=10, //This is how much you get set to if you lose your cig, or at what point you spit it out
	}
	int aggrotiming;
	int cigfxtiming;
	override void doeffect(){
		let hdp=hdplayerpawn(owner);
		double ret=min(0.1,amount*0.006);
	}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;
		//if(!random(0,10)||hdp.countinv("CigAggro"))hdp.aggravateddamage++;
		if(hdp.stunned>0)hdp.stunned=-3; //These are great if you hate being stunned, too cool to be stunned!
		if(hdp.beatcap>30)hdp.beatcap--; //what stims do, but if you got em too, its 2x
		if(hd_debug>=4)console.printf("Smoking "..amount);
		//////////////////////////////////////////////////////////////////////////////////
		// AGGRO
		if(aggrotiming==150){ //calculation to give u 4 aggro over time
		hdp.aggravateddamage++;
		aggrotiming = 0;
		} else{aggrotiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		// EFFECTS
		vector3 smkpos=hdp.pos;
		vector3 smkvel=vel; //vel
		vector3 smkdir=(0,0,0);
		double smkscale=0.25;
		double smkang=hdp.angle;
		double smkpitch=hdp.pitch;
		double smkspeed=hdp.speed; //hdp.speed
		double smkstartalpha=5.;
		//smkvel=0.01;
		smkdir*=smkspeed;
		smkvel+=smkdir;
		smkang=owner.angle-30;
		smkpos.z+=owner.height*0.75;
		smkpos.xy+=10*(cos(smkang),sin(smkang));
		actor a=spawn("HDCigaretteSmoke",smkpos,ALLOW_REPLACE);
		a.angle=smkang;a.pitch=smkpitch-90;a.vel=smkvel;a.scale*=smkscale;a.alpha=smkstartalpha;
		//////////////////////////////////////////////////////////////////////////////////
		if(cigfxtiming==3){
		vector3 smkpos=hdp.pos;
		vector3 smkvel=vel*=0.4;
		vector3 smkdir=(0,0,0);
		double smkscale=0.75;
		double smkang=hdp.angle;
		double smkpitch=hdp.pitch;
		double smkspeed=hdp.speed*3.;
		double smkstartalpha=5.;
		smkvel*=0.4;
		smkdir*=smkspeed;
		smkvel+=smkdir;
		smkang=owner.angle;
		smkpos.z+=owner.height*0.75;
		smkpos.xy-=10*(cos(smkang),sin(smkang));
		actor a=spawn("HDCigarettePuffSmoke",smkpos,ALLOW_REPLACE);
		smkvel*=0.4;
		smkdir*=smkspeed;
		smkvel+=smkdir;
		a.angle=smkang;a.pitch=smkpitch+15;a.vel=smkvel;a.scale*=smkscale;a.alpha=smkstartalpha;
		cigfxtiming = 0;
		} else{cigfxtiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		// LOSING OR DROP CONDITIONS 
		if(hdp.countinv("Heat")){
			amount=0;
			vector3 cigpos=hdp.pos;
			actor b=spawn("BurntCig",cigpos,ALLOW_REPLACE);
		}
		if(hdp.incapacitated>0||hdp.stunned>0){
			amount=0;
			vector3 cigpos=hdp.pos;
			actor b=spawn("BurntCig",cigpos,ALLOW_REPLACE);
		}
		amount--;
		}
}

class BurntCig:HDDebris{
	default{
		xscale 0.32;yscale 0.28;radius 3;height 3;
		bouncesound "misc/fragknock";
	}
	states{
	spawn:
		CIGA A 0;
	spawn2:
		---- A 1{
			A_SetRoll(roll+60,SPF_INTERPOLATE);
		}wait;
	death:
		---- A -1{
			roll=90;
			if(!random(0,1))scale.x*=-1;
		
		}
		---- A random(1,4) A_FadeOut(frandom(-0.03,0.032));
		wait;
	}
}

class HDCigaretteSmoke:HDSmoke{
	default{
		scale 0.3;renderstyle "add";alpha 0.4;
		hdpuff.decel 0.97;
		hdpuff.fade 0.8;
		hdpuff.grow 0.06;
		hdpuff.minalpha 0.01;
		hdpuff.startvelz 0;
	}
	override void postbeginplay(){
		super.postbeginplay();
		a_changevelocity(cos(pitch),0,-sin(pitch),CVF_RELATIVE);
		vel+=(frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(0.4,0.9));
	}
}

class HDCigarettePuffSmoke:HDSmoke{
	default{
		scale 0.3;renderstyle "add";alpha 0.4;
		hdpuff.decel 0.97;
		hdpuff.fade 0.8;
		hdpuff.grow 0.06;
		hdpuff.minalpha 0.01;
		hdpuff.startvelz 0;
	}
	override void postbeginplay(){
		super.postbeginplay();
		a_changevelocity(cos(pitch)*4,0,-sin(pitch)*4,CVF_RELATIVE);
		vel+=(frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(0.4,0.9));
	}
}

class HD_CigaretteDropper:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
			let a=CigarettePack(spawn("CigarettePack",pos,ALLOW_REPLACE));
			a.weaponstatus[HDCIGPACK_AMOUNT]=random(0,20);
        }stop;
    }
}

class EmptyCigarettePack:HDDebris{
	default{
		xscale 0.32;yscale 0.28;
		radius 3;height 3;
		bouncefactor 0.1;
		bouncesound "misc/zerkdrop";
	}
	states{
	spawn:
		CIGP B 0;
	spawn2:
		---- B 1{
			A_SetPitch(pitch+frandom(60,270),SPF_INTERPOLATE);
		}wait;
	death:
		CIGP B -1;
		stop;
	}
}