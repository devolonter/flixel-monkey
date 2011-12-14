Strict

Import flxg
Import flxpoint
Import flxrect
Import flxbasic
Import flxobject

Import plugin.monkey.flxcolor

Class FlxCamera Extends FlxBasic

	Const STYLE_LOCKON:Int = 0
	
	Const STYLE_PLATFORMER:Int = 1
	
	Const STYLE_TOPDOWN:Int = 2
	
	Const STYLE_TOPDOWN_TIGHT:Int = 3
	
	Const SHAKE_BOTH_AXES:Int = 0
	
	Const SHAKE_HORIZONTAL_ONLY:Int = 1
	
	Const SHAKE_VERTICAL_ONLY:Int  = 2
	
	Global defaultZoom:Float		
	
	Field target:FlxObject
	
	Field deadzone:FlxRect
	
	Field bounds:FlxRect
	
	Field scroll:FlxPoint
	
	Field point:FlxPoint	
	
Private
	Const _MIN_FLOAT_VALUE:Float = .0000001

	Field _x:Float
	
	Field _y:Float
	
	Field _realX:Float
	
	Field _realY:Float

	Field _width:Float
	
	Field _height:Float
	
	Field _realWidth:Float
	
	Field _realHeight:Float

	Field _zoom:Float
	
	Field _point:FlxPoint
	
	Field _color:FlxColor
		
	Field _scaleX:Float
	
	Field _scaleY:Float
	
	Field _clipped:Bool
	
	Field _bgColor:FlxColor
	
	Field _fillColor:FlxColor
	
	Field _fxFlashColor:Int
	
	Field _fxFlashDuration:Float
	
	Field _fxFlashComplete:FlxFunction
	
	Field _fxFlashAlpha:Float	

Public
	Method New(x:Int, y:Int, width:Int, height:Int, zoom:Float = 0)
		Zoom = zoom
		X = x
		Y = y
		Width = width
		Height = height
		target = Null
		deadzone = Null
		scroll = New FlxPoint()
		_point = New FlxPoint()
		bounds = Null
		_bgColor = New FlxColor(FlxG.BgColor())
		_color = New FlxColor()
		_fillColor = New FlxColor(0)
		
		_fxFlashColor = 0
		_fxFlashDuration = 0
		_fxFlashComplete = null
		_fxFlashAlpha = 0			
	End Method
	
	Method Destroy:Void()
		target = Null
		scroll = Null
		deadzone = Null
		bounds = Null
		_color = Null
		_bgColor = Null
		_fillColor = Null		
		_fxFlashComplete = Null
	End Method
	
	Method Update:Void()	
		If (_fxFlashAlpha > 0) Then			
			_fxFlashAlpha-= FlxG.elapsed / _fxFlashDuration
			If (_fxFlashAlpha <= 0 And _fxFlashComplete <> Null) Then
				_fxFlashComplete.Call()
			End If
		End If
	End Method
	
	Method Lock:Void()
		If (_clipped) Then
			SetScissor(_realX, _realY, _realWidth, _realHeight)			
		End If
				
		PushMatrix()
				
		Translate(_x, _y)		
		Scale(_scaleX, _scaleY)		
		
		SetAlpha(_color.a)
		
		If (_clipped Or _bgColor.argb <> FlxG._bgColor.argb) 
			SetColor(_bgColor.r, _bgColor.g, _bgColor.b)
			DrawRect(0, 0, _width, _height)
			FlxG._lastDrawingColor = _bgColor.argb
		End If
		
		If (_color.argb <> FlxG._lastDrawingColor) Then
			SetColor(_color.r, _color.g, _color.b)
			FlxG._lastDrawingColor = _color.argb
		End if		
	End Method
	
	Method Unlock:Void()
		If (_fillColor.argb <> 0) Then
			If (_fillColor.argb <> FlxG._lastDrawingColor) Then
				SetAlpha(_fillColor.a)
				SetColor(_fillColor.r, _fillColor.g, _fillColor.b)
			End if
			
			DrawRect(0, 0, _width, _height)		
		End If
		
		PopMatrix()
		_fillColor.SetARGB(0)
	End Method
	
	Method Flash:Void(color:Int = FlxG.WHITE, duration:Float = 1, onComplete:FlxFunction = Null, force:Bool = False)	
		If (Not force And _fxFlashAlpha > 0) Return
		
		_fxFlashColor = color		
		If (duration <= 0) duration = _MIN_FLOAT_VALUE
		_fxFlashDuration = duration
		_fxFlashComplete = onComplete
		_fxFlashAlpha = 1				
	End Method
	
	Method StopFX:Void()
		_fxFlashAlpha = 0
	End Method
	
	Method X:Float() Property
		Return _x	
	End Method
	
	Method X:Void(x:Float) Property
		_x = x
		_realX = _x * FlxG._deviceScaleFactorX
		
		If (x <> 0) Then
			_clipped = True			
		Else
			_clipped = False	
		End If
	End Method
	
	Method Y:Float() Property
		Return _y	
	End Method
	
	Method Y:Void(y:Float) Property
		_y = y
		_realY = _y * FlxG._deviceScaleFactorY
		
		If (y <> 0) Then
			_clipped = True
		Else
			_clipped = False	
		End If
	End Method
	
	Method Width:Float() Property
		Return _width	
	End Method
	
	Method Width:Void(width:Float) Property
		_width = width
		_realWidth = Min(Float(FlxG.DEVICE_WIDTH), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
		
		If (_realWidth <> FlxG.DEVICE_WIDTH) Then
			_clipped = True
		Else
			_clipped = False
		End If
	End Method
	
	Method Height:Float() Property
		Return _height	
	End Method
	
	Method Height:Void(height:Float) Property
		_height = height
		_realHeight = Min(Float(FlxG.DEVICE_HEIGHT), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
		
		If (_realHeight <> FlxG.DEVICE_HEIGHT) Then
			_clipped = True
		Else
			_clipped = False
		End If
	End Method
	
	Method Zoom:Float() Property
		Return _zoom
	End Method
	
	Method Zoom:Void(zoom:Float) Property
		If (zoom = 0) Then
			_zoom = FlxCamera.defaultZoom
		Else
			_zoom = zoom
		End If
						
		SetScale(_zoom, _zoom)	
	End Method
	
	Method GetScale:FlxPoint()
		Return FlxPoint.Make(_scaleX, _scaleY)	
	End Method
	
	Method SetScale:Void(x:Float, y:Float)
		_scaleX = x
		_scaleY = y
		_realWidth = Min(Float(FlxG.DEVICE_WIDTH), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
		_realHeight = Min(Float(FlxG.DEVICE_HEIGHT), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
	End Method
	
	Method Fill:Void(color:Int, blendAlpha:Bool = True)
		Local alphaComponent:Float
	
		If (blendAlpha) Then
			alphaComponent = _fxFlashColor Shr 24
			If (alphaComponent <= 0) alphaComponent = $FF 
			_fillColor.SetARGB(((alphaComponent * _fxFlashAlpha) Shl 24) + (_fxFlashColor & $00ffffff))
		Else
			_fillColor.SetARGB(color)	
		End If
	End Method
	
	Method Color:Int() Property
		Return _color.argb
	End Method
	
	Method Color:Void(color:Int) Property
		_color.SetARGB(color)
	End Method
	
	Method BgColor:Int() Property
		Return _bgColor.argb
	End Method
	
	Method BgColor:Void(color:Int) Property
		_bgColor.SetARGB(color)
	End Method
	
	Method DrawFX:Void()
		If (_fxFlashAlpha > 0) Fill(_fxFlashColor)
	End Method

	Method ToString:String()
		Return "FlxCamera"	
	End Method	

End Class
