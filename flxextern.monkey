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
#ElseIf TARGET = "xna" Or TARGET = "psm"
	Function SystemMillisecs:Int() = "flixel.functions.systemMillisecs"
	Function IsMobile:Bool() = "flixel.functions.isMobile"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
	Function IsMobile:Bool() = "flixel.isMobile"
#End

#If TARGET = "ios"
	Function FlxOpenURL:Void(url:String) = "flixel::openURL"
#End

#If TARGET = "glfw" And HOST = "macos"
	Function FlxOpenURL:Void(url:String) = "flixel::openURL"
#End

#If TARGET = "xna" Or TARGET = "psm"
	Function FlxOpenURL:Void(url:String) = "flixel.functions.openURL"
#End

#If TARGET = "html5"
	Function IsIE:Bool() = "flixel.isIE"
#End
