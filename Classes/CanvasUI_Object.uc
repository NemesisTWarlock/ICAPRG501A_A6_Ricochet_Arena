class CanvasUI_Object extends Object
	dependson(Canvas);

var const string ObjectName;

struct UVCoords
{
	var bool bCustomCoords;

	/** The UV coords. */
	var float U;
	var float V;
	var float UL;
	var float VL;
};

/** The position and size of the object. */
var Vector2D Position;
var Vector2D Size;

/** The 2 images that make up the button.  [0] = the unhover, [1] = hover */
var Texture2D Images[2];
/** The UV Coordinates for the images.  [0] = the unhover, [1] = hover */
var UVCoords ImagesUVs[2];

/** A reference to the input owner */
var PlayerInput InputOwner;
/** The scene this object is in */
var CanvasUI_Scene OwnerScene;

/** Is this object active to the mouse */
var bool bIsActive;
/** The console command to use if object is active */
var string ActivateCommand;
/** If not a console command, link to scene */
var class<CanvasUI_Scene> ActivateScene;
/** Active the command immediately */
var bool bActivateCommandImmediately;

/** If true, this control is highlighted */
var bool bIsHighlighted;

/** Caption for the Object */
var string Caption;
var Vector2D CaptionScale;

/** Holds the Colour for the caption */
var LinearColor CaptionColor;

/**
 * Initialise the scene object
 *
 * @param PlayerInput - the reference to the input owner
 * @param Scene - the reference to the owner scene
 */
function InitMenuObject(PlayerInput PlayerInput, CanvasUI_Scene Scene)
{
	local int i;

	InputOwner = PlayerInput;
	OwnerScene = Scene;

	for (i = 0; i < 2; i++)
	{
		if (!ImagesUVs[i].bCustomCoords && Images[i] != none)
		{
			ImagesUVs[i].U = 0.0f;
			ImagesUVs[i].V = 0.0f;
			ImagesUVs[i].UL = Images[i].SizeX;
			ImagesUVs[i].VL = Images[i].SizeY;
		}
	}
}

/**
 * Check the bounds of the current object, if mouse within, highlight it and
 * tell PlayerController the hoverobject
 *
 * @param MousePositionX - the clamped X position of the mouse
 * @param MousePositionY - the clamped Y position of the mouse
 */
function bool CheckBounds(float MousePositionX, float MousePositionY)
{
	local Vector2D FinalRange;

	if (bIsActive == true)
	{
		FinalRange = Position + Size;

		//CheckMousePositionWithinBounds
		if (MousePositionX >= Position.X && MousePositionX <= FinalRange.X && MousePositionY >= Position.Y && MousePositionY <= FinalRange.Y)
		{
			bIsHighlighted = true;
			RicoPlayerController(InputOwner.Outer).HoverObject = self;
			return true;
		}
		else
		{
			bIsHighlighted = false;
			return false;
		}
	}
}

/**
 * Activate object will be called on mouse click
 */
function ActivateObject(optional byte MouseInput = 0)
{
	local int i;
	local CanvasUI_Object UIObject;

	if (!OwnerScene.bSceneDisabled && bIsActive && bIsHighlighted)
	{
		if (ActivateCommand != "" && bActivateCommandImmediately)
		{
			InputOwner.Outer.ConsoleCommand(ActivateCommand);
		}
		else if (ActivateCommand != "" && !bActivateCommandImmediately)
		{
			ForEach OwnerScene.UIObjects(UIObject, i)
			{
				if (UIObject == self && OwnerScene.CLI_Commands.Length > i)
				{
					OwnerScene.CLI_Commands[i] = ActivateCommand;
					break;
				}
			}
		}
		else if (ActivateScene != None)
		{
			RicoHUD(InputOwner.Outer.myHUD).PushStack(ActivateScene);
		}
	}
}

/**
 * Render the optional caption on top of the widget
 *
 * @param Canvas - the canvas object for drawing
 */
function RenderCaption(canvas Canvas)
{
	local float X, Y, UL, VL;

	if (Caption != "")
	{
		Canvas.Font = OwnerScene.SceneFont;
		Canvas.TextSize(Caption, UL, VL, CaptionScale.X, CaptionScale.Y);

		X = Position.X + Size.X / 2 - UL / 2;
		Y = Position.Y + Size.Y / 2 - VL / 2;

		Canvas.SetPos(X, Y);

		Canvas.DrawColor.R = byte(CaptionColor.R * 255.0);
		Canvas.DrawColor.G = byte(CaptionColor.G * 255.0);
		Canvas.DrawColor.B = byte(CaptionColor.B * 255.0);

		if (bIsHighlighted)
			Canvas.DrawColor.A = byte(CaptionColor.A * 255.0);
		else
			Canvas.DrawColor.A = byte(CaptionColor.A * 255.0) * 3 / 4;

		Canvas.DrawText(Caption,, CaptionScale.X, CaptionScale.Y);
	}
}

function DrawObject(Canvas Canvas)
{
	local int Idx;
	local LinearColor DrawColor;

	//Switch Texture when highlighted
	Idx = (bIsHighlighted) ? 1 : 0;
	DrawColor.R = 1.0;
	DrawColor.G = 1.0;
	DrawColor.B = 1.0;
	DrawColor.A = 1.0;

	Canvas.SetPos(Position.X, Position.Y);

	if (Images[Idx] != None)
		Canvas.DrawTile(Images[Idx], Size.X, Size.Y, ImagesUVs[Idx].U, ImagesUVs[Idx].V, ImagesUVs[Idx].UL, ImagesUVs[Idx].VL, DrawColor);

	RenderCaption(Canvas);
}

defaultproperties
{
}