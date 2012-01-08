Strict

Import flixel

Function Main:Int()
	New CamerasTest()
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
	
	Method Create:Void()
		FlxG.visualDebug = True			
	End Method
	
End Class