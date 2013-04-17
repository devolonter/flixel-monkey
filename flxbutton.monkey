Strict

Import reflection

Import flxextern
Import flxsprite
Import flxtext
Import flxpoint
Import flxsound
Import flxg
Import flxcamera
Import system.flxassetsmanager

Import "data/button_flx.png"
Import "data/beep_flx.mp3"

Class FlxButton Extends FlxSprite

	Global ClassObject:Object
	
	Const NORMAL:Int = 0
	
	Const HIGHLIGHT:Int = 1
	
	Const PRESSED:Int = 2	
	
	Field label:FlxText
	
	Field labelOffset:FlxPoint
	
	Field onUp:FlxButtonClickListener
	
	Field onDown:FlxButtonDownListener
	
	Field onOver:FlxButtonOverListener
	
	Field onOut:FlxButtonOutListener
	
	Field status:Int
	
	Field soundOver:FlxSound
	
	Field soundOut:FlxSound
	
	Field soundDown:FlxSound
	
	Field soundUp:FlxSound
	
Private
	Field _onToggle:Bool
	
	Field _pressed:Bool
	
	Field _initialized:Bool
	
Public
	Method New(x:Float = 0, y:Float = 0, label:String = "", onClick:FlxButtonClickListener = Null)
		Super.New(x, y)
		
		If (label.Length() > 0) Then
			Self.label = New FlxText(0, 0, 80, label)
			Self.label.SetFormat(FlxText.SYSTEM_FONT, 8, $FF333333, FlxText.ALIGN_CENTER)
			labelOffset = New FlxPoint(-1, 3)
		End If
		
		LoadGraphic("button" + FlxG.DATA_SUFFIX, True, False, 80, 20)
		onUp = onClick
		onDown = Null
		onOut = Null
		onOver = Null
		
		soundOver = Null
		soundOut = Null
		soundDown = Null
		soundUp = Null
		
		status = NORMAL
		_onToggle = False
		_pressed = False
	End Method
	
	Method Destroy:Void()
		If (label <> Null) Then
			label.Destroy()
			label = Null
		End If
		
		onUp = Null
		onDown = Null
		onOut = Null
		onOver = Null
		
		If (soundOver <> Null) Then
			soundOver.Destroy()
			soundOver = Null
		End If
		
		If (soundOut <> Null) Then
			soundOut.Destroy()
			soundOut = Null
		End If
		
		If (soundDown <> Null) Then
			soundDown.Destroy()
			soundDown = Null
		End If
		
		If (soundUp <> Null) Then
			soundUp.Destroy()
			soundUp = Null
		End If
		
		Super.Destroy()
	End Method
	
	Method Update:Void()
		_UpdateButton()
		
		If (label = Null) Return
		
		Select (Frame)
			Case HIGHLIGHT
				label.Alpha = 1.0
				
			Case PRESSED
				label.Alpha = .5
				label.y += 1
				
			Case NORMAL
				label.Alpha = .8
			
			Default
				label.Alpha = .8
		End Select
	End Method
	
	Method Draw:Void()
		Super.Draw()
		
		If (label <> Null) Then
			label.scrollFactor = scrollFactor
			label.Draw()
		End If
	End Method
	
	Method _ResetHelpers:Void()
		Super._ResetHelpers()
		
		If (label <> Null) Then
			label.SetWidth(width)			
		End If
	End Method
	
	Method SetSounds:Void(soundOver:String = "", soundOverVolume:Float = 1.0, soundOut:String = "", soundOutVolume:Float = 1.0, soundDown:String = "", soundDownVolume:Float = 1.0, soundUp:String = "", soundUpVolume:Float = 1.0)
		If (soundOver.Length() > 0) Then
			Self.soundOver = FlxG.LoadSound(soundOver, soundOverVolume)
		End If
		
		If (soundOut.Length() > 0) Then
			Self.soundOut = FlxG.LoadSound(soundOut, soundOutVolume)
		End If
		
		If (soundDown.Length() > 0) Then
			Self.soundDown = FlxG.LoadSound(soundDown, soundDownVolume)
		End If
		
		If (soundUp.Length() > 0) Then
			Self.soundUp = FlxG.LoadSound(soundUp, soundUpVolume)
		End If
	End Method
	
	Method On:Bool() Property
		Return _onToggle	
	End Method
	
	Method On:Void(on:Bool) Property
		_onToggle = on	
	End Method
	
Private
	Method _UpdateButton:Void()
		If (FlxG.Mobile Or FlxG.Mouse.Visible Or FlxG._Game.useSystemCursor) Then
			Local cameras:Stack<FlxCamera> = FlxG.Cameras
			Local camera:FlxCamera
			Local i:Int = 0
			Local l:Int = cameras.Length()
			Local offAll:Bool = True
			Local click:Bool = False
			
			While (i < l)
				camera = cameras.Get(i)
				FlxG.Mouse.GetWorldPosition(camera, _point)
				
				If (OverlapsPoint(_point, True, camera)) Then
					offAll = False
					
					If (FlxG.Mouse.JustPressed()) Then
						status = PRESSED
						
						If (onDown <> Null) Then
							onDown.OnButtonDown()
						End If
						
						If (soundDown <> Null) Then
							soundDown.Play(True)
						End If
					End If
					
					If (FlxG.Mouse.JustReleased() And status = PRESSED) Then
						status = NORMAL
						click = True
					End If
					
					If (status = NORMAL) Then
						status = HIGHLIGHT
						
						If (onOver <> Null) Then
							onOver.OnButtonOver()
						End If
						
						If (soundOver <> Null) Then
							soundOver.Play(True)
						End If
					End If
				End If
				
				i += 1
			Wend
			
			If(offAll) Then
				If (status <> NORMAL) Then
					If (onOut <> Null) Then
						onOut.OnButtonOut()
					End If
					
					If (soundOut <> Null) Then
						soundOut.Play(True)
					End If
				End If
				
				status = NORMAL
			End If
			
			If(click) Then
				If (onUp <> Null) Then
					onUp.OnButtonClick()
				End If
				
				If (soundUp <> Null) Then
					soundUp.Play(True)
				End If
			End If
		End If
		
		If (label <> Null) Then
			label.x = x
			label.y = y
		End If
		
		If (labelOffset <> Null) Then
			label.x += labelOffset.x
			label.y += labelOffset.y
		End If
		
		If (status = HIGHLIGHT And _onToggle) Then
			Frame = NORMAL
		Else
			Frame = status
		End If
	End Method

End Class

Interface FlxButtonClickListener
	
	Method OnButtonClick:Void()

End Interface

Interface FlxButtonDownListener
	
	Method OnButtonDown:Void()

End Interface

Interface FlxButtonOverListener
	
	Method OnButtonOver:Void()

End Interface

Interface FlxButtonOutListener
	
	Method OnButtonOut:Void()

End Interface