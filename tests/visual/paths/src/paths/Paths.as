package paths
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class Paths extends FlxGame 
	{
		
		public function Paths():void 
		{
			super(640, 480, PathsState);			
			FlxG.visualDebug = true;
		}
		
	}
	
}