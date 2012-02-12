Strict

Import mojo.audio

Import flxsound
Import system.flxassetsmanager

Class FlxMusic Extends FlxSound

Private
	Field _filename:String
	
	Field _oldMusicVolume:Float
	
Public
	Method Update:Void()
		If (_oldMusicVolume <> FlxG._Volume) Then
			_UpdateTransform()
			_oldMusicVolume = FlxG._Volume
		End If			
	End Method

	Method Kill:Void()
		Super.Kill()
		Stop()
	End Method
	
	Method Load:FlxSound(music:String, looped:Bool = False, autoDestroy:Bool = True)
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
	
	Method ToString:String()
		Return "FlxMusic"
	End Method
	
	Method _SetTransform:Void(volume:Float, pan:Float)
		SetMusicVolume(volume)
	End Method

End Class