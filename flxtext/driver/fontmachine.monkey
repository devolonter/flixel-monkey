Strict

Import mojo
Import fontmachine.fontmachine

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

Import "../../data/flx_system_machine_font_8_P_1.png"
Import "../../data/flx_system_machine_font_8.txt"
Import "../../data/flx_system_machine_font_9_P_1.png"
Import "../../data/flx_system_machine_font_9.txt"
Import "../../data/flx_system_machine_font_10_P_1.png"
Import "../../data/flx_system_machine_font_10.txt"
Import "../../data/flx_system_machine_font_11_P_1.png"
Import "../../data/flx_system_machine_font_11.txt"
Import "../../data/flx_system_machine_font_12_P_1.png"
Import "../../data/flx_system_machine_font_12.txt"
Import "../../data/flx_system_machine_font_13_P_1.png"
Import "../../data/flx_system_machine_font_13.txt"
Import "../../data/flx_system_machine_font_14_P_1.png"
Import "../../data/flx_system_machine_font_14.txt"
Import "../../data/flx_system_machine_font_15_P_1.png"
Import "../../data/flx_system_machine_font_15.txt"
Import "../../data/flx_system_machine_font_16_P_1.png"
Import "../../data/flx_system_machine_font_16.txt"
Import "../../data/flx_system_machine_font_17_P_1.png"
Import "../../data/flx_system_machine_font_17.txt"
Import "../../data/flx_system_machine_font_18_P_1.png"
Import "../../data/flx_system_machine_font_18.txt"
Import "../../data/flx_system_machine_font_19_P_1.png"
Import "../../data/flx_system_machine_font_19.txt"
Import "../../data/flx_system_machine_font_20_P_1.png"
Import "../../data/flx_system_machine_font_20.txt"
Import "../../data/flx_system_machine_font_21_P_1.png"
Import "../../data/flx_system_machine_font_21.txt"
Import "../../data/flx_system_machine_font_22_P_1.png"
Import "../../data/flx_system_machine_font_22.txt"
Import "../../data/flx_system_machine_font_23_P_1.png"
Import "../../data/flx_system_machine_font_23.txt"
Import "../../data/flx_system_machine_font_24_P_1.png"
Import "../../data/flx_system_machine_font_24.txt"

Global FontmachineTextDriver:FlxClass = New FlxFMDriverClass()

Class FlxTextFontMachineDriver Extends FlxTextDriver

Private
	Global _FontLoader:FlxFMDriverLoader = New FlxFMDriverLoader()
	Global _FontsManager:FlxResourcesManager<BitmapFont> = New FlxResourcesManager<BitmapFont>()
	
	Field _font:BitmapFont
	Field _fontHeight:Int

Public
	Function Init:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		Local fontPathPrefix:String = FlxG.DATA_PREFIX + FlxText.SYSTEM_FONT + "_machine_font_"
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont("system", FlxText.DRIVER_FONTMACHINE)
		
		For Local size:Int = minSize To maxSize
			angelSystemFont.SetPath(size, fontPathPrefix +  size + ".txt")
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
		_font.UnloadFullFont()
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

End Class

Private
Class FlxFMDriverClass Implements FlxClass
	
	Method CreateInstance:Object()
		Return New FlxTextFontMachineDriver()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return FlxTextFontMachineDriver(object) <> Null
	End Method

End Class

Class FlxFMDriverLoader Extends FlxResourceLoader<BitmapFont>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return New BitmapFont(FlxAssetsManager.GetFont(fontFamily, FlxText.DRIVER_FONTMACHINE).GetPath(fontSize), False)			
	End Method

End Class