Strict

Import mojo
Import reflection
Import fontmachine.fontmachine

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

Import "../../data/system_machine_font_8_flx_P_1.png"
Import "../../data/system_machine_font_8_flx.txt"
Import "../../data/system_machine_font_9_flx_P_1.png"
Import "../../data/system_machine_font_9_flx.txt"
Import "../../data/system_machine_font_10_flx_P_1.png"
Import "../../data/system_machine_font_10_flx.txt"
Import "../../data/system_machine_font_11_flx_P_1.png"
Import "../../data/system_machine_font_11_flx.txt"
Import "../../data/system_machine_font_12_flx_P_1.png"
Import "../../data/system_machine_font_12_flx.txt"
Import "../../data/system_machine_font_13_flx_P_1.png"
Import "../../data/system_machine_font_13_flx.txt"
Import "../../data/system_machine_font_14_flx_P_1.png"
Import "../../data/system_machine_font_14_flx.txt"
Import "../../data/system_machine_font_15_flx_P_1.png"
Import "../../data/system_machine_font_15_flx.txt"
Import "../../data/system_machine_font_16_flx_P_1.png"
Import "../../data/system_machine_font_16_flx.txt"
Import "../../data/system_machine_font_17_flx_P_1.png"
Import "../../data/system_machine_font_17_flx.txt"
Import "../../data/system_machine_font_18_flx_P_1.png"
Import "../../data/system_machine_font_18_flx.txt"
Import "../../data/system_machine_font_19_flx_P_1.png"
Import "../../data/system_machine_font_19_flx.txt"
Import "../../data/system_machine_font_20_flx_P_1.png"
Import "../../data/system_machine_font_20_flx.txt"
Import "../../data/system_machine_font_21_flx_P_1.png"
Import "../../data/system_machine_font_21_flx.txt"
Import "../../data/system_machine_font_22_flx_P_1.png"
Import "../../data/system_machine_font_22_flx.txt"
Import "../../data/system_machine_font_23_flx_P_1.png"
Import "../../data/system_machine_font_23_flx.txt"
Import "../../data/system_machine_font_24_flx_P_1.png"
Import "../../data/system_machine_font_24_flx.txt"

Class FlxTextFontMachineDriver Extends FlxTextDriver

	Global ClassObject:ClassInfo

Private
	Global _FontLoader:FlxFMDriverLoader = New FlxFMDriverLoader()
	Global _FontsManager:FlxResourcesManager<BitmapFont> = New FlxResourcesManager<BitmapFont>()
	
	Field _font:BitmapFont
	Field _fontHeight:Int

Public
	Function Init:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		Local fontPathPrefix:String = FlxText.SYSTEM_FONT + "_machine_font_"
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT, FlxText.DRIVER_FONTMACHINE)
		
		For Local size:Int = minSize To maxSize
			angelSystemFont.SetPath(size, fontPathPrefix +  size + FlxG.DATA_SUFFIX + ".txt")
		Next
	End Function

	Method GetTextWidth:Int(text:String)
		Return _font.GetTxtWidth(text)
	End Method
	
	Method GetTextHeight:Int()
		Return _countLines * _fontHeight
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
		_font = Null				
		Super.Destroy()
	End Method			

	Method Reset:Void()
		_FontLoader.fontFamily = _fontFamily
		_FontLoader.fontSize = _size
		
		_font = _FontsManager.GetResource(_fontFamily + _size, _FontLoader)		
		_fontHeight = _font.GetFontHeight()	
	End Method
	
	Method ID:Int() Property
		Return FlxText.DRIVER_FONTMACHINE		 	
	End Method
	
	Method GetFontObject:Object()
		Return _font
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