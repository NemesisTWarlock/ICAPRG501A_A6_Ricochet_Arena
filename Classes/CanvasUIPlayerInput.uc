//DO NOT USE. REFER TO RICOPLAYERINPUT. 
class CanvasUIPlayerInput extends UDKPlayerInput within CanvasUIPlayerController;

var IntPoint MousePosition;

event PlayerInput(float DeltaTime)
{
	MousePosition.X = MousePosition.X + aMouseX;
	MousePosition.Y = MousePosition.Y - aMouseY;

	Super.PlayerInput(DeltaTime);
}

DefaultProperties
{
}