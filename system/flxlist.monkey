Strict

Import flixel.flxobject
Import flixel.flxg

Class FlxList

	Field object:FlxObject
	
	Field nextLink:FlxList
	
	Field exists:Bool
	
	Method New()
		object = null
		nextLink = Null		
	End Method
	
	Method Destroy:Void()
		object = Null
		If (nextLink <> Null) nextLink.Destroy()
		nextLink = Null
		exists = False
	End Method

End Class