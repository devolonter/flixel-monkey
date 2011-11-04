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

#Rem
Code on ActionScript for for comparison:

import org.flixel.*
[SWF(width="640", height="480", backgroundColor="#000000")] 

public class CamerasTest extends FlxGame {
		
	public function CamerasTest() {			
		super(640, 480, CamerasTestState);		
	}
		
}

public class CamerasTestState extends FlxState{
		
	override public function create():void {
		var camera:FlxCamera = new FlxCamera(10, 10, 100, 100);
		camera.bgColor = FlxG.RED;
		FlxG.addCamera(camera);
	}
}
#End