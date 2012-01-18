Strict

Import flixel

Import playstate
Import playership
Import alien
Import assets

Class FlxInvaders Extends FlxGame
	
	Method New()		
		Super.New(320, 240, PlayState._CLASS)
	End Method
	
	Method OnContentInit:Void()
		'Register assets
		FlxAssetsManager.AddImage(Assets.IMAGE_PLAYER_SHIP, "ship.png")
		FlxAssetsManager.AddImage(Assets.IMAGE_ALIEN_SHIP, "alien.png")
	End Method

End Class