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
	Function IsMobile:Bool() = "flixel::isMobile"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
	Function HideMouse:Void() = "flixel.hideMouse"
	Function ShowMouse:Void() = "flixel.showMouse"
	Function IsMobile:Bool() = "flixel.isMobile"
#End

Public

Interface FlxClass
	
	Method CreateInstance:Object()
	
	Method InstanceOf:Bool(object:Object)

End Interface