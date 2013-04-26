Strict

Import flxextern
Import flxsprite
Import flxcamera
Import flxg
Import system.flxcolor
Import system.flxassetsmanager

Private

#If FLX_TEXT_DRIVER = "angelfont"
	Import vendor.angelfont
#ElseIf FLX_TEXT_DRIVER = "fontmachine"
	Import vendor.fontmachine
#End

Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx.${FLX_FONT_EXTENSION}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx_${FLX_FONT_IMAGE_MASK}"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx.${FLX_FONT_EXTENSION}"

Public

Class FlxText Extends FlxSprite Implements FlxSpriteRenderer

	Global ClassObject:Object
	
	Const ALIGN_LEFT:Float = 0
	Const ALIGN_CENTER:Float = 0.5
	Const ALIGN_RIGHT:Float = 1
	
	Const SYSTEM_FONT:String = "system"
	
Private
	Global _FontLoader:FlxFontLoader = New FlxFontLoader()
	
	Global _FontsManager:FlxResourcesManager<FlxBitmapFont> = New FlxResourcesManager<FlxBitmapFont>()

	Field _shadow:FlxColor
	
	Field _value:String
	
	Field _lines:FlxTextLine[]
	
	Field _countLines:Int

	Field _alignment:Float
	
	Field _fontFamily:String
	
	Field _fontSize:Int
	
	Field _fontHeight:Int

	Field _fontObject:FlxBitmapFont

Public
	Method New(x:Float, y:Float, width:Int = 0, text:String = "")
		Super.New(x, y)
		
		SetRenderer(Self)
		_shadow = New FlxColor(0)
		
		Self.width = width
		frameWidth = Self.width
		moves = False

		SetFormat(SYSTEM_FONT)
		Text = text
	End Method
	
	Method Destroy:Void()
		Local i:Int = 0, l:Int = _lines.Length()
		
		While (i < l)
			_lines[i] = Null
			i += 1
		Wend
		
		_fontObject = Null
		_shadow = Null
	
		Super.Destroy()
	End Method
	
	Method SetFormat:FlxText(font:String = "", size:Int = 0, color:Int = FlxG.WHITE, alignment:Float = ALIGN_LEFT, shadowColor:Int = 0)
		_alignment = alignment
		_fontFamily = font
		_fontSize = FlxAssetsManager.GetFont(font).GetValidSize(size)
		
		Self.Color = color
		Shadow = shadowColor
		
		_ResetFont()
		_ResetHelpers()
		
		Return Self
	End Method
	
	Method SetWidth:Void(width:Float)
		Self.width = width
		frameWidth = Self.width
		_ResetHelpers()
	End Method
	
	Method Text:String() Property
		Return _value
	End Method
	
	Method Text:Void(text:String) Property
		_value = text
		_ResetHelpers()
	End Method
	
	Method Size:Void(size:Int) Property
		_fontSize = FlxAssetsManager.GetFont(_fontFamily).GetValidSize(size)
		_ResetFont()
		_ResetHelpers()
	End Method
	
	Method Size:Int() Property
		Return _fontSize
	End Method
	
	Method Font:String() Property
		Return _fontFamily
	End Method
	
	Method Font:Void(font:String) Property
		_fontFamily = font
		_ResetFont()
		_ResetHelpers()
	End Method
	
	Method Alignment:Float() Property
		Return _alignment
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		If (_alignment = alignment) Return
		_alignment = alignment
		_ResetAlignment()
	End Method
	
	Method Shadow:Int() Property
		Return _shadow.argb
	End Method
	
	Method Shadow:Void(color:Int) Property
		_shadow.SetARGB(color)
	End Method
	
	Method SetFontShadowEnabled:Void(enabled:Bool)
	#If FLX_TEXT_DRIVER = "angelfont"
		Return
	#ElseIf FLX_TEXT_DRIVER = "fontmachine"
		_fontObject._drawShadow = enabled
	#End
	End Method
	
	Method SetFontBoderEnabled:Void(enabled:Bool)
	#If FLX_TEXT_DRIVER = "angelfont"
		Return
	#ElseIf FLX_TEXT_DRIVER = "fontmachine"
		_fontObject._drawBorder = enabled
	#End
	End Method
	
	Method OnSpriteRender:Void(x:Float, y:Float)
		If (_shadow.argb <> 0) Then
			Local oldColor:Int = FlxG._LastDrawingColor
			Local oldAlpha:Int = FlxG._LastDrawingAlpha
		
			If (_camera.Color <> FlxG.WHITE) Then
				_mixedColor.MixRGB(_shadow, _camera._color)
				
				If (FlxG._LastDrawingColor <> _mixedColor.argb) Then
					SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
				End If				
			Else
				If (FlxG._LastDrawingColor <> _shadow.argb) Then
					SetColor(_shadow.r, _shadow.g, _shadow.b)
				End If		
			End If
			
			If (_camera.Alpha < 1) Then
				Local _mixedAlpha:Float = _camera.Alpha * _shadow.a
				
				If (FlxG._LastDrawingAlpha <> _mixedAlpha) Then
					SetAlpha(_mixedAlpha)					
				End If
			Else
				If (FlxG._LastDrawingAlpha <> _shadow.a) Then
					SetAlpha(_shadow.a)					
				End If
			End If					
			
			_fontObject.DrawText(Self, x + 1, y + 1)
			
			_mixedColor.SetRGB(oldColor)
			SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
			SetAlpha(oldAlpha)
		End If		
		
		_fontObject.DrawText(Self, x, y)
	End Method
	
Private
	Method _ResetHelpers:Void()
		If (_value.Length() > 0) Then
			If (width <> 0) Then
				_ParseText()
			Else
				_countLines = 0
				_AddLine(0, _value.Length(), _fontObject.GetTextWidth(Self, 0, _value.Length()))
				_ResetAlignment()
			End If
			
			Self.height = _GetHeight()
			frameHeight = Self.height
		Else
			Self.height = 0
			frameHeight = 0
		End If
		
		Super._ResetHelpers()
	End Method

	Method _ResetFont:Void()
		_FontLoader.fontFamily = _fontFamily
		_FontLoader.fontSize = _fontSize
		
		_fontObject = _FontsManager.GetResource(_fontFamily + _fontSize, _FontLoader)
		_fontHeight = _fontObject.GetFontHeight(Self)
	End Method

	Method _ResetAlignment:Void()
		If (_value.Length() = 0) Return
		
		For Local line:Int = 0 Until _countLines
			_lines[line].xOffset = (width - _lines[line].width) * _alignment
		Next
	End Method
	
	Method _GetHeight:Int()
		If (width = 0) Then
			Return _fontHeight
		Else
			Return _fontObject.GetTextHeight(Self)
		End If
	End Method

	Method _ParseText:Void()
		_countLines = 0
	
		Local prevOffset:Int = 0
		Local offset:Int = -1
		
		Local i:Int = 0, l:Int = _value.Length()
		
		While (i < l)
			If (_value[i] = 10 Or _value[i] = KEY_ENTER) Then
				offset = i
				Exit
			End If
			
			i += 1
		Wend

		If (offset >= 0) Then
			While (offset >= 0)
				_BuildLines(prevOffset, offset)
				
				prevOffset = offset + 1
				
				i = prevOffset
				offset = -1
		
				While (i < l)
					If (_value[i] = 10 Or _value[i] = KEY_ENTER) Then
						offset = i
						Exit
					End If
					
					i += 1
				Wend
			Wend
			
			_BuildLines(prevOffset, _value.Length())
		Else
			_BuildLines(0, _value.Length())
		End If

		_ResetAlignment()
	End Method
	
	Method _BuildLines:Void(startPos:Int, endPos:Int)
		Local textWidth:Int = _fontObject.GetTextWidth(Self, startPos, endPos)

		If (width < textWidth) Then
			Local textLength:Int = endPos - startPos
			
			Local range:Int = Ceil(textLength / Float(Floor(textWidth / Float(width)) + 1))

			Repeat			
				range += 1
				If (range >= textLength) range = textLength + 1
				textWidth = _fontObject.GetTextWidth(Self, startPos, range)
			Until (textWidth >= width)

			Local maxOffset:Int = range
			Local minOffset:Int = startPos
			Local offset:Int = maxOffset
			Local tmpOffset:Int = 0
			Local dirty:Bool = False
			Local finalTextWidth:Int = 0
			Local success:Bool
						
			Repeat			
				Repeat
					offset -= 1
					If (offset - minOffset <= 1) Then
						offset = minOffset + 1
						Exit
					End if
					
					tmpOffset = -1
					For Local i:Int = offset - 1 To minOffset Step - 1
						success = False
					
						If (_value[i] = KEY_SPACE Or _value[i] = KEY_TAB) Then
							tmpOffset = i
							success = True
							Exit
						End If
					Next
					
					If (tmpOffset < 0) Then
						tmpOffset = _GetMinOffset(minOffset, offset)
					Else
						If (_value[minOffset] = KEY_SPACE Or _value[minOffset] = KEY_TAB) Then
							For Local i:Int = minOffset To offset
								If (_value[i] <> KEY_SPACE And _value[i] <> KEY_TAB) Then
									minOffset = i
									Exit
								End If
							Next
						End If
					End If
					
					offset = tmpOffset
					textWidth = _fontObject.GetTextWidth(Self, minOffset, offset)
				Until (textWidth <= width)
			
				dirty = False
				finalTextWidth = _fontObject.GetTextWidth(Self, minOffset)
				
				If (finalTextWidth > width And textLength - minOffset > 1) Then
					For Local i:Int = minOffset Until offset
						If (_value[i] = KEY_SPACE Or _value[i] = KEY_TAB) Then
							minOffset += 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					For Local i:Int = offset - 1 To minOffset Step - 1
						If (_value[i] = KEY_SPACE Or _value[i] = KEY_TAB) Then
							offset -= 1
							dirty = True
						Else
							Exit
						End If
					Next
								
					If (offset - minOffset = 0) Continue
					
					If ( Not dirty) Then
						_AddLine(minOffset, offset, textWidth)
					Else
						_AddLine(minOffset, offset, _fontObject.GetTextWidth(Self, minOffset, offset))
					End If
					
					minOffset = offset
					If (success) minOffset += 1
					
					maxOffset = Min(minOffset + range, textLength)
					offset = maxOffset
				Else
					Local l:Int = _value.Length()
				
					For Local i:Int = minOffset Until l
						If (_value[i] = KEY_SPACE Or _value[i] = KEY_TAB) Then
							minOffset += 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					For Local i:Int = l - 1 To minOffset Step - 1
						If (_value[i] = KEY_SPACE Or _value[i] = KEY_TAB) Then
							l -= 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					If (l - minOffset <= 0) Exit
					
					If ( Not dirty) Then
						_AddLine(minOffset, l, finalTextWidth)
					Else
						_AddLine(minOffset, offset, _fontObject.GetTextWidth(Self, minOffset, l))
					End If
					
					Exit
				End If
			Forever
		Else
			_AddLine(startPos, endPos, textWidth)
		End If
	End Method
	
	Method _GetMinOffset:Int(startPos:Int, endPos:Int)
		Local offset:Int = endPos - startPos
		
		While (_fontObject.GetTextWidth(Self, startPos, startPos + offset) > width)
			offset -= 1			
			If (offset = 1) Return offset
		Wend

		Return startPos + offset
	End Method
	
	Method _AddLine:FlxTextLine(startPos:Int, endPos:Int, width:Int)
		Local line:FlxTextLine
	
		If (_countLines = _lines.Length()) Then
			_lines = _lines.Resize(_countLines * 2 + 10)
			line = New FlxTextLine(startPos, endPos, width)
			_lines[_countLines] = line
		Else
			line = _lines[_countLines]
			If (line = Null) Then
				line = New FlxTextLine(startPos, endPos, width)
				_lines[_countLines] = line
			Else
				line.Reset(startPos, endPos, width)
			End If
		End If
		
		_countLines += 1
		Return line
	End Method
	
End Class

Private
Class FlxTextLine

	Field xOffset:Float
	
	Field startPos:Int
	
	Field endPos:Int
	
	Field width:Int
	
	Method New(startPos:Int, endPos:Int, width:Int)
		Reset(startPos, endPos, width)
	End Method
	
	Method Reset:Void(startPos:Int, endPos:Int, width:Int)
		Self.startPos = startPos
		Self.endPos = endPos
		Self.width = width
	End Method

End Class

Class FlxFontLoader Extends FlxResourceLoader<FlxBitmapFont>
		
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:FlxBitmapFont(name:String)
		Return New FlxBitmapFont(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize))
	End Method

End Class

#If FLX_TEXT_DRIVER = "angelfont"	
	Class FlxBitmapFont
	Private
		Field image:Image[] = New Image[1]
		Field chars:Char[256]
		
		Field kernPairs:IntMap<IntMap<KernPair>> = New IntMap<IntMap<KernPair>>
		Global firstKp:IntMap<KernPair>
		Global secondKp:KernPair

		Field iniText:String
	
		Field xOffset:Int
		Field yOffset:Int
	
	Public
		Field useKerning:Bool = True
	
		Field height:Int = 0
		Field heightOffset:Int = 9999
		
		Field lineGap:Int = 5
		
		Method New(url:String)
			iniText = LoadString(url+".fnt")
			Local lines:String[] = iniText.Split(String.FromChar(10))
			Local firstLine:String = lines[0]
			If firstLine.Contains("<?xml")
				Local lineList:List<String> = New List<String>(lines)
				lineList.RemoveFirst()
				lines = lineList.ToArray()
				iniText = "~n".Join(lines)
			End	

			Local pageCount:Int = 0
			
			Local config:= LoadConfig(iniText)
			
			Local nodes:= config.FindNodesByPath("font/chars/char")
			
			For Local node:= EachIn nodes
				Local id:Int = Int(node.GetAttribute("id"))
				Local page:Int = Int(node.GetAttribute("page"))
				If pageCount < page pageCount = page
				chars[id] = New Char(Int(node.GetAttribute("x")), Int(node.GetAttribute("y")), Int(node.GetAttribute("width")), Int(node.GetAttribute("height")),  Int(node.GetAttribute("xoffset")),  Int(node.GetAttribute("yoffset")),  Int(node.GetAttribute("xadvance")), page)
				Local ch := chars[id]
				If ch.height > Self.height Self.height = ch.height
				If ch.yOffset < Self.heightOffset Self.heightOffset = ch.yOffset
			Next
			
			nodes = config.FindNodesByPath("font/kernings/kerning")
			
			If (nodes <> Null) Then
				For Local node:= EachIn nodes
					Local first:Int = Int(node.GetAttribute("first"))
					firstKp = kernPairs.Get(first)
					If firstKp = Null
						kernPairs.Add(first, New IntMap<KernPair>)
						firstKp = kernPairs.Get(first)
					End
					
					Local second:Int = Int(node.GetAttribute("second"))
					firstKp.Add(second, New KernPair(first, second, Int(node.GetAttribute("amount"))))
				End
			Else
				useKerning = False
			End If
			
			If pageCount = 0
				image[0] = LoadImage(url+".png")
				If image[0] = Null image[0] = LoadImage(url + "_0.png")
			Else
				For Local page:= 0 To pageCount
					If image.Length < page+1 image = image.Resize(page+1)
					image[page] = LoadImage(url+"_"+page+".png")
				End
			End
		End
		
		Method GetTextWidth:Int(txt:FlxText, startPos:Int = 0, endPos:Int = -1)
			Local prevChar:Int = 0
			Local width:Int = 0
			
			If (endPos < 0) endPos = txt._value.Length()
			Local asc:Int, ac:Char
		
			For Local i:= startPos Until endPos
				asc = txt._value[i]
				ac = chars[asc]

				If ac <> Null
					If useKerning
						Local firstKp:= kernPairs.Get(prevChar)
						If firstKp <> Null
							Local secondKp:= firstKp.Get(asc)
							If secondKp <> Null
								xOffset += secondKp.amount
							End							
						EndIf
						
						prevChar = asc
					EndIf
					
					width += ac.xAdvance
				EndIf
			Next
			
			Return width
		End Method
		
		Method GetFontHeight:Int(txt:FlxText)
			Local h:Int = 0
			
			If (txt._value.Length() <> 0) Then
				Local l:Int = txt._value.Length()
			
				For Local i:= 0 Until l
					Local asc:Int = txt._value[i]
					Local ac:Char = chars[asc]
					If ac <> Null And ac.height + ac.yOffset > h h = ac.height + ac.yOffset
				Next
			Else
				h = chars[KEY_SPACE].height + chars[KEY_SPACE].yOffset
			End If
		
			Return h
		End
		
		Method GetTextHeight:Int(txt:FlxText)
			Return ( (txt._fontHeight + lineGap) * txt._countLines) - lineGap
		End Method
		
		Method DrawText:Void(txt:FlxText, x:Int, y:Int)
			Local lineIndex:Int = 0, countLines:Int = txt._countLines, line:FlxTextLine
				
			Local prevChar:Int = 0, xOffset:Int = 0, yOffset:Int = y
			Local i:Int = 0, l:Int
			Local asc:Int, ac:Char
			Local lineHeight:Int = txt._fontHeight + lineGap
			
			While (lineIndex < countLines)
				line = txt._lines[lineIndex]
				i = line.startPos
				l = line.endPos
				xOffset = x + line.xOffset
			
				While (i < l)
					asc = txt._value[i]
					ac = chars[asc]
				
					If ac <> Null
						If useKerning
							firstKp = kernPairs.Get(prevChar)
							If firstKp <> Null
								secondKp = firstKp.Get(asc)
								If secondKp <> Null
									xOffset += secondKp.amount
								End
							EndIf
							
							prevChar = asc
						Endif
												
						ac.Draw(image[ac.page], xOffset, yOffset)
						xOffset += ac.xAdvance
					Endif
					
					i += 1
				Wend

				lineIndex += 1
				yOffset += lineHeight
			Wend
		End Method
	
	End Class
	
#ElseIf FLX_TEXT_DRIVER = "fontmachine"

	Class FlxBitmapFont Implements Font

		Method New(fontDescriptionFilePath:String)
			Local text:String = LoadString(fontDescriptionFilePath + ".txt")
			If text = "" Then Print "FONT " + fontDescriptionFilePath + " WAS NOT FOUND!!!"
			
			_kerning = New drawingpoint.DrawingPoint
			LoadFontData(text, fontDescriptionFilePath, False)
		End

		Method GetTextWidth:Float(text:FlxText, fromChar:Int = 0, toChar:Int = -1)
			Local twidth:Float
			Local char:Int
			Local lastchar:Int = 0
			
			If (toChar < 0) toChar = text._value.Length()
					
			For Local i:Int = fromChar Until toChar
				char = text._value[i]
				
				If faceChars[char] <> Null Then
					lastchar = char
					twidth = twidth + faceChars[char].drawingMetrics.drawingWidth + _kerning.x
				End If
			Next

			Return twidth - faceChars[lastchar].drawingMetrics.drawingWidth + faceChars[lastchar].drawingMetrics.drawingSize.x
		End Method

		Method GetTextHeight:Float(text:FlxText)
			Return ( (text._fontHeight + _kerning.y) * text._countLines) - _kerning.y
		End

		Method GetFontHeight:Int(txt:FlxText)
			If faceChars[32] = Null Then Return 0
			Return faceChars[32].drawingMetrics.drawingSize.y 
		End Method
		
		Method DrawText:Void(text:FlxText, x:Float, y:Float)
			If (_drawShadow) DrawChars(text, x, y, shadowChars)
			If (_drawBorder) DrawChars(text, x, y, borderChars)
			DrawChars(text, x, y, faceChars)
		End
			
	Private
		
		Field _drawShadow:Bool = False
		Field _drawBorder:Bool = False
		Field borderChars:BitMapChar[]
		Field faceChars:BitMapChar[]
		Field shadowChars:BitMapChar[]
			
		Method LoadFontData:Void(Info:String, fontName:String, dynamicLoad:bool)
			if Info.StartsWith("P1") Then
				LoadPacked(Info,fontName,dynamicLoad)				
				return
			EndIf
			Local tokenStream:String[] = Info.Split(",") 
			local index:Int = 0 
			borderChars = New BitMapChar[65536]
			faceChars = New BitMapChar[65536]
			shadowChars = New BitMapChar[65536]
			
			Local prefixName:String = fontName
			if prefixName.ToLower().EndsWith(".txt") Then prefixName = prefixName[..-4]
			
			Local char:Int = 0
			while index<tokenStream.Length
				'We get char to load:
				Local strChar:String = tokenStream[index]
				if strChar.Trim() = "" Then 
					'Print "This is going to fail..."
					index+=1
					Exit    
				endif
				char = int(strChar)
				'Print "Loading char: " + char + " at index: " + index
				index+=1
				
				Local kind:String = tokenStream[index]
				'Print "Found kind= " + kind 
				index +=1
				
				Select kind
					Case "{BR"
						index+=3 '3 control point for future use
						borderChars[char] = New BitMapChar
						borderChars[char].drawingMetrics.drawingOffset.x = Int(tokenStream[index])
						borderChars[char].drawingMetrics.drawingOffset.y = Int(tokenStream[index+1])
						borderChars[char].drawingMetrics.drawingSize.x = Int(tokenStream[index+2])
						borderChars[char].drawingMetrics.drawingSize.y = Int(tokenStream[index+3])
						borderChars[char].drawingMetrics.drawingWidth = Int(tokenStream[index+4])
						if dynamicLoad  = False then
							borderChars[char].image = LoadImage(prefixName + "_BORDER_" + char + ".png")
							borderChars[char].image.SetHandle(-borderChars[char].drawingMetrics.drawingOffset.x,-borderChars[char].drawingMetrics.drawingOffset.y)
						Else
							borderChars[char].SetImageResourceName  prefixName + "_BORDER_" + char + ".png"
						endif
						index+=5
						index += 1 ' control point for future use
						
						_drawBorder = True
	
					Case "{SH"
						index+=3 '3 control point for future use
						shadowChars[char] = New BitMapChar
						shadowChars[char].drawingMetrics.drawingOffset.x = Int(tokenStream[index])
						shadowChars[char].drawingMetrics.drawingOffset.y = Int(tokenStream[index+1])
						shadowChars[char].drawingMetrics.drawingSize.x = Int(tokenStream[index+2])
						shadowChars[char].drawingMetrics.drawingSize.y = Int(tokenStream[index+3])
						shadowChars[char].drawingMetrics.drawingWidth = Int(tokenStream[index+4])
						Local filename:String = prefixName + "_SHADOW_" + char + ".png"
						if dynamicLoad  = False then
							shadowChars[char].image = LoadImage(filename)
							shadowChars[char].image.SetHandle(-shadowChars[char].drawingMetrics.drawingOffset.x,-shadowChars[char].drawingMetrics.drawingOffset.y)
						Else
							shadowChars[char].SetImageResourceName  filename 
						endif
	
						
						'shadowChars[char].image = LoadImage(filename)
						'shadowChars[char].image.SetHandle(-shadowChars[char].drawingMetrics.drawingOffset.x,-shadowChars[char].drawingMetrics.drawingOffset.y)
	
						index+=5
						index += 1 ' control point for future use
						
						_drawShadow = True
						
					Case "{FC"
						index+=3 '3 control point for future use
						faceChars[char] = New BitMapChar
						faceChars[char].drawingMetrics.drawingOffset.x = Int(tokenStream[index])
						faceChars[char].drawingMetrics.drawingOffset.y = Int(tokenStream[index+1])
						faceChars[char].drawingMetrics.drawingSize.x = Int(tokenStream[index+2])
						faceChars[char].drawingMetrics.drawingSize.y = Int(tokenStream[index+3])
						faceChars[char].drawingMetrics.drawingWidth = Int(tokenStream[index+4])
						if dynamicLoad = False then
							faceChars[char].image = LoadImage(prefixName + "_" + char + ".png")
							faceChars[char].image.SetHandle(-faceChars[char].drawingMetrics.drawingOffset.x,-faceChars[char].drawingMetrics.drawingOffset.y)
						Else
							faceChars[char].SetImageResourceName prefixName + "_" + char + ".png" 
						endif
						index+=5 
						index+=1 ' control point for future use
	
					Default 
					Print "Error loading font! Char = " + char
					
				End
			Wend
			borderChars = borderChars[..char+1]
			faceChars = faceChars[..char+1]
			shadowChars = shadowChars[..char+1]
		End
		
		Field packedImages:Image[]
		
		Method LoadPacked:Void(info:String, fontName:String, dynamicLoad:bool)
	
			Local header:String = info[.. info.Find(",")]
			
			Local separator:String
			Select header
				Case "P1"
					separator = "."
				Case "P1.01"
					separator = "_P_"
			End Select
			info = info[info.Find(",")+1..]
			borderChars = New BitMapChar[65536]
			faceChars = New BitMapChar[65536]
			shadowChars = New BitMapChar[65536]
			packedImages = New Image[256]
			Local maxPacked:Int = 0
			Local maxChar:Int = 0
	
			Local prefixName:String = fontName
			if prefixName.ToLower().EndsWith(".txt") Then prefixName = prefixName[..-4]
	
			Local charList:string[] = info.Split(";")
			For local chr:String = EachIn charList
	
				Local chrdata:string[] = chr.Split(",")
				if chrdata.Length() <2 Then Exit 
				Local char:bitmapchar.BitMapChar 
				Local charIndex:Int = int(chrdata[0])
				if maxChar<charIndex Then maxChar = charIndex 
				
				select chrdata[1]
					Case "B"
						borderChars[charIndex] = New BitMapChar
						char = borderChars[charIndex]
						_drawBorder = True
					Case "F"
						faceChars [charIndex] = New BitMapChar
						char = faceChars[charIndex]
					Case "S"
						shadowChars [charIndex] = New BitMapChar
						char = shadowChars[charIndex]
						_drawShadow = True
				End Select
				char.packedFontIndex = Int(chrdata[2])
				if packedImages[char.packedFontIndex] = null Then
					packedImages[char.packedFontIndex] = LoadImage(prefixName + separator + char.packedFontIndex +  ".png")
					if maxPacked<char.packedFontIndex Then maxPacked = char.packedFontIndex
				endif
				char.packedPosition.x = Int(chrdata[3])
				char.packedPosition.y = Int(chrdata[4])
				char.packedSize.x = Int(chrdata[5])
				char.packedSize.y = Int(chrdata[6])
				char.drawingMetrics.drawingOffset.x = Int(chrdata[8])
				char.drawingMetrics.drawingOffset.y = Int(chrdata[9])
				char.drawingMetrics.drawingSize.x = Int(chrdata[10])
				char.drawingMetrics.drawingSize.y = Int(chrdata[11])
				char.drawingMetrics.drawingWidth = Int(chrdata[12])
	
			Next
			
			borderChars = borderChars[..maxChar+1]
			faceChars = faceChars[..maxChar+1]
			shadowChars = shadowChars[..maxChar+1]
			packedImages = packedImages[..maxPacked+1]
			
		End
		
		Method DrawChars:Void(text:FlxText, x:Float, y:Float, target:BitMapChar[])
			Local lineIndex:Int = 0, countLines:Int = text._countLines, line:FlxTextLine
				
			Local drx:Int = x, dry:Int = y
			Local i:Int = 0, l:Int
			Local char:Int
			
			Local lineHeight:Int = text._fontHeight + _kerning.y
			Local targetLength:Int = target.Length()
			
			While (lineIndex < countLines)
				line = text._lines[lineIndex]
				i = line.startPos
				l = line.endPos
				drx = x + line.xOffset
			
				While (i < l)
					char = text._value[i]
				
					If char >= 0 And char <= targetLength And target[char] <> Null Then
						If target[char].packedFontIndex > 0 Then
								DrawImageRect(packedImages[target[char].packedFontIndex], drx + target[char].drawingMetrics.drawingOffset.x, dry + target[char].drawingMetrics.drawingOffset.y, target[char].packedPosition.x, target[char].packedPosition.y, target[char].packedSize.x, target[char].packedSize.y)
						ElseIf target[char].image <> Null Then
							DrawImage(target[char].image, drx, dry)
						EndIf
						
						drx += faceChars[char].drawingMetrics.drawingWidth + _kerning.x
					End If
					
					i += 1
				Wend

				lineIndex += 1
				dry += lineHeight
			Wend
		End Method
	
		Field _kerning:drawingpoint.DrawingPoint
	End
#End