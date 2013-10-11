Strict

#If Not FLX_NATIVE_IMPLEMENTED
	#If TARGET="android" Or TARGET="flash" Or TARGET="glfw" Or TARGET="html5" Or TARGET="ios" Or TARGET="psm" Or TARGET="winrt" Or TARGET="xna" Or TARGET="bmax"
		Import "native/flixel.${TARGET}.${LANG}"
		#FLX_NATIVE_IMPLEMENTED = True
	#End
#End

#If TARGET = "html5" And FLX_WEBGL_ENABLED
	Import "native/webgl/mojo.${TARGET}.gl.min.${LANG}"
#End

Extern

#If FLX_NATIVE_IMPLEMENTED
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
	#If Not FLX_NATIVE_IMPLEMENTED
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
	#If Not FLX_NATIVE_IMPLEMENTED
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

#If Not FLX_NATIVE_IMPLEMENTED
	Function FlxIsMobile:Bool()
		Return False
	End Function
#End