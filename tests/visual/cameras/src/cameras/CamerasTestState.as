package cameras
{
	import org.flixel.*;
	
	public class CamerasTestState extends FlxState
	{
		
		public var pink_camera:FlxCamera
		public var red_camera:FlxCamera
		public var green_camera:FlxCamera
		
		override public function create():void
		{
			pink_camera = new FlxCamera(10, 10, 100, 100, .5);
			pink_camera.bgColor = FlxG.PINK;
			FlxG.addCamera(pink_camera);
			
			red_camera = new FlxCamera(70, 10, 100, 100);
			red_camera.bgColor = FlxG.RED;
			FlxG.addCamera(red_camera);
			
			green_camera = new FlxCamera(180, 10, 100, 100, 2);
			green_camera.bgColor = FlxG.GREEN;
			FlxG.addCamera(green_camera);
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("S"))
			{
				pink_camera.shake();
			}
			
			if (FlxG.keys.justPressed("L"))
			{
				red_camera.flash();
			}
			
			if (FlxG.keys.justPressed("F"))
			{
				green_camera.fade();
			}
		}
	
	}

}