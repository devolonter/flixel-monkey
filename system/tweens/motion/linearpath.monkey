Strict

Import motion
Import flixel.flxpoint
Import flixel.flxg
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class LinearPath Extends Motion
	
Private
	Field _distance:Float

	Field _points:Stack<FlxPoint>
	
	Field _pointD:Stack<Float>
	
	Field _pointT:Stack<Float>
	
	Field _speed:Float
	
	Field _index:Int

	Field _last:FlxPoint
	
	Field _prevPoint:FlxPoint
	
	Field _nextPoint:FlxPoint
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_points = New Stack<FlxPoint>()
		_pointD = New Stack<Float>()
		_pointT = New Stack<Float>()
		
		_distance = 0; _speed = 0; _index = 0
		_pointD.Push(0); _pointT.Push(0)
	End Method
	
	Method Destroy:Void()
		_points = Null
		_pointD = Null
		_pointT = Null
		_last = Null
		_prevPoint = Null
		_nextPoint = Null
		Super.Destroy()
	End Method
	
	Method SetMotion:Void(duration:Float, ease:FlxEaseFunction = Null)
		_UpdatePath()
		_target = duration
		_speed = _distance / duration
		_ease = ease
		Start()
	End Method
	
	Method SetMotionSpeed:Void(speed:Float, ease:FlxEaseFunction = Null)
		_UpdatePath()
		_target = _distance / speed
		_speed = speed
		_ease = ease
		Start()
	End Method
	
	Method AddPoint:Void(x:Float = 0, y:Float = 0)
		If (_last <> Null) Then
			_distance += Sqrt( (x - _last.x) * (x - _last.x) + (y - _last.y) * (y - _last.y))
			_pointD.Push(_distance)
		End If
		
		_last = New FlxPoint(x, y)
		_points.Push(_last)
	End Method
	
	Method GetPoint:FlxPoint(index:Int = 0)
		If (_points.Length() = 0) Then
			FlxG.Log("No points have been added to the path yet")
			Return Null
		End If
		
		Return _points.Get(index Mod _points.Length())
	End Method
	
	Method Start:Void()
		If ( Not _backward) Then
			_index = 0
		Else
			_index = _points.Length() -1
		End If
		Super.Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		If ( Not _backward) Then
			If (_index < _points.Length() -1) Then
				While (_t > _pointT.Get(_index + 1))
					_index += 1
					If (_index = _points.Length() -1) Then
						_index -= 1
						Exit
					End If
				Wend
			End If
			
			Local td:Float = _pointT.Get(_index)
			Local tt:Float = _pointT.Get(_index + 1) - td
			
			td = (_t - td) / tt
			
			_prevPoint = _points.Get(_index)
			_nextPoint = _points.Get(_index + 1)
			
			x = _prevPoint.x + (_nextPoint.x - _prevPoint.x) * td
			y = _prevPoint.y + (_nextPoint.y - _prevPoint.y) * td
		Else
			If (_index > 0) Then
				While (_t < _pointT.Get(_index - 1))
					_index -= 1
					If (_index = 0) Then
						_index += 1
						Exit
					End If
				Wend
			End If
			
			Local td:Float = _pointT.Get(_index)
			Local tt:Float = _pointT.Get(_index - 1) - td
			
			td = (_t - td) / tt
			
			_prevPoint = _points.Get(_index)
			_nextPoint = _points.Get(_index - 1)
			
			x = _prevPoint.x + (_nextPoint.x - _prevPoint.x) * td
			y = _prevPoint.y + (_nextPoint.y - _prevPoint.y) * td
		End If
		
		Super.PostUpdate()
	End Method
	
	Method PointCount:Int() Property
		Return _points.Length()
	End Method
	
	Method Distance:Float() Property
		Return _distance
	End Method
	
Private
	Method _UpdatePath:Void()
		If (_points.Length() < 2) Then
			FlxG.Log("WARNING: A LinearPath must have at least 2 points to operate")
			Return
		End If
		
		If (_pointD.Length() = _pointT.Length()) Return
		
		Local i:Int = 0
		Local l:Int = _points.Length()
		
		While (i < l)
			_pointT.Push(_pointD.Get(i + 1) / _distance)
			i += 1
		Wend
	End Method

End Class