Strict

Import flixel
Import playstate
Import assets

Import flixel.flxtext.driver.angelfont

Class PathFinding Extends FlxGame

	Method New()
		Super.New(400, 300, PlayState.ClassObject)
	End Method
	
	Method OnContentInit:Void()
		FlxAssetsManager.AddImage(Assets.TILES, "tiles.png")
		FlxAssetsManager.AddString(Assets.MAP, "pathfinding_map.txt")
		
		FlxTextAngelFontDriver.Init()
		FlxText.SetDefaultDriver(AngelfontTextDriver)
	End Method

End Class