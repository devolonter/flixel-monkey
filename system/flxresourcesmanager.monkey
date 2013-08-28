Strict

Class FlxResource<T>

	Field name:String
	
	Method New(name:String)
		Self.name = name
	End Method
	
	Method Load:T()
		Error "Method FlxResource.Load must be overrided"
		Return NIL
	End Method
	
	Method Use:T()
		Error "Method FlxResource.Use must be overrided"
		Return NIL
	End Method
	
	Method Discard:Void()
		Error "Method FlxResource.Discard must be overrided"
	End Method
	
	Private
	
	Global NIL:T
	
End Class

Class FlxResourcesManager<T>

Private
	Field _resources:StringMap<FlxResource<T>>
	
	Method New()
		_resources = New StringMap<FlxResource<T>>()
	End Method

Public
	Method GetResource:T(name:String, resource:FlxResource<T>)			
		If (_resources.Contains(name)) Then
			Return _resources.Get(name).Use()
		End If
		
		Local raw:T = resource.Load()
		If (raw = Null) Error("Resource " + name + " can't be loaded")
		
		_resources.Set(name, resource)	
		Return raw
	End Method
	
	Method RemoveResource:Void(name:String)
		If (_resources.Contains(name)) Then
			_resources.Get(name).Discard()
			_resources.Remove(name)
		End If
	End Method
	
	Method CheckResource:Bool(name:String)
		Return _resources.Contains(name)
	End Method
	
	Method Clear:Void()
		If (_resources.IsEmpty()) Return
		
		For Local res:FlxResource<T> = EachIn _resources.Keys()
			res.Discard()
		Next
		
		_resources.Clear()
	End Method

End Class