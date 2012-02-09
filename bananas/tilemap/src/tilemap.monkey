Strict

Import flixel
Import playstate
Import assets

Import flixel.flxtext.driver.angelfont

Class Tilemap Extends FlxGame

	Method New()
		Super.New(400, 300, PlayState.ClassObject)
	End Method
	
	Method OnContentInit:Void()
		FlxAssetsManager.AddImage(Assets.ALT_TILES, "alt_tiles.png")
		FlxAssetsManager.AddImage(Assets.AUTO_TILES, "auto_tiles.png")
		FlxAssetsManager.AddImage(Assets.EMPTY_TILES, "empty_tiles.png")
		FlxAssetsManager.AddImage(Assets.PLAYER, "spaceman.png")
		
		FlxAssetsManager.AddString(Assets.ALT_MAP, "default_alt.txt")
		FlxAssetsManager.AddString(Assets.AUTO_MAP, "default_auto.txt")
		FlxAssetsManager.AddString(Assets.EMPTY_MAP, "default_empty.txt")
		
		FlxTextAngelFontDriver.Init()
		FlxText.SetDefaultDriver(AngelfontTextDriver)
	End Method

End Class