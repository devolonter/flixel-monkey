Strict

Import flixel

Class TextTest Extends FlxGame
	
	Method New()
		Super.New(560, 420, TextTestState.CREATOR)	
	End Method

End Class

Class TextTestStateCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New TextTestState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (TextTestState(object) <> Null)
	End Method

End Class

Class TextTestState Extends FlxState

	Global CREATOR:FlxClassCreator = new TextTestStateCreator()
	
	Method Create:Void()		
		Local leftAlign:FlxText = New FlxText(10, 10, 540, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam “Atomic” Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize. Flixel has been used in hundreds of games, including IGF nominees, Adult Swim games, and avant-garde experiments. Many Flixel users make their first game ever in Flixel.")		
		leftAlign.Size = 16
		'leftAlign.Shadow = FlxG.PINK
		Add(leftAlign)
	End Method
	
End Class