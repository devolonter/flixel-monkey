Strict

Import flixel

#REFLECTION_FILTER="cameras*|flixel*"

Function Main:Int()
	New Cameras()
	Return 0
End Function

Class Cameras Extends FlxGame
	
	Method New()
		Super.New(640, 480, GetClass("CamerasState"))
	End Method

End Class

Class CamerasState Extends FlxState
	
	Field pink_camera:FlxCamera
	Field red_camera:FlxCamera
	Field green_camera:FlxCamera
	
	Method Create:Void()
		Local pink_camera:FlxCamera = new FlxCamera(10, 10, 100, 100, .5)
		pink_camera.BgColor = FlxG.PINK
		FlxG.AddCamera(pink_camera)	
	
		Local red_camera:FlxCamera = new FlxCamera(70, 10, 100, 100)
		red_camera.BgColor = FlxG.RED
		FlxG.AddCamera(red_camera)
		
		Local green_camera:FlxCamera = new FlxCamera(180, 10, 100, 100, 2)
		green_camera.BgColor = FlxG.GREEN
		FlxG.AddCamera(green_camera)		
	End Method
	
	Method Update:Void()
		If (FlxG.Keys.JustPressed(KEY_SPACE)) Then
			FlxG.Shake(0.5)
		End If
	End Method
	
End Class