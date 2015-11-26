/** Extends UTPlayerController to provide Support for the CanvasUI System. */

class RicoPlayerController extends UTPlayerController;



var CanvasUI_Object HoverObject;

exec function StartFire(optional byte FireModeNum)
{
	if (RicoHUD(myHud) != None && RicoHUD(myHud).UIScene_Stack.Length > 0 && HoverObject != None)
	{
		// FireModeNum=0 (Left Click), FireModeNum=1 (Right Click)
		HoverObject.ActivateObject(FireModeNum);
	}
	else
	{
		super.StartFire(FireModeNum);
	}
}

DefaultProperties
{
	InputClass=class'RicoPlayerInput'
}