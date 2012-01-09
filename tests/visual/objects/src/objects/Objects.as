package objects
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class Objects extends FlxGame 
	{
		
		public function Objects():void 
		{
			super(640, 480, ObjectsState);
			FlxG.visualDebug = true;
		}
		
	}
	
}