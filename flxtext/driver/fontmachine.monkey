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
	Field _width:Int
	Field _text:String
	Field _textLines:StringStack
	Field _multiline:Bool
	Field _countLines:Int
	Field _font:BitmapFont
	
	Field _fontName:String
	Field _fontHeight:Int = 0	
	Field _size:Int = FlxText.MIN_SIZE
	Field _alignment:Float

Public
	Method New()
		_textLines = New StringStack();
	End Method
	
	Method SetFormat:Void(fontName:String, size:Int, alignment:Int)		
		SetAlignment(alignment)
		_fontName = fontName
		_size = size
		_InitFont(fontName, size)
		If (_text.Length > 0) _ParseText()
	End Method	

	Method GetName:String()
		Return "fm"
	End Method
	
	Method SetWidth:Void(width:Int)
		_width = width
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method SetFontName:Void(fontName:String)
		_fontName = fontName
		_InitFont(fontName, _size)
		If (_text.Length > 0) _ParseText()			
	End Method
	
	Method GetFontName:String()
		Return _fontName
	End Method
	
	Method SetSize:Void(size:Int)
		_size = size
		_InitFont(_fontName, size)
		If (_text.Length > 0) _ParseText()	
	End Method
	
	Method GetSize:Int()
		Return _size
	End Method
	
	Method SetText:Void(text:String)
		_text = text
		If (_width <> 0) _ParseText()
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
		If (Not _multiline) Then
			_font.DrawText(_text, x, y)
		Else		
			For Local line:Int = 0 Until _countLines
				_font.DrawText(_textLines.Get(line), x, y + line * _fontHeight)
			Next
		End If	
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
				_fontHeight = _font.GetFontHeight()
				Return
			End If
			
			_fontManager.AddFont(fontName, size, _font)
			If (_defaultFont = Null) _defaultFont = _font			
		End If
		
		_fontHeight = _font.GetFontHeight()
	End Method
	
	Method _ParseText:Void()	
		_multiline = False
		_countLines = 0
		_textLines.Clear()
		
		Local prevOffset:Int = 0
		Local offsetN:Int = _text.Find("~n", 0)
		Local offsetR:Int = _text.Find("~r", 0)
		Local offset:Int = 0
		
		If (offsetN >= 0 And offsetR >= 0) Then
			offset = Min(offsetN, offsetR)
		Else
			offset = Max(offsetN, offsetR)
		End if
		
		If (offset >= 0) Then
			While (offset >= 0)			
				_BuildLines(_text[prevOffset..offset])
				
				prevOffset = offset+1
				
				offsetN = _text.Find("~n", prevOffset)
				offsetR = _text.Find("~r", prevOffset)
								
				If (offsetN >= 0 And offsetR >= 0) Then
					offset = Min(offsetN, offsetR)
				Else
					offset = Max(offsetN, offsetR)
				End if
			Wend
			
			_BuildLines(_text[prevOffset..])
		Else
			_BuildLines(_text)	
		End If		 
		
		If (_textLines.Length() > 0) Then
			_multiline = True
			_countLines = _textLines.Length()		
		End If
	End Method
	
	Method _BuildLines:Void(text:String)		
		Local textWidth:Int = _font.GetTxtWidth(text)		

		If (_width < textWidth) Then		
			Local textLength:Int = text.Length
			
			Local range:Int = Ceil(textLength / Float(Floor(textWidth / Float(_width)) + 1))
			Repeat
				range+=1
			Until(_font.GetTxtWidth(text[0..range]) >= _width)

			Local maxOffset:Int = range
			Local minOffset:Int = 0
			Local offset:Int = maxOffset
			
			Repeat
				Repeat
					offset-=1
					While (text[offset] <> KEY_SPACE And offset > minOffset)						
						offset-=1
					Wend
					If (offset <= minOffset) Exit
				Until(_font.GetTxtWidth(text[minOffset..offset]) <= _width)
				
				If (offset <= minOffset) Then
					While(_font.GetTxtWidth(text[minOffset..offset+1]) < _width And offset < textLength)
						offset+=1
					Wend	
				End If
				
				If (_font.GetTxtWidth(text[minOffset..]) > _width And textLength - minOffset > 1) Then
					offset+=1
					_textLines.Push(text[minOffset..offset])				
					minOffset = offset
					
					maxOffset = minOffset + range
					offset = maxOffset
				Else
					_textLines.Push(text[minOffset..])
					Exit
				End If 	
			Forever
			
			_countLines = _textLines.Length()
		Else
			_textLines.Push(text)							
		End If	
	End Method
	
Public
		

End Class

Private
	Global _fontManager:FontManager<BitmapFont> = New FontManager<BitmapFont>()
	Global _defaultFont:BitmapFont