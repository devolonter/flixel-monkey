Strict

Class FlxResource<T> Abstract

	Field name:String
	
	Method New(name:String)
		Self.name = name
	End Method
	
	Method Load:T() Abstract
	
	Method Use:T() Abstract
	
	Method Discard:Void() Abstract
	
End Class

Class FlxResourcesManager<T>

Private
	Field _resources:StringMap<FlxResource<T>>
	
Public
	Method New()
		_resources = New StringMap<FlxResource<T>>()
	End Method
	
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
		
		For Local res:FlxResource<T> = EachIn _resources.Values()
			res.Discard()
		Next
		
		_resources.Clear()
	End Method

End Class
