Strict

Import flixel

Function Main:Int()
	New ObjectsTest()
	Return 0
End Function

Class ObjectsTest Extends FlxGame
	
	Method New()
		Super.New(640, 480, ObjectsTestState.CLASS_OBJECT)	
	End Method

End Class

Class ObjectsTestStateClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New ObjectsTestState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (ObjectsTestState(object) <> Null)
	End Method

End Class

Class ObjectsTestState Extends FlxState

	Global CLASS_OBJECT:FlxClass = new ObjectsTestStateClass()
	
	Field blocks1:FlxGroup
	Field blocks2:FlxGroup	
	Field floor:FlxGroup
	Field sky:FlxGroup
	
	Method Create:Void()
		FlxG.visualDebug = True
		
		Local block:FlxObject
		Local path:FlxPath
		
		blocks1 = New FlxGroup()
		For Local i:Int = 0 Until 5
			block = New FlxObject(50 + i * 50, FlxG.height / 2 - 50, 50, 50)
			
			#Rem			
			path = New FlxPath()
			
			path.Add(75 + i * 50, FlxG.height / 2 - 25)
			path.Add(75 + i * 50, 150)
			
			If (i Mod 2 = 0) Then
				block.FollowPath(path, 100, FlxObject.PATH_LOOP_FORWARD)
			Else
				block.FollowPath(path, 100, FlxObject.PATH_BACKWARD)
			End If
			#End
			
			blocks1.Add(block)
		Next
		
		path = New FlxPath()
			
		path.Add(75 + 4 * 50, FlxG.height / 2 - 25)
		path.Add(75 + 4 * 50, 150)
		
		If (4 Mod 2 = 0) Then
			block.FollowPath(path, 100, FlxObject.PATH_BACKWARD)
		Else
			block.FollowPath(path, 100, FlxObject.PATH_BACKWARD)
		End If
		
		Add(blocks1)
		
		blocks2 = New FlxGroup()
		For Local i:Int = 0 Until 3
			block = New FlxObject(FlxG.width - 100 - i * 50, FlxG.height / 2 + 50, 50, 50)
			blocks2.Add(block)
		Next
		Add(blocks2)
		
		floor = New FlxGroup()
		For Local i:Int = 0 Until 16
			block = New FlxObject(0 + i * 40, FlxG.height - 40, 40, 40)	
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
	End Method
	
	Method Update:Void()
		If (KeyDown(KEY_RIGHT)) Then
			FlxG.camera.scroll.x += 2
		End If
		
		If (KeyDown(KEY_LEFT)) Then
			FlxG.camera.scroll.x -= 2
		End If
		
		Super.Update()
	End Method
	
End Class