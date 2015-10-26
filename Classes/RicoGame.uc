class RicoGame extends UTGame;


/** The Base GameInfo for Ricochet Arena. it should handle Inventory Management, Weapon Perks, and Scoring. */



DefaultProperties
{
	//Sets Default Pawn to RicoPawn
	DefaultPawnClass=class'Ricochet_Arena.Ricopawn'

	//Remove PhysGun, Set default Weapon to Disc Launcher
	bGivePhysicsGun=False
	DefaultInventory[0]=class'Ricochet_Arena.RicoDiscLauncher'

	//Sets Classic HUD
	bUseClassicHUD=True
}