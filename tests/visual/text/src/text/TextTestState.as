package text 
{
	import org.flixel.*;
	
	public class TextTestState extends FlxState 
	{
		
		public function TextTestState() 
		{
			add(new FlxText(10, 10, 100, "Hello, World!"));
		}
		
	}

}