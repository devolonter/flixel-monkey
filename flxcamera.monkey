Strict

Import ext.color

Import flxg
Import flxpoint
Import flxrect
Import flxbasic
Import flxobject

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
	
	Field bgColor:Color
	
Private
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
	
	Field _color:Color
		
	Field _scaleX:Float
	
	Field _scaleY:Float	

Public
	Method New(x:Int, y:Int, width:Int, height:Int, zoom:Float = 0)
		X = x
		Y = y
		Width = width
		Height = height
		target = Null
		deadzone = Null
		scroll = New FlxPoint()
		_point = New FlxPoint()
		bounds = Null
		bgColor = FlxG.BgColor()
		_color = FlxG.WHITE		
		Zoom = zoom				
	End Method
	
	Method Lock:Void()
		SetScissor(_realX, _realY, _realWidth, _realHeight)
				
		PushMatrix()
				
		Translate(_x, _y)		
		Scale(_scaleX, _scaleY)
		
		SetAlpha(_color.a)
		SetColor(bgColor.r, bgColor.g, bgColor.b)
		DrawRect(0, 0, _width, _height)
					
		SetColor(_color.r, _color.g, _color.b)			
	End Method
	
	Method Unlock:Void()
		PopMatrix()
	End Method
	
	Method X:Float() Property
		Return _x	
	End Method
	
	Method X:Void(x:Float) Property
		_x = x
		_realX = _x * FlxG._deviceScaleFactorX
	End Method
	
	Method Y:Float() Property
		Return _y	
	End Method
	
	Method Y:Void(y:Float) Property
		_y = y
		_realY = _y * FlxG._deviceScaleFactorY
	End Method
	
	Method Width:Float() Property
		Return _width	
	End Method
	
	Method Width:Void(width:Float) Property
		_width = width
		_realWidth = Min(Float(FlxG.deviceWidth), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
	End Method
	
	Method Height:Float() Property
		Return _height	
	End Method
	
	Method Height:Void(height:Float) Property
		_height = height
		_realHeight = Min(Float(FlxG.deviceHeight), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
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
		_realWidth = Min(Float(FlxG.deviceWidth), Floor(_width * _scaleX * FlxG._deviceScaleFactorX))
		_realHeight = Min(Float(FlxG.deviceHeight), Floor(_height * _scaleY * FlxG._deviceScaleFactorY))
	End Method
	
	Method Fill:Void(color:Color)
		SetColor(color.r, color.g, color.b)
		DrawRect(x, y, width, height)
		SetColor(255, 255, 255)
	End Method

	Method ToString:String()
		Return "FlxCamera"	
	End Method

End Class
