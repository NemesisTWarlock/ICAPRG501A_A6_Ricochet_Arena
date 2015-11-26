/** Extends UTPlayerInput to Enable the CanvasUI System. */
class RicoPlayerInput extends UTPlayerInput within RicoPlayerController;

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