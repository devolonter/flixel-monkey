Strict

Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class ColorTween Extends FlxTween
	
	Field color:Int
	
	Field alpha:Float
	
	Field red:Int

	Field green:Int

	Field blue:Int
	
Private
	Field _startA:Float
	
	Field _startR:Float
	
	Field _startG:Float
	
	Field _startB:Float
	
	Field _rangeA:Float
	
	Field _rangeR:Float
	
	Field _rangeG:Float
	
	Field _rangeB:Float
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, complete)
		alpha = 1
	End Method
	
	Method Tween:Void(duration:Float, fromColor:Int, toColor:Int, fromAlpha:Float = 1, toAlpha:Float = 1, ease:FlxEaseFunction = Null)
		fromColor &= $FFFFFF
		toColor &= $FFFFFF
		color = fromColor
		
		red = (fromColor Shr 16) & $FF
		green = (fromColor Shr 8) & $FF
		blue = fromColor & $FF

		_startR = red / 255.0
		_startG = green / 255.0
		_startB = blue / 255.0
		
		_rangeR = ( ( (toColor Shr 16) & $FF) / 255) - _startR
		_rangeG = ( ( (toColor Shr 8) & $FF) / 255) - _startG
		_rangeB = ( (toColor & $FF) / 255) - _startB
		
		_startA = fromAlpha
		alpha = fromAlpha
		
		_rangeA = toAlpha - alpha
		
		_target = duration
		_ease = ease
		
		Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		alpha = _startA + _rangeA * _t
		
		red = (_startR + _rangeR * _t) * 255
		green = (_startG + _rangeG * _t) * 255
		blue = (_startB + _rangeB * _t) * 255
		
		color = red Shl 16 | green Shl 8 | blue
	End Method

End Class