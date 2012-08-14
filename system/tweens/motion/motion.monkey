Strict

Import flixel.flxobject
Import flixel.system.tweens.flxtween
Import flixel.system.tweens.util.ease

Class Motion Extends FlxTween
	
	Field x:Float
	
	Field y:Float
	
Private
	Field _object:FlxObject
	
Public
	Method New(duration:Float, complete:FlxTweenListener = Null, type:Int = -1, ease:FlxEaseFunction = Null)
		Super.New(duration, type, complete, ease)
	End Method
	
	Method Destroy:Void()
		_object = Null
		Super.Destroy()
	End Method
	
	Method SetObject:Void(object:FlxObject)
		_object = object
		_object.immovable = True
	End Method
	
	Method PostUpdate:Void()
		If (_object <> Null) Then
			_object.x = x
			_object.y = y
		End If
	End Method

End Class