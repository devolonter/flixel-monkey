Strict

Import ext.color

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
	
	Field x:Float
	
	Field y:Float	
	
	Field target:FlxObject
	
	Field deadzone:FlxRect
	
	Field bounds:FlxRect
	
	Field scroll:FlxPoint
	
	Field point:FlxPoint
	
	Field bgColor:Color
	
Private
	Field _width:Float
	
	Field _height:Float

	Field _zoom:Float
	
	Field _point:FlxPoint
	
	Field _color:Color
		
	Field _scaleX:Float
	
	Field _scaleY:Float
	
	Field _realWidth:Float
	
	Field _realHeight:Float

Public
	Method New(x:Int, y:Int, width:Int, height:Int, zoom:Float = 0)
		Self.x = x
		Self.y = y
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
		SetScissor(x, y, _realWidth, _realHeight)
				
		PushMatrix()
				
		Translate(x, y)		
		Scale(_scaleX, _scaleY)
		
		SetAlpha(_color.a)
		SetColor(bgColor.r, bgColor.g, bgColor.b)
		DrawRect(0, 0, _width, _height)
					
		SetColor(_color.r, _color.g, _color.b)			
	End Method
	
	Method Unlock:Void()
		PopMatrix()
	End Method
	
	Method Width:Float() Property
		Return _width	
	End Method
	
	Method Width:Void(width:Float) Property
		_width = width
		_realWidth = _width*_scaleX
	End Method
	
	Method Height:Float() Property
		Return _height	
	End Method
	
	Method Height:Void(height:Float) Property
		_height = height
		_realHeight = _height*_scaleY
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
		_realWidth = _width*_scaleX
		_realHeight = _height*_scaleY
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
