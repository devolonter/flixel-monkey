Strict

Import mojo.audio

Import flxbasic
Import flxobject
Import flxu
Import flxg
Import system.flxassetsmanager
Import system.flxresourcesmanager

Class FlxSound Extends FlxBasic
	
	Global ClassObject:FlxSoundClass = New FlxSoundClass()

	Field x:Float
	
	Field y:Float
	
	Field survive:Bool
	
	Field name:String
	
	Field artist:String
	
	Field autoDestroy:Bool
	
	Field _paused:Bool
	
	Field _looped:Bool
	
Private
	Const _CHANNELS_COUNT:Int = 32

	Global _UsedChannels:Bool[_CHANNELS_COUNT]
	
	Global _SoundLoader:FlxSoundLoader = New FlxSoundLoader()

	Field _sound:Sound
	
	Field _channel:Int
	
	Field _soundVolume:Float
	
	Field _soundPan:Float	
	
	Field _volume:Float
	
	Field _volumeAdjust:Float	
	
	Field _target:FlxObject
	
	Field _radius:Float
	
	Field _pan:Bool
	
	Field _fadeOutTimer:Float
	
	Field _fadeOutTotal:Float
	
	Field _pauseOnFadeOut:Bool
	
	Field _fadeInTimer:Float
	
	Field _fadeInTotal:Float
	
	Field _oldMute:Bool
	
Public
	Method New()
		Super.New()
		_CreateSound()
	End Method
	
	Method Destroy:Void()
		Kill()		
		_sound = Null		
		_channel = -1
		_target = Null
		
		Super.Destroy()
	End Method
	
	Method Update:Void()
		If (_paused) Return
		
		Local radial:Float = 1.0
		Local fade:Float = 1.0
		Local updateNeeded:Bool = False
		
		If (_target <> Null) Then
			'in original flixel: radial = FlxU.GetDistance(_target.x, _target.y, x, y) / _radius. Maybe a bug?		
			radial = 1 - FlxU.GetDistance(_target.x, _target.y, x, y) / _radius
			If (radial < 0) radial = 0
			
			If (_pan) Then
				'in original flixel: Local d:Float = (_target.x - x) / _radius. Maybe a bug?
				Local d:Float = -(_target.x - x) / _radius
				
				If (d < -1) Then
					d = -1
				ElseIf (d > 1) Then
					d = 1
				End If
				
				_soundPan = d
			End If
			
			updateNeeded = True
		End If
		
		If (_fadeOutTimer > 0) Then
			_fadeOutTimer -= FlxG.Elapsed
			
			If (_fadeOutTimer <= 0) Then
				If (_pauseOnFadeOut) Then
					Pause()
				Else
					Stop()
				End If
			End If
			
			fade = _fadeOutTimer / _fadeOutTotal
			If (fade < 0) fade = 0
			
			updateNeeded = True
		ElseIf (_fadeInTimer > 0) Then
			_fadeInTimer -= FlxG.Elapsed
			
			fade = _fadeInTimer / _fadeInTotal
			If (fade < 0) fade = 0
			fade = 1 - fade
			
			updateNeeded = True
		End If
		
		_volumeAdjust = radial * fade
		
		If (_oldMute <> FlxG.Mute) Then
			_UpdateTransform()			
			_oldMute = FlxG.Mute
			updateNeeded = True
		End If
		
		If (updateNeeded) _UpdateTransform()
	End Method
	
	Method Kill:Void()
		Super.Kill()		
		Stop()
	End Method
	
	Method Load:FlxSound(sound:String, looped:Bool = False, autoDestroy:Bool = False)
		Stop()
		_CreateSound()
		_sound = FlxG.AddSound(sound, _SoundLoader)
		_looped = looped
		_UpdateTransform()
		If (_sound <> Null) exists = True		
		Return Self
	End Method
	
	Method Proximity:FlxSound(x:Float, y:Float, object:FlxObject, radius:Float, pan:Bool = True)
		Self.x = x
		Self.y = y
		_target = object
		_radius = radius
		_pan = pan
		
		Return Self
	End Method
	
	Method Play:Void(forceRestart:Bool = False)
		If (forceRestart) Then
			Local oldAutoDestroy:Bool = autoDestroy
			autoDestroy = False
			Stop()
			autoDestroy = oldAutoDestroy
		End If
		
		If (_channel < 0)  Then
			_channel = _GetFreeChannel()
			If (_channel < 0) Then
				exists = False
				Return
			End If
		End If
		
		_UpdateTransform()
		
		If (Not _paused) Then
			PlaySound(_sound, _channel, _looped)
		Else
			ResumeChannel(_channel)			
		End If
		
		active = True
		_paused = False
	End Method
	
	Method Resume:Void()
		If (Not _paused) Return
		
		If (_channel < 0) Then
			exists = False
			Return
		End If
		
		ResumeChannel(_channel)
		_paused = False
		active = True
	End Method
	
	Method Pause:Void()
		If (_channel < 0) Then
			exists = False
			Return
		End If
		
		PauseChannel(_channel)
		_paused = True
		active = False
	End Method
	
	Method Stop:Void()
		_paused = False
	
		If (_channel >= 0) Then
			StopChannel(_channel)
			_UsedChannels[_channel] = False
			_channel = -1			
			active = False
			
			If (autoDestroy) Then
				Destroy()				
			End If
		Else
			exists = False
		End If
	End Method
	
	Method FadeOut:Void(seconds:Float, pauseInstead:Bool = False)
		_pauseOnFadeOut = pauseInstead
		_fadeInTimer = 0
		_fadeOutTimer = seconds
		_fadeOutTotal = _fadeOutTimer
	End Method
	
	Method FadeIn:Void(seconds:Float)
		_fadeOutTimer = 0
		_fadeInTimer = seconds
		_fadeInTotal = _fadeInTimer
	End Method
	
	Method Volume:Float() Property
		Return _volume	
	End Method
	
	Method Volume:Void(volume:Float) Property
		_volume = volume
		
		If (_volume < 0) Then
			_volume = 0
		ElseIf (_volume > 1)
			_volume = 1
		End If
		
		_UpdateTransform()
	End Method
	
	Method GetActualVolume:Float()
		Return _volume * _volumeAdjust
	End Method
	
	Method ToString:String()
		Return "FlxSound"
	End Method
	
	Function GetValidExt:String()
		#If TARGET = "glfw" Or TARGET = "xna"
			Return "wav"
		#ElseIf TARGET = "html5"
			If (IsIE()) Then
				Return "mp3"
			Else
				Return "ogg"
			End If
		#Else
			Return "mp3"
		#End
	End Function
	
	Method _SetTransform:Void(volume:Float, pan:Float)
		If (_channel >= 0) Then
			SetChannelVolume(_channel, volume)
			SetChannelPan(_channel, pan)
		End If
	End Method
	
	Method _CreateSound:Void()
		Destroy()
		x = 0
		y = 0
		_sound = Null
		_channel = -1
		_paused = False
		_volume = 1.0
		_volumeAdjust = 1.0
		_looped = False
		_target = Null
		_radius = 0
		_pan = False
		_fadeOutTimer = 0
		_fadeOutTotal = 0
		_pauseOnFadeOut = False
		_fadeInTimer = 0
		_fadeInTotal = 0
		exists = False
		active = False
		visible = False
		name = ""
		artist = ""
		autoDestroy = False
	End Method
	
	Method _UpdateTransform:Void()	
		If (Not FlxG.Mute) Then
			_soundVolume = FlxG._Volume * _volume * _volumeAdjust
		Else
			_soundVolume = 0
		End If		
		
		If (_soundVolume < 0) _soundVolume = 0
		_SetTransform(_soundVolume, _soundPan)
	End Method
	
Private	
	Method _GetFreeChannel:Int()
		Local i:Int = 0
		
		If (ChannelState(0) >= 0) Then
			While (i < _CHANNELS_COUNT)
				If (ChannelState(i) = 0) Return i				
				i += 1
			Wend	
		Else
			While (i < _CHANNELS_COUNT)
				If (Not _UsedChannels[i])
					_UsedChannels[i] = True
					Return i
				End If				
				i += 1
			Wend
		End If		
		
		FlxG.Log("All channels occupied!")
		Return -1
	End Method	

End Class

Interface FlxVolumeChangeListener

	Method OnVolumeChange:Void(volume:Float)

 End Interface

Private
Class FlxSoundClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxSound()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (FlxSound(object) <> Null)
	End Method
	
End Class

Class FlxSoundLoader Extends FlxResourceLoader<Sound>

	Method Load:Sound(name:String)
		Return LoadSound(FlxAssetsManager.GetSoundPath(name))
	End Method
	
End Class