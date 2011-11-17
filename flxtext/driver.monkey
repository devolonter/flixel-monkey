Strict

Import flixel.flxg

Class FlxTextDriver

	Field name:String	
	
	'private
	Field _width:Int
	Field _text:String
	Field _textLines:StringStack
	Field _multiline:Bool
	Field _countLines:Int

Public
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
	
	Method SetFormat:Void(fontFamily:String, size:Int, alignment:Int)
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method SetFontFamily:Void(fontFamily:String)
		If (_text.Length > 0) _ParseText()
	End Method	
	
	Method SetFontSize:Void(size:Int)
		If (_text.Length > 0) _ParseText()
	End Method
	
	Method GetFontFamily:String() Abstract
	
	Method GetFontSize:Int() Abstract
	
	Method SetTextAlignment:Void(alignment:Float) Abstract	
	
	Method GettTextAlignment:Float() Abstract
	
	Method GetTextWidth:Int(text:String) Abstract

	Method Draw:Void(x:Float, y:Float) Abstract
	
	Method Destroy:Void() Abstract	
	
Private
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
					
					_textLines.Push(text[minOffset..offset])
					
					If (text[offset] = KEY_SPACE) Then
						minOffset = offset + 1	
					Else
						minOffset = offset
					End If
					
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
	
End Class