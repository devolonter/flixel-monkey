Strict

Import flixel

Function Main:Int()
	New Sprites()
	Return 0
End Function

Class Sprites Extends FlxGame
	
	Method New()
		Super.New(640, 480, SpritesState.ClassObject)
		FlxG.VisualDebug = True
	End Method

End Class

Class SpritesStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New SpritesState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (SpritesState(object) <> Null)
	End Method

End Class

Class SpritesState Extends FlxState

	Global ClassObject:FlxClass = new SpritesStateClass()
	
	Field sprite:FlxSprite
	
	Method Create:Void()		
		sprite = New FlxSprite(FlxG.Width / 2, FlxG.Height / 2)
		sprite.LoadGraphic("flx_default", False, True)
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