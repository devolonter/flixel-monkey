package text 
{
	import org.flixel.*;
	
	public class TextTestState extends FlxState 
	{
		
		public function TextTestState() 
		{
			var text:FlxText = new FlxText(0, 0, 100, "Hello, World!");
			text.shadow = FlxG.RED;
			add(text);
		}
		
	}

}