Strict

Import flxbasic

Import "native/flixel.${TARGET}.${LANG}"

#If TARGET = "html5"
	Import "data/flx_empty_cursor.png" 
#End

Extern

#If LANG="cpp"
	Function SystemMillisecs:Int() = "flixel::systemMillisecs"
	Function HideMouse:Void() = "flixel::hideMouse"
	Function ShowMouse:Void() = "flixel::showMouse"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
	Function HideMouse:Void() = "flixel.hideMouse"
	Function ShowMouse:Void() = "flixel.showMouse"
#End

Public

Interface FlxClass
	
	Method CreateInstance:FlxBasic()
	
	Method InstanceOf:Bool(object:FlxBasic)

End Interface

Interface FlxFunction
	
	Method Invoke:Void()

End Interface

Interface FlxStringable
	
	Method ToString:String()

	Method FromString:FlxStringable(value:String)
	
	Method IsChanged:Bool()
	
End Interface
