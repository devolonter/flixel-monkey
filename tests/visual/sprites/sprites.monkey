Strict

Import flixel

#REFLECTION_FILTER="sprites*|flixel*"

Function Main:Int()
	New Sprites()
	Return 0
End Function

Class Sprites Extends FlxGame
	
	Method New()
		Super.New(640, 480, GetClass("SpritesState"))
		FlxG.VisualDebug = True
	End Method

End Class

Class SpritesState Extends FlxState
	
	Field sprite:FlxSprite
	
	Method Create:Void()		
		sprite = New FlxSprite(FlxG.Width / 2, FlxG.Height / 2)
		sprite.LoadGraphic("default_flx", False, True)
		sprite.x -= sprite.width *.5
		sprite.y -= sprite.height *.5
		sprite.angle = 45
		sprite.scale.x = 2
		sprite.scale.y = 2
		
		Add(sprite)		
	End Method
	
	Method Update:Void()
		If (FlxG.Keys.JustPressed(KEY_RIGHT)) Then
			sprite.Facing = FlxObject.RIGHT
		End If
		
		If (FlxG.Keys.JustPressed(KEY_LEFT)) Then
			sprite.Facing = FlxObject.LEFT
		End If
	
		Super.Update()
	End Method
	
End Class