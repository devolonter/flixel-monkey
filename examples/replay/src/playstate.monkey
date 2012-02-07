Strict

Import flixel
Import assets

Class PlayState Extends FlxState Implements FlxReplayListener

	Global ClassObject:FlxClass = New PlayStateClass()
	
	Field hintText:FlxText
	
	Field simpleTilemap:FlxTilemap
	
	Field thePlayer:FlxSprite
	
	Field theCursor:FlxSprite
	
	Global recording:Bool = False
	Global replaying:Bool = False	
			
	Method Create:Void()	
		simpleTilemap = New FlxTilemap()
		simpleTilemap.LoadMap(FlxAssetsManager.GetString(Assets.MAP), Assets.TILES, 0, 0, FlxTilemap.AUTO)
		simpleTilemap.y -= 15
		Add(simpleTilemap)
		
		theCursor = New FlxSprite()
		theCursor.MakeGraphic(9, 8, $FFFF0000)
		Add(theCursor)
		
		thePlayer = New FlxSprite()
		thePlayer.MakeGraphic(12, 12, $FF8CF1FF)
		thePlayer.maxVelocity.x = 80
		thePlayer.maxVelocity.y = 200
		thePlayer.acceleration.y = 300
		thePlayer.drag.x = thePlayer.maxVelocity.x * 4
		thePlayer.x = 30
		thePlayer.y = 200
		Add(thePlayer)
		
		hintText = New FlxText(0, 268, FlxG.Width)
		hintText.Color = $FF000000
		hintText.Alignment = FlxText.ALIGN_CENTER
		Add(hintText)
		
		Init()
	End Method
	
	Method Update:Void()
		FlxG.Collide(simpleTilemap, thePlayer)
		
		thePlayer.acceleration.x = 0
		
		If (FlxG.Keys.Left) Then
			thePlayer.acceleration.x -= thePlayer.drag.x
		End If
		
		If (FlxG.Keys.Right) Then
			thePlayer.acceleration.x = thePlayer.drag.x
		End If
		
		If (FlxG.Keys.JustPressed(KEY_X) And Not thePlayer.velocity.y) Then
			thePlayer.velocity.y = -200
		End If
		
		If (Not PlayState.recording And Not PlayState.replaying) Then
			StartRecord()
		End If
		
		If (FlxG.Keys.JustPressed(KEY_R) And PlayState.recording) Then
			StartPlay()
		End If
		
		Super.Update()
		
		theCursor.scale.x = 1
		theCursor.scale.y = 1
		
		If (FlxG.Mouse.Pressed()) Then
			theCursor.scale.x = 2
			theCursor.scale.y = 2
		End If
		
		theCursor.x = FlxG.Mouse.screenX
		theCursor.y = FlxG.Mouse.screenY
	End Method
	
	Method Init:Void()
		If (PlayState.recording) Then
			thePlayer.Alpha = 1
			theCursor.Alpha = 1
			hintText.Text = "Recording: Arrow Keys : move, X : jump, R : replay~nMouse move and click will also be recorded"
		Else
			thePlayer.Alpha = .5
			theCursor.Alpha = .5
			hintText.Text = "Replaying: Press left mouse button to stop and record again"
		End If
	End Method
	
	Method StartRecord:Void()
		PlayState.recording = true
		PlayState.replaying = false

		FlxG.RecordReplay(false)
	End Method
	
	Method StartPlay:Void()
		PlayState.replaying = true
		PlayState.recording = false
		
		Local save:String = FlxG.StopRecording()
		FlxG.LoadReplay(save, new PlayState, [KEY_LMB], 0, Self)
	End Method
	
	Method OnReplayComplete:Void()
		StartRecord()
	End Method
	
	Method GetClass:FlxClass()
		Return PlayState.ClassObject
	End Method

End Class

Class PlayStateClass Implements FlxClass
	
	Method CreateInstance:Object()
		Return New PlayState()
	End Method
	
	Method InstanceOf:Bool(object:Object)
		Return PlayState(object) <> Null
	End Method

End Class