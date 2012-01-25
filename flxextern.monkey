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
	
	Method CreateInstance:Object()
	
	Method InstanceOf:Bool(object:Object)

End Interface