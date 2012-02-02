Strict

Import flixel

Function Main:Int()
	New Emitter()
	Return 0
End Function

Class Emitter Extends FlxGame
	
	Method New()
		Super.New(640, 480, EmitterState.ClassObject)	
	End Method

End Class

Class EmitterState Extends FlxState

	Global ClassObject:FlxClass = new EmitterStateClass()
	
	Field theEmitter:FlxEmitter
	
	Field collisionGroup:FlxGroup
	Field wall:FlxSprite
	Field floor:FlxSprite

	Field whitePixel:FlxParticle
	
	Method Create:Void()		
		theEmitter = New FlxEmitter(FlxG.width / 2 - 50, FlxG.height / 2, 200)		
		theEmitter.SetXSpeed(100, 200)
		theEmitter.SetYSpeed( -50, 50)
		theEmitter.bounce = .8
		
		Add(theEmitter)
		
		Local l:Int = theEmitter.MaxSize
		For Local i:Int = 0 Until l
			whitePixel = New FlxParticle()
			whitePixel.MakeGraphic(2 + Ceil(FlxG.Random() * 2), 2 + Ceil(FlxG.Random() * 2))
			whitePixel.visible = False
			theEmitter.Add(whitePixel)
		Next
		
		theEmitter.Start(false, 3, .01)
		
		collisionGroup = New FlxGroup()
		
		wall= New FlxSprite(FlxG.width / 2 + 50, FlxG.height / 2 - 50)
		wall.MakeGraphic(10, 100, $FF555555)
		wall.visible = False
		wall.Solid = False
		wall.immovable = True
		
		floor = New FlxSprite(10, FlxG.height - 50)
		floor.MakeGraphic(FlxG.width - 20, 10, $FF555555)
		floor.visible = False
		floor.Solid = False
		floor.immovable = True
		
		collisionGroup.Add(wall)
		collisionGroup.Add(floor)
		
		Add(collisionGroup)
	End Method
	
	Method Update:Void()
		If (FlxG.keys.JustPressed(KEY_G) Or FlxG.Touch().JustPressed) Then
			If (theEmitter.gravity = 0) Then
				theEmitter.gravity = 200
			Else
				theEmitter.gravity = 0
			End If
		End If
		
		If (FlxG.keys.JustPressed(KEY_W) Or FlxG.Touch(1).JustPressed) Then
			If (Not wall.visible) Then
				wall.Solid = True
				wall.visible = True
			Else
				wall.Solid = False
				wall.visible = False
			End If
		End If
		
		If (FlxG.keys.JustPressed(KEY_F) Or FlxG.Touch(2).JustPressed) Then
			If (Not floor.visible) Then
				floor.Solid = True
				floor.visible = True
			Else
				floor.Solid = False
				floor.visible = False
			End If
		End If
		
		Super.Update()
		FlxG.Collide(theEmitter, collisionGroup)
	End Method
	
End Class

Private
Class EmitterStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New EmitterState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (EmitterState(object) <> Null)
	End Method

End Class