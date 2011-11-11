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
		Local camera_pink:FlxCamera = new FlxCamera(10, 10, 100, 100, .5)
		camera_pink.bgColor = FlxG.PINK
		FlxG.AddCamera(camera_pink)	
	
		Local camera_red:FlxCamera = new FlxCamera(70, 10, 100, 100)
		camera_red.bgColor = FlxG.RED
		FlxG.AddCamera(camera_red)
		
		Local camera_green:FlxCamera = new FlxCamera(180, 10, 100, 100, 2)
		camera_green.bgColor = FlxG.GREEN
		FlxG.AddCamera(camera_green)		
	End Method
	
End Class