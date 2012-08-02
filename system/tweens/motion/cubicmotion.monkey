Strict

Import motion
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class CubicMotion Extends Motion
	
Private
	Field _fromX:Float
	
	Field _fromY:Float
	
	Field _toX:Float
	
	Field _toY:Float
	
	Field _aX:Float
	
	Field _aY:Float
	
	Field _bX:Float
	
	Field _bY:Float
	
	Field _ttt:Float
	
	Field _tt:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_fromX = 0; _fromY = 0; _toX = 0; _toY = 0
		_aX = 0; _aY = 0; _bX = 0; _bY = 0
		_ttt = 0; _tt = 0
	End Method
	
	Method SetMotion:Void(fromX:Float, fromY:Float, aX:Float, aY:Float, bX:Float, bY:Float, toX:Float, toY:Float, duration:Float, ease:FlxEaseFunction = Null)
		x = fromX; y = fromY
		_fromX = fromX; _fromY = fromY
		
		_aX = aX; _aY = aY
		_bX = bX; _bY = bY
		
		_toX = toX; _toY = toY
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		x = _t * _t * _t * (_toX + 3 * (_aX - _bX) - _fromX) + 3 * _t * _t * (_fromX - 2 * _aX + _bX) + 3 * _t * (_aX - _fromX) + _fromX
		y = _t * _t * _t * (_toY + 3 * (_aY - _bY) - _fromY) + 3 * _t * _t * (_fromY - 2 * _aY + _bY) + 3 * _t * (_aY - _fromY) + _fromY
		
		PostUpdate()	
	End Method

End Class