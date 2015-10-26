class RicoPawn extends UTPawn;

/** The Ricochet Arena Player Pawn. 
 * This will contain Extentions of UTPawn Functions to change various things as noted in the Technical Design Doc.
 */

/** Check for player Dodging */
var bool bCanDodge; 



/**Disable Directional Dodge*/
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
	//Set Default Walking Speed
	GroundSpeed=200

}
