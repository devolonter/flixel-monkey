Strict

Import flixel

Function Main:Int()
	New Objects()
	Return 0
End Function

Class Objects Extends FlxGame
	
	Method New()
		Super.New(640, 480, ObjectsState.ClassObject)
		FlxG.VisualDebug = True
	End Method

End Class

Class ObjectsStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New ObjectsState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (ObjectsState(object) <> Null)
	End Method

End Class

Class ObjectsState Extends FlxState

	Global ClassObject:FlxClass = new ObjectsStateClass()
	
	Field blocks1:FlxGroup
	Field blocks2:FlxGroup	
	Field floor:FlxGroup
	Field sky:FlxGroup
	
	Field player:FlxObject
	
	Method Create:Void()		
		Local block:FlxObject
		Local path:FlxPath
		
		blocks1 = New FlxGroup()
		For Local i:Int = 0 Until 5
			block = New FlxObject(50 + i * 50, FlxG.Height / 2 - 50, 50, 50)			
			blocks1.Add(block)
		Next		
		Add(blocks1)
		
		blocks2 = New FlxGroup()
		For Local i:Int = 0 Until 3
			block = New FlxObject(FlxG.Width - 100 - i * 50, FlxG.Height / 2 + 50, 50, 50)
			blocks2.Add(block)
		Next
		Add(blocks2)
		
		floor = New FlxGroup()
		For Local i:Int = 0 Until 16
			block = New FlxObject(0 + i * 40, FlxG.Height - 40, 40, 40)	
			floor.Add(block)	
		Next
		Add(floor)
		
		sky = New FlxGroup()
		For Local i:Int = 0 Until 2
			block = New FlxObject(70 + i * 300, 20 + i * 50, 150, 30)
			block.scrollFactor.x = .5
			sky.Add(block)	
		Next
		Add(sky)
		
		player = New FlxObject(FlxG.Width / 2 - 15, FlxG.Height - 70, 30, 30)
		Add(player)		
		
		FlxG.Camera.Follow(player, FlxCamera.STYLE_PLATFORMER)
		FlxG.Camera.deadzone.y = FlxG.Height - 70
	End Method
	
	Method Update:Void()	
		If (KeyDown(KEY_RIGHT)) Then
			player.x += 2
		End If
		
		If (KeyDown(KEY_LEFT)) Then
			player.x -= 2
		End If
		
		Super.Update()
	End Method
	
End Class