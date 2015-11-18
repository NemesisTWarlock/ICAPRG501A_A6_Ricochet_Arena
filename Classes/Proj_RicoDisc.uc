/**
 * Uses Rocket Projectile Code, Copyright 1998-2015 Epic Games, Inc. All Rights Reserved.
 */

class Proj_RicoDisc extends UTProjectile;

var int NumBounces;
var int MaxBounces;


simulated function PostBeginPlay()
{
local RicoPawn P;

P = RicoPawn(Instigator);

	//Weapon Projectile Perks


	if ( P.bPerkVelocity == True )
	{ 
		Speed = 15000;
		MaxSpeed = 15000;
		//`log("Projectile Speed should be 15000, is currently" @ Speed);
		//`log("Projectile Max Speed should be 15000, is currently" @ MaxSpeed);
	}
	else
	{
		Speed = 900;
		MaxSpeed = 900;
		//`log("Projectile Speed should be 900, is currently" @ Speed);
		//`log("Projectile Max Speed should be 900, is currently" @ MaxSpeed);
	}

	if ( P.bPerkBounce == True )
	{
		MaxBounces = 6;
		//`log("Projectile Max Bounce count should be 6, is currently" @ MaxBounces);
	}
	else
	{
		MaxBounces = 3;
		//`log("Projectile Max Bounce count should be 3, is currently" @ MaxBounces);
	}

	Super.PostBeginPlay();
}

//Make the Disc Bounce

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	//Increase the Projectile Speed by 25%
	Velocity = Velocity * 1.25;

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


simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	//Check if the Pawn hit is not the instigator
    if ( Other != Instigator && Other != None )
    {
		// If not, Push the Pawn;
        Other.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		//Spawn a Particle Effect;
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, Location); 
		//And then Destroy the Projectile.
        Destroy();
    }
	else
		//If the Instigator /is/ hit by their own projectile,
    {  
		//Add an ammo unit back to their Weapon;
		UTWeapon(Pawn(Other).Weapon).AddAmmo (1);
		//And Destroy the Projectile.
		Destroy();
	}
}
 

 

defaultproperties
{	
	//Increase Collision radius slightly
	Begin Object Name=CollisionCylinder
        CollisionRadius=8
        CollisionHeight=16
    End Object

	ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'

	DecalWidth=128.0
	DecalHeight=128.0
	Speed=900.0
	MaxSpeed=900.0
	Damage=0.0
	DamageRadius=0.0
	MomentumTransfer=65000
	MyDamageType=class'UTDmgType_Rocket'
	LifeSpan=10.0


	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	RotationRate=(Roll=50000)
	bCollideWorld=true
	CheckRadius=42.0
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	bBounce=true
	
	//Set Max and Number of bounces
	MaxBounces=3
	NumBounces=0

	bWaitForEffects=true
	bAttachExplosionToVehicles=false

	//Allow the projectile to collide with it's instigator
	bBlockedByInstigator=True
}
