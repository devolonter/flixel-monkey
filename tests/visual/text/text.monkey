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
		Local leftAlign:FlxText = New FlxText(10, 10, "Left align text")
		leftAlign.Size = 16
		Add(leftAlign)
		
		FlxG.camera.Color = FlxG.GREEN
	End Method
	
End Class