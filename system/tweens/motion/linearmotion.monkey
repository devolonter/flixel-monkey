Strict

Import motion
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class LinearMotion Extends Motion
	
Private
	Field _fromX:Float
	
	Field _fromY:Float
	
	Field _moveX:Float
	
	Field _moveY:Float
	
	Field _distance:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_fromX = 0
		_fromY = 0
		_moveX = 0
		_moveY = 0
		_distance = -1
	End Method
	
	Method SetMotion:Void(fromX:Float, fromY:Float, toX:Float, toY:Float, duration:Float, ease:FlxEaseFunction = Null)
		_distance = -1
		
		x = fromX
		y = fromY
		
		_fromX = fromX
		_fromY = fromY
		
		_moveX = toX - fromX
		_moveY = toY - fromY
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method SetMotionSpeed:Void(fromX:Float, fromY:Float, toX:Float, toY:Float, speed:Float, ease:FlxEaseFunction = Null)
		_distance = -1
		
		x = fromX
		y = fromY
		
		_fromX = fromX
		_fromY = fromY
		
		_moveX = toX - fromX
		_moveY = toY - fromY
		
		_target = Distance / speed
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		x = _fromX + _moveX * _t
		y = _fromY + _moveY * _t
		
		PostUpdate()
		
		If (active And x = _fromX + _moveX And y = _fromY + _moveY) Then
			Finish()
		End If		
	End Method
	
	Method Distance:Float() Property
		If (_distance >= 0) return _distance
		
		_distance = Sqrt(_moveX * _moveX + _moveY * _moveY)
		
		Return _distance
	End Method

End Class