Strict

Import mojo.audio

Import flxbasic
Import flxobject
Import flxu
Import system.flxassetsmanager

Class FlxSound Extends FlxBasic
	
	Global _class:FlxSoundClass = New FlxSoundClass()

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

	Global _usedChannels:Bool[_CHANNELS_COUNT]

	Field _sound:Sound
	
	Field _channel:Int
	
	Field _soundVolume:Float
	
	Field _soundPan:Float	
	
	Field _volume:Float
	
	Field _volumeAdjust:Float	
	
	Field _target:FlxObject
	
	Field _radius:Float
	
	Field _pan:Float
	
	Field _fadeOutTimer:Float
	
	Field _fadeOutTotal:Float
	
	Field _pauseOnFadeOut:Bool
	
	Field _fadeInTimer:Float
	
	Field _fadeInTotal:Float
	
Public
	Method New()
		Super.New()
		_CreateSound()
	End Method
	
	Method Destroy:Void()
		Kill()
		
		If (_sound <> Null) Then
			_sound.Discard()
			_sound = Null
		End If	
		
		If (_channel >= 0) Then
			_usedChannels[_channel] = False
		End If
		
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
			radial = FlxU.GetDistance(_target.x, _target.y, x, y)
			If (radial < 0) radial = 0
			If (radial > 1) radial = 1
			
			If (_pan) Then
				Local d:Float = (_target.x - x) / _radius
				
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
			_fadeOutTimer -= FlxG.elapsed
			
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
			_fadeInTimer -= FlxG.elapsed
			
			fade = _fadeInTimer / _fadeInTotal
			If (fade < 0) fade = 0
			fade = 1 - fade
			
			updateNeeded = True
		End If
		
		_volumeAdjust = radial * fade
		
		If (updateNeeded) _UpdateTransform()
	End Method
	
	Method Kill:Void()
		Super.Kill()		
		If (_channel > 0) Stop()
	End Method
	
	Method Load:FlxSound(sound:String, looped:Bool = False, autoDestroy:Bool = False)
		Stop()
		_CreateSound()
		_sound = LoadSound(FlxAssetsManager.GetSoundPath(sound))
		_looped = looped
		_UpdateTransform()
		exists = True
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
	
	Method Play:Void(forceRestart:Bool)
		If (forceRestart) Then
			Local oldAutoDestroy:Bool = autoDestroy
			autoDestroy = False
			Stop()
			autoDestroy = oldAutoDestroy
		End If
		
		If (_channel < 0)  Then
			_channel = _GetFreeChannel()
			If (_channel < 0) Return
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
		If (Not _paused Or _channel < 0) Return
		
		ResumeChannel(_channel)
		_paused = False
		active = True
	End Method
	
	Method Pause:Void()
		If (_channel < 0) Return
		
		PauseChannel(_channel)
		_paused = True
		active = False
	End Method
	
	Method Stop:Void()
		_paused = False
	
		If (_channel >= 0) Then
			StopChannel(_channel)
			_usedChannels[_channel] = False
			_channel = -1			
			active = False
			
			If (autoDestroy) Then
				Destroy()				
			End If
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
	
	Method _SetTransform:Void(volume:Float, pan:Float)
		SetChannelVolume(_channel, volume)
		SetChannelPan(_channel, pan)
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
		_radius = Null
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
		If (Not FlxG.mute) Then
			_soundVolume = FlxG._volume * _volume * _volumeAdjust
		Else
			_soundVolume = 0
		End If
		
		If (_channel >= 0) Then
			_SetTransform(_soundVolume, _soundPan)
		End If
	End Method
	
Private	
	Method _GetFreeChannel:Int()
		Local i:Int = 0
		
		While (i < _CHANNELS_COUNT)
			If (Not _usedChannels[i]) Return i
			i += 1
		Wend
		
		FlxG.Log("All channels occupied!")
		Return -1
	End Method	

End Class

Private
Class FlxSoundClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxSound()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return (FlxSound(object) <> Null)
	End Method
	
End Class