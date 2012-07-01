Strict

Import flixel

#REFLECTION_FILTER="text*|flixel*"

Function Main:Int()
	New Text()
	Return 0
End Function

Class Text Extends FlxGame
	
	Method New()
		Super.New(640, 480, GetClass("TextState"))	
	End Method

End Class

Class TextState Extends FlxState
	
	Method Create:Void()		
		Local helloWorld:FlxText = New FlxText(10, 10, 620, "Hello World!")	
		helloWorld.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER, FlxG.PINK)	
		Add(helloWorld)
		
		Local leftAlignedText:FlxText = New FlxText(10, 70, 250, "This text is left-aligned")	
		leftAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.RED, FlxText.ALIGN_LEFT)	
		Add(leftAlignedText)
		
		Local rightAlignedText:FlxText = New FlxText(380, 70, 250, "This text is right-aligned")	
		rightAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.GREEN, FlxText.ALIGN_RIGHT)	
		Add(rightAlignedText)
		
		Local abouFlixel:FlxText = New FlxText(10, 140, 620, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam Atomic Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize.")	
		abouFlixel.SetFormat(FlxText.SYSTEM_FONT, 14, FlxG.BLUE, FlxText.ALIGN_LEFT)	
		Add(abouFlixel)
	End Method
	
End Class