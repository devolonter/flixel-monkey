Strict

Import flixel
Import flixel.flxtext.driver.angelfont

Function Main:Int()
	New AngelFont()
	Return 0
End Function

Class AngelFont Extends FlxGame
	
	Method New()
		Super.New(640, 480, TextState.CLASS_OBJECT)	
	End Method
	
	Method OnContentInit:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont("system", FlxText.DRIVER_ANGELFONT)
		
		For Local i:Int = minSize To maxSize
			angelSystemFont.SetPath(i, "fonts/"+FlxText.SYSTEM_FONT+"/angelfont/"+i+".txt")	
		Next
	End Method

End Class

Class TextStateClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New TextState()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)
		Return (TextState(object) <> Null)
	End Method

End Class

Class TextState Extends FlxState

	Global CLASS_OBJECT:FlxClass = new TextStateClass()
	
	Method Create:Void()		
		Local helloWorld:FlxText = New FlxText(10, 10, 620, "Hello World!", New FlxTextAngelFontDriver())	
		helloWorld.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER, FlxG.PINK)	
		Add(helloWorld)
		
		Local leftAlignedText:FlxText = New FlxText(10, 70, 150, "This text is left-aligned", New FlxTextAngelFontDriver())	
		leftAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.RED, FlxText.ALIGN_LEFT)	
		Add(leftAlignedText)
		
		Local rightAlignedText:FlxText = New FlxText(480, 70, 150, "This text is right-aligned", New FlxTextAngelFontDriver())	
		rightAlignedText.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.GREEN, FlxText.ALIGN_RIGHT)	
		Add(rightAlignedText)
		
		Local abouFlixel:FlxText = New FlxText(10, 140, 620, "Flixel is an open source game-making library that is completely free for personal or commercial use. Written entirely in ActionScript 3 by Adam Atomic Saltsman, and designed to be used with free development tools, Flixel is easy to learn, extend and customize.", New FlxTextAngelFontDriver())	
		abouFlixel.SetFormat(FlxText.SYSTEM_FONT, 14, FlxG.BLUE, FlxText.ALIGN_LEFT)	
		Add(abouFlixel)
	End Method
	
End Class