Strict

Import flxsprite
Import flxtext.driver
Import flxtext.driver.fontmachine

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

Public
	Method New(x:Float, y:Float, text:String = "", driver:Int = DRIVER_FONTMACHINE)
		Super.New(x, y)
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
	
	Method SetFromat:Void(font:String = "", size:Int = 8, color:Color = FlxG.WHITE, alignment:Int = ALIGN_LEFT, shadowColor:Color = Null)
		_driver.SetFormat(font, size, color, alignment, shadowColor)
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
	
	Method Alignment:Float() Property
		Return _driver.GetAligment()
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		_driver.SetAlignment(alignment)
	End Method
	
	Method Shadow:Int() Property
		Return _driver.GetShadow()
	End Method
	
	Method Shadow:Void(shadow:Color) Property
		_driver.SetShadow(shadow)
	End Method
	
	Method Draw:Void()
		_driver.Draw(x, y)
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