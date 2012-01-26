Strict

Import flxgroup

Class FlxState Extends FlxGroup Abstract

	Global _class:FlxClass = new FlxStateClass()
	
	Method Create:Void()
		
	End Method
	
	Method GetClass:FlxClass()
		Error "You must override GetClass method"
		Return Null
	End Method
	
	Method ToString:String()
		Return "FlxState"
	End Method

End Class

Class FlxStateClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxObject()
	End Method
	
	Method InstanceOf:Bool(object:Object)			
		Return (FlxState(object) <> Null)
	End Method	
	
End Class