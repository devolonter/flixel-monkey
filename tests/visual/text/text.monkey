Strict

Import flixel

Function Main:Int()
	New TextTest()
	Return 0
End Function

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
		Local helloWorld:FlxText = New FlxText(10, 10, 540, "Hello World!")	
		helloWorld.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER, FlxG.PINK)	
		Add(helloWorld)
		
		Local leftAlignedText:FlxText = New FlxText(10, 70, 250, "This text is left-aligned")	
		leftAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.RED, FlxText.ALIGN_LEFT)	
		Add(leftAlignedText)
		
		Local rightAlignedText:FlxText = New FlxText(300, 70, 250, "This text is right-aligned")	
		rightAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.GREEN, FlxText.ALIGN_RIGHT)	
		Add(rightAlignedText)
		
		Local abouFlixel:FlxText = New FlxText(10, 140, 540, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam Atomic Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize.")	
		abouFlixel.SetFormat(FlxText.SYSTEM_FONT, 14, FlxG.BLUE, FlxText.ALIGN_LEFT)	
		Add(abouFlixel)
	End Method
	
End Class