package text
{
	import org.flixel.*;
	
	public class TextTestState extends FlxState
	{
		override public function create():void
		{
			var helloWorld:FlxText = new FlxText(10, 10, 540, "Hello World!")
			helloWorld.setFormat("system", 16, FlxG.WHITE, "center", FlxG.PINK)
			add(helloWorld)
			
			var leftAlignedText:FlxText = new FlxText(10, 70, 150, "This text is left-aligned")
			leftAlignedText.setFormat("system", 16, FlxG.RED, "left")
			add(leftAlignedText)
			
			var rightAlignedText:FlxText = new FlxText(400, 70, 150, "This text is right-aligned")
			rightAlignedText.setFormat("system", 16, FlxG.GREEN, "right")
			add(rightAlignedText)
			
			var abouFlixel:FlxText = new FlxText(10, 140, 540, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam “Atomic” Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize.")
			abouFlixel.setFormat("system", 15, FlxG.BLUE, "left")
			add(abouFlixel)
		}
	
	}
}