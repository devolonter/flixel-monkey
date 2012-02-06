Strict

Import flixel
Import assets

Class PlayState Extends FlxState

	Global ClassObject:FlxClass = New PlayStateClass()

	Const TILE_WIDTH:Int = 12
	Const TILE_HEIGHT:Int = 12	
	
	Const ACTION_GO:Int = 1	
	Const ACTION_IDLE:Int = 0
	
	Field map:FlxTilemap
	Field goal:FlxSprite
	Field unit:FlxSprite
	
	Field action:Int
	
	Field btnFindPath:FlxButton
	Field btnStopUnit:FlxButton
	Field btnResetUnit:FlxButton
	
	Field legends:FlxText
			
	Method Create:Void()
		FlxG.mouse.Show()
	
		map = New FlxTilemap()
		map.LoadMap(FlxAssetsManager.GetString(Assets.MAP), Assets.TILES, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF, 1)
		Add(map)
		
		goal = New FlxSprite(map.width - TILE_WIDTH, map.height - TILE_HEIGHT)
		goal.MakeGraphic(TILE_WIDTH, TILE_HEIGHT, $FFFFFF00)
		Add(goal)
		
		unit = New FlxSprite(0, 0)
		unit.MakeGraphic(TILE_WIDTH, TILE_HEIGHT, $FFFF0000)
		Add(unit)
		
		btnFindPath = New FlxButton(320, 10, "Find Path", New BtnFindPathClickListener(Self))
		Add(btnFindPath)
		
		btnStopUnit = New FlxButton(320, 30, "Stop Unit", New BtnStopUnitClickListener(Self))
		Add(btnStopUnit)
		
		btnResetUnit = New FlxButton(320, 50, "Reset Unit", New BtnResetUnitClickListener(Self))
		Add(btnResetUnit)
		
		legends = New FlxText(320, 90, 80, "Click in map to place or remove tile~n~nLegends:~nRed:Unit~nYellow:Goal~nBlue:Wall~nWhite:Path")
		Add(legends)
	End Method
	
	Method Draw:Void()
		Super.Draw()
		
		If (unit.path <> Null) Then
			unit.path.DrawDebug()
		End If
	End Method
	
	Method Update:Void()
		FlxG.Collide(unit, map)
		
		Super.Update()
		
		If (FlxG.mouse.JustPressed() And action = ACTION_IDLE) Then
			Local mx:Int = FlxG.mouse.screenX / TILE_WIDTH
			Local my:Int = FlxG.mouse.screenY / TILE_HEIGHT
			
			map.SetTile(mx, my, 1 - map.GetTile(mx, my))
		End If
		
		If (action = ACTION_GO And unit.pathSpeed = 0) Then
			StopUnit 		
		End If
	End Method
	
	Method MoveToGoal:Void()
		If (action = ACTION_IDLE) Then
			Local path:FlxPath = map.FindPath(New FlxPoint(unit.x + unit.width / 2, unit.y + unit.height / 2),
				New FlxPoint(goal.x + goal.width / 2, goal.y + goal.height / 2))
			
			If (path <> Null) Then
				unit.FollowPath(path)
				action = ACTION_GO
			End If
		End If
	End Method
	
	Method StopUnit:Void()
		action = ACTION_IDLE
		unit.StopFollowingPath(True)
		unit.velocity.x = 0
		unit.velocity.y = 0
	End Method
	
	Method ResetUnit:Void()
		unit.Reset(0, 0)		
		If (ACTION_GO) StopUnit()
	End Method

End Class

Class BtnResetUnitClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.ResetUnit()
	End Method

End Class

Class BtnStopUnitClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.StopUnit()
	End Method

End Class

Class BtnFindPathClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.MoveToGoal()
	End Method

End Class

Class BtnClickListener Implements FlxButtonClickListener

	Field state:PlayState

	Method New(state:PlayState)
		Self.state = state
	End Method
	
	Method OnButtonClick:Void()
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