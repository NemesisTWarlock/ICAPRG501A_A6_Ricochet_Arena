class CanvasUISeqAct_PushPopUIScene extends SequenceAction;

var Object Target;
var() class<CanvasUI_Scene> Scene;
var() bool bDoNotDeinitScene;

function Activated()
{
	local RicoHUD HUD;

	if (PlayerController(Target) != None && RicoHUD(PlayerController(Target).myHUD) != None)
	{
		HUD = RicoHUD(PlayerController(Target).myHUD);

		if (InputLinks[0].bHasImpulse)
			HUD.PushStack(Scene);
		else
			HUD.PopStack();

		HUD.CurrentScene.bDoNotDeinit = bDoNotDeinitScene;
	}
}

defaultproperties
{
	ObjName="Push/Pop UI Scene"
	ObjCategory="CanvasUI"

	bDoNotDeinitScene=True

	InputLinks.Empty
	InputLinks(0)=(LinkDesc="Push")
	InputLinks(1)=(LinkDesc="Pop")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target",PropertyName=Target,MaxVars=1)
}
