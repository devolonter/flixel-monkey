Strict

Import motion
Import flixel.flxpoint
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class QuadMotion Extends Motion
	
Private
	Global Point:FlxPoint = New FlxPoint()
	
	Global Point2:FlxPoint = New FlxPoint()

	Field _fromX:Float
	
	Field _fromY:Float
	
	Field _toX:Float
	
	Field _toY:Float
	
	Field _controlX:Float
	
	Field _controlY:Float
	
	Field _distance:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_distance = -1
		_fromX = 0; _fromY = 0; _toX = 0; _toY = 0
		_controlX = 0; _controlY = 0
	End Method
	
	Method SetMotion:Void(fromX:Float, fromY:Float, controlX:Float, controlY:Float, toX:Float, toY:Float, duration:Float, ease:FlxEaseFunction = Null)
		_distance = -1
		
		x = fromX; y = fromY
		_fromX = fromX; _fromY = fromY
		
		_controlX = controlX
		 _controlY = controlY
				
		_toX = toX
		_toY = toY
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method SetMotionSpeed:Void(fromX:Float, fromY:Float, controlX:Float, controlY:Float, toX:Float, toY:Float, speed:Float, ease:FlxEaseFunction = Null)
		_distance = -1
		
		x = fromX; y = fromY
		_fromX = fromX; _fromY = fromY
		
		_controlX = controlX
		 _controlY = controlY
				
		_toX = toX
		_toY = toY
		
		_target = Distance / speed
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		x = _fromX * (1 - _t) * (1 - _t) + _controlX * 2 * (1 - _t) * _t + _toX * _t * _t
		y = _fromY * (1 - _t) * (1 - _t) + _controlY * 2 * (1 - _t) * _t + _toY * _t * _t
		
		PostUpdate()		
	End Method
	
	Method Distance:Float() Property
		If (_distance >= 0) return _distance
		
		Local a:FlxPoint = QuadMotion.Point
		Local b:FlxPoint = QuadMotion.Point2
		
		a.x = x - 2 * _controlX + _toX
		a.y = y - 2 * _controlY + _toY
		
		b.x = 2 * _controlX - 2 * x
		b.y = 2 * _controlY - 2 * y
		
		Local A:Float = 4 * (a.x * a.x + a.y * a.y),
			B:Float = 4 * (a.x * b.x + a.y * b.y),
			C:Float = b.x * b.x + b.y * b.y,
			ABC:Float = 2 * Sqrt(A + B + C),
			A2:Float = Sqrt(A),
			A32:Float = 2 * A * A2,
			C2:Float = 2 * Sqrt(C),
			BA:Float = B / A2
			
		return(A32 * ABC + A2 * B * (ABC - C2) + (4 * C * A - B * B) * Log( (2 * A2 + BA + ABC) / (BA + C2))) / (4 * A32)
	End Method

End Class