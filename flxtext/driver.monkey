Strict

Import flixel.flxg

Class FlxTextDriver
	
'private
	Field _width:Int
	Field _offsetX:Float
	Field _text:String
	Field _textLines:Stack<FlxTextDriverTextLine>
	Field _countLines:Int
	
	Field _fontFamily:String		
	Field _size:Int
	Field _alignment:Float

Public
	Method New()
		_textLines = New Stack<FlxTextDriverTextLine>();
	End Method

	Method Width:Void(width:Int) Property
		_width = width
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method Text:Void(text:String) Property
		_text = text
		If (_width <> 0) _ParseText()
	End Method	
	
	Method Text:String() Property
		Return _text
	End Method
	
	Method SetFormat:Void(fontFamily:String, size:Int, alignment:Float)
		_alignment = alignment
		_fontFamily = fontFamily
		_size = size
		Reset()	
			
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method Font:Void(fontFamily:String) Property
		_fontFamily = fontFamily	
		Reset()
		
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method Font:String() Property
		Return _fontFamily
	End Method	
	
	Method Size:Void(size:Int) Property
		_size = size
		Reset()
		
		If (_text.Length > 0) _ParseText()
	End Method	
	
	Method Size:Int() Property
		Return _size
	End Method
	
	Method Alignment:Void(aligment:Float) Property
		_alignment = aligment
		
		If (_text.Length > 0) Then
			If (_countLines <= 1) Then
				_offsetX = (_width - GetTextWidth(_text)) * _alignment
			Else		
				For Local line:Int = 0 Until _countLines
					_textLines.Get(line).offsetX = (_width - GetTextWidth(_textLines.Get(line).text)) * _alignment
				Next
			End If	
		End If
	End Method
	
	Method Alignment:Float() Property
		Return _alignment
	End Method
	
	Method Destroy:Void()
		Local l:Int = _textLines.Length()			
		For Local i:Int = 0 Until l
			_textLines.Set(i, Null)
		Next
		
		_textLines.Clear()	
	End Method	
	
	Method GetTextWidth:Int(text:String) Abstract
	
	Method Reset:Void() Abstract

	Method Draw:Void(x:Float, y:Float) Abstract	
	
Private
	Method _ParseText:Void()
		_countLines = 1
		
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
		
		Alignment = _alignment 'recalc alignment
	End Method
	
	Method _BuildLines:Void(text:String)		
		Local textWidth:Int = GetTextWidth(text)		

		If (_width < textWidth) Then		
			Local textLength:Int = text.Length
			
			Local range:Int = Ceil(textLength / Float(Floor(textWidth / Float(_width)) + 1))
			Repeat
				range+=1
			Until(GetTextWidth(text[0..range]) >= _width)

			Local maxOffset:Int = range
			Local minOffset:Int = 0
			Local offset:Int = maxOffset
			Local linesCapacity:Int = _textLines.Length()
			
			Repeat
				Repeat
					offset-=1
					While (text[offset] <> KEY_SPACE And offset > minOffset)						
						offset-=1
					Wend
					If (offset <= minOffset) Exit
				Until(GetTextWidth(text[minOffset..offset]) <= _width)
				
				If (offset <= minOffset) Then
					While(GetTextWidth(text[minOffset..offset+1]) < _width And offset < textLength)
						offset+=1
					Wend	
				End If								
				
				If (GetTextWidth(text[minOffset..]) > _width And textLength - minOffset > 1) Then
					If (text[offset] <> KEY_SPACE) offset+=1
					
					If (_countLines > linesCapacity) Then
						_textLines.Push(New FlxTextDriverTextLine(text[minOffset..offset]))						
					Else
						_textLines.Get(_countLines - 1).text = text[minOffset..offset]
					End If
					
					If (text[offset] = KEY_SPACE) Then
						minOffset = offset + 1	
					Else
						minOffset = offset
					End If
					
					maxOffset = minOffset + range
					offset = maxOffset
					_countLines+=1
				Else
					If (_countLines >= linesCapacity) Then
						_textLines.Push(New FlxTextDriverTextLine(text[minOffset..]))
					Else
						_textLines.Get(_countLines).text = text[minOffset..]
					End If			
					Exit
				End If
			Forever						
		End If	
	End Method
	
End Class

Private
Class FlxTextDriverTextLine

	Field text:String
	Field offsetX:Float
	
	Method New(text:String)
		Self.text = text
	End Method
	
End Class