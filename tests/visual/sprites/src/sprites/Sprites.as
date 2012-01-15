package sprites
{
	import org.flixel.*
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class Sprites extends FlxGame 
	{
		
		public function Sprites():void 
		{
			super(640, 480, SpritesState);
			FlxG.visualDebug = true
		}
		
	}
	
}