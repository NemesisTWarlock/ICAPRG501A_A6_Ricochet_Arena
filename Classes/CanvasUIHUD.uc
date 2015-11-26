//SHOULD NOT BE USING THIS. CODE MUST BE POINTING TO RICOHUD CLASS.

class CanvasUIHUD extends UDKHUD;

var const Texture2D CursorTexture;

var CanvasUI_Scene CurrentScene;
var array<class<CanvasUI_Scene> > UIScene_Stack;

function PushStack(class<CanvasUI_Scene> SceneClass)
{
	UIScene_Stack.AddItem(SceneClass);

	CurrentScene = new() SceneClass;
	CurrentScene.InitMenuScene(PlayerOwner.PlayerInput);
}

function PopStack()
{
	UIScene_Stack.Remove(UIScene_Stack.Length - 1, 1);

	if (UIScene_Stack.Length > 0)
	{
		CurrentScene = new() UIScene_Stack[UIScene_Stack.Length - 1];
		CurrentScene.InitMenuScene(PlayerOwner.PlayerInput);
	}
}

event PostRender()
{
	local CanvasUIPlayerInput CanvasUIPlayerInput;

	// Ensure that we have a valid PlayerOwner and CursorTexture
	if (PlayerOwner != None && CursorTexture != None && UIScene_Stack.Length > 0) 
	{
		// Cast to get the MouseInterfacePlayerInput
		CanvasUIPlayerInput = CanvasUIPlayerInput(PlayerOwner.PlayerInput);

		if (CanvasUIPlayerInput != None)
		{
			// To retrieve/use the mouse  position
			CanvasUIPlayerInput.MousePosition.X = Clamp(CanvasUIPlayerInput.MousePosition.X, 0, Canvas.ClipX);
			CanvasUIPlayerInput.MousePosition.Y = Clamp(CanvasUIPlayerInput.MousePosition.Y, 0, Canvas.ClipY);

			if (UIScene_Stack.Length > 0)
				CurrentScene.RenderScene(Canvas, WorldInfo.RealTimeSeconds);

			// Set the canvas position to the mouse position
			Canvas.SetPos(CanvasUIPlayerInput.MousePosition.X, CanvasUIPlayerInput.MousePosition.Y);
			// Draw the texture on the screen
			Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
		}
	}

	Super.PostRender();
}

DefaultProperties
{
	CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
}