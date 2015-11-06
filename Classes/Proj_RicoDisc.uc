/**
 * Uses Rocket Projectile Code, Copyright 1998-2015 Epic Games, Inc. All Rights Reserved.
 */

class Proj_RicoDisc extends UTProjectile;

var int NumBounces;
var int MaxBounces;

simulated function PostBeginPlay()
{
	// force ambient sound if not vehicle game mode
	bImportantAmbientSound = !WorldInfo.bDropDetail;
	Super.PostBeginPlay();
}

//Make the Disc Bounce

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	//Bounce the Projectile
    Velocity = MirrorVectorByNormal(Velocity,HitNormal);
    SetRotation(Rotator(Velocity));

	//Check if bounce is under MaxBounces. if so, explode, otherwise increment NumBounces
	if (NumBounces >= MaxBounces)
	{
		explode(Location, HitNormal);
	}
	else
	{
		Numbounces++;
	}

}

//When Hitting another pawn, Push the Pawn, then Destroy the projectile
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if ( Other != Instigator && Other != None )
    {
        Other.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, Location); 
        Destroy();
    }
	else
    {  
		UTWeapon(Pawn(Other).Weapon).AddAmmo (1);
		Destroy();
	}
}
 

 

defaultproperties
{	//increase Collision radius slightly
	Begin Object Name=CollisionCylinder
        CollisionRadius=8
        CollisionHeight=16
    End Object

	ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'

	DecalWidth=128.0
	DecalHeight=128.0
	speed=900.0
	MaxSpeed=900.0
	Damage=0.0
	DamageRadius=0.0
	MomentumTransfer=65000
	MyDamageType=class'UTDmgType_Rocket'
	LifeSpan=8.0


	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	RotationRate=(Roll=50000)
	bCollideWorld=true
	CheckRadius=42.0
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	bBounce=true
	
	//set Max bounces
	MaxBounces=3
	NumBounces=0

	bWaitForEffects=true
	bAttachExplosionToVehicles=false
	//Allow projectile to collide with insigator
	bBlockedByInstigator=True
}
