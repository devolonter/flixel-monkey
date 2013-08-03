Strict

#If TARGET="android" Or TARGET="flash" Or TARGET="glfw" Or TARGET="html5" Or TARGET="ios" Or TARGET="psm" Or TARGET="win8" Or TARGET="xna" Or TARGET="bmax"
	Import "native/flixel.${TARGET}.${LANG}"
	#FLX_NATIVE_IMPLEMENTED = True
#End

#FLX_NATIVE_IMPLEMENTED = False

#If TARGET = "html5"
	#If FLX_WEBGL_ENABLED = "1"
		Import "native/webgl/mojo.${TARGET}.gl.min.${LANG}" 
	#End
#End

Extern

#If FLX_NATIVE_IMPLEMENTED = "1"
	#If LANG="cpp"
		Function FlxIsMobile:Bool() = "flixel::isMobile"
	#ElseIf TARGET = "xna" Or TARGET = "psm"
		Function FlxIsMobile:Bool() = "flixel.functions.isMobile"
	#Else
		Function FlxIsMobile:Bool() = "flixel.isMobile"
	#End
	
	#If TARGET = "xna" Or TARGET = "psm"
		Function FlxOpenURL:Void(url:String) = "flixel.functions.openURL"
	#End
#End

#If TARGET = "html5"
	Function FlxGetValidAudioExt:String() = "flixel.getValidAudioExt"
#End

Public

#If FLX_NATIVE_IMPLEMENTED = "0"
	Function FlxIsMobile:Bool()
		Return False
	End Function
#End