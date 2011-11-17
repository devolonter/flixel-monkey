Strict

Class FlxResourceLoader<T>
	
	Method Load:T(name:String) Abstract
	
End Class

Class FlxResourcesManager<T>

Private
	Field _resources:StringMap<FlxResource<T>>
	
	Method New()
		_resources = New StringMap<FlxResource<T>>()
	End Method

Public
	Method GetResource:T(name:String, loader:FlxResourceLoader<T>)
		Local resource:FlxResource<T> = _resources.Get(name)		
		If (resource <> Null) Then
			resource.count+=1
			Return resource.object
		End If
		
		Local object:T = loader.Load(name)		
		If (object = Null) Error ("Resource " + name +  " can't be loaded")
		
		resource = New FlxResource<T>(object)
		_resources.Set(name, resource)
		
		Return resource.object
	End Method

End Class

Private
Class FlxResource<T>	
	
	Field object:T
	Field count:Int
	
	Method New(object:T)		
		Self.object = object
		If (object <> Null) count+=1
	End Method

End Class