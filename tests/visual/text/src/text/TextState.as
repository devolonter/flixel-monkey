package text
{
	import flash.system.Capabilities;
	import org.flixel.*;
	
	public class TextState extends FlxState
	{
		override public function create():void
		{
			var os:String = Capabilities.version.substr(0, 3);
			var isMobile:Boolean = false;
			
			if (os == "AND") {
				isMobile = true;		
			} else {
				var mobileSystems:Array = new Array("Windows SmartPhone", "Windows PocketPC", "Windows Mobile");				
				isMobile = (mobileSystems.indexOf(Capabilities.os) != -1)
			}
		
			var helloWorld:FlxText = new FlxText(10, 10, 620, String(isMobile))
			helloWorld.setFormat("system", 16, FlxG.WHITE, "center", FlxG.PINK)
			add(helloWorld)
			
			var leftAlignedText:FlxText = new FlxText(10, 70, 150, "This text is left-aligned")
			leftAlignedText.setFormat("system", 16, FlxG.RED, "left")
			add(leftAlignedText)
			
			var rightAlignedText:FlxText = new FlxText(480, 70, 150, "This text is right-aligned")
			rightAlignedText.setFormat("system", 16, FlxG.GREEN, "right")
			add(rightAlignedText)
			
			var abouFlixel:FlxText = new FlxText(10, 140, 620, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam “Atomic” Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize.")
			abouFlixel.setFormat("system", 15, FlxG.BLUE, "left")
			add(abouFlixel)
		}
	
	}
}