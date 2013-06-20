Strict

Import motion
Import flixel.flxpoint
Import flixel.flxg
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class QuadPath Extends Motion
	
Private
	Global _Point:FlxPoint = New FlxPoint()
	
	Global _Point2:FlxPoint = New FlxPoint()

	Field _distance:Float

	Field _points:Stack<FlxPoint>
	
	Field _curve:Stack<FlxPoint>
	
	Field _curveD:Stack<Float>
	
	Field _curveT:Stack<Float>
	
	Field _updateCurve:Bool
	
	Field _speed:Float
	
	Field _index:Int
	
	Field _a:FlxPoint
	
	Field _b:FlxPoint
	
	Field _c:FlxPoint
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, complete, type, Null)
		_points = New Stack<FlxPoint>()
		_curve = New Stack<FlxPoint>()
		_curveD = New Stack<Float>()
		_curveT = New Stack<Float>()
		
		_distance = 0; _speed = 0; _index = 0
		_updateCurve = True
		_curveT.Push(0);
	End Method
	
	Method Destroy:Void()
		_points = Null
		_curve = Null
		_curveD = Null
		_curveT = Null
		_a = Null
		_b = Null
		_c = Null
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
		_updateCurve = true
		
		If (_points.Length() = 0) _curve.Push(New FlxPoint(x, y))
		_points.Push(New FlxPoint(x, y))
	End Method
	
	Method GetPoint:FlxPoint(index:Int = 0)
		If (_points.Length() = 0) Then
			#If FLX_DEBUG_ENABLED = "1"
				FlxG.Log("No points have been added to the path yet")
			#End
			
			Return Null
		End If
		
		Return _points.Get(index Mod _points.Length())
	End Method
	
	Method Start:Void()
		If ( Not _backward) Then
			_index = 0
		Else
			_index = _curve.Length() -1
		End If
		Super.Start()
	End Method
	
	Method Update:Void()
		Super.Update()
		
		If ( Not _backward) Then
			If (_index < _curve.Length() -1) Then
				While (_t > _curveT.Get(_index + 1))
					_index += 1
					If (_index = _curve.Length() -1) Then
						_index -= 1
						Exit
					End If
				Wend
			End If
			
			Local td:Float = _curveT.Get(_index)
			Local tt:Float = _curveT.Get(_index + 1) - td
			
			td = (_t - td) / tt
			
			_a = _curve.Get(_index)
			_b = _points.Get(_index + 1)
			_c = _curve.Get(_index + 1)
			
			x = _a.x * (1 - td) * (1 - td) + _b.x * 2 * (1 - td) * td + _c.x * td * td
			y = _a.y * (1 - td) * (1 - td) + _b.y * 2 * (1 - td) * td + _c.y * td * td
		Else
			If (_index > 0) Then
				While (_t < _curveT.Get(_index - 1))
					_index -= 1
					If (_index = 0) Then
						_index += 1
						Exit
					End If
				Wend
			End If
			
			Local td:Float = _curveT.Get(_index)
			Local tt:Float = _curveT.Get(_index - 1) - td
			
			td = (_t - td) / tt
			
			_a = _curve.Get(_index)
			_b = _points.Get(_index)
			_c = _curve.Get(_index - 1)
			
			x = _a.x * (1 - td) * (1 - td) + _b.x * 2 * (1 - td) * td + _c.x * td * td
			y = _a.y * (1 - td) * (1 - td) + _b.y * 2 * (1 - td) * td + _c.y * td * td
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
		If (_points.Length() < 3) Then
			#If FLX_DEBUG_ENABLED = "1"
				FlxG.Log("WARNING: A QuadPath must have at least 3 points to operate")
			#End
			
			Return
		End If
		
		If ( Not _updateCurve) Return
		
		Local p:FlxPoint, c:FlxPoint
		Local l:FlxPoint = _points.Get(1)
		
		Local i:Int = 2
		Local len:Int = _points.Length()
		
		While (i < len)
			p = _points.Get(i)
			
			If (_curve.Length() > i - 1) Then
				c = _curve.Get(i - 1)
			Else
				_curve.Push(New FlxPoint())
				c = _curve.Top()
			End If
			
			If (i < _points.Length() -1) Then
				c.x = l.x + (p.x - l.x) / 2
				c.y = l.y + (p.y - l.y) / 2
			Else
				c.x = p.x
				c.y = p.y
			End If
			
			l = p
			i += 1
		Wend
		
		i = 0
		len = _curve.Length() -1
		_distance = 0
		
		While (i < len)
			_curveD.Push(_CurveLength(_curve.Get(i), _points.Get(i + 1), _curve.Get(i + 1)))
			_distance += _curveD.Top()
			i += 1
		Wend
		
		i = 1
		Local d:Float = 0
				
		While (i < len)
			d += _curveD.Get(i)
			_curveT.Push(d / _distance)
			i += 1
		Wend
		
		_curveT.Push(1)
	End Method
	
	Method _CurveLength:Float(start:FlxPoint, control:FlxPoint, finish:FlxPoint)
		Local a:FlxPoint = _Point, b:FlxPoint = _Point2
		
		a.x = start.x - 2 * control.x + finish.x
		a.y = start.y - 2 * control.y + finish.y
		b.x = 2 * control.x - 2 * start.x
		b.y = 2 * control.y - 2 * start.y

		Local A:Float = 4 * (a.x * a.x + a.y * a.y),
			B:Float = 4 * (a.x * b.x + a.y * b.y),
			C:Float = b.x * b.x + b.y * b.y,
			ABC:Float = 2 * Sqrt(A + B + C),
			A2:Float = Sqrt(A),
			A32:Float = 2 * A * A2,
			C2:Float = 2 * Sqrt(C),
			BA:Float = B / A2
				
		Return(A32 * ABC + A2 * B * (ABC - C2) + (4 * C * A - B * B) * Log( (2 * A2 + BA + ABC) / (BA + C2))) / (4 * A32)
	End Method

End Class