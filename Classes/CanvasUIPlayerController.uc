//SHOULD NOT BE IN USE. PLEASE REFER TO RICOPLAYERCONTROLLER CLASS.

class CanvasUIPlayerController extends UDKPlayerController;

var CanvasUI_Object HoverObject;

exec function StartFire(optional byte FireModeNum)
{
	if (CanvasUIHUD(myHud) != None && CanvasUIHUD(myHud).UIScene_Stack.Length > 0 && HoverObject != None)
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
	InputClass=class'CanvasUIPlayerInput'
}