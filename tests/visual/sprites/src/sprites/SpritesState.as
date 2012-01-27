package sprites 
{
	import org.flixel.*;	
	
	public class SpritesState extends FlxState
	{
		[Embed(source="asteroids.mp3")] private var asteroids:Class
		
		var soundBox:FlxSprite
		var player:FlxSprite	
		
		override public function create():void 
		{
			player = new FlxSprite(10, 300)
			add(player)
		
			soundBox = new FlxSprite(500, 200)
			add(soundBox)
			soundBox.facing = FlxObject.LEFT
			
			var sound:FlxSound = (new FlxSound).loadEmbedded(asteroids, true).proximity(500, 200, player, 300)		
			FlxG.sounds.add(sound)
			
			sound.play()
		}
		
		override public function update():void 
		{			
			player.velocity.x = 0
		
			if (FlxG.keys.RIGHT) 
				player.velocity.x = 100;
			if (FlxG.keys.LEFT) 
				player.velocity.x = -100;
			
			super.update();
		}
		
	}

}