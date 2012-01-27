Strict

Import flixel

Function Main:Int()
	New Sprites()
	Return 0
End Function

Class Sprites Extends FlxGame
	
	Method New()
		Super.New(640, 480, SpritesState._class, 1, 60)
	End Method
	
	Method OnContentInit:Void()
		#if TARGET = "html5" OR TARGET = "android"
			FlxAssetsManager.AddSound("main", "beep.ogg")
		#ElseIf TARGET = "glfw" Or TARGET = "xna"
			FlxAssetsManager.AddSound("main", "beep.wav")
		#Else
			FlxAssetsManager.AddSound("main", "beep.mp3")
		#end
	End Method

End Class

Class SpritesStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New SpritesState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (SpritesState(object) <> Null)
	End Method

End Class

Class SpritesState Extends FlxState
	
	Global _class:FlxClass = New SpritesStateClass()
	
	Field soundBox:FlxSprite
	Field player:FlxSprite

	Method Create:Void()		
		player = New FlxSprite(10, 300)
		Add(player)
		
		soundBox = New FlxSprite(500, 200)
		Add(soundBox)
		soundBox.Facing = FlxObject.LEFT
		
		Local sound:FlxSound = (New FlxSound).Load("main", True).Proximity(500, 200, player, 300)		
		FlxG.sounds.Add(sound)
		
		sound.Play()
	End Method
	
	Method Update:Void()
		player.velocity.x = 0
		
		If (FlxG.keys.Right Or (FlxG.Touch().Pressed And FlxG.Touch().screenX > FlxG.width / 2)) player.velocity.x = 100
		If (FlxG.keys.Left Or  (FlxG.Touch().Pressed And FlxG.Touch().screenX < FlxG.width / 2)) player.velocity.x = -100
		
		If (FlxG.keys.Escape) Error ""
	
		Super.Update()
	End Method
	
End Class