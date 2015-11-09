class RicoPawn extends UTPawn;

/** The Ricochet Arena Player Pawn. 
 * This will contain Extentions of UTPawn Functions to change various things as noted in the Technical Design Doc.
 */

/** Check for player Dodging */
var bool bCanDodge; 

/** Amount of Damage to do on a Headshot */
var int HeadShotDamage;

/** Weapon Perks */
var bool bPerkAmmo;
var bool bPerkRegen;
var bool bPerkVelocity;
var bool bPerkBounce;
var Proj_RicoDisc Projectile;



/**Disable Directional Dodge*/
function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	if(bCanDodge)
		return super.Dodge(DoubleClickMove);

	return false;
}

// Adjust damage based on angle of attack, hitlocation, armour, etc 
function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
local name HitBone;

//Find the closest Bone to the Hitlocation
HitBone = Mesh.FindClosestBone(HitLocation);

//NEXT LINE FOR TESTING ONLY
//`log("Check Adjust Damage"@HitBone ); 

//If Hitbone is the Head bone..
if( Mesh.BoneIsChildOf(HitBone, 'b_Head') || HitBone == 'b_Head' )
{

//NEXT LINE FOR TESTING ONLY
//`log("headshot");

	//BOOM, HEADSHOT!
	InDamage = HeadShotDamage;
}
//NEXT LINE FOTR TESTING ONLY
//`log("InDamage"@InDamage);


super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
}

// Weapon Perk Testing, Delete when finished (This just sets toggles for the weapon perks)

exec function TogglePerkAmmo()
{


	if(!bPerkAmmo)
	{
		bPerkAmmo=true;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);		
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
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);			
		ClientMessage("Velocity Perk ON");
	}
	else
	{
		bPerkVelocity=false;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);				
		ClientMessage("Velocity Perk OFF");
	}
}

exec function TogglePerkBounce()
{
	if(!bPerkBounce)
	{
		bPerkBounce=true;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);					
		ClientMessage("Bounce Perk ON");
	}
	else
	{
		bPerkBounce=false;
		RicoDiscLauncher(Weapon).WeaponPerk(Self, Projectile);				
		ClientMessage("Bounce Perk OFF");
	}
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
