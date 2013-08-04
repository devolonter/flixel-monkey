Strict

Import mojo.audio

Import flxsound
Import system.flxassetsmanager

Class FlxMusic Extends FlxSound

	Global __CLASS__:Object

Private
	Field _filename:String
	
Public
	Method Kill:Void()
		Super.Kill()
		Stop()
	End Method
	
	Method Load:FlxSound(music:String, looped:Bool = False, autoDestroy:Bool = True, stopPrevious:Bool = True)
		Stop()
		_CreateSound()
		_filename = FlxAssetsManager.GetMusicPath(music)
		_looped = looped
		_UpdateTransform()
		exists = True
		Return Self
	End Method
	
	Method Play:Void(forceRestart:Bool = False)
		If (forceRestart) Then
			Local oldAutoDestroy:Bool = autoDestroy
			autoDestroy = False
			Stop()
			autoDestroy = oldAutoDestroy
		End If		
				
		_UpdateTransform()
		
		If (Not _paused) Then
			PlayMusic(_filename, _looped)
		Else
			ResumeMusic()		
		End If
		
		active = True
		_paused = False
	End Method
	
	Method Resume:Void()
		If (Not _paused) Return
		
		ResumeMusic()
		_paused = False
		active = True
	End Method
	
	Method Pause:Void()
		If (Not active) Return	
		
		PauseMusic()		
		_paused = True
		active = False
	End Method
	
	Method Stop:Void()
		_paused = False
		active = False
		
		StopMusic()
		
		If (autoDestroy) Then
			Destroy()				
		End If
	End Method
	
	Function GetValidExt:String()
	#If TARGET = "glfw" Or TARGET = "bmax"
		Return "ogg"
	#ElseIf TARGET = "html5"
		Return FlxGetValidAudioExt()
	#Else
		Return "mp3"
	#End
	End Function
	
	Method _SetTransform:Void(volume:Float, pan:Float)
		SetMusicVolume(volume)
	End Method

End Class