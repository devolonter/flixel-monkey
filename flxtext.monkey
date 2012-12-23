Strict

Import reflection

Import flxextern
Import flxsprite
Import flxcamera
Import flxtext.driver
Import flxtext.driver.native
Import flxg
Import system.flxcolor
Import system.flxassetsmanager

Class FlxText Extends FlxSprite

	Global ClassObject:Object
	
	Const ALIGN_LEFT:Float = 0
	Const ALIGN_RIGHT:Float = 1
	Const ALIGN_CENTER:Float = .5
	
	Const DRIVER_NATIVE:Int = 0
	Const DRIVER_FONTMACHINE:Int = 1	
	'ANGELFONT must be last
	Const DRIVER_ANGELFONT:Int = 2
	
	Const SYSTEM_FONT:String = "system"
	
Private
	Global _DefaultDriver:ClassInfo
	Field _driver:FlxTextDriver
	Field _shadow:FlxColor

Public
	Method New(x:Float, y:Float, width:Int = 0, text:String = "", driver:ClassInfo = Null)
		Super.New(x, y)
		
		Pixels = Null
		
		_shadow = New FlxColor(0)		
		
		If (driver = Null) Then
			If (_DefaultDriver = Null) _DefaultDriver = ClassInfo(FlxTextNativeDriver.ClassObject)
		
			driver = _DefaultDriver
		End If
		
		_driver = FlxTextDriver(driver.NewInstance())
		
		Self.width = width
		frameWidth = Self.width
		moves = False
		
		_driver.Width = width
		SetFormat(SYSTEM_FONT)
		Text = text		
	End Method
	
	Method Destroy:Void()
		_driver.Destroy()
		_driver = Null
		_shadow = Null
	
		Super.Destroy()
	End Method
	
	Method SetFormat:FlxText(font:String = "", size:Int = 0, color:Int = FlxG.WHITE, alignment:Float = ALIGN_LEFT, shadowColor:Int = 0)
		_driver.SetFormat(font, FlxAssetsManager.GetFont(font, _driver.ID).GetValidSize(size), alignment)
		Self.Color = color
		Shadow = shadowColor		
		
		Self.height = _driver.GetTextHeight()
		frameHeight = Self.height
		_ResetHelpers()
		
		Return Self
	End Method
	
	Method SetWidth:Void(width:Float)
		Self.width = width
		frameWidth = Self.width
		
		_driver.Width = width
		_ResetHelpers()
	End Method
	
	Method Text:String() Property
		Return _driver.Text
	End Method
	
	Method Text:Void(text:String) Property
		_driver.Text = text
		
		Self.height = _driver.GetTextHeight()
		frameHeight = Self.height
		_ResetHelpers()
	End Method
	
	Method Size:Void(size:Int) Property
		_driver.Size = FlxAssetsManager.GetFont(_driver.Font, _driver.ID).GetValidSize(size)
		
		Self.height = _driver.GetTextHeight()
		frameHeight = Self.height
		_ResetHelpers()
	End Method
	
	Method Size:Int() Property
		Return _driver.Size
	End Method
	
	Method Font:String() Property
		Return _driver.Font
	End Method
	
	Method Font:Void(font:String) Property
		_driver.Font = font
	End Method
	
	Method Alignment:Float() Property
		Return _driver.Alignment
	End Method
	
	Method Alignment:Void(alignment:Float) Property
		_driver.Alignment = alignment
		
		Self.height = _driver.GetTextHeight()
		frameHeight = Self.height
		_ResetHelpers()
	End Method
	
	Method Shadow:Int() Property
		Return _shadow.argb
	End Method
	
	Method Shadow:Void(color:Int) Property
		_shadow.SetARGB(color)
	End Method
	
	Method GetFontObject:Object()
		Return _driver.GetFontObject()
	End Method
	
	Method _DrawSurface:Void(x:Float, y:Float)	
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
			_driver.Draw(x+1, y+1)
			
			_mixedColor.SetRGB(oldColor)
			SetColor(_mixedColor.r, _mixedColor.g, _mixedColor.b)
			SetAlpha(oldAlpha)
		End If		
		
		_driver.Draw(x, y)
	End Method
	
	Function SetDefaultDriver:Void(driver:ClassInfo)
		_DefaultDriver = driver
	End Function
	
End Class