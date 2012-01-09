package objects 
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
	
	public class ObjectsState extends FlxState 
	{
		
		public var blocks1:FlxGroup
		public var blocks2:FlxGroup	
		public var floor:FlxGroup
		public var sky:FlxGroup
		
		public var player:FlxObject
		
		override public function create():void 
		{
			var block:FlxObject
			var path:FlxPath
			
			blocks1 = new FlxGroup()
			for (var i:int = 0; i < 5; i++) {
				block = new FlxObject(50 + i * 50, FlxG.height / 2 - 50, 50, 50)			
				blocks1.add(block)
			}		
			add(blocks1)
			
			blocks2 = new FlxGroup()
			for (var i:int = 0; i < 3; i++) {
				block = new FlxObject(FlxG.width - 100 - i * 50, FlxG.height / 2 + 50, 50, 50)
				blocks2.add(block)
			}
			add(blocks2)
			
			floor = new FlxGroup()
			for (var i:int = 0; i < 16; i++) {
				block = new FlxObject(0 + i * 40, FlxG.height - 40, 40, 40)	
				floor.add(block)	
			}
			add(floor)
			
			sky = new FlxGroup()
			for (var i:int = 0; i < 2; i++) {
				block = new FlxObject(70 + i * 300, 20 + i * 50, 150, 30)
				block.scrollFactor.x = .5
				sky.add(block)	
			}
			add(sky)
			
			player = new FlxObject(FlxG.width / 2 - 15, FlxG.height - 70, 30, 30)
			add(player)		
			
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER)
			FlxG.camera.deadzone.y = FlxG.height - 70
		}
		
		override public function update():void 
		{
			if (FlxG.keys.pressed("RIGHT")) {
				player.x += 2
			}
			
			if (FlxG.keys.pressed("LEFT")) {
				player.x -= 2
			}
			
			super.update();
		}
		
	}

}