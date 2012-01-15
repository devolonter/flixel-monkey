Strict

Import flixel

Class PlayerShip Extends FlxSprite	
	
	Const IMAGE_SHIP:String = "ship"
	
	Method New()
		Super.New(FlxG.width/2 - 6, FlxG.height - 12, IMAGE_SHIP)
	End Method
	
	Method Update:Void()
		velocity.x = 0
		
		If (KeyDown(KEY_LEFT) Or (TouchDown() And TouchX() <= FlxG.deviceWidth / 2)) Then
			velocity.x -= 150
		End If
		
		If (KeyDown(KEY_RIGHT) Or (TouchDown() And TouchX() > FlxG.deviceWidth / 2)) Then
			velocity.x += 150
		End If
			
		Super.Update()
		
		If (x > FlxG.width-width-4) Then
			x = FlxG.width-width-4
		End If
			
		If (x < 4) Then
			x = 4
		End if
		If (KeyHit(KEY_SPACE)) Then

		End If
	End Method

End Class