class RicoPawn extends UTPawn;

/** The Ricochet Arena Player Pawn. 
 * This will contain Extentions of UTPawn Functions to change various things as noted in the Technical Design Doc.
 */

/** Check for player Dodging */
var bool bCanDodge; 
var int HeadShotDamage;



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




DefaultProperties
{
	//Disable Double Jumping
	MaxMultiJump=0

	//Set Default Walking Speed
	GroundSpeed=200

	//Damage on Headshot (Keep this big enough to instantly kill the pawn)
	HeadshotDamage=1000

}
