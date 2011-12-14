Strict

Import mojo
Import fontmachine.fontmachine

Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.plugin.monkey.flxassetsmanager
Import flixel.plugin.monkey.flxresourcesmanager

Class FlxTextFontMachineDriver Extends FlxTextDriver

	Global LOADER:FlxFMDriverLoader = New FlxFMDriverLoader()

Private	
	Field _font:BitmapFont
	Field _fontHeight:Int

Public	
	Method GetTextWidth:Int(text:String)
		Return _font.GetTxtWidth(text)
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		If (_countLines <= 1) Then
			_font.DrawText(_text, x + _offsetX, y)
		Else			
			For Local line:Int = 0 Until _countLines
				_font.DrawText(_textLines.Get(line).text, x + _textLines.Get(line).offsetX, y + line * _fontHeight)
			Next
		End If	
	End Method
	
	Method Destroy:Void()		
		_font.UnloadFullFont()
		_font = Null
				
		Super.Destroy()
	End Method			

	Method Reset:Void()
		LOADER.fontFamily = _fontFamily
		LOADER.fontSize = _size
		
		_font = _fontsManager.GetResource(_fontFamily + _size, LOADER)		
		_fontHeight = _font.GetFontHeight()	
	End Method
	
	Method ID:Int() Property
		Return FlxText.DRIVER_FONTMACHINE		 	
	End Method

End Class

Private
Class FlxFMDriverLoader Extends FlxResourceLoader<BitmapFont>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return New BitmapFont(FlxAssetsManager.GetFont(fontFamily, FlxText.DRIVER_FONTMACHINE).GetPath(fontSize), False)			
	End Method

End Class

Global _fontsManager:FlxResourcesManager<BitmapFont> = New FlxResourcesManager<BitmapFont>()