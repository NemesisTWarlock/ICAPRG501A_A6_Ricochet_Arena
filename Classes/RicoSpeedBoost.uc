class RicoSpeedBoost extends UTTimedPowerup;

/**
 * This powerup temporarily increases the collecting pawn's movement speed.
 */

//Setting Vars

/** Sound played when the Powerup is running out */
var SoundCue PowerupFadingSound;

/** overlay material applied to owner */
var MaterialInterface OverlayMaterialInstance;

/** ambient sound played while active*/
var SoundCue DamageAmbientSound;


simulated static function AddWeaponOverlay(UTGameReplicationInfo GRI)
{
	GRI.WeaponOverlays[0] = default.OverlayMaterialInstance;
}

//TESTING: USING UDAMAGE POWERUP CODE, MODIFYING TO SUIT, CODE WILL CHANGE ANY TIME.

function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
	local Ricopawn P;

	Super.GivenTo(NewOwner, bDoNotActivate);
	P = RicoPawn(NewOwner);
	// boost speed
	P.GroundSpeed *= 5.0;	
	if (P != None)
	{
		// apply powerup overlay
		P.SetWeaponOverlayFlag(0);
		P.SetPawnAmbientSound(DamageAmbientSound);
	}
	// set timer for ending sounds
	SetTimer(TimeRemaining - 3.0, false, 'PlayPowerupFadingSound');

}

//Set things back to nromal when the powerup ends

function ItemRemovedFromInvManager()
{
	local UTPlayerReplicationInfo UTPRI;
	local UTPawn P;

	Pawn(Owner).GroundSpeed /= 5.0;
	P = UTPawn(Owner);
	if (P != None)
	{
		P.ClearWeaponOverlayFlag( 0 );
		P.SetPawnAmbientSound(none);
		//Stop the timer on the powerup stat
		if (P.DrivenVehicle != None)
		{
			UTPRI = UTPlayerReplicationInfo(P.DrivenVehicle.PlayerReplicationInfo);
		}
		else
		{
			UTPRI = UTPlayerReplicationInfo(P.PlayerReplicationInfo);
		}
		if (UTPRI != None)
		{
			UTPRI.StopPowerupTimeStat(GetPowerupStatName());
		}
	}
	SetTimer(0.0, false, 'PlayPowerupFadingSound');
}

/** called on a timer to play Powerup ending sound */
function PlayPowerupFadingSound()
{
	// reset timer if time got added
	if (TimeRemaining > 3.0)
	{
		SetTimer(TimeRemaining - 3.0, false, 'PlayPowerupFadingSound');
	}
	else
	{
		Instigator.PlaySound(PowerupFadingSound);
		SetTimer(0.75, false, 'PlayPowerupFadingSound');
	}
}

DefaultProperties
{
		
		PowerupStatName=POWERUPTIME_SPEEDBOOST

	Begin Object Class=StaticMeshComponent Name=MeshComponentA
		StaticMesh=StaticMesh'Pickups.JumpBoots.Mesh.S_UN_Pickups_Jumpboots002'
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		bAcceptsLights=true
		CollideActors=false
		BlockRigidBody=false
		Scale3D=(X=2,Y=2,Z=2)
		MaxDrawDistance=8000
		Translation=(X=0.0,Y=0.0,Z=-30.0)
	End Object
	DroppedPickupMesh=MeshComponentA
	PickupFactoryMesh=MeshComponentA

	Begin Object Class=UTParticleSystemComponent Name=PickupParticles
		Template=ParticleSystem'Pickups.UDamage.Effects.P_Pickups_UDamage_Idle'
		bAutoActivate=false
		SecondsBeforeInactive=1.0f
		Translation=(X=0.0,Y=0.0,Z=+5.0)
	End Object
	DroppedPickupParticles=PickupParticles

	bReceiveOwnerEvents=true
	PickupSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_PickupCue'
	PowerupFadingSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_WarningCue'
	PowerupOverSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_EndCue'
	OverlayMaterialInstance=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay'
	DamageAmbientSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_UDamage_PowerLoopCue'
	HudIndex=0
	IconCoords=(U=792,UL=43,V=41,VL=58)


	PP_Scene_Highlights=(X=-0.1,Y=0.04,Z=-0.2)


	TimeRemaining=10.0
	bDelayedSpawn=false
}
