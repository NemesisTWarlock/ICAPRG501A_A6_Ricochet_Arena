class RicoGame extends UTGame;


/** The Base GameInfo for Ricochet Arena. it should handle Inventory Management, Weapon Perks, and Scoring. */




//Kill Scoring
function ScoreKill(Controller Killer, Controller Other)
{
	if ( (Killer == Other) || (Killer == None ) )
		{   //If kill is a Suicide - 
			if ( (Other!=None) && (Other.PlayerReplicationInfo != None) )
			{ //Remove a point
				Other.PlayerReplicationInfo.Score -= 1;
				Other.PlayerReplicationInfo.bForceNetUpdate = True;
			}
		}

		Else if (killer.PlayerReplicationInfo != None) 
		{
			//Set point score for standard kills to 2
			killer.PlayerReplicationInfo.Score += 2;
			Killer.PlayerReplicationInfo.bForceNetUpdate = True;
			Killer.PlayerReplicationInfo.Kills++;
		}




		ModifyScoreKill (Killer, Other);

		if (Killer != None || Maxlives > 0)
		{
			CheckScore(Killer.PlayerReplicationInfo);
		}


}




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