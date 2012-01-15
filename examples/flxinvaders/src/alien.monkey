Strict

Import flixel

Class Alien Extends FlxSprite

	Const IMAGE_ALIEN:String = "alien"
	
	Global ReverseVelocity:ReverseVelocityInvoker = New ReverseVelocityInvoker()
	
	Field originalX:Int
	
Private
	Field _shotClock:Float
	Field _bullets:FlxGroup
	
Public
	Method New(x:Int, y:Int, color:Int, bullets:FlxGroup)
		Super.New(x, y)
		
		LoadGraphic(IMAGE_ALIEN, True)
		Color = color
		ResetShotClock()
		originalX = x
		_bullets = bullets
		
		AddAnimation("Default", [0,1,0,2], 6 + FlxG.Random() * 4)
		Play("Default")
		
		velocity.x = 10
	End Method
	
	Method Update:Void()		
		If (y > FlxG.height * .35) _shotClock -= FlxG.elapsed
		
		If (_shotClock <= 0) Then
			ResetShotClock()
			Local bullet:FlxSprite = FlxSprite(_bullets.Recycle())
			bullet.Reset(x + width / 2 - bullet.width / 2, y)
			bullet.velocity.y = 65
		End If
	End Method
	
	Method ResetShotClock:Void()
		_shotClock = 1 + FlxG.Random() * 20
	End Method

End Class

Class ReverseVelocityInvoker Implements FlxBasicInvoker

	Method Invoke:Void(object:FlxBasic)
		Local alien:Alien = Alien(object)
		
		If (alien.velocity.x > 0) Then
			alien.x = alien.originalX + 8
		Else
			alien.x = alien.originalX - 8
		End If
		
		alien.velocity.x = -alien.velocity.x		
	End Method

End Class