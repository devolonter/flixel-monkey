Strict

Class FlxResourceLoader<T>
	
	Method Load:T(name:String) Abstract
	
End Class

Class FlxResourcesManager<T>

Private
	Field _resources:StringMap<T>
	
	Method New()
		_resources = New StringMap<T>()
	End Method

Public
	Method GetResource:T(name:String, loader:FlxResourceLoader<T>)
		Local resource:T = _resources.Get(name)
			
		If (resource <> Null) Then
			Return resource
		End If
		
		resource = loader.Load(name)
		If (resource = Null) Error ("Resource " + name +  " can't be loaded")
		
		_resources.Set(name, resource)	
		Return resource
	End Method
	
	Method CheckResource:Bool(name:String)
		Return (_resources.Get(name) <> Null)
	End Method
	
	Method Clear:Void()
		_resources.Clear()
	End Method

End Class