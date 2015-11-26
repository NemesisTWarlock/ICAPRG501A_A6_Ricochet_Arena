class CanvasUI_ObjectBack extends CanvasUI_Object;

var bool bSaveAndApply;

function ActivateObject(optional byte MouseInput = 0)
{
	if (!OwnerScene.bSceneDisabled && bIsActive && bIsHighlighted)
	{
		RicoHUD(InputOwner.Outer.myHud).PopStack();

		if (bSaveAndApply)
			super.ActivateObject(MouseInput);
	}
}

DefaultProperties
{
	bIsActive=true
	bActivateCommandImmediately=true
}