package paths
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class PathsTest extends FlxGame 
	{
		
		public function PathsTest():void 
		{
			super(640, 480, PathsTestState);			
			FlxG.visualDebug = true;
		}
		
	}
	
}