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
	
	Method ID:Int() Property
		Return FlxText.DRIVER_NATIVE			 	
	End Method
	
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
			Local tmpOffset:Int = 0
			Local tmpString:String = ""
			
			Repeat
				Repeat
					offset -= 1
					If (offset - minOffset <= 1) Then
						offset = minOffset + 1
						Exit
					End if
				
					tmpString = text[minOffset..offset]
					tmpOffset = tmpString.FindLast(String.FromChar(KEY_SPACE))
					
					If (tmpOffset < 0) Then
						tmpOffset = _GetMinOffset(tmpString)
					Else
						If (tmpString.Length() > 1 And tmpString.StartsWith(String.FromChar(KEY_SPACE))) Then
							minOffset += 1
							offset +=  Min(offset + 2, maxOffset)
							Continue	
						EndIf		
					End If
					
					offset = tmpOffset + minOffset
				Until(GetTextWidth(text[minOffset..offset]) <= _width)
			
				
				If (GetTextWidth(text[minOffset..]) > _width And textLength - minOffset > 1) Then					
					tmpString = text[minOffset..offset].Trim()
					If (tmpString.Length() = 0) Continue
					
					If (_countLines > linesCapacity) Then
						_textLines.Push(New FlxTextDriverTextLine(tmpString))						
					Else
						_textLines.Get(_countLines - 1).text = tmpString
					End If

					minOffset = offset
					maxOffset = minOffset + range
					offset = maxOffset
					_countLines+=1
				Else
					tmpString = text[minOffset..].Trim()
					If (tmpString.Length() = 0) Continue
				
					If (_countLines >= linesCapacity) Then
						_textLines.Push(New FlxTextDriverTextLine(tmpString))
					Else
						_textLines.Get(_countLines - 1).text = tmpString
					End If			
					Exit
				End If
			Forever						
		End If	
	End Method
	
	Method _GetMinOffset:Int(text:String)
		Local offset:Int = text.Length()
		
		While(GetTextWidth(text[0..offset]) > _width)
			offset -= 1			
			If (offset = 0) Return offset		
		Wend

		Return offset		
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