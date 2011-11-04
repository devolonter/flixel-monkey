package cameras
{
	import org.flixel.*;
	
	public class CamerasTestState extends FlxState
	{
		
		override public function create():void
		{
			var camera:FlxCamera = new FlxCamera(10, 10, 100, 100);
			camera.bgColor = FlxG.RED;
			FlxG.addCamera(camera);
		}
	
	}

}