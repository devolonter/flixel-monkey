package text 
{
	import org.flixel.*;
	
	public class TextTestState extends FlxState 
	{			
		override public function create():void 
		{
			var leftAlign:FlxText = new FlxText(10, 10, 100, "Left align text");
			leftAlign.size = 16
			add(leftAlign);
		}
		
	}

}