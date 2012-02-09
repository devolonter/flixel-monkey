Strict

Import flixel
Import assets

Class PlayState Extends FlxState

	Global ClassObject:FlxClass = New PlayStateClass()
	
	Field topText:FlxText
	
	Field elevator:FlxSprite
	
	Field crate:FlxSprite
	
	Field numCrates:Int = 100
	
	Field crateStormGroup:FlxGroup
	Field crateStormGroup2:FlxGroup
	Field crateStormMegaGroup:FlxGroup
	
	Field flixelRider:FlxSprite
	
	Field crateStorm:FlxButton
	Field crateStormG1:FlxButton
	Field crateStormG2:FlxButton
	Field quitButton:FlxButton
	Field flxRiderButton:FlxButton
	Field groupCollision:FlxButton
	
	Field isCrateStormOn:Bool = True
	Field isFlxRiderOn:Bool = False
	Field collideGroups:Bool = False
	Field redGroup:Bool = True
	Field blueGroup:Bool = True
	Field rising:Bool = True
			
	Method Create:Void()
		elevator = New FlxSprite((FlxG.Width / 2) - 100, 250, Assets.ELEVATOR)
		elevator.maxVelocity.y = 300
		elevator.immovable = True
		elevator.Solid = True
		Add(elevator)
		
		crateStormGroup = New FlxGroup()
		For Local i:Int = 0 Until numCrates
			crate = New FlxSprite((FlxG.Random() * 200) + 100, 20)
			crate.LoadGraphic(Assets.CRATE, True)
			crate.Frame = 0
			crate.angularVelocity = FlxG.Random() * 50 - 150
			crate.acceleration.y = 300
			crate.acceleration.x = -50
			crate.maxVelocity.y = 500
			crate.maxVelocity.x = 200
			crate.elasticity = FlxG.Random()
			crateStormGroup.Add(crate)
		Next
		Add(crateStormGroup)
		
		crateStormGroup2 = New FlxGroup()
		For Local i:Int = 0 Until numCrates
			crate = New FlxSprite((FlxG.Random() * 200) + 100, 20)
			crate.LoadGraphic(Assets.CRATE, True)
			crate.Frame = 1
			crate.angularVelocity = FlxG.Random() * 50 - 150
			crate.acceleration.y = 300
			crate.acceleration.x = 50
			crate.maxVelocity.y = 500
			crate.maxVelocity.x = 200
			crate.elasticity = FlxG.Random()
			crateStormGroup2.Add(crate)
		Next
		Add(crateStormGroup2)
		
		crateStormMegaGroup = new FlxGroup()
		crateStormMegaGroup.Add(crateStormGroup)
		crateStormMegaGroup.Add(crateStormGroup2)
		
		flixelRider = New FlxSprite((FlxG.Width / 2) - 13, 0, Assets.FLIXEL_LOGO)
		flixelRider.Solid = False
		flixelRider.visible = False
		flixelRider.exists = False
		flixelRider.acceleration.y = 800
		Add(flixelRider)
		
		topText = New FlxText(0, 2, FlxG.Width, "Welcome")
		topText.Alignment = FlxText.ALIGN_CENTER
		Add(topText)
		
		crateStorm = new FlxButton(2, FlxG.Height - 22, "Crate Storm", New BtnCrateStormClickListener(Self))
		Add(crateStorm)
		flxRiderButton = new FlxButton(82, FlxG.Height - 22, "Flixel Rider", New BtnFlixelRiderClickListener(Self))
		Add(flxRiderButton)
		crateStormG1 = new FlxButton(162, FlxG.Height - 22, "Blue Group", New BtnCrateStormG1ClickListener(Self))
		Add(crateStormG1)
		crateStormG2 = new FlxButton(242, FlxG.Height - 22, "Red Group", New BtnCrateStormG2ClickListener(Self))
		Add(crateStormG2)
		groupCollision = new FlxButton(202, FlxG.Height - 42, "Groups", New BtnGroupCollisionlickListener(Self))
		Add(groupCollision)
		
		FlxG.Mouse.Show()		
	End Method
	
	Method Update:Void()
		If (FlxG.Keys.JustPressed(KEY_ESCAPE)) Error ""
	
		If (topText.Alpha > 0) Then
			topText.Alpha -= .01
		End If
	
		If (rising) Then
			elevator.velocity.y -= 15
		Else
			elevator.velocity.y += 15
		End If
		
		If (elevator.y < 200 And rising) Then
			rising = False
		ElseIf (elevator.y > FlxG.Height - 200 And Not rising) Then
			rising = True
		End If
		
		For Local basic:FlxBasic = EachIn crateStormGroup
			crate = FlxSprite(basic)
			
			If (crate.x < -10) crate.x = FlxG.Width
			If (crate.x > FlxG.Width) crate.x = -10
			If (crate.y > FlxG.Height) crate.y = -10
		Next
		
		For Local basic:FlxBasic = EachIn crateStormGroup2
			crate = FlxSprite(basic)
			
			If (crate.x < -10) crate.x = FlxG.Width
			If (crate.x > FlxG.Width) crate.x = -10
			If (crate.y > FlxG.Height) crate.y = -10
		Next
		
		Super.Update()
		
		If (collideGroups) Then
			FlxG.Collide(crateStormGroup, crateStormGroup2)
		End If
	
		If (isCrateStormOn) Then
			FlxG.Collide(elevator, crateStormMegaGroup)
		End If
				
		If (isFlxRiderOn) Then
			FlxG.Collide(elevator, flixelRider)		
		End If		
	End Method
	
	Method OnFlixelRider:Void()
		If (Not isFlxRiderOn) Then
			isFlxRiderOn = True
			isCrateStormOn = False
			
			crateStormGroup.visible = False
			crateStormGroup.exists = False
			crateStormGroup2.visible = False
			crateStormGroup2.exists = False
			
			flixelRider.Solid = True
			flixelRider.visible = True
			flixelRider.exists = True
			flixelRider.y = 0
			flixelRider.velocity.y = 0
			
			crateStormG1.visible = False
			crateStormG2.visible = False
			groupCollision.visible = False
			
			topText.Text = "Flixel Elevator Rider!"
			topText.Alpha = 1
		End If
	End Method
	
	Method OnCrateStorm:Void()
		isCrateStormOn = True
		isFlxRiderOn = False
		
		If (blueGroup) Then
			crateStormGroup.visible = True
			crateStormGroup.exists = True
		End If
		
		If (redGroup) Then
			crateStormGroup2.visible = True
			crateStormGroup2.exists = True
		End If
		
		flixelRider.Solid = False
		flixelRider.visible = False
		flixelRider.exists = False
		
		crateStormG1.visible = True
		crateStormG2.visible = True
		
		If (blueGroup And redGroup) Then
			groupCollision.visible = True
		End If
		
		topText.Text = "CRATE STOOOOORM!"
		topText.Alpha = 1
	End Method
	
	Method OnBlue:Void()
		blueGroup = Not blueGroup
		
		crateStormGroup.visible = Not crateStormGroup.exists
		crateStormGroup.exists = Not crateStormGroup.exists
		
		For Local basic:FlxBasic = EachIn crateStormGroup
			crate = FlxSprite(basic)			
			crate.Solid = Not crate.Solid
		Next
		
		If (blueGroup And redGroup) Then
			groupCollision.visible = True
		Else
			groupCollision.visible = False
		End If
		
		If (Not blueGroup) Then
			topText.Text = "Blue Group: Disabled"
			topText.Alpha = 1
		Else
			topText.Text = "Blue Group: Enabled"
			topText.Alpha = 1
		End If
	End Method
	
	Method OnRed:Void()
		redGroup = Not redGroup
		
		crateStormGroup2.visible = Not crateStormGroup2.exists
		crateStormGroup2.exists = Not crateStormGroup2.exists
		
		For Local basic:FlxBasic = EachIn crateStormGroup2
			crate = FlxSprite(basic)			
			crate.Solid = Not crate.Solid
		Next
		
		If (blueGroup And redGroup) Then
			groupCollision.visible = True
		Else
			groupCollision.visible = False
		End If
		
		If (Not redGroup) Then
			topText.Text = "Red Group: Disabled"
			topText.Alpha = 1
		Else
			topText.Text = "Red Group: Enabled"
			topText.Alpha = 1
		End If
	End Method
	
	Method OnCollideGroups:Void()
		collideGroups = Not collideGroups
		
		If (Not collideGroups) Then
			topText.Text = "Group Collision: Disabled"
			topText.Alpha = 1
		Else
			topText.Text = "Group Collision: Enabled"
			topText.Alpha = 1
		End If
	End Method

End Class

Class BtnFlixelRiderClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnFlixelRider()
	End Method

End Class

Class BtnCrateStormClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnCrateStorm()
	End Method

End Class

Class BtnCrateStormG1ClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnBlue()
	End Method

End Class

Class BtnCrateStormG2ClickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnRed()
	End Method

End Class

Class BtnGroupCollisionlickListener Extends BtnClickListener
	
	Method New(state:PlayState)
		Super.New(state)
	End Method
	
	Method OnButtonClick:Void()
		state.OnCollideGroups()
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