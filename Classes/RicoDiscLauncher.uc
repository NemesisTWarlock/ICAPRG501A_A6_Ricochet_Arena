class RicoDiscLauncher extends UTWeapon;

/** This is the Ricochet Disc Launcher. It fires High velocity bouncing projectiles that push opponents. If the user lands a headshot on a target however, it instantly kills them. */


//Regen Ammo

/** 
 *  recharge rate in ammo per second 
 */
var float RechargeRate;


simulated function RegenAmmo()
{
AmmoCount = Min(AmmoCount + 1, MaxAmmoCount);
if (AmmoCount == MaxAmmoCount)
{
ClearTimer ('RegenAmmo');
}
}

function ConsumeAmmo( byte FireModeNum )
{
super.ConsumeAmmo(FireModeNum);

if (AmmoCount != MaxAmmoCount)
{
SetTimer (RechargeRate, true, 'RegenAmmo');
}
}


//Weapon Perks



simulated function WeaponPerk (RicoPawn P, Proj_RicoDisc W)
{
	if ( P.bPerkAmmo == True )
	{
		MaxAmmoCount = 20;
		`log("Max Ammo Count should be 20, is currently" @ MaxAmmoCount);
	}
	else 
	{
		MaxAmmoCount = 10;
		`log("Max Ammo Count should be 10, is currently" @ MaxAmmoCount);
	}

	if ( P.bPerkRegen == True )
	{
		RechargeRate= 1.0;
		`log("Recharge Rate should be 1.0, is currently" @ RechargeRate);

	}
	else
	{
		RechargeRate=4.0;
		`log("Recharge Rate should be 4.0, is currently" @ RechargeRate);

	}

	if ( P.bPerkVelocity == True )
	{ 
		W.Speed = 15000;
		W.MaxSpeed = 15000;
		`log("Projectile Speed should be 15000, is currently" @ W.Speed);
		`log("Projectile Max Speed should be 15000, is currently" @ W.MaxSpeed);
	}
	else
	{
		W.Speed = 900;
		W.MaxSpeed = 900;
		`log("Projectile Speed should be 900, is currently" @ W.Speed);
		`log("Projectile Max Speed should be 900, is currently" @ W.MaxSpeed);
	}

	if ( P.bPerkBounce == True )
	{
		W.MaxBounces = 6;
		`log("Projectile Max Bounce count should be 6, is currently" @ W.MaxBounces);
	}
	else
	{
		W.MaxBounces = 3;
		`log("Projectile Max Bounce count should be 3, is currently" @ W.MaxBounces);
	}

}

DefaultProperties
{
	//Ripping out unneccesary Rocket Launcher stats, keeping only the basics here

	FireInterval(0)=+1.0
	PlayerViewOffset=(X=0.0,Y=0.0,Z=0.0)

//First Person Mesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		PhysicsAsset=None
		AnimTreeTemplate=AnimTree'WP_RocketLauncher.Anims.AT_WP_RocketLauncher_1P_Base'
		AnimSets(0)=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Translation=(X=0,Y=0,Z=0)
		Rotation=(Yaw=0)
		scale=1.0
		FOV=60.0
		bUpdateSkelWhenNotRendered=true
	End Object
	AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

	// Pickup staticmesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
	End Object


	WeaponFireSnd[0]=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Fire_Cue'

	WeaponEquipSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Raise_Cue'


	WeaponProjectiles(0)=class'Proj_RicoDisc'


//Projectile Fire Offset
	FireOffset=(X=20,Y=12,Z=-5)

	MaxDesireability=0.78
	AIRating=+0.78
	CurrentRating=+0.78
	bInstantHit=false
	bSplashJump=true
	bRecommendSplashDamage=true
	bSniping=false
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=1
	InventoryGroup=8
	GroupWeight=0.5

	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Rocket_Cue'

	AmmoCount=10
	MaxAmmoCount=10

	//Recharge Rate
	RechargeRate=2.0;

//Disable Secondary Fire
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_None


	MuzzleFlashSocket=MuzzleFlashSocketA


	MuzzleFlashPSCTemplate=WP_RocketLauncher.Effects.P_WP_RockerLauncher_Muzzle_Flash
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTRocketMuzzleFlashLight'



	IconX=460
	IconY=34
	IconWidth=51
	IconHeight=38

	EquipTime=+0.6



	JumpDamping=0.75

	LockerRotation=(pitch=0,yaw=0,roll=-16384)
	IconCoordinates=(U=131,V=379,UL=129,VL=50)
	CrossHairCoordinates=(U=128,V=64,UL=64,VL=64)
	WeaponPutDownSnd=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Lower_Cue'



	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
}
