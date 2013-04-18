Strict

Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_8_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_9_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_10_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_11_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_12_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_13_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_14_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_15_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_16_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_17_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_18_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_19_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_20_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_21_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_22_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_23_flx.fnt"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx_0.png"
Import "data/fonts/${FLX_TEXT_DRIVER}/system_font_24_flx.fnt"

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
	Global _FontLoader:FlxFontLoader = New FlxFontLoader()
	
	Global _FontsManager:FlxFontsManager = New FlxFontsManager()

	Field _shadow:FlxColor
	
	Field _value:String
	
	Field _lines:FlxTextLine[]
	
	Field _countLines:Int

	Field _alignment:Float
	
	Field _fontFamily:String
	
	Field _fontSize:Int
	
	Field _fontHeight:Int

#If FLX_TEXT_DRIVER = "angelfont"	
	Field _fontObject:AngelFont
#End

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
		_fontHeight = _fontObject.GetTextHeight(Self)
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
			Return _fontHeight + _fontObject.lineGap * (_countLines - 1)
		End If
	End Method

	Method _ParseText:Void()
		_countLines = 0
	
		Local prevOffset:Int = 0
		Local offsetN:Int = _value.Find("~n", 0)
		Local offsetR:Int = _value.Find("~r", 0)
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
				
				offsetN = _value.Find("~n", prevOffset)
				offsetR = _value.Find("~r", prevOffset)
								
				If (offsetN >= 0 And offsetR >= 0) Then
					offset = Min(offsetN, offsetR)
				Else
					offset = Max(offsetN, offsetR)
				End if
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
				textWidth = _fontObject.GetTextWidth(Self, 0, range)
			Until (textWidth >= width)

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
						If (_value[i] = KEY_SPACE) tmpOffset = i
					Next
					
					If (tmpOffset < 0) Then
						tmpOffset = _GetMinOffset(minOffset, offset)
					Else
						If (offset - minOffset > 1 And _value[offset] = KEY_SPACE) Then
							minOffset += 1
							offset +=  Min(offset + 2, maxOffset)
							Continue	
						EndIf		
					End If
					
					offset = tmpOffset + minOffset
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
					maxOffset = minOffset + range
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
					
					If (offset - l = 0) Continue
					
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
		Local offset:Int = startPos - endPos
		
		While (_fontObject.GetTextWidth(Self, 0, offset) > width)
			offset -= 1			
			If (offset = 0) Return offset		
		Wend

		Return offset		
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

#If FLX_TEXT_DRIVER = "angelfont"
	Class FlxFontLoader Extends FlxResourceLoader<AngelFont>
		
		Field fontFamily:String = FlxText.SYSTEM_FONT
		Field fontSize:Int
		
		Method Load:AngelFont(name:String)
			Local font:AngelFont = New AngelFont()
			font.LoadFontXml(FlxAssetsManager.GetFont(fontFamily).GetPath(fontSize))
			
			Return font
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
		
		Field lineGap:Int = 5
		
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
				If image[0] = Null image[0] = LoadImage(url+"_0.png")
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
						Endif
					EndIf
					
					width += ac.xAdvance
					prevChar = asc
				EndIf
			Next
			
			Return width
		End Method
		
		Method GetTextHeight:Int(txt:FlxText, startPos:Int = 0, endPos:Int = -1)
			Local h:Int = 0
			
			If (endPos < 0) endPos = txt._value.Length()
			
			For Local i:= startPos Until endPos
				Local asc:Int = txt._value[i]
				Local ac:Char = chars[asc]
				If ac.height+ac.yOffset > h h = ac.height+ac.yOffset
			Next
			Return h
		End
		
		Method DrawText:Void(txt:FlxText, x:Int, y:Int)
			Local lineIndex:Int = 0, countLines:Int = txt._countLines, line:FlxTextLine
				
			Local prevChar:Int = 0, xOffset:Int = 0, yOffset:Int = 0
			Local i:Int = 0, l:Int
			Local asc:Int, ac:Char
			Local lineHeight:Int = txt._fontHeight + lineGap
			
			While (lineIndex < countLines)
				line = txt._lines[lineIndex]
				i = line.startPos
				l = line.endPos
			
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
							Endif
						Endif
												
						ac.Draw(image[ac.page], x + xOffset + line.xOffset, y + yOffset)
						xOffset += ac.xAdvance
						prevChar = asc
					Endif
					
					i += 1
				Wend

				lineIndex += 1
				yOffset += lineHeight
			Wend
		End Method
	
	End Class
#End