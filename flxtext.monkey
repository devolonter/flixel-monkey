Strict

Import flxsprite
Import flxtext.driver
Import flxtext.driver.fontmachine

Class FlxText Extends FlxSprite

	Global CREATOR:FlxClassCreator = new FlxTextCreator()
	
	Const MIN_SIZE:Int = 8
	Const MAX_SIZE:Int = 16
	
	Const ALIGN_LEFT:Int = 0
	Const ALIGN_RIGHT:Int = 1
	Const ALIGN_CENTER:Int = 2
	
	Const DRIVER_NATIVE:Int = 0
	Const DRIVER_FONTMACHINE:Int = 1
	Const DRIVER_ANGELFONT:Int = 2
	
Private
	Field _driverType:Int	
	Field _driver:TextDriver	

Public
	Method New(x:Float, y:Float, text:String = Null)
		Super.New(x, y)		
	End Method
	
	Method SetDriver:Void(driver:Int)
		If (_driverType = driver) Return
		
		Select (driver)				
			Case DRIVER_FONTMACHINE				
				If (_fontMachineDriver = Null) _fontMachineDriver = New FontMachineDriver()
				_driver = _fontMachineDriver
				_driverType = driver
		End Select
	End Method
	
	Method GetDriver:Int()
		Return _driverType
	End Method
	
	Method SetFromat:Void(font:String = Null, size:Int = 8, color:Color = FlxG.WHITE, alignment:Int = ALIGN_LEFT, shadowColor:Color = Null)
		_driver.SetFormat(font, size, color, alignment, shadowColor)
	End Method
	
	Method Text:String() Property
		Return _driver.GetText()
	End Method
	
	Method Text:Void(text:String) Property
		_driver.SetText(text)
	End Method
	
	Method Size:Int() Property
		Return _driver.GetSize()
	End Method
	
	Method Size:Void(size:String) Property
		_driver.SetSize(size)
	End Method
	
	Method Size:Int() Property
		Return _driver.GetSize()
	End Method
	
	Method Size:Void(size:String) Property
		_driver.SetSize(size)
	End Method
	
	Method Color:Color() Property
		Return _driver.GetFontColor()
	End Method
	
	Method Color:Void(color:Color) Property
		_driver.SetFontColor(color)
	End Method
	
	Method Font:String() Property
		Return _driver.GetFontName()
	End Method
	
	Method Font:Void(font:String) Property
		_driver.SetFontName(font)
	End Method
	
	Method Alignment:Int() Property
		Return _driver.GetAligment()
	End Method
	
	Method Alignment:Void(alignment:Int) Property
		_driver.SetAlignment(font)
	End Method
	
	Method Shadow:Int() Property
		Return _driver.GetShadow()
	End Method
	
	Method Shadow:Void(shadow:Color) Property
		_driver.SetShadow(shadow)
	End Method
	
End Class

Private
Global _fontMachineDriver:FontMachineDriver
	
Class FlxTextCreator Implements FlxClassCreator

	Method CreateInstance:FlxBasic()
		Return New FlxText()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
		Return (FlxText(object) <> Null)
	End Method	
	
End Class