Strict

Import flixel

Function Main:Int()
	New Paths()
	Return 0
End Function

Class Paths Extends FlxGame
	
	Method New()
		Super.New(640, 480, PathsState.ClassObject, 1, 60, 60)
		FlxG.VisualDebug = True	
	End Method

End Class

Class PathsStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New PathsState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (PathsState(object) <> Null)
	End Method

End Class

Class PathsState Extends FlxState

	Global ClassObject:FlxClass = new PathsStateClass()
	
	Field pathFrowardedObject:FlxObject
	Field pathForward:FlxPath
	
	Field pathBackwardedObject:FlxObject
	Field pathBackward:FlxPath
	
	Field pathLoopForwadedObject:FlxObject
	Field pathLoopForward:FlxPath
	
	Field pathLoopBackwardedObject:FlxObject
	Field pathLoopBackward:FlxPath
	
	Method Create:Void()
		Local offsetX:Float = 90
			
		pathForward = New FlxPath()
		pathForward.Add(offsetX + 75, 125)
		pathForward.Add(offsetX + 75, 325)
		
		pathFrowardedObject = New FlxObject(offsetX + 50, 200, 50, 50)			
		Add(pathFrowardedObject)
		
		pathBackward = New FlxPath()
		pathBackward.Add(offsetX + 175, 125)
		pathBackward.Add(offsetX + 175, 325)
		
		pathBackwardedObject = new FlxObject(offsetX + 150, 200, 50, 50)			
		Add(pathBackwardedObject)
		
		pathLoopForward = New FlxPath()
		pathLoopForward.Add(offsetX + 275, 125)
		pathLoopForward.Add(offsetX + 275, 325)
		
		pathLoopForwadedObject = New FlxObject(offsetX + 250, 200, 50, 50)			
		Add(pathLoopForwadedObject)
		
		pathLoopBackward = New FlxPath()
		pathLoopBackward.Add(offsetX + 375, 125)
		pathLoopBackward.Add(offsetX + 375, 325)
		
		pathLoopBackwardedObject = New FlxObject(offsetX + 350, 200, 50, 50)			
		Add(pathLoopBackwardedObject)
	End Method
	
	Method Update:Void()
		If (FlxG.Keys.JustPressed(KEY_SPACE) Or FlxG.Touch().JustPressed()) Then
			pathFrowardedObject.FollowPath(pathForward, 50, FlxObject.PATH_FORWARD)
			pathBackwardedObject.FollowPath(pathBackward, 50, FlxObject.PATH_BACKWARD)
			pathLoopForwadedObject.FollowPath(pathLoopForward, 50, FlxObject.PATH_LOOP_FORWARD)
			pathLoopBackwardedObject.FollowPath(pathLoopBackward, 50, FlxObject.PATH_LOOP_BACKWARD)
		End If
	
		Super.Update()
	End Method
	
End Class