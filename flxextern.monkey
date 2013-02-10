Strict

#if TARGET = "glfw" And HOST = "macos"
	Import "native/flixel.${TARGET}.macos.${LANG}"
#Else
	Import "native/flixel.${TARGET}.${LANG}"
#End

Extern

#If LANG="cpp"
	Function SystemMillisecs:Int() = "flixel::systemMillisecs"
	Function IsMobile:Bool() = "flixel::isMobile"
	Function OpenURL:Void(url:String) = "flixel::openURL"
#ElseIf TARGET = "xna" Or TARGET = "psm"
	Function SystemMillisecs:Int() = "flixel.functions.systemMillisecs"
	Function IsMobile:Bool() = "flixel.functions.isMobile"
	Function OpenURL:Void(url:String) = "flixel.functions.openURL"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
	Function IsMobile:Bool() = "flixel.isMobile"
	Function OpenURL:Void(url:String) = "flixel.openURL"
#End

#If TARGET = "html5"
	Function IsIE:Bool() = "flixel.isIE"
#End