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
		Local leftAlign:FlxText = New FlxText(10, 10, FlxG.deviceWidth - 20, "Monkey Flixel Rocks!")		
		leftAlign.Size = 16
		leftAlign.Shadow = FlxG.PINK
		Add(leftAlign)
	End Method
	
End Class