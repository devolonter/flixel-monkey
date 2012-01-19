Strict

Import flixel
Import flixel.flxtext.driver.angelfont

Import playstate
Import playership
Import alien
Import assets

#MOJO_IMAGE_FILTERING_ENABLED="False"

Class FlxInvaders Extends FlxGame
	
	Method New()		
		Super.New(320, 240, PlayState._CLASS)
		ShowMouse()
	End Method
	
	Method OnContentInit:Void()
		FlxTextAngelFontDriver.Init()
		FlxText.SetDefaultDriver(ANGELFONT_TEXT_DRIVER)
		
		'Register assets
		FlxAssetsManager.AddImage(Assets.IMAGE_PLAYER_SHIP, "ship.png")
		FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP, "alien.png")
		
		#If TARGET = "html5"
			FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP + (FlxG.BLUE), "alien" + (FlxG.BLUE) + ".png")
			FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP + (FlxG.BLUE | FlxG.GREEN), "alien" + (FlxG.BLUE | FlxG.GREEN) + ".png")
			FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP + (FlxG.GREEN), "alien" + (FlxG.GREEN) + ".png")
			FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP + (FlxG.GREEN | FlxG.RED), "alien" + (FlxG.GREEN | FlxG.RED) + ".png")
			FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP + (FlxG.RED), "alien" + (FlxG.RED) + ".png")
	End Method

End Class