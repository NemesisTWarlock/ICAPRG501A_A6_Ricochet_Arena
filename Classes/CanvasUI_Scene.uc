class CanvasUI_Scene extends Object
	dependson(Canvas);

var() instanced array<CanvasUI_Object> UIObjects;
var() font SceneFont;

var const string SceneName;

var bool bDoNotDeinit;
var bool bSceneDisabled;
var array<string> CLI_Commands;

var PlayerInput InputOwner;

/**
 * Initialise this Menu Scene
 *
 * @param PlayerInput - The PlayerInput that owns the Canvas
 */
event InitMenuScene(PlayerInput PlayerInput)
{
	local CanvasUI_Object CanvasObject;

	InputOwner = PlayerInput;
	CLI_Commands.Length = UIObjects.Length;

	ForEach UIObjects(CanvasObject)
	{
		CanvasObject.InitMenuObject(InputOwner,self);
	}
}

/**
 * Deinitialise this Menu Scene
 *
 * @param bExecuteCommands - Defaults to False, executes all commands on deinitialise scene
 */
event DeinitMenuScene(optional bool bExecuteCommands = false)
{
	local string CLI_Command;
	local array<string> CLI_ParsedCommands;

	if (bDoNotDeinit)
		return;

	if (bExecuteCommands)
	{
		ForEach CLI_Commands(CLI_Command)
		{
			// Use the pipe (|) command to delimit many commands in one string
			ParseStringIntoArray(CLI_Command, CLI_ParsedCommands, "|", true);

			ForEach CLI_ParsedCommands(CLI_Command)
			{
				if (CLI_Command != "")
					InputOwner.Outer.ConsoleCommand(CLI_Command);
			}
		}
	}

	CLI_Commands.Length = 0;
}

/**
 * Render the scene
 *
 * @param Canvas - the canvas object for drawing
 */
function RenderScene(Canvas Canvas, float RealWorldTime)
{
	local CanvasUI_Object CanvasObject;
	local IntPoint MousePos;

	MousePos = RicoPlayerInput(InputOwner).MousePosition;
	RicoPlayerController(InputOwner.Outer).HoverObject = None;

	ForEach UIObjects(CanvasObject)
	{
		if (CanvasObject != None)
		{
			CanvasObject.DrawObject(Canvas);

			if (!bSceneDisabled && CanvasObject.bIsActive)
				CanvasObject.CheckBounds(MousePos.X, MousePos.Y);
		}
	}
}

defaultproperties
{
	SceneFont=Font'enginefonts_rus.SmallFont'
}