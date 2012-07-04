Strict

Import flixel

#REFLECTION_FILTER="sound*|flixel*"

Function Main:Int()
	New Sound()
	Return 0
End Function

Class Sound Extends FlxGame
	
	Method New()
		Super.New(640, 480, GetClass("SoundState"), 1, 60, 60)
	End Method
	
	Method OnContentInit:Void()
		#if TARGET = "html5" OR TARGET = "android"
			Print "html5"
			FlxAssetsManager.AddSound("main", "beep.ogg")
		#ElseIf TARGET = "glfw" Or TARGET = "xna"
			FlxAssetsManager.AddSound("main", "beep.wav")
		#Else
			FlxAssetsManager.AddSound("main", "beep.mp3")
		#end
	End Method

End Class

Class SoundState Extends FlxState
	
	Field soundBox:FlxSprite
	Field player:FlxSprite

	Method Create:Void()		
		player = New FlxSprite(10, 300)
		Add(player)
		
		soundBox = New FlxSprite(500, 200)
		Add(soundBox)
		soundBox.Facing = FlxObject.LEFT
		
		Local sound:FlxSound = (New FlxSound).Load("main", True).Proximity(500, 200, player, 300)		
		FlxG.Sounds.Add(sound)
		
		sound.Play()
	End Method
	
	Method Update:Void()
		player.velocity.x = 0
		
		If (FlxG.Keys.Right Or (FlxG.Touch().Pressed And FlxG.Touch().screenX > FlxG.Width / 2)) player.velocity.x = 100
		If (FlxG.Keys.Left Or  (FlxG.Touch().Pressed And FlxG.Touch().screenX < FlxG.Width / 2)) player.velocity.x = -100
		
		If (FlxG.Keys.Escape) Error ""
	
		Super.Update()
	End Method
	
End Class