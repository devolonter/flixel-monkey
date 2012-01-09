package cameras
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class Cameras extends FlxGame 
	{
		
		public function Cameras():void 
		{
			super(640, 480, CamerasState);
		}
		
	}
	
}