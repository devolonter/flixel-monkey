Strict

Import mojo

Import flixel.flxextern
Import flixel.flxtext
Import flixel.flxtext.driver

Import flixel.system.flxfont
Import flixel.system.flxassetsmanager
Import flixel.system.flxresourcesmanager

Import "../../data/flx_system_angel_font_8.png"
Import "../../data/flx_system_angel_font_8.txt"
Import "../../data/flx_system_angel_font_9.png"
Import "../../data/flx_system_angel_font_9.txt"
Import "../../data/flx_system_angel_font_10.png"
Import "../../data/flx_system_angel_font_10.txt"
Import "../../data/flx_system_angel_font_11.png"
Import "../../data/flx_system_angel_font_11.txt"
Import "../../data/flx_system_angel_font_12.png"
Import "../../data/flx_system_angel_font_12.txt"
Import "../../data/flx_system_angel_font_13.png"
Import "../../data/flx_system_angel_font_13.txt"
Import "../../data/flx_system_angel_font_14.png"
Import "../../data/flx_system_angel_font_14.txt"
Import "../../data/flx_system_angel_font_15.png"
Import "../../data/flx_system_angel_font_15.txt"
Import "../../data/flx_system_angel_font_16.png"
Import "../../data/flx_system_angel_font_16.txt"
Import "../../data/flx_system_angel_font_17.png"
Import "../../data/flx_system_angel_font_17.txt"
Import "../../data/flx_system_angel_font_18.png"
Import "../../data/flx_system_angel_font_18.txt"
Import "../../data/flx_system_angel_font_19.png"
Import "../../data/flx_system_angel_font_19.txt"
Import "../../data/flx_system_angel_font_20.png"
Import "../../data/flx_system_angel_font_20.txt"
Import "../../data/flx_system_angel_font_21.png"
Import "../../data/flx_system_angel_font_21.txt"
Import "../../data/flx_system_angel_font_22.png"
Import "../../data/flx_system_angel_font_22.txt"
Import "../../data/flx_system_angel_font_23.png"
Import "../../data/flx_system_angel_font_23.txt"
Import "../../data/flx_system_angel_font_24.png"
Import "../../data/flx_system_angel_font_24.txt"

Global ANGELFONT_TEXT_DRIVER:FlxTextDriverClass = New FlxAFDriverClass()

Class FlxTextAngelFontDriver Extends FlxTextDriver	

Private
	Global _fontLoader:FlxAFDriverLoader = New FlxAFDriverLoader()
	Global _fontsManager:FlxResourcesManager<AngelFont> = New FlxResourcesManager<AngelFont>()
	
	Field _font:AngelFont
	Field _fontHeight:Int	
	
Public
	Function Init:Void()
		Local minSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MinSize
		Local maxSize:Int = FlxAssetsManager.GetFont(FlxText.SYSTEM_FONT).MaxSize
		Local fontPathPrefix:String = FlxG.DATA_PREFIX + FlxText.SYSTEM_FONT + "_angel_font_"
		
		Local angelSystemFont:FlxFont = FlxAssetsManager.AddFont("system", FlxText.DRIVER_ANGELFONT)
		
		For Local size:Int = minSize To maxSize
			angelSystemFont.SetPath(size, fontPathPrefix +  size + ".txt")
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
		_fontLoader.fontFamily = _fontFamily
		_fontLoader.fontSize = _size
		
		_font = _fontsManager.GetResource(_fontFamily + _size, _fontLoader)	
		_fontHeight = _font.TextHeight(_text)*1.5
	End Method
	
	Method ID:Int() Property
		Return FlxText.DRIVER_ANGELFONT		 	
	End Method		

End Class

Private
Class FlxAFDriverClass Implements FlxTextDriverClass
	
	Method CreateInstance:FlxTextDriver()
		Return New FlxTextAngelFontDriver()
	End Method
	
	Method InstanceOf:Bool(object:FlxTextDriver)
		Return FlxTextAngelFontDriver(object) <> Null
	End Method

End Class

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
	Field first:String
	Field second:String
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