Strict

Import flixel
Import playstate
Import assets

Import flixel.flxtext.driver.angelfont

Class Collisions Extends FlxGame

	Method New()
		Super.New(400, 300, PlayState.ClassObject)
	End Method
	
	Method OnContentInit:Void()
		FlxAssetsManager.AddImage(Assets.CRATE, "crate.png")
		FlxAssetsManager.AddImage(Assets.ELEVATOR, "elevator.png")
		FlxAssetsManager.AddImage(Assets.FLIXEL_LOGO, "flixel_logo.png")
		
		FlxTextAngelFontDriver.Init()
		FlxText.SetDefaultDriver(AngelfontTextDriver)
	End Method

End Class