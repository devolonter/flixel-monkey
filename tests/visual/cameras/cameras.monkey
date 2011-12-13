Strict

Import flixel

Function Main:Int()
	New CamerasTest()
	Return 0
End Function

Class CamerasTest Extends FlxGame
	
	Method New()
		Super.New(640, 480, CamerasTestState.CLASS_OBJECT)	
	End Method

End Class

Class CamerasTestStateClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New CamerasTestState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (CamerasTestState(object) <> Null)
	End Method

End Class

Class CamerasTestState Extends FlxState

	Global CLASS_OBJECT:FlxClass = new CamerasTestStateClass()
	
	Method Create:Void()
		Local camera_pink:FlxCamera = new FlxCamera(10, 10, 100, 100, .5)
		camera_pink.BgColor = FlxG.PINK
		FlxG.AddCamera(camera_pink)	
	
		Local camera_red:FlxCamera = new FlxCamera(70, 10, 100, 100)
		camera_red.BgColor = FlxG.RED
		FlxG.AddCamera(camera_red)
		
		Local camera_green:FlxCamera = new FlxCamera(180, 10, 100, 100, 2)
		camera_green.BgColor = FlxG.GREEN
		FlxG.AddCamera(camera_green)		
	End Method
	
End Class