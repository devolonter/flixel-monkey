Strict

Import mojo
Import reflection

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxfont
Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

Import "../../data/system_angel_font_8_flx.png"
Import "../../data/system_angel_font_8_flx.txt"
Import "../../data/system_angel_font_9_flx.png"
Import "../../data/system_angel_font_9_flx.txt"
Import "../../data/system_angel_font_10_flx.png"
Import "../../data/system_angel_font_10_flx.txt"
Import "../../data/system_angel_font_11_flx.png"
Import "../../data/system_angel_font_11_flx.txt"
Import "../../data/system_angel_font_12_flx.png"
Import "../../data/system_angel_font_12_flx.txt"
Import "../../data/system_angel_font_13_flx.png"
Import "../../data/system_angel_font_13_flx.txt"
Import "../../data/system_angel_font_14_flx.png"
Import "../../data/system_angel_font_14_flx.txt"
Import "../../data/system_angel_font_15_flx.png"
Import "../../data/system_angel_font_15_flx.txt"
Import "../../data/system_angel_font_16_flx.png"
Import "../../data/system_angel_font_16_flx.txt"
Import "../../data/system_angel_font_17_flx.png"
Import "../../data/system_angel_font_17_flx.txt"
Import "../../data/system_angel_font_18_flx.png"
Import "../../data/system_angel_font_18_flx.txt"
Import "../../data/system_angel_font_19_flx.png"
Import "../../data/system_angel_font_19_flx.txt"
Import "../../data/system_angel_font_20_flx.png"
Import "../../data/system_angel_font_20_flx.txt"
Import "../../data/system_angel_font_21_flx.png"
Import "../../data/system_angel_font_21_flx.txt"
Import "../../data/system_angel_font_22_flx.png"
Import "../../data/system_angel_font_22_flx.txt"
Import "../../data/system_angel_font_23_flx.png"
Import "../../data/system_angel_font_23_flx.txt"
Import "../../data/system_angel_font_24_flx.png"
Import "../../data/system_angel_font_24_flx.txt"

Class FlxTextAngelFontDriver Extends FlxTextDriver

	Global ClassObject:ClassInfo

Private
	Global _FontLoader:FlxAFDriverLoader = New FlxAFDriverLoader()
	Global _FontsManager:FlxResourcesManager<AngelFont> = New FlxResourcesManager<AngelFont>()
	
	Field _font:AngelFont
	Field _fontHeight:Int	
	
Public
	Function Init:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		Local fontPathPrefix:String = FlxText.SYSTEM_FONT + "_angel_font_"
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont(FlxText.SYSTEM_FONT, FlxText.DRIVER_ANGELFONT)
		
		For Local size:Int = minSize To maxSize
			angelSystemFont.SetPath(size, fontPathPrefix +  size + FlxG.DATA_SUFFIX + ".txt")
		Next
	End Function
	
	Method GetTextWidth:Int(text:String)
		Return _font.TextWidth(text)
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
		
		If (_text.Length() > 0) Then
			_fontHeight = _font.TextHeight(_text) * 1.5
		Else
			_fontHeight = _font.TextHeight(" ") * 1.5
		End If
	End Method
	
	Method ID:Int() Property
		Return FlxText.DRIVER_ANGELFONT		 	
	End Method
	
	Method GetFontObject:Object()
		Return _font
	End Method		

End Class

Private
Class FlxAFDriverLoader Extends FlxResourceLoader<AngelFont>
	
	Field fontFamily:String = FlxText.SYSTEM_FONT
	Field fontSize:Int
	
	Method Load:T(name:String)
		Return New AngelFont(FlxAssetsManager.GetFont(fontFamily, FlxText.DRIVER_ANGELFONT).GetPath(fontSize))			
	End Method

End Class

#Rem
	AngelFont ported source	

	PC: http://www.angelcode.com/products/bmfont/
	Mac/PC: http://slick.cokeandcode.com/demos/hiero.jnlp
#End

Class AngelFont

Private	
	Field image:Image	
	Field chars:Char[256]
	Field kernPairs:StringMap<KernPair> = New StringMap<KernPair>
	Field iniText:String

	Field xOffset:Int
	Field yOffset:Int
	
	Field prevMouseDown:Bool = False

Public
	Field useKerning:Bool = True

	Field lineGap:Int = 5
	Field height:Int = 0
	Field heightOffset:Int = 9999
	Field scrollY:Int = 0
	
	Field italicSkew:Float = 0.25
	
	Method New(url:String="")
		If url <> ""
			Self.LoadFont(url)
		Endif
	End Method
	
	Method GetChars:Char[]()
		Return chars
	End

	Method LoadFont:Void(url:String)
		
		iniText = LoadString(url)
		Local lines:= iniText.Split(String.FromChar(10))
		For Local line:= Eachin lines
		
			line=line.Trim()
			
			If line.StartsWith("id,") Or line = "" Continue
			If line.StartsWith("first,")
				Continue
			Endif
			Local data$[] = line.Split(",")
			
			For Local i:=0 Until data.Length
				data[i]=data[i].Trim()
			Next
			
			If data.Length > 0
				If data.Length = 3
					kernPairs.Insert(String.FromChar(Int(data[0]))+"_"+String.FromChar(Int(data[1])), New KernPair(Int(data[0]), Int(data[1]), Int(data[2])))
				Else
					If data.Length >= 8
						chars[Int(data[0])] = New Char(Int(data[1]), Int(data[2]), Int(data[3]), Int(data[4]),  Int(data[5]),  Int(data[6]),  Int(data[7]))
						Local ch := chars[Int(data[0])]
						If ch.height > Self.height Self.height = ch.height
						If ch.yOffset < Self.heightOffset Self.heightOffset = ch.yOffset
					Endif
				Endif
			Endif
		Next		

		image = LoadImage(url.Replace(".txt", ".png"))
	End Method
	
	Method DrawText:Void(txt:String, x:Int, y:Int)
		Local prevChar:String = ""
		xOffset = 0
		
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			Local thisChar:String = String.FromChar(asc)
			If ac  <> Null
				If useKerning
					Local key:String = prevChar+"_"+thisChar
					If kernPairs.Contains(key)
						xOffset += kernPairs.Get(key).amount
					Endif
				Endif
				ac.Draw(image, x+xOffset,y)
				xOffset += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
	End Method

	Method TextWidth:Int(txt:String)
		Local prevChar:String = ""
		Local width:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			Local thisChar:String = String.FromChar(asc)
			If ac  <> Null
				If useKerning
					Local key:String = prevChar+"_"+thisChar
					If kernPairs.Contains(key)
						width += kernPairs.Get(key).amount
					Endif
				Endif
				width += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
		Return width
	End Method
	
	Method TextHeight:Int(txt:String)
		Local h:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			If (ac <> Null And ac.height > h) h = ac.height
		Next
		Return h
	End

End Class

Class Char
	Field asc:Int
	Field x:Int
	Field y:Int
	
	Field width:Int
	Field height:Int = 0
	
	Field xOffset:Int = 0
	Field yOffset:Int = 0
	Field xAdvance:Int = 0
	
	
	Method New(x:Int,y:Int, w:Int, h:Int, xoff:Int=0, yoff:Int=0, xadv:Int=0)
		Self.x = x
		Self.y = y
		Self.width = w
		Self.height = h
		
		Self.xOffset = xoff
		Self.yOffset = yoff
		Self.xAdvance = xadv
	End
	
	Method Draw:Void(fontImage:Image, linex:Int, liney:Int)
		DrawImageRect(fontImage, linex+xOffset,liney+yOffset, x,y, width,height)
	End Method

	Method toString:String()
		Return String.FromChar(asc)+"="+asc
	End Method
End Class

Class KernPair
	Field first:Int
	Field second:Int
	Field amount:Int
	
	
	Method New(first:Int, second:Int, amount:Int)
		Self.first = first
		Self.second = second
		Self.amount = amount
	End
	
	Method toString:String()
		Return "first="+String.FromChar(first)+" second="+String.FromChar(second)+" amount="+amount
	End Method
End Class