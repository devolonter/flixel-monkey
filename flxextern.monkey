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
	#ElseIf LANG="cs"
		Function FlxIsMobile:Bool() = "flixel.functions.isMobile"
	#Else
		Function FlxIsMobile:Bool() = "flixel.isMobile"
	#End
	
	#If TARGET = "xna" Or TARGET = "psm"
		Function FlxOpenURL:Void(url:String) = "flixel.functions.openURL"
	#End
#End

#If FLX_SOUND_EXTENSION = "unknown"
	#If FLX_NATIVE_IMPLEMENTED = "0"
		#Error "Native file for detection extension of sound files not found"
	#End

	#If LANG="cpp"
		Function FlxGetValidSoundExt:String() = "flixel::getValidSoundExt"
	#ElseIf LANG="cs"
		Function FlxGetValidSoundExt:String() = "flixel.functions.getValidSoundExt"
	#Else
		Function FlxGetValidSoundExt:String() = "flixel.getValidSoundExt"
	#End
#End

#If FLX_MUSIC_EXTENSION = "unknown"
	#If FLX_NATIVE_IMPLEMENTED = "0"
		#Error "Native file for detection extension of music files not found"
	#End

	#If LANG="cpp"
		Function FlxGetValidMusicExt:String() = "flixel::getValidMusicExt"
	#ElseIf LANG="cs"
		Function FlxGetValidMusicExt:String() = "flixel.functions.getValidMusicExt"
	#Else
		Function FlxGetValidMusicExt:String() = "flixel.getValidMusicExt"
	#End
#End

Public

#If FLX_NATIVE_IMPLEMENTED = "0"
	Function FlxIsMobile:Bool()
		Return False
	End Function
#End