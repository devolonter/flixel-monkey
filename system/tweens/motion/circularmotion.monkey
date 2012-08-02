Strict

Import motion
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class CircularMotion Extends Motion

	Field angle:Float
	
Private
	Field _centerX:Float
	
	Field _centerY:Float
	
	Field _radius:Float
	
	Field _angleStart:Float
	
	Field _angleFinish:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_centerX = 0
		_centerY = 0
		_radius = 0
		angle = 0
		_angleStart = 0
		_angleFinish = 0
	End Method
	
	Method SetMotion:Void(centerX:Float, centerY:Float, radius:Float, angle:Float, clockwise:Bool, duration:Float, ease:FlxEaseFunction = Null)
		_centerX = centerX
		_centerY = centerY
		
		_radius = radius
		
		Self.angle = angle * PI / (-180)
		
		_angleStart = Self.angle
		
		If (clockwise) Then
			_angleFinish = TWOPI
		Else
			_angleFinish = -TWOPI
		End If
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method SetMotionSpeed:Void(centerX:Float, centerY:Float, radius:Float, angle:Float, clockwise:Bool, speed:Float, ease:FlxEaseFunction = Null)
		_centerX = centerX
		_centerY = centerY
		
		_radius = radius
		
		Self.angle = angle * PI / (-180)
		
		_angleStart = Self.angle
		
		If (clockwise) Then
			_angleFinish = TWOPI
		Else
			_angleFinish = -TWOPI
		End If
		
		_target = (_radius * TWOPI) / speed
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		angle = _angleStart + _angleFinish * _t
		x = _centerX + Cosr(angle) * _radius
		y = _centerY + Sinr(angle) * _radius
		
		PostUpdate()
	End Method
	
	Method Circumference:Float() Property
		Return _radius * TWOPI
	End Method

End Class