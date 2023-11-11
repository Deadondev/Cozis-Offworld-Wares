const HDLD_CLEANSER="cln";
const ENC_CLEANSER=4; //Stims are 7
class PortableCleanser:PortableStimpack{
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Cleanser Injector"
		//$Sprite "CLENA0"

		inventory.pickupmessage "Picked up a Cleanser.";
		inventory.icon "CLENA0";
		scale 0.3;
		tag "$TAG_CLEANSER";
		hdweapon.refid HDLD_CLEANSER;
		+inventory.ishealth
		portablestimpack.injecttype "HDCleanser";
	}
	override string PickupMessage() {String pickupmessage = Stringtable.Localize("$PICKUP_CLEANSER"); return pickupmessage;}
	override double weaponbulk(){
		return ENC_CLEANSER;
	}
	states{
	spawn:
		CLEN A -1 nodelay{if(invoker.amount>2)invoker.scale=(0.4,0.35);else invoker.scale=(0.3,0.3);}
	}
}
class HDCleanser:PortableStimpack{
	default{
		portablestimpack.injecttype "InjectCleanserDummy";
		portablestimpack.spentinjecttype "SpentStim";
		//hdweapon.inventorytype "PortableCleanser";
		weapon.selectionorder 1003;
		//portablestimpack.injectoricon "CLENA0";
		//portablestimpack.injecttype "PortableCleanser";
		tag "$TAG_CLEANSER";
		portablestimpack.mainhelptext "\cr*** \caCLEANSER \cr***\c-\n\n\nCleanser packs help clear ALL drugs out of your system.\n\n\Press altfire to use on someone else.";
	}
	override string,double getpickupsprite(){return "CLENA0",1.;}
}
class InjectCleanserDummy:IdleDummy{
	hdplayerpawn tg;
	states{
	spawn:
		TNT1 A 6 nodelay{
			tg=HDPlayerPawn(target);
			if(!tg||tg.bkilled){destroy();return;}
			if(tg.countinv("HDZerk")>HDZerk.HDZERK_COOLOFF)tg.aggravateddamage+=int(ceil(accuracy*0.01*random(1,3))); //Zerk causing Aggro, I put it here because it'll only cause aggro when you're above "cool-off" -Cozi
		}
		TNT1 A 1{
			if(!target||target.bkilled){destroy();return;}
			HDF.Give(target,"CleanserDrug",CleanserDrug.HDCLEAN_DOSE);
		}stop;
	}
}
class CleanserDrug:HDDrug{
	enum CleanAmounts{
		HDCLEAN_DOSE=80, //80
		HDCLEAN_COOLOFF=30,
		HDCLEAN_VOMIT=2,
	}
	int vomitamount;
	override void doeffect(){
		let hdp=hdplayerpawn(owner);

		double ret=min(0.1,amount*0.006);
		if(hdp.fatigue<HDCONST_SPRINTFATIGUE)hdp.fatigue++; //so 'eepy!
		if(hdp.stunned<40)hdp.stunned+=3; //Stun from zerk, probably will nerf but idk so far it's fine.
	}
	override void OnHeartbeat(hdplayerpawn hdp){
		if(amount<1)return;

		if(hdp.countinv("HDZerk")){
			hdp.A_TakeInventory("HDZerk",100);
			hdp.bloodloss+=10;
			vomitamount+=10;
			hdp.stunned=max(hdp.stunned,10);
			hdp.incaptimer+=(3); //Basically the player collapses
			//hdp.AddBlackout(256,2,4,24);
		}
		if(hdp.countinv("HDStim")){
			hdp.A_TakeInventory("HDStim",40);
			hdp.bloodloss+=4;
			vomitamount+=4;
		}
		if(hdp.countinv("UasAlcohol_Offworld_IntoxToken")){
			hdp.A_TakeInventory("UasAlcohol_Offworld_IntoxToken",104);
			hdp.bloodloss+=1;
			vomitamount+=1;
		}
		if(hdp.countinv("HealingMagic")){
			hdp.A_TakeInventory("HealingMagic",10);
			hdp.bloodloss+=1;
			vomitamount+=1;
		}

		if(hdp.countinv("CleanserDrug")<CleanserDrug.HDCLEAN_VOMIT){//Go to the bathroom! You're Vomiting yourself!
		hdp.muzzleclimb1+=(0,frandom(8,4));
		while(vomitamount>0){
		owner.A_SpawnItemEx(owner.bloodtype,0,0,owner.height*frandom(0.8,0.9),
		frandom(0,4),frandom(-0.2,0.2),frandom(-0.1,0.1),0,
			flags:SXF_USEBLOODCOLOR|SXF_NOCHECKPOSITION|SXF_TRANSFERROLL|SXF_TRANSFERPITCH
		);
		vomitamount--;
		}
		}
		
		if(hd_debug>=4)console.printf("Cleaning "..amount.."  = "..hdp.strength);
		amount--;
		}
}

class HD_CleanserDropper:IdleDummy{
    states{
    spawn:
        TNT1 A 0 nodelay{
			A_SpawnItemEx("PortableCleanser",frandom(-12,12),frandom(-12,12),frandom(-12,12),0,0,0,0,SXF_NOCHECKPOSITION);
        }stop;
    }
}