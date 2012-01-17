Strict

Import flxextern
Import flxpoint
Import flxrect
Import flxbasic
Import flxobject
Import flxg

Import system.flxcolor

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
	
	Field _alpha:Float
		
	Field _scaleX:Float
	
	Field _scaleY:Float
	
	Field _angle:Float
	
	Field _clipped:Bool
	
	Field _bgColor:FlxColor	
	
	Field _fxFlashColor:Int
	
	Field _fxFlashDuration:Float
	
	Field _fxFlashComplete:FlxFunction
	
	Field _fxFlashAlpha:Float
	
	Field _fxFadeColor:Int
	
	Field _fxFadeDuration:Float
	
	Field _fxFadeComplete:FlxFunction
	
	Field _fxFadeAlpha:Float
	
	Field _fxShakeIntensity:Float
	
	Field _fxShakeDuration:Float
	
	Field _fxShakeComplete:FlxFunction
	
	Field _fxShakeOffset:FlxPoint
	
	Field _fxShakeDirection:Int
	
	Field _fill:FlxColor

Public
	Method New(x:Int, y:Int, width:Int, height:Int, zoom:Float = 0)
		Zoom = zoom 'must be first for init
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
		_alpha = 1	
		
		_fxFlashColor = 0
		_fxFlashDuration = 0
		_fxFlashComplete = null
		_fxFlashAlpha = 0
		
		_fxFadeColor = 0
		_fxFadeDuration = 0
		_fxFadeComplete = Null
		_fxFadeAlpha = 0
		
		_fxShakeIntensity = 0
		_fxShakeDuration = 0
		_fxShakeComplete = Null
		_fxShakeOffset = New FlxPoint()
		_fxShakeDirection = 0
		
		_fill = New FlxColor(0)			
	End Method
	
	Method Destroy:Void()
		target = Null
		scroll = Null
		deadzone = Null
		bounds = Null
		_color = Null
		_bgColor = Null				
		_fxFlashComplete = Null
		_fxFadeComplete = Null
		_fxShakeComplete = Null
		_fxShakeOffset = Null
		_fill = Null
	End Method
	
	Method Lock:Void()
		If (_clipped) Then
			SetScissor(_realX + _fxShakeOffset.x * FlxG._deviceScaleFactorX, _realY + _fxShakeOffset.y * FlxG._deviceScaleFactorY, _realWidth, _realHeight)			
		End If
				
		PushMatrix()
				
		Translate(_x + _fxShakeOffset.x, _y + _fxShakeOffset.y)		
		Scale(_scaleX, _scaleY)		
		
		If (_clipped Or _bgColor.argb <> FlxG._bgColor.argb) 
			SetColor(_bgColor.r, _bgColor.g, _bgColor.b)
			DrawRect(0, 0, _width, _height)
			FlxG._lastDrawingColor = _bgColor.argb
		End If	
	End Method
	
	Method Unlock:Void()		
		If (_fill.argb <> 0) Then
			If (_fill.argb <> FlxG._lastDrawingColor) Then				
				SetColor(_fill.r, _fill.g, _fill.b)
				FlxG._lastDrawingColor = _fill.argb				
			End if
			
			If (FlxG._lastDrawingAlpha <> _fill.a) Then
				SetAlpha(_fill.a)
				FlxG._lastDrawingAlpha = _fill.a			
			End If
			
			DrawRect(0, 0, _width, _height)			
		End If
		
		PopMatrix()
		_fill.SetARGB(0)
	End Method
	
	Method Update:Void()
		If (target <> Null) Then
			If (deadzone = Null) Then
				FocusOn(target.GetMidpoint(_point))		
			Else
				Local edge:Float
				Local targetX:Float
				Local targetY:Float
				
				If (target.x > 0) Then
					targetX = target.x + 0.0000001	
				Else
					targetX = target.x - 0.0000001
				End If
				
				If (target.y > 0) Then
					targetY = target.y + 0.0000001	
				Else
					targetY = target.y - 0.0000001
				End If
				
				edge = targetX - deadzone.x
				If (scroll.x > edge) scroll.x = edge
				edge = targetX + target.width - deadzone.x - deadzone.width
				If (scroll.x < edge) scroll.x = edge
				
				edge  = targetY - deadzone.y
				If (scroll.y > edge) scroll.y = edge				
				edge = targetY + target.height - deadzone.y - deadzone.height
				If (scroll.y < edge) scroll.y = edge
			End If
		End If
		
		If (bounds <> Null) Then
			If (scroll.x < bounds.Left) scroll.x = bounds.Left
			If (scroll.x > bounds.Right - _width) scroll.x = bounds.Right - _width
			If (scroll.y < bounds.Top) scroll.y = bounds.Top
			If (scroll.y > bounds.Bottom - _height) scroll.y = bounds.Bottom - _height
		End If
		
		If (_fxFlashAlpha > 0) Then			
			_fxFlashAlpha -= FlxG.elapsed / _fxFlashDuration
			
			If (_fxFlashAlpha <= 0 And _fxFlashComplete <> Null) Then
				_fxFlashComplete.Invoke()
			End If
		End If
		
		If (_fxFadeAlpha > 0 And _fxFadeAlpha < 1) Then
			_fxFadeAlpha += FlxG.elapsed / _fxFadeDuration
						
			If (_fxFadeAlpha >= 1) Then
				_fxFadeAlpha = 1				
				If (_fxFadeComplete <> Null) _fxFadeComplete.Invoke()				
			End If
		End If
		
		If (_fxShakeDuration > 0) Then
			_fxShakeDuration -= FlxG.elapsed
			If (_fxShakeDuration <= 0) Then
				_fxShakeOffset.Make()
								
				If (_fxShakeComplete <> Null) _fxShakeComplete.Invoke()
			Else
				If (_fxShakeDirection = SHAKE_BOTH_AXES Or _fxShakeDirection = SHAKE_HORIZONTAL_ONLY) Then
					_fxShakeOffset.x = (FlxG.Random() * _fxShakeIntensity * _width * 2 - _fxShakeIntensity * _width) * _zoom		
				End If
				
				If (_fxShakeDirection = SHAKE_BOTH_AXES Or _fxShakeDirection = SHAKE_VERTICAL_ONLY) Then
					_fxShakeOffset.y = (FlxG.Random() * _fxShakeIntensity * _height * 2 - _fxShakeIntensity * _height) * _zoom
				End If
			End If
		End If
	End Method
	
	Method Follow:Void(target:FlxObject, style:Int = STYLE_LOCKON)
		Self.target = target
		Local helper:Float
		
		Select (style)
			Case STYLE_PLATFORMER
				Local w:Float = _width / 8
				Local h:Float = _height / 3
				deadzone = New FlxRect((_width - w) / 2, (_height - h) / 2 - h * .25, w, h)
			
			Case STYLE_TOPDOWN
				helper = Max(_width, _height) / 4
				deadzone = New FlxRect((_width - helper) / 2, (_height - helper) / 2, helper, helper)
				
			Case STYLE_TOPDOWN_TIGHT
				helper = Max(_width, _height) / 8
				deadzone = New FlxRect((_width - helper) / 2, (_height - helper) / 2, helper, helper)
				
			Case STYLE_LOCKON
				deadzone = Null
				
			Default
				deadzone = Null	
		End Select
	End Method
	
	Method FocusOn:Void(point:FlxPoint)
		If (point.x > 0) Then
			point.x += 0.0000001	
		Else
			point.x -= 0.0000001	 
		End If
		
		If (point.y > 0) Then
			point.y += 0.0000001	
		Else
			point.y -= 0.0000001	 
		End If
		
		scroll.Make(point.x - _width * .5, point.y - _height * .5)		
	End Method
	
	Method SetBounds:Void(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, updateWorld:Bool = False)
		If (bounds = Null) bounds = New FlxRect()		
		bounds.Make(x, y, width, height)
		If (updateWorld) FlxG.worldBounds.CopyFrom(bounds)
		Update()
	End Method	
	
	Method Flash:Void(color:Int = FlxG.WHITE, duration:Float = 1, onComplete:FlxFunction = Null, force:Bool = False)	
		If (Not force And _fxFlashAlpha > 0) Return
		
		_fxFlashColor = color		
		If (duration <= 0) duration = _MIN_FLOAT_VALUE
		_fxFlashDuration = duration
		_fxFlashComplete = onComplete
		_fxFlashAlpha = 1				
	End Method
	
	Method Fade:Void(color:Int = FlxG.BLACK, duration:Float = 1, onComplete:FlxFunction = Null, force:Bool = False)
		If (Not force And _fxFadeAlpha > 0)	Return
		
		_fxFadeColor = color
		If (duration <= 0) duration = _MIN_FLOAT_VALUE
		_fxFadeDuration = duration
		_fxFadeComplete = onComplete
		_fxFadeAlpha = _MIN_FLOAT_VALUE
	End Method
	
	Method Shake:Void(intensity:Float = 0.05, duration:Float = 0.5, onComplete:FlxFunction = Null, force:Bool = True, direction:Int = SHAKE_BOTH_AXES)
		If (Not force And (_fxShakeOffset.x <> 0 Or _fxShakeOffset.y <> 0)) Return
		
		_fxShakeIntensity = intensity
		_fxShakeDuration = duration
		_fxShakeComplete = onComplete
		_fxShakeDirection = direction
		_fxShakeOffset.Make()
	End Method
	
	Method StopFX:Void()
		_fxFlashAlpha = 0
		_fxFadeAlpha = 0		
		_fxShakeDuration = 0
		_fxShakeOffset.x = 0
		_fxShakeOffset.y = 0
	End Method
	
	Method CopyFrom:FlxCamera(camera:FlxCamera)
		If (camera.bounds = Null) Then
			bounds = camera.bounds
		Else
			If (bounds = Null) bounds = New FlxRect()
			bounds.CopyFrom(camera.bounds)
		End If
		
		target = camera.target
		If (target <> Null) Then
			If (camera.deadzone = Null) Then
				deadzone = Null
			Else
				If (deadzone = Null) deadzone = New FlxRect()
				deadzone.CopyFrom(camera.deadzone)
			End If
		End If
		
		Return Self
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
		_realWidth = Min(Float(FlxG.deviceWidth), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
		
		If (_realWidth <> FlxG.deviceWidth) Then
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
		_realHeight = Min(Float(FlxG.deviceHeight), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
		
		If (_realHeight <> FlxG.deviceHeight) Then
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
	
	Method Alpha:Float() Property
		Return _alpha
	End Method
	
	Method Alpha:Void(alpha:Float) Property
		_alpha = alpha	
	End Method
	
	Method Angle:Float() Property
		Return _angle
	End Method
	
	Method Angle:Void(angle:Float) Property
		_angle = angle	
	End Method
	
	Method Color:Int() Property
		Return _color.argb
	End Method
	
	Method Color:Void(color:Int) Property
		_color.SetRGB(color)
	End Method
	
	Method BgColor:Int() Property
		Return _bgColor.argb
	End Method
	
	Method BgColor:Void(color:Int) Property
		_bgColor.SetARGB(color)
	End Method
	
	Method GetScale:FlxPoint()
		Return _point.Make(_scaleX, _scaleY)	
	End Method
	
	Method SetScale:Void(x:Float, y:Float)
		_scaleX = x
		_scaleY = y
		_realWidth = Min(Float(FlxG.deviceWidth), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
		_realHeight = Min(Float(FlxG.deviceHeight), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
	End Method
	
	Method Fill:Void(color:Int, blendAlpha:Bool = True)	
		If (blendAlpha) Then
			_fill.SetARGB(color)
		Else			
			_fill.SetRGB(color)	
		End If
	End Method
	
	Method DrawFX:Void()	
		If (_fxFlashAlpha > 0) Then
			Local alphaComponent:Float
			
			alphaComponent = _fxFlashColor Shr 24
			If (alphaComponent <= 0) alphaComponent = $FF 
			Fill(((alphaComponent * _fxFlashAlpha) Shl 24) + (_fxFlashColor & $00FFFFFF))
		End If
		
		If (_fxFadeAlpha > 0) Then
			Local alphaComponent:Float
			
			alphaComponent = _fxFadeColor Shr 24
			If (alphaComponent <= 0) alphaComponent = $FF 
			Fill(((alphaComponent * _fxFadeAlpha) Shl 24) + (_fxFadeColor & $00FFFFFF))	
		End If
	End Method
	
	Method ToString:String()
		Return "FlxCamera"	
	End Method
	
	Method _GetColorObject:FlxColor()
		Return Self._color
	End Method

End Class
