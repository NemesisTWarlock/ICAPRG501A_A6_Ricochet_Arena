class CanvasUI_SceneTestOptions extends CanvasUI_Scene;

defaultproperties
{
	Begin Object Class=CanvasUI_ObjectBack Name=Test0
		ObjectName="Back"

		Position=(X=300,Y=50)
		Size=(X=100,Y=100)

		Caption="This button will go back in the stack!"
		CaptionScale=(X=1.5,Y=1.5)
		CaptionColor = (R=1.0,G=1.0,B=1.0,A=1.0)

		Images(0)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_D_Disp'
		Images(1)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_N'
		ImagesUVs(0)=(bCustomCoords=true,U=366,V=140,UL=260,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=366,V=195,UL=260,VL=48)
	End Object
	UIObjects.Add(Test0)

	Begin Object Class=CanvasUI_ObjectBack Name=Test1
		ObjectName="SaveApply"

		Position=(X=300,Y=150)
		Size=(X=100,Y=100)

		Caption="This button will go back in the stack, and save and apply the changes (there's none in here)!"
		CaptionScale=(X=1.5,Y=1.5)
		CaptionColor = (R=1.0,G=1.0,B=1.0,A=1.0)

		Images(0)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_D_Disp'
		Images(1)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_N'
		ImagesUVs(0)=(bCustomCoords=true,U=366,V=140,UL=260,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=366,V=195,UL=260,VL=48)

		bSaveAndApply=true
	End Object
	UIObjects.Add(Test1)

	Begin Object Class=CanvasUI_Object Name=Test2
		ObjectName="Test"

		Position=(X=300,Y=250)
		Size=(X=100,Y=100)

		Caption="This button will quit the game!"
		CaptionScale=(X=1.5,Y=1.5)
		CaptionColor = (R=1.0,G=1.0,B=1.0,A=1.0)

		Images(0)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_D_Disp'
		Images(1)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_N'
		ImagesUVs(0)=(bCustomCoords=true,U=366,V=140,UL=260,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=366,V=195,UL=260,VL=48)

		bIsActive=true
		bActivateCommandImmediately=true
		ActivateCommand="quit"
	End Object
	UIObjects.Add(Test2)
}