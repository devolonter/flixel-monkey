Strict

Import reflection
Import flixel.flxbasic
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class VarTween Extends FlxTween
	
Private
	Field _property:FieldInfo
	
	Field _start:Float
	
	Field _range:Float
	
	Field _object:Object
	
Public
	Method New(complete:FlxTweenListener = Null, type:Int = -1)
		Super.New(0, type, complete)
	End Method
	
	Method Destroy:Void()
		_object = Null
		Super.Destroy()
	End Method
	
	Method Tween:Void(object:Object, prop:String, toValue:Float, duration:Float, ease:FlxEaseFunction = Null)
		_object = object
		_target = duration
		_ease = ease
		
		Local classInfo:ClassInfo
		
		If (FlxBasic(object) <> Null) Then
			classInfo = FlxBasic(object).GetClassInfo()
			
			If (FlxObject(object) <> Null) Then
				FlxObject(object).immovable = True
			End If
		Else
			classInfo = GetClass(object)
		End If
		
		_property = classInfo.GetField(prop, True)
		
		If (_property <> Null) Then
			If (_property.Type.ExtendsClass(FloatClass()) Or _property.Type.ExtendsClass(IntClass())) Then
				_start = UnboxFloat(_property.GetValue(object))
				_range = toValue - _start
				Start()
			Else
				#If FLX_DEBUG_ENABLED = "1"
					FlxG.Log("WARNING: The property ~q" + prop + "~q is not numeric")
				#End
			End If
		Else
			#If FLX_DEBUG_ENABLED = "1"
				FlxG.Log("WARNING: The ~q" + classInfo.Name + "~q does not have the property ~q" + prop + "~q, or it is not accessible")
			#End
		End If
	End Method
	
	Method Update:Void()
		Super.Update()
		_property.SetValue(_object, BoxFloat(_start + _range * _t))
	End Method

End Class