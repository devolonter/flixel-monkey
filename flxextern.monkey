Strict

#if TARGET = "glfw" And HOST = "macos"
	Import "native/flixel.${TARGET}.macos.${LANG}"
#Else
	Import "native/flixel.${TARGET}.${LANG}"
#End

#If TARGET = "html5"
	Import "data/flx_empty_cursor.png" 
#End

Extern

#If LANG="cpp"
	Function SystemMillisecs:Int() = "flixel::systemMillisecs"
	Function HideMouse:Void() = "flixel::hideMouse"
	Function ShowMouse:Void() = "flixel::showMouse"
	Function IsMobile:Bool() = "flixel::isMobile"
	Function OpenURL:Void(url:String) = "flixel::openURL"
#ElseIf TARGET = "xna"
	Function SystemMillisecs:Int() = "flixel.functions.systemMillisecs"
	Function HideMouse:Void() = "flixel.functions.hideMouse"
	Function ShowMouse:Void() = "flixel.functions.showMouse"
	Function IsMobile:Bool() = "flixel.functions.isMobile"
	Function OpenURL:Void(url:String) = "flixel.functions.openURL"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
	Function HideMouse:Void() = "flixel.hideMouse"
	Function ShowMouse:Void() = "flixel.showMouse"
	Function IsMobile:Bool() = "flixel.isMobile"
	Function OpenURL:Void(url:String) = "flixel.openURL"
#End

#If TARGET = "html5"
	Function IsIE:Bool() = "flixel.isIE"
#End

Public

	Interface FlxClass
		
		Method CreateInstance:Object()
		
		Method InstanceOf:Bool(object:Object)
	
	End Interface