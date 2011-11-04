Strict

Import flixel

Class CamerasTest Extends FlxGame
	
	Method New()
		Super.New(640, 480, CamerasTestState.CREATOR)	
	End Method

End Class

Class CamerasTestStateCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New CamerasTestState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (CamerasTestState(object) <> Null)
	End Method

End Class

Class CamerasTestState Extends FlxState

	Global CREATOR:FlxClassCreator = new CamerasTestStateCreator()
	
	Method Create:Void()
		Local camera:FlxCamera = new FlxCamera(10, 10, 100, 100)
		camera.bgColor = FlxG.RED
		FlxG.AddCamera(camera)		
	End Method
	
End Class