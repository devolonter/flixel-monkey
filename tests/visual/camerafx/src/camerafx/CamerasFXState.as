package camerafx 
{
	import org.flixel.*;
	
	public class CamerasFXState extends FlxState 
	{
		
		override public function create():void 
		{
			var manual:FlxText = new FlxText(10, 10, 620, "- Press S to shake");
			manual.setFormat("system", 16, FlxG.WHITE, "left")	;
			add(manual);
			
			manual = new FlxText(10, 40, 620, "- Press L to flash");
			manual.setFormat("system", 16, FlxG.WHITE, "left");
			add(manual);
			
			manual = new FlxText(10, 70, 620, "- Press F to fade");
			manual.setFormat("system", 16, FlxG.WHITE, "left");
			add(manual);
			
			manual = new FlxText(10, 100, 620, "- Press SPACE to stopFX");
			manual.setFormat("system", 16, FlxG.WHITE, "left");	
			add(manual);
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("S")) {
				FlxG.shake();
			}	
			
			if (FlxG.keys.justPressed("L")) {
				FlxG.flash();
			}
			
			if (FlxG.keys.justPressed("F")) {
				FlxG.fade();
			}
			
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.camera.stopFX();
			}
			
			super.update();
		}
		
	}

}