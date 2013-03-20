Strict

Import "native/flixel.${TARGET}.${LANG}"

#If TARGET = "html5"
	#If FLX_WEBGL_ENABLED = 1
		Import "native/webgl/mojo.${TARGET}.gl.min.${LANG}" 
	#End
#End

Extern

#If LANG="cpp"
	Function IsMobile:Bool() = "flixel::isMobile"
#ElseIf TARGET = "xna" Or TARGET = "psm"
	Function IsMobile:Bool() = "flixel.functions.isMobile"
#Else
	Function IsMobile:Bool() = "flixel.isMobile"
#End

#If TARGET = "xna" Or TARGET = "psm"
	Function FlxOpenURL:Void(url:String) = "flixel.functions.openURL"
#End

#If TARGET = "html5"
	Function IsIE:Bool() = "flixel.isIE"
#End
