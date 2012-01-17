Strict

Import flixel

Function Main:Int()
	New Sprites()
	Return 0
End Function

Class Sprites Extends FlxGame
	
	Method New()
		Super.New(640, 480, SpritesState._class)
		FlxG.visualDebug = True
	End Method

End Class

Class SpritesStateClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New SpritesState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (SpritesState(object) <> Null)
	End Method

End Class

Class SpritesState Extends FlxState

	Global _class:FlxClass = new SpritesStateClass()
	
	Field sprite:FlxSprite
	
	Method Create:Void()		
		sprite = New FlxSprite(FlxG.width / 2, FlxG.height / 2)
		sprite.LoadGraphic("flx_default", False, True)
		sprite.x -= sprite.width *.5
		sprite.y -= sprite.height *.5
		sprite.angle = 45
		sprite.scale.x = 2
		sprite.scale.y = 2
		
		Add(sprite)		
	End Method
	
	Method Update:Void()
		If (KeyHit(KEY_RIGHT)) Then
			sprite.Facing = FlxObject.RIGHT
		End If
		
		If (KeyHit(KEY_LEFT)) Then
			sprite.Facing = FlxObject.LEFT
		End If
	
		Super.Update()
	End Method
	
End Class