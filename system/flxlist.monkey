Strict

Import flixel.flxobject

Class FlxList

	Field object:FlxObject
	
	Field nextLink:FlxList
	
	Method New()
		object = null
		nextLink = Null	
	End Method
	
	Method Destroy:Void()
		object = Null
		If (nextLink <> Null) nextLink.Destroy()
		nextLink = Null
	End Method

End Class