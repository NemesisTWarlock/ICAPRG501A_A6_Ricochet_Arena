class RicoUIScene_MainMenu extends CanvasUI_Scene;

DefaultProperties
{
	Begin Object Class=CanvasUI_Object Name=Test0
		ObjectName="Test"

		Position=(X=300,Y=50)
		Size=(X=100,Y=100)

		Caption="This button will go to the options scene"
		CaptionScale=(X=1.5,Y=1.5)
		CaptionColor = (R=1.0,G=1.0,B=1.0,A=1.0)

		Images(0)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_D_Disp'
		Images(1)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_N'
		ImagesUVs(0)=(bCustomCoords=true,U=366,V=140,UL=260,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=366,V=195,UL=260,VL=48)

		bIsActive=true
		bActivateCommandImmediately=true
		ActivateScene=class'CanvasUI_SceneTestOptions'
	End Object
	UIObjects.Add(Test0)

	Begin Object Class=CanvasUI_Object Name=Test1
		ObjectName="Test"

		Position=(X=300,Y=150)
		Size=(X=100,Y=100)

		Caption="You're a wizard, Harry"
		CaptionScale=(X=1.5,Y=1.5)
		CaptionColor = (R=1.0,G=1.0,B=1.0,A=1.0)

		Images(0)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_D_Disp'
		Images(1)=Texture2D'LandscapeMobileMat.Textures.LS_Snow_01_N'
		ImagesUVs(0)=(bCustomCoords=true,U=366,V=140,UL=260,VL=48)
		ImagesUVs(1)=(bCustomCoords=true,U=366,V=195,UL=260,VL=48)

		bIsActive=true
		bActivateCommandImmediately=true
		ActivateCommand="CE OurConsoleEventInKismet"
	End Object
	UIObjects.Add(Test1)

	Begin Object Class=CanvasUI_Object Name=Test2
		ObjectName="Test"

		Position=(X=300,Y=350)
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