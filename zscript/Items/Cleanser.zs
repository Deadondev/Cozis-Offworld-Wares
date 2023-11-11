//-------------------------------------------------
// Cleanser
//-------------------------------------------------
const HDLD_CLEANSER="cln";
const ENC_CLEANSER=4; //Stims are 7

enum InjectorWeapon{
	INJECTF_SPENT=1,
	INJECTS_AMOUNT=1,
}
class PortableCleanser:HDWeapon{
	string mainhelptext;property mainhelptext:mainhelptext;
	class<actor> spentinjecttype;property spentinjecttype:spentinjecttype;
	class<actor> injecttype;property injecttype:injecttype;
	override double weaponbulk(){
		return ENC_CLEANSER;
	}
	override bool AddSpareWeapon(actor newowner){return AddSpareWeaponRegular(newowner);}
	override hdweapon GetSpareWeapon(actor newowner,bool reverse,bool doselect){
		if(weaponstatus[0]&INJECTF_SPENT)doselect=false;
		return GetSpareWeaponRegular(newowner,reverse,doselect);
	}
	default{
		//$Category "Items/Hideous Destructor/Supplies"
		//$Title "Cleanser"
		//$Sprite "CLENA0"

		scale 0.37;
		inventory.pickupmessage "$PICKUP_CLEANSER";
		inventory.icon "CLENA0";
		tag "$TAG_CLEANSER";
		hdweapon.refid HDLD_CLEANSER;
		+inventory.ishealth
		+inventory.invbar
		+weapon.wimpy_weapon
		+weapon.no_auto_switch
		+hdweapon.fitsinbackpack
		inventory.pickupSound "weapons/pocket";

		weapon.selectionorder 1003;

		portablecleanser.mainhelptext "\cr*** \caCLEANSER \cr***\c-\n\n\nCleanser packs help clear ALL drugs out of your system.\n\n\Press altfire to use on someone else.";
		portablecleanser.spentinjecttype "SpentStim"; //Change this later
		portablecleanser.injecttype "InjectCleanserDummy";
	}
	states(actor){
	//don't use a CreateTossable override - we need the throwing stuff
	spawn:
		TNT1 A 1; //DO NOT REMOVE DELAY
		TNT1 A 0{
			if(weaponstatus[0]&INJECTF_SPENT){
				actor aa=spawn(spentinjecttype,pos,ALLOW_REPLACE);
				if(!aa)return;
				aa.target=target;aa.angle=angle;aa.pitch=pitch;aa.vel=vel;
				aa.A_StartSound("misc/stimdrop",CHAN_VOICE);
			}else setstatelabel("spawn2");
		}
		stop;
	spawn2:
		CLEN A -1;
		stop;
	}

	action void A_InjectorReachDown(){
		if(hdplayerpawn(self))hdplayerpawn(self).gunbraced=false;
		if(invoker.weaponstatus[0]&INJECTF_SPENT){
			setweaponstate("nope");
			return;
		}
		let blockinv=HDWoundFixer.CheckCovered(self,CHECKCOV_ONLYFULL);
		if(blockinv){
			A_TakeOffFirst(blockinv.gettag(),2);
			setweaponstate("nope");
			return;
		}
		if(pitch<55){
			A_MuzzleClimb(0,8);
			A_Refire();
			return;
		}
		setweaponstate("inject");
	}

	action void A_InjectorInject(actor agent,actor patient){invoker.InjectorInject(agent,patient);}
	virtual void InjectorInject(actor agent,actor patient){
		patient.A_SetBlend("7a 3a 18",0.1,4);

		let hdp=hdplayerpawn(patient);
		if(hdp){
			hdp.A_StartSound(hdp.medsound,CHAN_VOICE);
			hdp.A_MuzzleClimb((0,2),(0,0),(0,0),(0,0));
		}
		else patient.A_StartSound(patient.painsound,CHAN_VOICE);

		agent.A_StartSound("misc/injection",CHAN_WEAPON,CHANF_OVERLAP);
		weaponstatus[0]|=INJECTF_SPENT;

		A_InjectorEffect(patient);
	}

	action void A_InjectorEffect(actor patient){invoker.InjectorEffect(patient);}
	virtual void InjectorEffect(actor patient){
		actor a=spawn(injecttype,patient.pos,ALLOW_REPLACE);
		a.accuracy=40;a.target=patient;
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
		TNT1 A 0 A_InjectorReachDown();
		goto nope;
	inject:
		TNT1 A 1 A_InjectorInject(self,self);
		TNT1 AAAA 1 A_MuzzleClimb(0,-0.5);
		TNT1 A 6;
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
				if(
					ccc
					&&invoker.getclassname()=="CleanserDrug"
				){
					if(
						ccc.stunned<100
						||ccc.health<10
					){
						if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_NONEED"),2);
						return resolvestate("nope");
					}
					invoker.weaponstatus[0]|=INJECTF_SPENT;
					ccc.A_StartSound(ccc.painsound,CHAN_VOICE);
					ccc.stunned=max(0,ccc.stunned>>1);
					return resolvestate("injected");
				}
				if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_NOTHINGTOBEDONE"));
				return resolvestate("nope");
			}
			let blockinv=HDWoundFixer.CheckCovered(self,CHECKCOV_ONLYFULL);
			if(blockinv){
				if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_TAKEOFFOTHER")..blockinv.gettag()..Stringtable.Localize("$STIMPACK_ELIPSES"));
				return resolvestate("nope");
			}
			if(IsMoving.Count(c)>4){
				bool chelptext=DoHelpText(c);
				if(c.countinv("CleanserDrug")){
					if(chelptext)HDWeapon.ForceWeaponMessage(c,string.format(Stringtable.Localize("$STIMPACK_OVERDOSEPLAYER"),player.getusername()));
					if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_FIDGETY"));
				}else{
					if(chelptext)HDWeapon.ForceWeaponMessage(c,string.format(Stringtable.Localize("$STIMPACK_STOPSQUIRMING"),player.getusername()));
					if(helptext)A_WeaponMessage(Stringtable.Localize("$STIMPACK_STAYSTILLOTHER"));
				}
				return resolvestate("nope");
			}
			if(
				//because poisoning people should count as friendly fire!
				(teamplay || !deathmatch)&&
				(
					(
						invoker.injecttype=="InjectCleanserDummy"
						&& c.countinv("CleanserDrug")
					)||
					(
						invoker.injecttype=="InjectZerkDummy"
						&& c.countinv("HDZerk")>HDZerk.HDZERK_COOLOFF
					)
				)
			){
				if(DoHelpText(c))HDWeapon.ForceWeaponMessage(c,string.format(Stringtable.Localize("$STIMPACK_OVERDOSEPLAYER"),player.getusername()));
				if(DoHelpText())A_WeaponMessage(Stringtable.Localize("$STIMPACK_SEEMFIDGETY"));
				return resolvestate("nope");
			}

			//and now...
			A_InjectorInject(self,c);
			return resolvestate("injected");
		}
	injected:
		TNT1 A 8;
		goto nope;
	}
}
class InjectCleanserDummy:IdleDummy{
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