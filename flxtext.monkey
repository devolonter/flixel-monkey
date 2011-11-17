Strict

Import flxsprite
Import flxtext.driver
Import flxtext.driver.fontmachine
Import flxg

Import plugin.monkey.flxcolor
Import plugin.monkey.flxassetsmanager

Class FlxText Extends FlxSprite

	Global CREATOR:FlxClassCreator = new FlxTextCreator()
	
	Const ALIGN_LEFT:Float = 0
	Const ALIGN_RIGHT:Float = 1
	Const ALIGN_CENTER:Float = .5
	
	Const DRIVER_NATIVE:Int = 0
	Const DRIVER_FONTMACHINE:Int = 1	
	'ANGELFONT must be last
	Const DRIVER_ANGELFONT:Int = 2
	
	Const SYSTEM_FONT:String = "system"
	
Private
	Field _driver:FlxTextDriver
	
	Field _color:FlxColor
	Field _shadow:FlxColor	

Public
	Method New(x:Float, y:Float, width:Int = 0, text:String = "", driver:Int = DRIVER_FONTMACHINE)
		Super.New(x, y)
		
		_color = New FlxColor()
		_shadow = New FlxColor(0)	
			
		_SetDriver(driver)
		
		_driver.Width = width
		SetFromat(SYSTEM_FONT)
		Text = text		
	End Method	
	
	Method SetFromat:Void(font:String = "", size:Int = 0, color:Int = FlxG.WHITE, alignment:Int = ALIGN_LEFT, shadowColor:Int = 0)
		_driver.SetFormat(font, FlxAssetsManager.GetValidFontSize(font, size), alignment)
		Self.Color = color
		Shadow = shadowColor
	End Method
	
	Method Text:String() Property
		Return _driver.Text
	End Method
	
	Method Text:Void(text:String) Property
		_driver.Text = text
	End Method
	
	Method Size:Void(size:Int) Property
		_driver.SetFontSize(FlxAssetsManager.GetValidFontSize(_driver.GetFontFamily(), size))
	End Method
	
	Method Size:Int() Property
		Return _driver.GetFontSize()
	End Method
	
	Method Color:Int() Property
		Return _color.argb
	End Method
	
	Method Color:Void(color:Int) Property
		_color.SetARGB(color)
	End Method
	
	Method Font:String() Property
		Return _driver.GetFontFamily()
	End Method
	
	Method Font:Void(font:String) Property
		_driver.SetFontFamily(font)
	End Method
	
	Method Alignment:Float() Property
		Return _driver.GetTextAligment()
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		_driver.SetTextAlignment(alignment)
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
	
Private
	Method _SetDriver:Void(driver:Int)
		Select (driver)
			Case DRIVER_FONTMACHINE
				_driver = New FlxTextFontMachineDriver()	
		End Select
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