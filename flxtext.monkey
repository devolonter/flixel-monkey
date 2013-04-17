Strict

Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx.txt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx.txt"

Import flxextern
Import flxsprite
Import flxcamera
Import flxg
Import system.flxcolor
Import system.flxassetsmanager

#If FLX_TEXT_DRIVER = "angelfont"
	Import vendor.angelfont
#End

Class FlxText Extends FlxSprite Implements FlxSpriteRenderer

	Global ClassObject:Object
	
	Const ALIGN_LEFT:Float = 0
	Const ALIGN_CENTER:Float = 0.5
	Const ALIGN_RIGHT:Float = 1
	
	Const SYSTEM_FONT:String = "system"
	
Private
	Field _shadow:FlxColor
	
	Field _textObject:FlxTextInternalObject

Public
	Method New(x:Float, y:Float, width:Int = 0, text:String = "")
		Super.New(x, y)
		
		_textObject = New FlxTextInternalObject()
		
		SetRenderer(Self)
		_shadow = New FlxColor(0)
		
		Self.width = width
		frameWidth = Self.width
		moves = False

		SetFormat(SYSTEM_FONT)
		Text = text
	End Method
	
	Method Destroy:Void()
		_textObject.Destroy()
		_textObject = Null
		_shadow = Null
	
		Super.Destroy()
	End Method
	
	Method SetFormat:FlxText(font:String = "", size:Int = 0, color:Int = FlxG.WHITE, alignment:Float = ALIGN_LEFT, shadowColor:Int = 0)
		_textObject.SetFormat(font, FlxAssetsManager.GetFont(font).GetValidSize(size), alignment)
		Self.Color = color
		Shadow = shadowColor
		
		Self.height = _textObject.GetHeight()
		frameHeight = Self.height
		_ResetHelpers()
		
		Return Self
	End Method
	
	Method SetWidth:Void(width:Float)
		Self.width = width
		frameWidth = Self.width
		
		_textObject.SetWidth(width)
		_ResetHelpers()
	End Method
	
	Method Text:String() Property
		Return _textObject.value
	End Method
	
	Method Text:Void(text:String) Property
		_textObject.SetText(text)
		
		height = _textObject.GetHeight()
		frameHeight = height
		_ResetHelpers()
	End Method
	
	Method Size:Void(size:Int) Property
		_textObject.SetFontSize(FlxAssetsManager.GetFont(_textObject._fontFamily).GetValidSize(size))
		
		height = _textObject.GetHeight()
		frameHeight = height
		_ResetHelpers()
	End Method
	
	Method Size:Int() Property
		Return _textObject._fontSize
	End Method
	
	Method Font:String() Property
		Return _textObject._fontFamily
	End Method
	
	Method Font:Void(font:String) Property
		_textObject.SetFontFamily(font)
		
		height = _textObject.GetHeight()
		frameHeight = height
		_ResetHelpers()
	End Method
	
	Method Alignment:Float() Property
		Return _textObject._alignment
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		_textObject.SetAlignment(alignment)
	End Method
	
	Method Shadow:Int() Property
		Return _shadow.argb
	End Method
	
	Method Shadow:Void(color:Int) Property
		_shadow.SetARGB(color)
	End Method

#If FLX_TEXT_DRIVER = "angelfont"	
	Method GetFontObject:AngelFont()
		Return _textObject._font
	End Method
#End
	
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
			
			_textObject._font._FlxDrawText(_textObject, x + 1, y + 1)
			
			_mixedColor.SetRGB(oldColor)
			SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
			SetAlpha(oldAlpha)
		End If		
		
		_textObject._font._FlxDrawText(_textObject, x, y)
	End Method
	
End Class

Class FlxTextInternalObject
	
	Field value:String
	
	Field lines:FlxTextInternalLine[]
	
	Field countLines:Int
	
Private
	Global _FontLoader:FlxFontLoader = New FlxFontLoader()
	
	Global _FontsManager:FlxFontsManager = New FlxFontsManager()
	
	Field _width:Int

	Field _alignment:Float
	
	Field _fontFamily:String
	
	Field _fontSize:Int

#If FLX_TEXT_DRIVER = "angelfont"	
	Field _font:AngelFont
#End
	
	Method Destroy:Void()
		Local i:Int = 0, l:Int = lines.Length()
		
		While (i < l)
			lines[i] = Null
		Wend
	End Method
	
	Method SetWidth:Void(width:Int)
		_width = width
		If (value.Length() > 0) _ParseText()
	End Method
	
	Method SetText:Void(text:String)
		value = text
		If (value.Length() > 0) _ParseText()
	End Method
	
	Method SetFormat:Void(fontFamily:String, fontSize:Int, alignment:Float)
		_alignment = alignment
		_fontFamily = fontFamily
		_fontSize = fontSize
		
		_ResetFont()
		If (value.Length() > 0) _ParseText()
	End Method
	
	Method SetFontFamily:Void(fontFamily:String)
		_fontFamily = fontFamily
			
		_ResetFont()
		If (value.Length() > 0) _ParseText()
	End Method
	
	Method SetFontSize:Void(fontSize:Int) Property
		_fontSize = fontSize
		
		_ResetFont()
		If (value.Length() > 0) _ParseText()
	End Method
	
	Method SetAlignment:Void(alignment:Float) Property
		_alignment = alignment
		If (value.Length() > 0) _ResetAlignment(alignment)
	End Method
	
	Method GetHeight:Int()
		Local h:Int = 0
	
		For Local line:Int = 0 Until countLines
			h += _font._FlxGetTextHeight(Self, lines[line].startPos, lines[line].endPos) * 1.5
		Next
		
		Return h
	End Method
	
Private
	Method _ResetFont:Void()
		_FontLoader.fontFamily = _fontFamily
		_FontLoader.fontSize = _fontSize
		
		_font = _FontsManager.GetResource(_fontFamily + _fontSize, _FontLoader)
	End Method

	Method _ResetAlignment:Void(alignment:Float) Property
		_alignment = alignment
		
		If (value.Length() = 0) Return
		
		For Local line:Int = 0 Until countLines
			lines[line].x = (_width - lines[line].width) * alignment
		Next
	End Method

	Method _ParseText:Void()
		Local prevOffset:Int = 0
		Local offsetN:Int = value.Find("~n", 0)
		Local offsetR:Int = value.Find("~r", 0)
		Local offset:Int = 0
		
		If (offsetN >= 0 And offsetR >= 0) Then
			offset = Min(offsetN, offsetR)
		Else
			offset = Max(offsetN, offsetR)
		End if
		
		If (offset >= 0) Then
			While (offset >= 0)			
				_BuildLines(prevOffset, offset)
				
				prevOffset = offset + 1
				
				offsetN = value.Find("~n", prevOffset)
				offsetR = value.Find("~r", prevOffset)
								
				If (offsetN >= 0 And offsetR >= 0) Then
					offset = Min(offsetN, offsetR)
				Else
					offset = Max(offsetN, offsetR)
				End if
			Wend
			
			_BuildLines(prevOffset, value.Length())
		Else			
			_BuildLines(0, value.Length())
		End If
		
		_ResetAlignment(_alignment)
	End Method
	
	Method _BuildLines:Void(startPos:Int, endPos:Int)
		Local textWidth:Int = _font._FlxGetTextWidth(Self, startPos, endPos)

		If (_width < textWidth) Then		
			Local textLength:Int = startPos - endPos
			
			Local range:Int = Ceil(textLength / Float(Floor(textWidth / Float(_width)) + 1))
			Repeat
				range += 1
				textWidth = _font._FlxGetTextWidth(Self, 0, range)
			Until (textWidth >= _width)

			Local maxOffset:Int = range
			Local minOffset:Int = 0
			Local offset:Int = maxOffset
			Local tmpOffset:Int = 0
			Local dirty:Bool = False
			Local finalTextWidth:Int = 0
						
			Repeat
				Repeat
					offset -= 1
					If (offset - minOffset <= 1) Then
						offset = minOffset + 1
						Exit
					End if
					
					tmpOffset = -1
					For Local i:Int = offset - 1 To minOffset Step - 1
						If (value[i] = KEY_SPACE) tmpOffset = i
					Next
					
					If (tmpOffset < 0) Then
						tmpOffset = _GetMinOffset(minOffset, offset)
					Else
						If (offset - minOffset > 1 And value[offset] = KEY_SPACE) Then
							minOffset += 1
							offset +=  Min(offset + 2, maxOffset)
							Continue	
						EndIf		
					End If
					
					offset = tmpOffset + minOffset
					textWidth = _font._FlxGetTextWidth(Self, minOffset, offset)
				Until (textWidth <= _width)
			
				dirty = False
				finalTextWidth = _font._FlxGetTextWidth(Self, minOffset)
				
				If (finalTextWidth > _width And textLength - minOffset > 1) Then
					For Local i:Int = minOffset Until offset
						If (value[i] = KEY_SPACE Or value[i] = KEY_TAB) Then
							minOffset += 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					For Local i:Int = offset - 1 To minOffset Step - 1
						If (value[i] = KEY_SPACE Or value[i] = KEY_TAB) Then
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
						_AddLine(minOffset, offset, _font._FlxGetTextWidth(Self, minOffset, offset))
					End If
					
					minOffset = offset
					maxOffset = minOffset + range
					offset = maxOffset
				Else
					Local l:Int = value.Length()
				
					For Local i:Int = minOffset Until l
						If (value[i] = KEY_SPACE Or value[i] = KEY_TAB) Then
							minOffset += 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					For Local i:Int = l - 1 To minOffset Step - 1
						If (value[i] = KEY_SPACE Or value[i] = KEY_TAB) Then
							l -= 1
							dirty = True
						Else
							Exit
						End If
					Next
					
					If (offset - l = 0) Continue
					
					If ( Not dirty) Then
						_AddLine(minOffset, l, finalTextWidth)
					Else
						_AddLine(minOffset, offset, _font._FlxGetTextWidth(Self, minOffset, l))
					End If
					
					Exit
				End If
			Forever
		Else
			_AddLine(startPos, endPos, textWidth)
		End If	
	End Method
	
	Method _GetMinOffset:Int(startPos:Int, endPos:Int)
		Local offset:Int = startPos - endPos
		
		While (_font._FlxGetTextWidth(Self, 0, offset) > _width)
			offset -= 1			
			If (offset = 0) Return offset		
		Wend

		Return offset		
	End Method
	
	Method _AddLine:FlxTextInternalLine(startPos:Int, endPos:Int, width:Int)
		Local line:FlxTextInternalLine
		
		Print value[startPos..endPos]
	
		If (countLines = lines.Length()) Then
			lines = lines.Resize(countLines * 2 + 10)
			line = New FlxTextInternalLine(startPos, endPos, width)
			lines[countLines] = line
		Else
			line = lines[countLines]
			If (line = Null) Then
				line = New FlxTextInternalLine(startPos, endPos, width)
				lines[countLines] = line
			Else
				line.Reset(startPos, endPos, width)
			End If
		End If
		
		countLines += 1
		Return line
	End Method

End Class

Class FlxTextInternalLine

	Field x:Float
	
	Field y:Float
	
	Field startPos:Int
	
	Field endPos:Int
	
	Field width:Int
	
	Method New(startPos:Int, endPos:Int, width:Int)
		Reset(startPos, endPos, width)
	End Method
	
	Method Reset:Void(startPos:Int, endPos:Int, width:Int)
		Self.startPos = startPos
		Self.endPos = endPos
	End Method

End Class

Private
#If FLX_TEXT_DRIVER = "angelfont"
	Class FlxFontLoader Extends FlxResourceLoader<AngelFont>
		
		Field fontFamily:String = FlxText.SYSTEM_FONT
		Field fontSize:Int
		
		Method Load:AngelFont(name:String)
			Local font:AngelFont = New AngelFont()
			font.LoadFontXml(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize))
		End Method
	
	End Class
	
	Class FlxFontsManager Extends FlxResourcesManager<AngelFont>
	End Class
	
	Class AngelFont
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
		
		Method LoadFontXml:Void(url:String)
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
			
			Local nodes := config.FindNodesByPath("font/chars/char")
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
			
			If pageCount = 0
				image[0] = LoadImage(url+".png")
				If image[0] = Null image[0] = LoadImage(url+"_0.png")
			Else
				For Local page:= 0 To pageCount
					If image.Length < page+1 image = image.Resize(page+1)
					image[page] = LoadImage(url+"_"+page+".png")
				End
			End
		End
		
		Method GetTextWidth:Int(txt:FlxTextInternalObject, startPos:Int = 0, endPos:Int = -1)
			Local prevChar:Int = 0
			Local width:Int = 0
			
			If (endPos < 0) endPos = txt.value.Length()
			
			For Local i:= startPos Until endPos
				Local asc:Int = txt.value[i]
				Local ac:Char = chars[asc]
				Local thisChar:Int = asc
				If ac  <> Null
					If useKerning
						Local firstKp:= kernPairs.Get(prevChar)
						If firstKp <> Null
							Local secondKp:= firstKp.Get(thisChar)
							If secondKp <> Null
								xOffset += secondKp.amount
							End							
						Endif
					Endif
					width += ac.xAdvance
					prevChar = thisChar
				Endif
			Next
			
			Return width
		End Method
		
		Method GetTextHeight:Int(txt:FlxTextInternalObject, startPos:Int = 0, endPos:Int = -1)
			Local h:Int = 0
			
			If (endPos < 0) endPos = txt.value.Length()
			
			For Local i:= startPos Until endPos
				Local asc:Int = txt.value[i]
				Local ac:Char = chars[asc]
				If ac.height+ac.yOffset > h h = ac.height+ac.yOffset
			Next
			Return h
		End
		
		Method DrawText:Void(txt:FlxTextInternalObject, x:Int, y:Int)
			Local prevChar:Int = 0
			xOffset = 0
			yOffset = 0
			height = 0
			
			For Local line:Int = 0 Until txt.countLines
				height = 0
				
				For Local i:= txt.lines[line].startPos Until txt.lines[line].endPos
					Local asc:Int = txt.value[i]
					Local ac:Char = chars[asc]
					Local thisChar:Int = asc
					If ac  <> Null
						If useKerning
							firstKp = kernPairs.Get(prevChar)
							If firstKp <> Null
								secondKp = firstKp.Get(thisChar)
								If secondKp <> Null
									xOffset += secondKp.amount
								End
							Endif
						Endif
						ac.Draw(image[ac.page], x + xOffset, y + yOffset)
						xOffset += ac.xAdvance
						If (height < ac.yOffset + ac.height) height = ac.yOffset + ac.height
						prevChar = thisChar
					Endif
				Next
			
				yOffset += height
			Next
		End Method
	
	End Class
#End