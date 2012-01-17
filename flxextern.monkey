Strict

Import flxbasic

Import "native/flixel.${TARGET}.${LANG}"

Extern

#If LANG="cpp" Then
	Function SystemMillisecs:Int() = "flixel::systemMillisecs"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
#End

Public

Interface FlxClass
	
	Method CreateInstance:FlxBasic()
	
	Method InstanceOf:Bool(object:FlxBasic)

End Interface

Interface FlxFunction
	
	Method Invoke:Void()

End Interface
