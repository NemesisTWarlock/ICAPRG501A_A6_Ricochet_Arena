class RicoPawn extends UTPawn;

/** The Ricochet Arena Player Pawn. 
 * This will contain Extentions of UTPawn Functions to change various things as noted in the Technical Design Doc.
 */

/** Check for player Dodging */
var bool bCanDodge; 

/** Amount of Damage to do on a Headshot */
var int HeadShotDamage;

/** Weapon Perk - Ammo Count */
var bool bPerkAmmo;

/** Weapon Perk - Ammo Regen Rate */
var bool bPerkRegen;

/** Weapon Perk - Projectile Velocity */
var bool bPerkVelocity;

/** Weapon Perk - Projectile Bounce Count */
var bool bPerkBounce;

/** Spread Fire Powerup */
var bool bPowerupSpreadFire;

/** Freeze Shot Powerup */
var bool bPowerupFreezeShot;

/** Projectiles fired by the Pawn */
var Proj_RicoDisc Projectile;

/** Is the Pawn Freezing? */
var bool bIsFreezing;
/** Is the Pawn Frozen? */
var bool bIsFrozen;
/** Is the Pawn Thawing? */
var bool bIsThawing;


/** Assist Scoring Array Struct */
struct Hit
{
	var controller Shooter; //Who hit the pawn?
	var float TimeStamp; //When was it hit?
};


/** HitHistory - Keeps track of controllers who hit a Pawn, and the Time Stamp (For Assist Scoring)*/
var array<Hit> HitHistory;



/**Disable Directional Dodge*/
function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	if(bCanDodge)
		return super.Dodge(DoubleClickMove);

	return false;
}

/**Adjust damage based on angle of attack, hitlocation, armour, etc. Used here to set up Headshots.*/

function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
local name HitBone;

//Find the closest Bone to the Hitlocation
HitBone = Mesh.FindClosestBone(HitLocation);

//If Hitbone is the Head bone..
if( Mesh.BoneIsChildOf(HitBone, 'b_Head') || HitBone == 'b_Head' )
{
	//BOOM, HEADSHOT!
	InDamage = HeadShotDamage;
}

super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
}

// Weapon Perk Console Toggles

exec function TogglePerkAmmo()
{


	if(!bPerkAmmo)
	{
		bPerkAmmo=true;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);	//Calls the weapon perk Function to make sure it toggles correctly	
		ClientMessage("Ammo Perk ON");
	}
	else
	{
		bPerkAmmo=false;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);
		ClientMessage("Ammo Perk OFF");
	}
}

exec function TogglePerkRegen()
{
	if(!bPerkRegen)
	{
		bPerkRegen=true;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);		
		ClientMessage("Regen Perk ON");
	}
	else
	{
		bPerkRegen=false;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);		
		ClientMessage("Regen Perk OFF");
	}
}

exec function TogglePerkVelocity()
{
	if(!bPerkVelocity)
	{
		bPerkVelocity=true;
		
		ClientMessage("Velocity Perk ON");
	}
	else
	{
		bPerkVelocity=false;
			
		ClientMessage("Velocity Perk OFF");
	}
}

exec function TogglePerkBounce()
{
	if(!bPerkBounce)
	{
		bPerkBounce=true;
				
		ClientMessage("Bounce Perk ON");
	}
	else
	{
		bPerkBounce=false;
		
		ClientMessage("Bounce Perk OFF");
	}
}

exec function TogglePerkSpread()
{
	if(!bPowerupSpreadFire)
	{
		bPowerupSpreadFire=true;
				
		ClientMessage("Spread Powerup ON");
	}
	else
	{
		bPowerupSpreadFire=false;
		
		ClientMessage("Spread Powerup OFF");
	}
}

exec function FreezeMe()
{
	FreezePawn();
}

/** When hit, add the controller to hit the pawn and the time since level start to the HitHistory Array (For Assist Scoring)*/
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	

	local Hit LastHit;
	local int i;
//	local int HitArrayLength;
	local bool bAlreadyInArray;


//Get the True length of the Array
//	HitArrayLength= HitHistory.Length - 1; 

//Get the last controller to hit the pawn
	LastHit.Shooter = EventInstigator;

//Get the Time this occured
	LastHit.TimeStamp = WorldInfo.TimeSeconds;

// Set the Default bool for AlreadyInArray
	bAlreadyInArray = False;

//Check if the Shooter is already in the Array
	for (i=0; i < HitHistory.Length; i++)
	{
//If it is, Do not add it to the array
		if (HitHistory[i].Shooter == LastHit.Shooter)
		{
			bAlreadyInArray = True;
			break;
		}
	}

//if it's not, Add it to the Array
	if (!bAlreadyInArray)
	{
		HitHistory.AddItem(LastHit);
	}

//Freeze Shot
	if (RicoPawn(EventInstigator.Pawn).bPowerupFreezeShot == True)
		{
			FreezePawn();
		}

//Do the rest of the standard TakeDamage Event
	super.TakeDamage(Damage,EventInstigator, HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}





simulated function FreezePawn()
{
 bIsFreezing = true;
 SetTimer( 10.0, false, 'FrozenPawn' );
}

simulated function FrozenPawn()
{
	bIsFreezing = false;
	bIsFrozen = true; //Not particularly needed, but there in case I want to do something to a frozen player later, like for example, a shatterkill
	SetTimer( 1.0, false, 'ThawPawn');
}

simulated function ThawPawn()
{
 bIsFrozen = false;
 bIsThawing = true;
 SetTimer( 10.0, false);
}

simulated function Tick(float DeltaTime)
{

 if ( bIsFreezing )
 {
  GroundSpeed = FInterpTo(GroundSpeed, default.GroundSpeed * 0.25, DeltaTime, 1.5);
 }
 else if ( bIsThawing )
 {
  GroundSpeed = FInterpTo(GroundSpeed, default.GroundSpeed, DeltaTime, 1.5);
  
 }


}



simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{


/** The Time Limit for Scoring an Assist */
	local float AssistTimeLimit;
	local int i;

	//Set the Time Limit
	AssistTimeLimit = Worldinfo.TimeSeconds - 10;

	//Check if running as a Client first
	if (worldinfo.NetMode != NM_Client)
	{
	//Then Check through the Array
	for (i=0; i < HitHistory.Length; i++)
		{
			//If the timestamp of a hit in the array is less than the AssistTimeLimit;
			if (HitHistory[i].TimeStamp <= AssistTimeLimit )
				{
					//Award a Point;
					HitHistory[i].Shooter.PlayerReplicationInfo.Score += 1;
					//Force a Net Update;
					HitHistory[i].Shooter.PlayerReplicationInfo.bForceNetUpdate = True;
					//Log the Event;
					`log(HitHistory[i].Shooter @ "Scored an Assist!");
					//And then Clear the Array for the next respawn.
					HitHistory.Length = 0;
				}
		}
	}
	//Then do the rest of the standard Death functions.
	super.PlayDying(DamageType, HitLoc);
}



DefaultProperties
{
	//Disable Double Jumping
	MaxMultiJump = 0

	//Set Default Walking Speed
	GroundSpeed = 200

	//Damage on Headshot (Keep this big enough to instantly kill the pawn)
	HeadshotDamage = 1000


}
