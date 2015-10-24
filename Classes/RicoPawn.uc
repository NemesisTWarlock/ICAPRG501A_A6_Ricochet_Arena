class RicoPawn extends UTPawn;

/* The Ricochet Arena Player Pawn. 
 * This will contain Extentions of UTPawn Functions to change various things as noted in the Technical Design Doc.
 */

//Variables Setup
var bool bCanDodge; //Checks for player Dodging




//Disable Directional Dodge


function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	if(bCanDodge)
		return super.Dodge(DoubleClickMove);

	return false;
}





DefaultProperties
{
	//Disable Double Jumping
	MaxMultiJump=0
	//Change Walking Speed
	GroundSpeed=200

}
