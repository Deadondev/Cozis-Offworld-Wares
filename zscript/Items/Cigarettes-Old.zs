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
				A_GiveInventory("Cigarette");
				invoker.cigarettesleft--;
				A_StartSound("weapons/pocket",9);
				A_Log("There are " ..invoker.cigarettesleft.. " left in the box");
			}
			if(invoker.cigarettesleft==0){
				A_StartSound("weapons/pocket",9);
				A_Log("You discard the box as there are no more cigarettes left");
				A_TakeInventory("CigarettePack",1);
				actor a=spawn("SpentStim",pos,ALLOW_REPLACE);
				a.target=invoker;
				a.angle=invoker.angle;a.vel=invoker.vel;a.A_ChangeVelocity(-2,1,4,CVF_RELATIVE);
				a.A_StartSound("weapons/grenopen",CHAN_VOICE);
			}
			
		}
		fail;
	}
}
/*	action void A_SpawnSpent(){invoker.SpawnSpent(self);}
	actor SpawnSpent(actor onr){
		if(!onr)return null;
		actor a=onr.spawn(spentinjecttype,(onr.pos+HDMath.GetGunPos(onr)),ALLOW_REPLACE);
		if(!a)return null;
		a.target=onr;
		a.angle=onr.angle;a.vel=onr.vel;a.A_ChangeVelocity(-2,1,4,CVF_RELATIVE);
		a.A_StartSound("weapons/grenopen",CHAN_VOICE);
		return a;
	}*/
class Cigarette:PortableStimpack{
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Cigarettes"
		//$Sprite "CIGAA0"

//		inventory.pickupmessage "Picked up a Cigarette.";
		inventory.icon "CIGAA0";
		scale 0.3;
		tag "$TAG_CIGARETTE";
		hdweapon.refid HDLD_CIGARETTE;
		portablestimpack.injecttype "HDCigarette";
	}
	override string PickupMessage() {String pickupmessage = Stringtable.Localize("$PICKUP_CIGARETTE"); return pickupmessage;}
	override double weaponbulk(){
		return ENC_CIGARETTE;
	}
	states{
	spawn:
		CLEN A -1 nodelay{if(invoker.amount>2)invoker.scale=(0.4,0.35);else invoker.scale=(0.3,0.3);}
	}
}
class HDCigarette:PortableStimpack{
	default{
		portablestimpack.injecttype "CigaretteDummy"; //Don't think I'll use this either but just in case its InjectCleanserDummy
		portablestimpack.spentinjecttype "SpentStim"; //donnnn't think ill be usin' this. - Cozi
		//hdstimpacker.inventorytype "Cigarette";
		weapon.selectionorder 1003;
		//hdstimpacker.injectoricon "CIGAA0";
		//hdstimpacker.injectortype "Cigarette";
		tag "$TAG_CIGARETTE";
		portablestimpack.mainhelptext "\cr*** \caHEARTSTOPPER CIGARETTES \cr***\c-\n\n\nCigarettes help lower your heart rate, \crwatch out for aggro!.\n\n\Please don't smoke IRL.";
	}
states{
	spawn:
		TNT1 A 1; //DO NOT REMOVE DELAY
		stop;
	select:
		TNT1 A 8{
			bool helptext=DoHelpText();
			if(helptext)A_WeaponMessage(invoker.mainhelptext);

			//IfWaterLevel 3 {return resolvestate("inject");} Hey future Cozi, it's me, ya boy, I need you to put a waterlevel check here that basically says if you're submerged, you can go fuck yourself in terms of lighting a cig, that's all!
			A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
			A_StartSound("cig/open",CHAN_WEAPON,CHANF_OVERLAP);

			//take away one item in inventory.
			//the way deselect works, the only way you can have a fresh hdstimpacker
			//while having no stimpacks to draw from is if you cheated to obtain it,
			//which should be respected as = cheating to obtain one stimpack.
			let iii=HDInjectorMaker(findinventory(invoker.inventorytype));
			if(
				!!iii
				&&iii.amount>0
			){
				iii.SyncAmount();
				invoker.weaponstatus[INJECTS_AMOUNT]=iii.mags[0];
				iii.mags.delete(0);
				iii.amount--;
			}
		}
		goto super::ready;
	deselect:
		TNT1 A 5 A_StartSound("weapons/pocket",8,CHANF_OVERLAP,volume:0.5);
		TNT1 A 0{
			HDMagAmmo.GiveMag(self,invoker.inventorytype,invoker.weaponstatus[INJECTS_AMOUNT]);
		}
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
			actor a=spawn(invoker.injecttype,pos,ALLOW_REPLACE);
			a.accuracy=40;a.target=self; //actor
			A_SelectWeapon("HDFist");
			A_TakeInventory("HDCigarette");
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
	//override string,double getpickupsprite(){return "CIGAA0",1.;}
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
		HDCIG_DOSE=TICRATE*60*6, //It's long because it's a cigarette - Cozi
		HDCIG_NOCIG=10, //This is how much you get set to if you lose your cig, or at what point you spit it out
	}
	int cigtiming;
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
		// EFFECTS
		if(cigtiming==1){
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
		cigtiming--;
		} else{cigtiming++;}
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
			A_SpawnItemEx("CigarettePack",frandom(-12,12),frandom(-12,12),frandom(-12,12),0,0,0,0,SXF_NOCHECKPOSITION);
        }stop;
    }
}