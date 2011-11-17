Strict

Import mojo
Import fontmachine.fontmachine

Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.plugin.monkey.flxassetsmanager
Import flixel.plugin.monkey.flxresourcesmanager

Import "../../data/flx_system_font_fontmachine_8.txt"
Import "../../data/flx_system_font_fontmachine_8_P_1.png"
Import "../../data/flx_system_font_fontmachine_9.txt"
Import "../../data/flx_system_font_fontmachine_9_P_1.png"
Import "../../data/flx_system_font_fontmachine_10.txt"
Import "../../data/flx_system_font_fontmachine_10_P_1.png"
Import "../../data/flx_system_font_fontmachine_11.txt"
Import "../../data/flx_system_font_fontmachine_11_P_1.png"
Import "../../data/flx_system_font_fontmachine_12.txt"
Import "../../data/flx_system_font_fontmachine_12_P_1.png"
Import "../../data/flx_system_font_fontmachine_13.txt"
Import "../../data/flx_system_font_fontmachine_13_P_1.png"
Import "../../data/flx_system_font_fontmachine_14.txt"
Import "../../data/flx_system_font_fontmachine_14_P_1.png"
Import "../../data/flx_system_font_fontmachine_15.txt"
Import "../../data/flx_system_font_fontmachine_15_P_1.png"
Import "../../data/flx_system_font_fontmachine_16.txt"
Import "../../data/flx_system_font_fontmachine_16_P_1.png"

Class FlxTextFontMachineDriver Extends FlxTextDriver

	Global LOADER:FlxFMDriverLoader = New FlxFMDriverLoader()

Private	
	Field _font:BitmapFont
	Field _fontHeight:Int

Public	
	Method SetTextAlignment:Void(alignment:Float)
		_alignment = alignment
	End Method	
	
	Method GetTextAlignment:Float()
		Return _alignment
	End Method
	
	Method GetTextWidth:Int(text:String)
		Return _font.GetTxtWidth(text)
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		If (_countLines = 1) Then
			_font.DrawText(_text, x, y)
		Else		
			For Local line:Int = 0 Until _countLines
				_font.DrawText(_textLines.Get(line).text, x, y + line * _fontHeight)
			Next
		End If	
	End Method
	
	Method Destroy:Void()
	End Method			

	Method Reset:Void()
		LOADER.fontFamily = _fontFamily
		LOADER.fontSize = _size
		
		_font = _fontsManager.GetResource(_fontFamily + _size, LOADER)		
		_fontHeight = _font.GetFontHeight()
	End Method	

End Class

Private
Class FlxFMDriverLoader Extends FlxResourceLoader<BitmapFont>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return New BitmapFont(FlxAssetsManager.GetFontPath(fontFamily, fontSize), False)			
	End Method

End Class

Global _fontsManager:FlxResourcesManager<BitmapFont> = New FlxResourcesManager<BitmapFont>()