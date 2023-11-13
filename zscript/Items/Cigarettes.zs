const HDLD_CIGARETTE="cig";
const HDLD_CIGARETTEPACK= "cpk"; //Yes, this name sucks. I know. -Cozi
const ENC_CIGARETTE=1; //Stims are 7
const ENC_CIGARETTEPACK=5; //this is so theres a good reason to keep the pack as is, 20 cigs outside of it should be shittier than it unopened
//-------------------------------------------------
// Pack of Cigarettes
//-------------------------------------------------
class CigarettePack:HDPickup{
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Pack of Cigarettes"
		//$Sprite "CIGPA0"

		-hdpickup.droptranslation
		inventory.pickupmessage "Picked up a pack of cigs.";
		inventory.icon "CIGPA0";
		scale 0.4;
		hdpickup.bulk ENC_CIGARETTEPACK;
		tag "cigarette pack";
		hdpickup.refid HDLD_CIGARETTEPACK;
	}
	int cigarettesleft;
	override void PostBeginPlay(){
		cigarettesleft=random(1,20);
	}
	states{
	spawn:
		CIGP A -1;
		stop;
	use:
		TNT1 A 0{
			if(invoker.cigarettesleft>=1){
				let mdk=HDWeapon(spawn("Cigarette",pos));
				mdk.actualpickup(self,true);
				invoker.cigarettesleft--;
				A_StartSound("weapons/pocket",9);
				A_Log("There are " ..invoker.cigarettesleft.. " left in the box");
			}
			if(invoker.cigarettesleft==0){
				A_StartSound("weapons/pocket",9);
				A_Log("You discard the box as there are no more cigarettes left");
				A_TakeInventory("CigarettePack",1);
				actor a=spawn("EmptyCigarettePack",pos,ALLOW_REPLACE);
				a.target=invoker;
				a.angle=invoker.angle;a.vel=invoker.vel;a.A_ChangeVelocity(-2,1,4,CVF_RELATIVE);
				a.A_StartSound("weapons/grenopen",CHAN_VOICE);
			}
			
		}
		fail;
	}
}

class Cigarette:HDWeapon{
	string mainhelptext;property mainhelptext:mainhelptext;
	class<actor> injecttype;property injecttype:injecttype;
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Cigarettes"
		//$Sprite "CIGAA0"

		inventory.pickupmessage "Picked up a Cigarette.";
		inventory.icon "CIGAA0";
		scale 0.3;
		tag "$TAG_CIGARETTE";
		hdweapon.refid HDLD_CIGARETTE;
		cigarette.mainhelptext "\cr*** \caHEARTSTOPPER CIGARETTES \cr***\c-\n\n\nCigarettes help lower your heart rate, \crwatch out for aggro!.\n\n\Please don't smoke IRL.";
		weapon.selectionorder 1003;
		cigarette.injecttype "CigaretteDrug";
		+inventory.invbar
		+hdweapon.fitsinbackpack
	}
	override string PickupMessage() {String pickupmessage = Stringtable.Localize("$PICKUP_CIGARETTE"); return pickupmessage;}
	override double weaponbulk(){
		return ENC_CIGARETTE;
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){
		if(weaponstatus[0]&INJECTF_SPENT)doselect=false;
		return GetSpareWeaponRegular(newowner,reverse,doselect);
	}
	override void DrawHUDStuff(HDStatusBar sb,HDWeapon hdw,HDPlayerPawn hpl){
		sb.drawimage(
			texman.getname(icon),(-23,-7),
			sb.DI_SCREEN_CENTER_BOTTOM|sb.DI_ITEM_RIGHT
		);
	}
	states{
	spawn:
		CIGA A -1 nodelay{if(invoker.amount>2)invoker.scale=(0.4,0.35);else invoker.scale=(0.3,0.3);}
	select:
		TNT1 A 8{
			bool helptext=DoHelpText();
			if(helptext)A_WeaponMessage(invoker.mainhelptext);

			//IfWaterLevel 3 {return resolvestate("inject");} Hey future Cozi, it's me, ya boy, I need you to put a waterlevel check here that basically says if you're submerged, you can go fuck yourself in terms of lighting a cig, that's all!
			A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
			A_StartSound("cig/open",CHAN_WEAPON,CHANF_OVERLAP);
		}
		goto super::ready;
	deselect:
		TNT1 A 5 A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
		TNT1 A 0 A_Lower(999);
		wait;
	ready:
		TNT1 A 0;
		goto super::ready;
	fire:
	hold:
		TNT1 A 1;
		TNT1 A 0{
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
			A_GiveInventory("CigaretteDrug",CigaretteDrug.HDCIG_DOSE);
			A_SelectWeapon("HDFist");
			A_TakeInventory("Cigarette");
		}
		TNT1 AAAA 1 A_MuzzleClimb(0,-0.5);
		TNT1 A 6;
		goto nope;
	altfire: //maybe later i'll make it that you can help someone light up a cig, i see no reason to do this otherwise though -Cozi
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
		HDCIG_DOSE=TICRATE*60*5, //It's long because it's a cigarette - Cozi
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
		if(aggrotiming==TICRATE*60){ //calculation to give u 4 aggro over time
		hdp.aggravateddamage++;
		aggrotiming = 0;
		} else{aggrotiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		// EFFECTS
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
		actor a=spawn("HDCigaretteSmoke",smkpos,ALLOW_REPLACE);
		smkvel*=0.4;
		smkdir*=smkspeed;
		smkvel+=smkdir;
		a.angle=smkang;a.pitch=smkpitch+15;a.vel=smkvel;a.scale*=smkscale;a.alpha=smkstartalpha;
		cigfxtiming = 0;
		} else{cigfxtiming++;}
		//////////////////////////////////////////////////////////////////////////////////
		if(hdp.incapacitated>0||hdp.stunned>0){
			amount=0;
			vector3 smkpos=hdp.pos;
			actor b=spawn("SpentStim",smkpos,ALLOW_REPLACE);
		}
		amount--;
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
		a_changevelocity(cos(pitch)*4,0,-sin(pitch)*4,CVF_RELATIVE);
		vel+=(frandom(-0.1,0.1),frandom(-0.1,0.1),frandom(0.4,0.9));
	}
}

class HD_CigaretteDropper:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
			A_SpawnItemEx("CigarettePack",frandom(-12,12),frandom(-12,12),frandom(-12,12),0,0,0,frandom(0,270),SXF_NOCHECKPOSITION);
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