Strict

Import flixel

Class TextTest Extends FlxGame
	
	Method New()
		Super.New(640, 480, TextTestState.CREATOR)	
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
		Add(New FlxText(10, 10, "Hello World"))
	End Method
	
End Class