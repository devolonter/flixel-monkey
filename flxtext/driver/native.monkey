Strict

Import mojo

Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.plugin.monkey.flxassetsmanager
Import flixel.plugin.monkey.flxresourcesmanager

Import "../../data/flx_system_font_8.png"
Import "../../data/flx_system_font_9.png"
Import "../../data/flx_system_font_10.png"
Import "../../data/flx_system_font_11.png"
Import "../../data/flx_system_font_12.png"
Import "../../data/flx_system_font_13.png"
Import "../../data/flx_system_font_14.png"
Import "../../data/flx_system_font_15.png"
Import "../../data/flx_system_font_16.png"
Import "../../data/flx_system_font_17.png"

Class FlxTextNativeDriver Extends FlxTextDriver

	Global LOADER:FlxNFDriverLoader = New FlxNFDriverLoader()

Private	
	Field _font:Image
	Field _fontHeight:Int

Public	
	Method GetTextWidth:Int(text:String)
		Return text.Length()*_font.Width()
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		_defaultFont = GetFont()
		SetFont(_font)
		
		If (_countLines <= 1) Then
			DrawText(_text, x + _offsetX, y)
		Else			
			For Local line:Int = 0 Until _countLines
				DrawText(_textLines.Get(line).text, x + _textLines.Get(line).offsetX, y + line * _fontHeight)
			Next
		End If
		
		SetFont(_defaultFont)	
	End Method
	
	Method Destroy:Void()
		_font = Null				
		Super.Destroy()
	End Method			

	Method Reset:Void()
		LOADER.fontFamily = _fontFamily
		LOADER.fontSize = _size
		
		_font = _fontsManager.GetResource(_fontFamily + _size, LOADER)		
		_fontHeight = _font.Height()
	End Method

End Class

Private
Class FlxNFDriverLoader Extends FlxResourceLoader<Image>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return LoadImage(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize), 96, Image.XPadding)			
	End Method

End Class

Global _fontsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
Global _defaultFont:Image