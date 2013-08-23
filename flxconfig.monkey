
#TEXT_FILES += "|*.txt|*.xml|*.json|"

#REFLECTION_FILTER += "flixel.flxbasic*|flixel.flxbutton*|flixel.flxcamera*|flixel.flxemitter*"
#REFLECTION_FILTER += "flixel.flxgroup*|flixel.flxmusic*|flixel.flxobject*|flixel.flxparticle*"
#REFLECTION_FILTER += "flixel.flxpath*|flixel.flxpoint*|flixel.flxrect*|flixel.flxsound*"
#REFLECTION_FILTER += "flixel.flxsprite*|flixel.flxstate*|flixel.flxtext*|flixel.flxtileblock*"
#REFLECTION_FILTER += "flixel.flxtilemap*|flixel.plugin*"

#If CONFIG = "debug"
	#FLX_DEBUG_ENABLED = True
#Else
	#FLX_DEBUG_ENABLED = False
#End

#FLX_WEBGL_ENABLED  = False
#FLX_ASYNC_EVENTS_ENABLED = False

#FLX_TEXT_DRIVER = "angelfont"
#FLX_FONT_EXTENSION = ""
#FLX_FONT_IMAGE_MASK = ""

#If TARGET = "ios" Or TARGET = "android" Or TARGET = "psm" Or TARGET = "win8"
	#FLX_KEYBOARD_ENABLED = False
	
	#If TARGET <> "psm"
		#FLX_JOYSTICK_ENABLED = False
	#End
#End

#If TARGET = "glfw" Or TARGET = "flash"
	#FLX_ACCEL_ENABLED = False
	#FLX_MULTITOUCH_ENABLED = False
	
	#If TARGET = "flash"
		#FLX_JOYSTICK_ENABLED = False
	#End
#End

#FLX_MOUSE_ENABLED = True
#FLX_KEYBOARD_ENABLED = True
#FLX_JOYSTICK_ENABLED = True
#FLX_MULTITOUCH_ENABLED = True
#FLX_ACCEL_ENABLED = True

#If FLX_ACCEL_ENABLED = "0"
	#IOS_ACCELEROMETER_ENABLED = False
#End

#If TARGET = "html5"
	#FLX_SOUND_EXTENSION = "unknown"
	#FLX_MUSIC_EXTENSION = "unknown"
	
	#Print FLX_SOUND_EXTENSION
	
#ElseIf TARGET = "flash" Or TARGET = "android" Or TARGET = "ios"
	#FLX_SOUND_EXTENSION = "mp3"
	#FLX_MUSIC_EXTENSION = "mp3"
	
#ElseIf TARGET = "glfw"
	#FLX_SOUND_EXTENSION = "ogg"
	#FLX_MUSIC_EXTENSION = "ogg"
	
#ElseIf TARGET = "xna" Or TARGET = "psm" Or TARGET = "win8"
	#FLX_MUSIC_EXTENSION = "mp3"
	
#ElseIf TARGET = "bmax"
	#FLX_SOUND_EXTENSION = "ogg"
#End

#FLX_SOUND_EXTENSION = "wav"
#FLX_MUSIC_EXTENSION = "ogg"

