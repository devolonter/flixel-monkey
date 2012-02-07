Strict

Import mojo

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

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

Global NativeTextDriver:FlxClass = New FlxNFDriverClass()

Class FlxTextNativeDriver Extends FlxTextDriver

Private
	Global _FontLoader:FlxNFDriverLoader = New FlxNFDriverLoader()
	Global _FontsManager:FlxResourcesManager<Image> = New FlxResourcesManager<Image>()
	Global _DefaultFont:Image
	
	Field _font:Image
	Field _fontHeight:Int

Public	
	Method GetTextWidth:Int(text:String)
		Return text.Length()*_font.Width()
	End Method
	
	Method GetTextHeight:Int()
		Return _countLines * _fontHeight
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		_DefaultFont = GetFont()
		SetFont(_font)
		
		If (_countLines <= 1) Then
			DrawText(_text, x + _offsetX, y)
		Else			
			For Local line:Int = 0 Until _countLines
				DrawText(_textLines.Get(line).text, x + _textLines.Get(line).offsetX, y + line * _fontHeight)
			Next
		End If
		
		SetFont(_DefaultFont)	
	End Method
	
	Method Destroy:Void()
		_font = Null				
		Super.Destroy()
	End Method			

	Method Reset:Void()
		_FontLoader.fontFamily = _fontFamily
		_FontLoader.fontSize = _size
		
		_font = _FontsManager.GetResource(_fontFamily + _size, _FontLoader)		
		_fontHeight = _font.Height()
	End Method

End Class

Private
Class FlxNFDriverClass Implements FlxClass
	
	Method CreateInstance:Object()
		Return New FlxTextNativeDriver()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return FlxTextNativeDriver(object) <> Null
	End Method

End Class

Class FlxNFDriverLoader Extends FlxResourceLoader<Image>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return LoadImage(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize), 96, Image.XPadding)			
	End Method

End Class