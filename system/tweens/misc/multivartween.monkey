Strict

Import reflection
Import flixel.flxbasic
Import flixel.flxg
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class MultiVarTween Extends FlxTween
	
Private
	Field _vars:Stack<FieldInfo>
	
	Field _start:Stack<Float>
	
	Field _range:Stack<Float>
	
	Field _object:Object
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, complete)
	
		_vars = New Stack<FieldInfo>
		_start = New Stack<Float>
		_range = New Stack<Float>
	End Method
	
	Method Destroy:Void()
		_object = Null
		Super.Destroy()
	End Method
	
	Method Tween:Void(object:Object, properties:StringMap<Float>, duration:Float, ease:FlxEaseFunction = Null)
		_object = object
		
		_vars.Clear()
		_start.Clear()
		_range.Clear()
		
		Local classInfo:ClassInfo
		
		If (FlxBasic(object) <> Null) Then
			classInfo = FlxBasic(object).GetClassInfo()
			
			If (FlxObject(object) <> Null) Then
				FlxObject(object).immovable = True
			End If
		Else
			classInfo = GetClass(object)
		End If
		
		_target = duration
		_ease = ease
		
		Local f:FieldInfo
		For Local prop:String = EachIn properties.Keys()
			f = classInfo.GetField(prop, True)
			If (f <> Null) Then
				If (f.Type.ExtendsClass(FloatClass()) Or f.Type.ExtendsClass(IntClass())) Then
					Local value:Float = UnboxFloat(f.GetValue(object))
				
					_vars.Push(f)
					_start.Push(value)
					_range.Push(properties.Get(f.Name) - value)
				Else
					FlxG.Log("WARNING: The property ~q" + prop + "~q is not numeric")
				End If
			Else
				FlxG.Log("WARNING: The ~q" + classInfo.Name + "~q does not have the property ~q" + prop + "~q, or it is not accessible")
			End If
		Next
		
		Start()
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