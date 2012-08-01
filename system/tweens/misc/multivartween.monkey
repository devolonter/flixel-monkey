Strict

Import reflection
Import flixel.flxbasic
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.flxease

Class MultiVarTween Extends FlxTween
	
Private
	Field _vars:Stack<FieldInfo>
	Field _start:Stack<Float>
	Field _range:Stack<Float>
	Field _object:Object
	
Public
	Method New(complete:FlxTweenListener, type:Int)
		Super.New(0, type, complete)
	
		_vars = New Stack<FieldInfo>
		_start = New Stack<Float>
		_range = New Stack<Float>
	End Method
	
	Method Tween:Void(object:Object, properties:StringMap<Float>, duration:Float, ease:FlxEaseFunction = Null)
		_object = object
		
		_vars.Clear()
		_start.Clear()
		_range.Clear()
		
		Local classInfo:ClassInfo
		
		If (FlxBasic(object) <> Null) Then
			classInfo = FlxBasic(object).GetClass()
		Else
			classInfo = GetClass(object)
		End If
		
		_target = duration
		_ease = ease
		
		For Local f:FieldInfo = EachIn classInfo.GetFields(True)
			If (properties.Contains(f.Name)) Then
				Local value:Float = UnboxFloat(f.GetValue(object))
			
				_vars.Push(f)
				_start.Push(value)
				_range.Push(properties.Get(f.Name) - value)
			End If
		Next
	End Method
	
	Method Update:Void()
		Super.Update()
		
		Local i:Int = _vars.Length()
		While (i > 0)
			i -= 1
			_vars.Get(i).SetValue(_object, BoxFloat(_start.Get(i) + _range.Get(i) * _t))
		Wend
	End Method

End Class