package sprites 
{
	import org.flixel.*;
	
	public class SpritesState extends FlxState 
	{
		
		public var sprite:FlxSprite
		public var sprite2:FlxSprite
		
		override public function create():void 
		{
			sprite = new FlxSprite(10, 10)
			sprite.makeGraphic(100, 100, 0x77ff0000)
			
			sprite2 = new FlxSprite(20, 20)
			sprite2.makeGraphic(100, 100, FlxG.GREEN)
			
			add(sprite2)
			add(sprite)			
		}
		
		override public function update():void 
		{
			if (FlxG.keys.pressed("SPACE"))
			{
				sprite.scale.x += .05
				sprite.scale.y += .05
			}
			
			if (FlxG.keys.pressed("LEFT"))
			{
				sprite.angle -= 1
			}
			
			if (FlxG.keys.pressed("RIGHT"))
			{
				sprite.angle += 1
			}
			
			if (FlxG.keys.justPressed("C"))
			{
				FlxG.camera.color = 0x00777777
			}
			
			if (FlxG.keys.justPressed("A"))
			{
				FlxG.camera.alpha = .5
			}
			
			if (FlxG.keys.justPressed("F"))
			{
				sprite.flicker()
			}
			
			super.update();
		}
		
	}

}