//Some code copied from UTUDamage class, Copyright 1998-2015 Epic Games, Inc. All Rights Reserved.

class RicoFreezeShot extends UTTimedPowerup;

/**
 * This powerup Causes projectiles fired from the Collecting Pawn's Weapon to reduce movement speed by 30%.
 */


/** Sound played when the Powerup is running out */
var SoundCue PowerupFadingSound;

/** overlay material applied to owner */
var MaterialInterface OverlayMaterialInstance;

/** ambient sound played while active*/
var SoundCue DamageAmbientSound;


/**Replicate Weapon Overlay material to be seen by other players */
simulated static function AddWeaponOverlay(UTGameReplicationInfo GRI)
{
	GRI.WeaponOverlays[0] = default.OverlayMaterialInstance;
}




/**When Pawn Recieves the Powerup*/
function GivenTo(Pawn NewOwner, optional bool bDoNotActivate) 
{
	local Ricopawn P;

	Super.GivenTo(NewOwner, bDoNotActivate);
	P = RicoPawn(NewOwner);

	// Toggle ON The FreezeShot Bool
	P.bPowerupFreezeShot = True;

	if (P != None)
	{
		// apply powerup overlay
		P.SetWeaponOverlayFlag(0);
		P.SetPawnAmbientSound(DamageAmbientSound);
	}
	// set timer for Warning sounds
	SetTimer(TimeRemaining - 3.0, false, 'PlayPowerupFadingSound');

}

/**Display the Powerup Timer on the HUD*/
simulated function DisplayPowerup(Canvas Canvas, UTHUD HUD, float ResolutionScale,out float YPos)
{
	local float FlashAlpha, Scaler; //The Alpha for the Warning Flash, The Time scale for the flash amount
	local float XPos; //UI X Position
	local string TimeRemainingAsString; //Time Remaining String
	local int TimeRemainingAsInt; //Time Remaining Integer

	//Setup Warning Flash
	if (TransitionTime > 0.0)
	{
		TransitionTime -= HUD.RenderDelta;
		if (TransitionTime < 0.0)
		{
			TransitionTime = 0.0;
		}
	}

	Scaler = TransitionTime / TransitionDuration;
	if (TimeRemaining < 1.0)
	{
		FlashAlpha = TimeRemaining;
	}
	else
	{
		FlashAlpha = (TimeRemaining <= WarningTime) ? 0.25 + (0.75*abs(cos(TimeRemaining))) : 1.0;
	}

	Scaler = 1.0 + (12 * Scaler);
	XPos = (Canvas.ClipX * 0.025);
	

	// Draw the Time Remaining;
    TimeRemainingAsInt = Max(0, int(TimeRemaining+1));
	TimeRemainingAsString =("Boost Time Remaining:" @ TimeRemainingAsInt);
    
	Canvas.SetPos(XPos+20 * ResolutionScale, YPos+20 * ResolutionScale);
	XPos += (35 * ResolutionScale);
	YPos -= 50 * ResolutionScale;
	Canvas.Font=MultiFont'UI_Fonts.MultiFonts.MF_HudHuge';
	Canvas.SetDrawColor(255,255,255,255*FlashAlpha);
	Canvas.DrawText(TimeRemainingAsString,,0.25,0.25);



}

/**Set things back to normal when the powerup ends*/

function ItemRemovedFromInvManager()
{
	local UTPlayerReplicationInfo UTPRI;
	local RicoPawn P;
	P = RicoPawn(Owner);

//Toggle off the FreezeShot Bool
	P.bPowerupFreezeShot = False;

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
		
		PowerupStatName=POWERUPTIME_SPREADFIRE

	Begin Object Class=StaticMeshComponent Name=MeshComponentA
		StaticMesh=StaticMesh'KismetGame_Assets.Meshes.SM_MuzzleFlash_01'
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		bAcceptsLights=true
		CollideActors=false
		BlockRigidBody=false
		Scale3D=(X=0.5,Y=0.5,Z=0.5)
		MaxDrawDistance=8000
		Translation=(X=0.0,Y=0.0,Z=-30.0)
	End Object
	DroppedPickupMesh=MeshComponentA
	PickupFactoryMesh=MeshComponentA

	Begin Object Class=UTParticleSystemComponent Name=PickupParticles
		Template=ParticleSystem'Pickups.WeaponBase.Effects.P_Pickups_WeaponBase_Glow'
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


	PP_Scene_Highlights=(X=-0.1,Y=0.04,Z=-0.2)


	TimeRemaining=10.0
	bDelayedSpawn=false

	RespawnTime=5.0
}
