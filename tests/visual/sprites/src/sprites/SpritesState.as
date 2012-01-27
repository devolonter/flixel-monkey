package sprites 
{
	import org.flixel.*;	
	
	public class SpritesState extends FlxState
	{
		[Embed(source = "asteroids.mp3")] private var asteroids:Class
		[Embed(source="default.png")] private var sprite:Class
		
		public var soundBox:FlxSprite
		public var player:FlxSprite
		public var sound:FlxSound
		
		override public function create():void 
		{
			player = new FlxSprite(10, 300)
			player.loadGraphic(sprite)
			add(player)
		
			soundBox = new FlxSprite(500, 200)
			add(soundBox)
			//soundBox.facing = FlxObject.LEFT
			
			sound = (new FlxSound).loadEmbedded(asteroids, true).proximity(500, 200, player, 300)	

			sound.play()
		}
		
		override public function update():void 
		{			
			player.velocity.x = 0
		
			if (FlxG.keys.RIGHT) 
				player.velocity.x = 100;
			if (FlxG.keys.LEFT) 
				player.velocity.x = -100;
				
			sound.update()
			
			super.update();
		}
		
	}

}