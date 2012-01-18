Strict

Import flixel

Import assets

Class PlayerShip Extends FlxSprite

Private
	Field _bullets:FlxGroup

Public	
	Method New(bullets:FlxGroup)
		Super.New(FlxG.width/2 - 6, FlxG.height - 12, Assets.IMAGE_PLAYER_SHIP)
		_bullets = bullets
	End Method
	
	Method Update:Void()
		velocity.x = 0
		
		If (KeyDown(KEY_LEFT) Or AccelX() < -.2) Then
			velocity.x -= 150
		End If
		
		If (KeyDown(KEY_RIGHT) Or AccelX() > .2) Then
			velocity.x += 150
		End If
			
		Super.Update()
		
		If (x > FlxG.width-width-4) Then
			x = FlxG.width-width-4
		End If
			
		If (x < 4) Then
			x = 4
		End If
		
		If (KeyHit(KEY_SPACE) Or TouchHit()) Then
			Local bullet:FlxSprite = FlxSprite(_bullets.Recycle())		
			bullet.Reset(x + width / 2 - bullet.width / 2, y)
			bullet.velocity.y = -140
		End If
	End Method

End Class