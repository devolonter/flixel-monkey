Strict

Import flixel.flxtext
Import flixel.flxtext.driver
Import flixel.flxtext.fontmanager

Import mojo
Import fontmachine.fontmachine

Import "../../data/flx_system_fm_font_8.txt"
Import "../../data/flx_system_fm_font_8_P_1.png"
Import "../../data/flx_system_fm_font_9.txt"
Import "../../data/flx_system_fm_font_9_P_1.png"
Import "../../data/flx_system_fm_font_10.txt"
Import "../../data/flx_system_fm_font_10_P_1.png"
Import "../../data/flx_system_fm_font_11.txt"
Import "../../data/flx_system_fm_font_11_P_1.png"
Import "../../data/flx_system_fm_font_12.txt"
Import "../../data/flx_system_fm_font_12_P_1.png"
Import "../../data/flx_system_fm_font_13.txt"
Import "../../data/flx_system_fm_font_13_P_1.png"
Import "../../data/flx_system_fm_font_14.txt"
Import "../../data/flx_system_fm_font_14_P_1.png"
Import "../../data/flx_system_fm_font_15.txt"
Import "../../data/flx_system_fm_font_15_P_1.png"
Import "../../data/flx_system_fm_font_16.txt"
Import "../../data/flx_system_fm_font_16_P_1.png"

Class FontMachineDriver Extends TextDriver	

Private	
	Field _text:String
	Field _font:BitmapFont
	
	Field _fontName:String	
	Field _size:Int = FlxText.MIN_SIZE
	Field _alignment:Float

Public
	Method GetName:String()
		Return "fm"
	End Method
	
	Method SetFontName:Void(fontName:String)
		_fontName = fontName
		_InitFont(fontName, _size)		
	End Method
	
	Method GetFontName:String()
		Return _fontName
	End Method
	
	Method SetSize:Void(size:Int)
		_size = size
		_InitFont(_fontName, size)
	End Method
	
	Method GetSize:Int()
		Return _size
	End Method
	
	Method SetText:Void(text:String)
		_text = text
	End Method	
	
	Method GetText:String()
		Return _text
	End Method
	
	Method SetAlignment:Void(alignment:Float)
		_alignment = alignment
	End Method	
	
	Method GettAlignment:Float()
		Return _alignment
	End Method
	
	Method Draw:Void(x:Float, y:Float)
		_font.DrawText(_text, x, y)		
	End Method
	
	Method Destroy:Void()
	End Method			
	
Private
	Method _InitFont:Void(fontName:String, size:Int)
		_font = _fontManager.GetFont(fontName, size)
		If (_font = Null) Then
			_font = New BitmapFont(Self.GetFileName(fontName) + size + ".txt", False)
			
			If (_font = Null And _defaultFont = Null) Then
				Error ("Font " + fontName +  " can't be loaded")
			ElseIf (_font = Null) Then
				_font = _defaultFont
				Return
			End If
			
			_fontManager.AddFont(fontName, size, _font)
			If (_defaultFont = Null) _defaultFont = _font
		End If
	End Method
	
Public
		

End Class

Private
	Global _fontManager:FontManager<BitmapFont> = New FontManager<BitmapFont>()
	Global _defaultFont:BitmapFont