const HDLD_CIGARETTE="cig";
const HDLD_CIGARETTEPACK= "cpk"; //Yes, this name sucks. I know. -Cozi
const ENC_CIGARETTE=1; //Stims are 7
const ENC_CIGARETTEPACK=5; //this is so theres a good reason to keep the pack as is, 20 cigs outside of it should be shittier than it unopened
//-------------------------------------------------
// Pack of Cigarettes
//-------------------------------------------------
enum cigarettestatus{
		HDCIGPACK_AMOUNT=0,
		HDCIGPACK_SLOT1=1,
		HDCIGPACK_SLOT2=2,
		HDCIGPACK_SLOT3=3,
		HDCIGPACK_SLOT4=4,
		HDCIGPACK_SLOT5=5,
		HDCIGPACK_SLOT6=6,
		HDCIGPACK_SLOT7=7,
		HDCIGPACK_SLOT8=8,
		HDCIGPACK_SLOT9=9,
		HDCIGPACK_SLOT10=10,
		HDCIGPACK_SLOT11=11,
		HDCIGPACK_SLOT12=12,
		HDCIGPACK_SLOT13=13,
		HDCIGPACK_SLOT14=14,
		HDCIGPACK_SLOT15=15,
		HDCIGPACK_SLOT16=16,
		HDCIGPACK_SLOT17=17,
		HDCIGPACK_SLOT18=18,
		HDCIGPACK_SLOT19=19,
		HDCIGPACK_SLOT20=20,

		HDCIG_DOSE=600, //It's long because it's a cigarette, 6 minutes - Cozi
		HDCIG_AMOUNT=600,
	}
class CigarettePack:HDWeapon{
	class<inventory> inventorytype;
	
	override void beginplay(){
		super.beginplay();
		weaponstatus[HDCIGPACK_SLOT1]=0;weaponstatus[HDCIGPACK_SLOT2]=0;weaponstatus[HDCIGPACK_SLOT3]=0;weaponstatus[HDCIGPACK_SLOT4]=0;weaponstatus[HDCIGPACK_SLOT5]=0;weaponstatus[HDCIGPACK_SLOT6]=0;weaponstatus[HDCIGPACK_SLOT7]=0;weaponstatus[HDCIGPACK_SLOT8]=0;weaponstatus[HDCIGPACK_SLOT9]=0;weaponstatus[HDCIGPACK_SLOT10]=0;weaponstatus[HDCIGPACK_SLOT11]=0;weaponstatus[HDCIGPACK_SLOT12]=0;weaponstatus[HDCIGPACK_SLOT13]=0;weaponstatus[HDCIGPACK_SLOT14]=0;weaponstatus[HDCIGPACK_SLOT15]=0;weaponstatus[HDCIGPACK_SLOT16]=0;weaponstatus[HDCIGPACK_SLOT17]=0;weaponstatus[HDCIGPACK_SLOT18]=0;weaponstatus[HDCIGPACK_SLOT19]=0;weaponstatus[HDCIGPACK_SLOT20]=0;
	}
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Pack of Cigarettes"
		//$Sprite "CIGPA0"

		+weapon.wimpy_weapon
		+inventory.invbar
		+hdweapon.fitsinbackpack
		inventory.pickupsound "misc/w_pkup";
		inventory.pickupmessage "$PICKUP_CIGARETTEPACK";
		inventory.icon "CIGPA0";
		scale 0.4;
		hdweapon.refid HDLD_CIGARETTEPACK;
		tag "$TAG_CIGARETTEPACK";
	}
	override double gunmass(){return 0;}
	override double weaponbulk(){
		return (ENC_CIGARETTEPACK);
	}
	override void loadoutconfigure(string input){
		weaponstatus[HDCIGPACK_AMOUNT]=20;
		weaponstatus[HDCIGPACK_SLOT1]=600;weaponstatus[HDCIGPACK_SLOT2]=600;weaponstatus[HDCIGPACK_SLOT3]=600;weaponstatus[HDCIGPACK_SLOT4]=600;weaponstatus[HDCIGPACK_SLOT5]=600;weaponstatus[HDCIGPACK_SLOT6]=600;weaponstatus[HDCIGPACK_SLOT7]=600;weaponstatus[HDCIGPACK_SLOT8]=600;weaponstatus[HDCIGPACK_SLOT9]=600;weaponstatus[HDCIGPACK_SLOT10]=600;weaponstatus[HDCIGPACK_SLOT11]=600;weaponstatus[HDCIGPACK_SLOT12]=600;weaponstatus[HDCIGPACK_SLOT13]=600;weaponstatus[HDCIGPACK_SLOT14]=600;weaponstatus[HDCIGPACK_SLOT15]=600;weaponstatus[HDCIGPACK_SLOT16]=600;weaponstatus[HDCIGPACK_SLOT17]=600;weaponstatus[HDCIGPACK_SLOT18]=600;weaponstatus[HDCIGPACK_SLOT19]=600;weaponstatus[HDCIGPACK_SLOT20]=600;
	}
	override int getsbarnum(int flags){
		return weaponstatus[HDCIGPACK_AMOUNT];
	}
		override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		vector2 bob=hpl.wepbob*0.3;
		//int cigarettesleft=weaponstatus[HDCIGPACK_AMOUNT];
		sb.drawimage("CIGPA0",(0,-64)+bob,
			sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_CENTER,
			alpha:255,scale:(2.5,2.5)
		);
		sb.drawstring(
			sb.psmallfont,""..weaponstatus[HDCIGPACK_AMOUNT],(0,-108)+bob,
			sb.DI_TEXT_ALIGN_CENTER|sb.DI_SCREEN_CENTER_BOTTOM,
			weaponstatus[HDCIGPACK_AMOUNT]?Font.CR_GRAY:Font.CR_DARKGRAY,alpha:255
		);
	}
	override string gethelptext(){
		return
		WEPHELP_FIRE.."  Pull out a cigarette\n"
		..WEPHELP_ALTFIRE.."  Put back a cigarette";
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){return GetSpareWeaponRegular(newowner,reverse,doselect);}

	action void A_PullCigarettePack(){
		invoker.weaponstatus[HDCIGPACK_SLOT1]=invoker.weaponstatus[HDCIGPACK_SLOT2];
		invoker.weaponstatus[HDCIGPACK_SLOT2]=invoker.weaponstatus[HDCIGPACK_SLOT3];
		invoker.weaponstatus[HDCIGPACK_SLOT3]=invoker.weaponstatus[HDCIGPACK_SLOT4];
		invoker.weaponstatus[HDCIGPACK_SLOT4]=invoker.weaponstatus[HDCIGPACK_SLOT5];
		invoker.weaponstatus[HDCIGPACK_SLOT5]=invoker.weaponstatus[HDCIGPACK_SLOT6];
		invoker.weaponstatus[HDCIGPACK_SLOT6]=invoker.weaponstatus[HDCIGPACK_SLOT7];
		invoker.weaponstatus[HDCIGPACK_SLOT7]=invoker.weaponstatus[HDCIGPACK_SLOT8];
		invoker.weaponstatus[HDCIGPACK_SLOT8]=invoker.weaponstatus[HDCIGPACK_SLOT9];
		invoker.weaponstatus[HDCIGPACK_SLOT9]=invoker.weaponstatus[HDCIGPACK_SLOT10];
		invoker.weaponstatus[HDCIGPACK_SLOT10]=invoker.weaponstatus[HDCIGPACK_SLOT11];
		invoker.weaponstatus[HDCIGPACK_SLOT11]=invoker.weaponstatus[HDCIGPACK_SLOT12];
		invoker.weaponstatus[HDCIGPACK_SLOT12]=invoker.weaponstatus[HDCIGPACK_SLOT13];
		invoker.weaponstatus[HDCIGPACK_SLOT13]=invoker.weaponstatus[HDCIGPACK_SLOT14];
		invoker.weaponstatus[HDCIGPACK_SLOT14]=invoker.weaponstatus[HDCIGPACK_SLOT15];
		invoker.weaponstatus[HDCIGPACK_SLOT15]=invoker.weaponstatus[HDCIGPACK_SLOT16];
		invoker.weaponstatus[HDCIGPACK_SLOT16]=invoker.weaponstatus[HDCIGPACK_SLOT17];
		invoker.weaponstatus[HDCIGPACK_SLOT17]=invoker.weaponstatus[HDCIGPACK_SLOT18];
		invoker.weaponstatus[HDCIGPACK_SLOT18]=invoker.weaponstatus[HDCIGPACK_SLOT19];
		invoker.weaponstatus[HDCIGPACK_SLOT19]=invoker.weaponstatus[HDCIGPACK_SLOT20];
		invoker.weaponstatus[HDCIGPACK_SLOT20]=0;
		if(hd_debug){
			A_Log("Slot 1 is now " ..invoker.weaponstatus[HDCIGPACK_SLOT1].. "");
		}
		}
	
	action void A_PushCigarettePack(){
		invoker.weaponstatus[HDCIGPACK_SLOT20]=invoker.weaponstatus[HDCIGPACK_SLOT19];
		invoker.weaponstatus[HDCIGPACK_SLOT19]=invoker.weaponstatus[HDCIGPACK_SLOT18];
		invoker.weaponstatus[HDCIGPACK_SLOT18]=invoker.weaponstatus[HDCIGPACK_SLOT17];
		invoker.weaponstatus[HDCIGPACK_SLOT17]=invoker.weaponstatus[HDCIGPACK_SLOT16];
		invoker.weaponstatus[HDCIGPACK_SLOT16]=invoker.weaponstatus[HDCIGPACK_SLOT15];
		invoker.weaponstatus[HDCIGPACK_SLOT15]=invoker.weaponstatus[HDCIGPACK_SLOT14];
		invoker.weaponstatus[HDCIGPACK_SLOT14]=invoker.weaponstatus[HDCIGPACK_SLOT13];
		invoker.weaponstatus[HDCIGPACK_SLOT13]=invoker.weaponstatus[HDCIGPACK_SLOT12];
		invoker.weaponstatus[HDCIGPACK_SLOT12]=invoker.weaponstatus[HDCIGPACK_SLOT11];
		invoker.weaponstatus[HDCIGPACK_SLOT11]=invoker.weaponstatus[HDCIGPACK_SLOT10];
		invoker.weaponstatus[HDCIGPACK_SLOT10]=invoker.weaponstatus[HDCIGPACK_SLOT9];
		invoker.weaponstatus[HDCIGPACK_SLOT9]=invoker.weaponstatus[HDCIGPACK_SLOT8];
		invoker.weaponstatus[HDCIGPACK_SLOT8]=invoker.weaponstatus[HDCIGPACK_SLOT7];
		invoker.weaponstatus[HDCIGPACK_SLOT7]=invoker.weaponstatus[HDCIGPACK_SLOT6];
		invoker.weaponstatus[HDCIGPACK_SLOT6]=invoker.weaponstatus[HDCIGPACK_SLOT5];
		invoker.weaponstatus[HDCIGPACK_SLOT5]=invoker.weaponstatus[HDCIGPACK_SLOT4];
		invoker.weaponstatus[HDCIGPACK_SLOT4]=invoker.weaponstatus[HDCIGPACK_SLOT3];
		invoker.weaponstatus[HDCIGPACK_SLOT3]=invoker.weaponstatus[HDCIGPACK_SLOT2];
		invoker.weaponstatus[HDCIGPACK_SLOT2]=invoker.weaponstatus[HDCIGPACK_SLOT1];
		invoker.weaponstatus[HDCIGPACK_SLOT1]=0;
		}

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
			if(invoker.weaponstatus[HDCIGPACK_SLOT1]>=1){
				let mdk=HDWeapon(spawn("Cigarette",pos));
				mdk.health=invoker.weaponstatus[HDCIGPACK_SLOT1];
				mdk.actualpickup(self,true);
				invoker.weaponstatus[HDCIGPACK_AMOUNT]--;
				A_StartSound("weapons/pocket",9);
				A_PullCigarettePack();
			}
			if(invoker.weaponstatus[HDCIGPACK_SLOT1]==0){
				A_StartSound("weapons/pocket",9);
			}
		}
		TNT1 A 10;
		goto ready;
	altfire:
		TNT1 A 0{
			if(invoker.weaponstatus[HDCIGPACK_SLOT20]>=1){
				A_StartSound("weapons/pocket",9);
				A_Log("The box is full!");
				resolvestate("nope");
			} else{
			if(countinv("Cigarette")<1){
				A_Log("No cigarettes to put away!");
				resolvestate("nope");
			} else {
				A_PushCigarettePack();
				let iii=HDWeapon(findinventory("Cigarette"));
			if(!!iii){
				invoker.weaponstatus[HDCIGPACK_SLOT1]=iii.health;
				iii.weaponstatus[0]|=INJECTF_SPENT;
				DropInventory(iii,1);
				invoker.weaponstatus[HDCIGPACK_AMOUNT]++;
				A_StartSound("weapons/pocket",9);
				if(hd_debug){
				A_Log("Slot 1 is now " ..invoker.weaponstatus[HDCIGPACK_SLOT1].. "");
				}
			}
			}
			}
		}
		TNT1 A 10;
		goto ready;
	}
}

class Cigarette:HDWeapon{
	enum CigAmounts{
		HDCIG_DOSE=600, //How much said cigarette has left.
		//HDCIG_AMOUNT=600,

	}
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

		health 600;
	}
	states{
	spawn:
		TNT1 A 1; //DO NOT REMOVE DELAY
		TNT1 A 0{
			if(!invoker.weaponstatus[0]&INJECTF_SPENT){
			setstatelabel("spawn2");
			if(hd_debug>=4)console.printf("dropped cigarette at "..health);
		}
		}
		stop;
	spawn2:
		CIGA A 1 {if(HDMath.CheckLiquidTexture(invoker)&&floorz==pos.z){
			//A_StartSound("potion/swish",8,CHANF_OVERLAP,volume:0.5);
			setstatelabel("death");}}
		loop;
	death:
	TNT1 A 0;
	stop;
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
			if(invoker.countinv("PowerIronFeet")){
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
			A_GiveInventory("CigaretteDrug",invoker.health);
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

class CigaretteDrug:HDDrug{
	enum CigAmounts{
		HDCIG_DOSE=600, //It's long because it's a cigarette, 6 minutes - Cozi
		HDCIG_NOCIG=10, //This is how much you get set to if you lose your cig, or at what point you spit it out
		 //How much said cigarette has left.
	}
	int aggrotiming;
	int cigfxtiming;
	int cigtwofxtiming;
	override void doeffect(){
		let hdp=hdplayerpawn(owner);
		double ret=min(0.1,amount*0.006);
		// LOSING OR DROP CONDITIONS
		if(hdp.countinv("Heat")||hdp.health<12||hdp.incapacitated>0){
			let dropcig=Cigarette(spawn("Cigarette",hdp.pos,ALLOW_REPLACE));
			//dropcig.weaponstatus[HDCIG_AMOUNT]=1;
			dropcig.health=amount;
			dropcig.vel.x += frandom(-2,2);
			dropcig.vel.y += frandom[spawnstuff](-2,2);
			dropcig.vel.z += frandom[spawnstuff](1,2);
			dropcig.angle += frandom(0,360);
			A_Log("Cigarette dropped!");
			amount=0;
		}
		if(hdp.countinv("WornRadsuit")){
			A_Log("You put your cigarette out and slip the radsuit on.");
			amount=0;
			}
	}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;
		if(hdp.stunned>0)hdp.stunned=-3; //These are great if you hate being stunned, too cool to be stunned!
		if(hdp.beatcap>30)hdp.beatcap--; //what stims do, but if you got em too, its 2x
		if(hd_debug>=4)console.printf("Smoking "..amount);
		//////////////////////////////////////////////////////////////////////////////////
		// AGGRO
		if(aggrotiming==60){ //calculation to give u 10 aggro over time
		hdp.aggravateddamage+=0.1;
		aggrotiming = 0;
		} else{aggrotiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		// EFFECTS
		if(cigtwofxtiming==3){
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
		cigtwofxtiming = 0;
		} else{cigtwofxtiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		if(cigfxtiming==9){
		vector3 smkpos=hdp.pos;
		vector3 smkvel=vel*=0.4;
		vector3 smkdir=(0,0,0);
		double smkscale=0.75;
		double smkang=hdp.angle;
		double smkpitch=hdp.pitch;
		double smkspeed=hdp.speed*3;
		double smkstartalpha=5;
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
			let cig=Cigarette(spawn("Cigarette",pos,ALLOW_REPLACE));
			cig.health=random(50,600);
			cig.vel.x += frandom(-2,2);
			cig.vel.y += frandom[spawnstuff](-2,2);
			cig.vel.z += frandom[spawnstuff](1,2);
			cig.angle += frandom(0,360);
        }stop;
    }
}

class HD_CigaretteBoxDropper:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
			int cigpackamount=random(0,20);
			let cigpak=CigarettePack(spawn("CigarettePack",pos,ALLOW_REPLACE));
			cigpak.vel.x += frandom(-2,2);
			cigpak.vel.y += frandom[spawnstuff](-2,2);
			cigpak.vel.z += frandom[spawnstuff](1,2);
			cigpak.angle += frandom(0,360);
			cigpak.weaponstatus[HDCIGPACK_AMOUNT]=cigpackamount;
			if(cigpackamount>=1){cigpak.weaponstatus[HDCIGPACK_SLOT1]=600;}
			if(cigpackamount>=2){cigpak.weaponstatus[HDCIGPACK_SLOT2]=600;}
			if(cigpackamount>=3){cigpak.weaponstatus[HDCIGPACK_SLOT3]=600;}
			if(cigpackamount>=4){cigpak.weaponstatus[HDCIGPACK_SLOT4]=600;}
			if(cigpackamount>=5){cigpak.weaponstatus[HDCIGPACK_SLOT5]=600;}
			if(cigpackamount>=6){cigpak.weaponstatus[HDCIGPACK_SLOT6]=600;}
			if(cigpackamount>=7){cigpak.weaponstatus[HDCIGPACK_SLOT7]=600;}
			if(cigpackamount>=8){cigpak.weaponstatus[HDCIGPACK_SLOT8]=600;}
			if(cigpackamount>=9){cigpak.weaponstatus[HDCIGPACK_SLOT9]=600;}
			if(cigpackamount>=10){cigpak.weaponstatus[HDCIGPACK_SLOT10]=600;}
			if(cigpackamount>=11){cigpak.weaponstatus[HDCIGPACK_SLOT11]=600;}
			if(cigpackamount>=12){cigpak.weaponstatus[HDCIGPACK_SLOT12]=600;}
			if(cigpackamount>=13){cigpak.weaponstatus[HDCIGPACK_SLOT13]=600;}
			if(cigpackamount>=14){cigpak.weaponstatus[HDCIGPACK_SLOT14]=600;}
			if(cigpackamount>=15){cigpak.weaponstatus[HDCIGPACK_SLOT15]=600;}
			if(cigpackamount>=16){cigpak.weaponstatus[HDCIGPACK_SLOT16]=600;}
			if(cigpackamount>=17){cigpak.weaponstatus[HDCIGPACK_SLOT17]=600;}
			if(cigpackamount>=18){cigpak.weaponstatus[HDCIGPACK_SLOT18]=600;}
			if(cigpackamount>=19){cigpak.weaponstatus[HDCIGPACK_SLOT19]=600;}
			if(cigpackamount>=20){cigpak.weaponstatus[HDCIGPACK_SLOT20]=600;}
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