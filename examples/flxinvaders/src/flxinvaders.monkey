Strict

Import flixel

Import playstate
Import playership
Import alien

Class FlxInvaders Extends FlxGame
	
	Method New()		
		Super.New(320, 240, PlayState._class)
	End Method
	
	Method OnContentInit:Void()
		'Register assets
		FlxAssetsManager.AddImage(PlayerShip.IMAGE_SHIP, "ship.png")
		FlxAssetsManager.AddImage(Alien.IMAGE_ALIEN, "alien.png")
	End Method

End Class