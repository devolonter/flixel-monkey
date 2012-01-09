package camerafx
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class CamerasFX extends FlxGame 
	{
		
		public function CamerasFX():void 
		{
			super(640, 480, CamerasFXState);
		}
		
	}
	
}