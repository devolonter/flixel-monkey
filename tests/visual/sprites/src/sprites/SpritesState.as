package sprites 
{
	import org.flixel.*;	
	
	public class SpritesState extends FlxState 
	{		
		public var sprite:FlxSprite;
		
		
		[Embed(source="default.png")] protected var ImgDefault:Class;
		
		override public function create():void 
		{
			sprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
			sprite.loadGraphic(ImgDefault, false, true);
			sprite.x -= sprite.width * .5;
			sprite.y -= sprite.height * .5;
		
			add(sprite)			
		}
		
		override public function update():void 
		{			
			if (FlxG.keys.pressed("RIGHT"))
			{
				sprite.facing = FlxObject.RIGHT;
			}
			
			if (FlxG.keys.pressed("LEFT"))
			{
				sprite.facing = FlxObject.LEFT;
			}
			
			
			super.update();
		}
		
	}

}