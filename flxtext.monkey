Strict

Import ext.color

Import flxsprite
Import flxtext.driver
Import flxtext.driver.fontmachine
Import flxg

Class FlxText Extends FlxSprite

	Global CREATOR:FlxClassCreator = new FlxTextCreator()
	
	Const MIN_SIZE:Int = 8
	Const MAX_SIZE:Int = 16
	
	Const ALIGN_LEFT:Float = 0
	Const ALIGN_RIGHT:Float = 1
	Const ALIGN_CENTER:Float = .5
	
	Const DRIVER_NATIVE:Int = 0
	Const DRIVER_FONTMACHINE:Int = 1
	Const DRIVER_ANGELFONT:Int = 2
	
Private
	Field _driver:TextDriver
	
	Field _color:Color
	Field _shadow:Color	

Public
	Method New(x:Float, y:Float, text:String = "", driver:Int = DRIVER_FONTMACHINE)
		Super.New(x, y)
		
		_color = New Color()
		_shadow = New Color(0)	
		
		SetDriver(driver)
		SetFromat(FlxG.DATA_PREFIX + "system")
		Text = text			
	End Method
	
	Method SetDriver:Void(driver:Int)
		Select (driver)
			Case DRIVER_FONTMACHINE
				_driver = New FontMachineDriver()	
		End Select
	End Method
	
	Method GetDriver:TextDriver()
		Return _driver
	End Method
	
	Method SetFromat:Void(font:String = "", size:Int = 8, color:Int = FlxG.WHITE, alignment:Int = ALIGN_LEFT, shadowColor:Int = 0)
		_driver.SetFormat(font, size, alignment)
		Self.Color = color
		Shadow = shadowColor
	End Method
	
	Method Text:String() Property
		Return _driver.GetText()
	End Method
	
	Method Text:Void(text:String) Property
		_driver.SetText(text)
	End Method
	
	Method Size:Void(size:Int) Property
		_driver.SetSize(size)
	End Method
	
	Method Size:Int() Property
		Return _driver.GetSize()
	End Method
	
	Method Color:Int() Property
		Return _color.argb
	End Method
	
	Method Color:Void(color:Int) Property
		_color.SetARGB(color)
	End Method
	
	Method Font:String() Property
		Return _driver.GetFontName()
	End Method
	
	Method Font:Void(font:String) Property
		_driver.SetFontName(font)
	End Method
	
	Method Alignment:Float() Property
		Return _driver.GetAligment()
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		_driver.SetAlignment(alignment)
	End Method
	
	Method Shadow:Int() Property
		Return _shadow.argb
	End Method
	
	Method Shadow:Void(color:Int) Property
		_shadow.SetARGB(color)
	End Method
	
	Method Draw:Void()
		If (_shadow.argb <> 0) Then
			If (_shadow.argb <> FlxG._lastDrawingColor) Then
				SetColor(_shadow.r, _shadow.g, _shadow.b)
				SetAlpha(_shadow.a)
				FlxG._lastDrawingColor = _shadow.argb
			End if
			
			_driver.Draw(x+1, y+1)
		End If
	
		If (_color.argb <> FlxG._lastDrawingColor) Then
			SetColor(_color.r, _color.g, _color.b)
			SetAlpha(_color.a)
			FlxG._lastDrawingColor = _color.argb
		End If
		_driver.Draw(x, y)
	End Method
	
	Method ToString:String()
		Return "FlxText"	
	End Method
	
End Class

Private	
Class FlxTextCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New FlxText()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
		Return (FlxText(object) <> Null)
	End Method	
	
End Class