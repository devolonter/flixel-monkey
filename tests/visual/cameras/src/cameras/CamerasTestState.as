package cameras
{
	import org.flixel.*;
	
	public class CamerasTestState extends FlxState
	{
		
		override public function create():void
		{
			var camera_pink:FlxCamera = new FlxCamera(10, 10, 100, 100, .5);
			camera_pink.bgColor = FlxG.PINK;
			FlxG.addCamera(camera_pink);
			
			var camera_red:FlxCamera = new FlxCamera(70, 10, 100, 100);
			camera_red.bgColor = FlxG.RED;
			FlxG.addCamera(camera_red);
			
			var camera_green:FlxCamera = new FlxCamera(180, 10, 100, 100, 2);
			camera_green.bgColor = FlxG.GREEN;
			FlxG.addCamera(camera_green);
		}
	
	}
}