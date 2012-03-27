Strict

#rem
	header:This module contains the FlxObject class.
#end

Import flxextern
Import flxbasic
Import flxpoint
Import flxpath
Import flxgroup
Import flxcamera
Import flxtilemap
Import flxg
Import flxu

Import system.flxcolor
Import system.flxtile

#Rem
summary:This is the base class for most of the display objects (FlxSprite, FlxText, etc).
It includes some basic attributes about game objects, including retro-style flickering, 
basic state information, sizes, scrolling, and basic physics and motion.
#End
Class FlxObject Extends FlxBasic

	Global ClassObject:FlxClass = new FlxObjectClass()
	
	Global XComparator:FlxBasicComparator = new FlxObjectXComparator()
	
	Global YComparator:FlxBasicComparator = new FlxObjectYComparator()
	
	'summary:Generic value for "left" Used by facing, allowCollisions, and touching.
	Const LEFT:Int = 1
	
	'summary:Generic value for "right" Used by facing, allowCollisions, and touching.
	Const RIGHT:Int = 2
	
	'summary:Generic value for "up" Used by facing, allowCollisions, and touching.
	Const UP:Int = 4
	
	'summary:Generic value for "down" Used by facing, allowCollisions, and touching.
	Const DOWN:Int = 8	

	'summary:Special-case constant meaning no collisions, used mainly by allowCollisions and touching.	 
	Const NONE:Int = 0
	
	'summary:Special-case constant meaning up, used mainly by allowCollisions and touching.	 
	Const CEILING:Int = UP
	
	'summary:Special-case constant meaning down, used mainly by allowCollisions and touching.	 
	Const FLOOR:Int = DOWN
	
	'summary:Special-case constant meaning only the left and right sides, used mainly by allowCollisions and touching.	 
	Const WALL:Int = LEFT | RIGHT
	
	'summary:Special-case constant meaning any direction, used mainly by allowCollisions and touching.	 
	Const ANY:Int = LEFT | RIGHT | UP | DOWN	
	
	'summary:Handy constant used during collision resolution (see separateX() and separateY()).	 
	Const OVERLAP_BIAS:Int = 4	
	
	'summary:Path behavior controls: move from the start of the path to the end then stop.	
	Const PATH_FORWARD:Int = 0
	
	'summary:Path behavior controls: move from the end of the path to the start then stop.	
	Const PATH_BACKWARD:Int = 1
	
	'summary:Path behavior controls: move from the start of the path to the end then directly back to the start, and start over.	
	Const PATH_LOOP_FORWARD:Int = 2
	
	'summary:Path behavior controls: move from the end of the path to the start then directly back to the end, and start over.	
	Const PATH_LOOP_BACKWARD:Int = 4
	
	'summary:Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over.	
	Const PATH_YOYO:Int = 8
	
	'summary:Path behavior controls: ignores any vertical component to the path data, only follows side to side.
	Const PATH_HORIZONTAL_ONLY:Int = 16
	
	'summary:Path behavior controls: ignores any horizontal component to the path data, only follows up and down.
	Const PATH_VERTICAL_ONLY:Int = 32	
	
	'summary:X position of the upper left corner of this object in world space.	
	Field x:Float
	
	'summary:Y position of the upper left corner of this object in world space.	
	Field y:Float
	
	'summary:The width of this object.	
	Field width:Float
	
	'summary:The height of this object.	
	Field height:Float	
	
	'summary:Whether an object will move/alter position after a collision.	
	Field immovable:Bool
	
	Field velocity:FlxPoint
	
	Field mass:Float
	
	Field elasticity:Float
	
	Field acceleration:FlxPoint
	
	Field drag:FlxPoint
	
	Field maxVelocity:FlxPoint
	
	Field angle:Float
	
	Field angularVelocity:Float
	
	Field angularAcceleration:Float
	
	Field angularDrag:Float
	
	Field maxAngular:Float
	
	Field scrollFactor:FlxPoint
	
	Field health:Float
	
	Field moves:Bool
	
	Field touching:Int
	
	Field wasTouching:Int
	
	Field allowCollisions:Int
	
	Field last:FlxPoint
	
	Field path:FlxPath
	
	Field pathSpeed:Float
	
	Field pathAngle:Float
	
	Field _flicker:Bool
	
	Field _flickerTimer:Float
	
	Field _point:FlxPoint
	
	Field _rect:FlxRect
	
Private
	Global _separateXCallback:FlxObjectSeparateX = New FlxObjectSeparateX()
	
	Global _separateYCallback:FlxObjectSeparateY = New FlxObjectSeparateY()

	Global _pZero:FlxPoint = New FlxPoint()		
	
	Field _pathNodeIndex:Int
	
	Field _pathMode:Int
	
	Field _pathInc:Int
	
	Field _pathRotate:Bool
	
	Field _debugBoundingBoxColor:FlxColor
	
Public	
	Method New(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0)
		Self.x = x
		Self.y = y
		last = New FlxPoint(x, y)
		Self.width = width
		Self.height = height
		mass = 1.0
		elasticity = 0.0
		
		health = 1
		
		immovable = False
		moves = True
		
		touching = NONE
		wasTouching = NONE
		allowCollisions = ANY
		
		velocity = New FlxPoint()
		acceleration = New FlxPoint()
		drag = New FlxPoint()
		maxVelocity = New FlxPoint(10000, 10000)
		
		angle = 0
		angularVelocity = 0
		angularAcceleration = 0
		angularDrag = 0
		maxAngular = 10000
		
		scrollFactor = New FlxPoint(1.0, 1.0)
		_flicker = False
		_flickerTimer = 0
		
		_point = New FlxPoint()
		_rect = New	FlxRect()
		
		path = Null
		pathSpeed = 0
		pathAngle = 0	
	End Method
	
	Method Destroy:Void()
		velocity = Null
		acceleration = Null
		drag = Null
		maxVelocity = Null
		scrollFactor = Null
		_point = Null
		_rect = Null
		last = Null
		_cameras = Null
		If (path <> Null) path.Destroy()
		path = Null		
		_debugBoundingBoxColor = Null	
	End Method
	
	Method PreUpdate:Void()
		_ActiveCount += 1
		
		If (_flickerTimer <> 0) Then
			If (_flickerTimer > 0) Then
				_flickerTimer -= FlxG.Elapsed				
				If (_flickerTimer <= 0) Then
					_flickerTimer = 0
					_flicker = False
				End If
			End If
		End If
		
		last.x = x
		last.y = y
		
		If (path <> Null And pathSpeed <> 0 And path.nodes.Get(_pathNodeIndex) <> Null) Then
			_UpdatePathMotion()		 
		End If
	End Method
	
	Method PostUpdate:Void()
		If (moves) _UpdateMotion()
		
		wasTouching = touching
		touching = NONE
	End Method
	
	Method Draw:Void()
		If (_cameras <> Null And Not _cameras.Contains(FlxG._CurrentCamera.ID)) Return	
		If (Not OnScreen(FlxG._CurrentCamera)) Return
		
		_VisibleCount += 1
		If (FlxG.VisualDebug And Not ignoreDrawDebug) DrawDebug(FlxG._CurrentCamera)	
	End Method
	
	Method DrawDebug:Void(camera:FlxCamera = Null)
		If (camera = Null) camera = FlxG.Camera
	
		Local boundingBoxX:Float = x - Int(camera.scroll.x * scrollFactor.x)		
		Local boundingBoxY:Float = y - Int(camera.scroll.y * scrollFactor.y)
		
		If (boundingBoxX > 0) Then
			boundingBoxX += 0.0000001
		Else
			boundingBoxX -= 0.0000001
		End If
		
		If (boundingBoxY > 0) Then
			boundingBoxY += 0.0000001
		Else
			boundingBoxY -= 0.0000001
		End If
		
		Local boundingBoxWidth:Int
		Local boundingBoxHeight:Int
		
		If (width <> Int(width)) Then
			boundingBoxWidth = width
		Else
			boundingBoxWidth = width - 1
		End If
		
		If (height <> Int(height)) Then
			boundingBoxHeight = height
		Else
			boundingBoxHeight = height - 1
		End If
		
		If (_debugBoundingBoxColor = Null) _debugBoundingBoxColor = New FlxColor()
		If (allowCollisions) Then
			If (allowCollisions <> ANY) Then
				_debugBoundingBoxColor.SetARGB(FlxG.PINK)
			ElseIf (immovable)
				_debugBoundingBoxColor.SetARGB(FlxG.GREEN)
			Else
				_debugBoundingBoxColor.SetARGB(FlxG.RED)				
			End if
		Else
			_debugBoundingBoxColor.SetARGB(FlxG.BLUE)
		End If
		
		SetAlpha(.5)
		
		If (FlxG._LastDrawingColor <> _debugBoundingBoxColor.argb) Then
			SetColor(_debugBoundingBoxColor.r, _debugBoundingBoxColor.g, _debugBoundingBoxColor.b)
			FlxG._LastDrawingColor = _debugBoundingBoxColor.argb
		End If
		
		DrawLine(boundingBoxX, boundingBoxY, boundingBoxX + boundingBoxWidth, boundingBoxY)
		DrawLine(boundingBoxX + boundingBoxWidth, boundingBoxY, boundingBoxX + boundingBoxWidth ,boundingBoxY + boundingBoxHeight)
		DrawLine(boundingBoxX + boundingBoxWidth ,boundingBoxY + boundingBoxHeight, boundingBoxX, boundingBoxY + boundingBoxHeight)
		DrawLine(boundingBoxX, boundingBoxY + boundingBoxHeight, boundingBoxX, boundingBoxY)		
		
		SetAlpha(1)
	End Method
	
	Method FollowPath:Void(path:FlxPath, speed:Float = 100, mode:Int = PATH_FORWARD, autoRotate:Bool = False)		
		If (path.nodes.Length() <= 0) Then
			FlxG.Log("WARNING: Paths need at least one node in them to be followed.")
			Return
		End If
		
		Self.path = path
		pathSpeed = Abs(speed)
		_pathMode = mode
		_pathRotate = autoRotate
		
		If (_pathMode = PATH_BACKWARD Or _pathMode = PATH_LOOP_BACKWARD) Then
			_pathNodeIndex = Self.path.nodes.Length() - 1
			_pathInc = -1
		Else
			_pathNodeIndex = 0
			_pathInc = 1
		End If		
	End Method
	
	Method StopFollowingPath:Void(destroyPath:Bool = False)
		pathSpeed = 0
		If (destroyPath And path <> Null) Then
			path.Destroy()
			path = Null
		End If
	End Method
	
	Method Overlaps:Bool(objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (objectOrGroup = Null) Return False
	
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local results:Bool = False			
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local i:Int = 0
			Local l:Int = members.Length()
			
			While(i < l)
				If (Overlaps(members[i], inScreenSpace, camera)) Then
					results = True
					Exit
				End if
				i += 1
			Wend
			
			Return results
		End If
		
		If (FlxTilemap(objectOrGroup) <> Null) Then
			Return FlxTilemap(objectOrGroup).overlaps(Self, inScreenSpace, camera)
		End If
		
		Local object:FlxObject = FlxObject(objectOrGroup)
		
		If (Not inScreenSpace) Then
			Return (object.x + object.width > x) And (object.x < x + width) And
				(object.y + object.height > y) And (object.y < y + height)
		End If
		
		If (camera = Null) camera = FlxG.Camera
		Local objectScreenPos:FlxPoint = object.GetScreenXY(Null, camera)		
		GetScreenXY(_point, camera)
		
		Return (objectScreenPos.x + object.width > _point.x) And (objectScreenPos.x < _point.x + width) And
			(objectScreenPos.y + object.height > _point.y) And (objectScreenPos.y < _point.y + height)
	End Method
	
	Method OverlapsAt:Bool(x:Float, y:Float, objectOrGroup:FlxBasic, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (objectOrGroup = Null) Return False
	
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local results:Bool = False			
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local i:Int = 0
			Local l:Int = members.Length()
			
			While(i < l)
				If (overlapsAt(x, y, members[i], inScreenSpace, camera)) Then
					results = True
					Exit
				End if
				i += 1
			Wend
			
			Return results
		End If
		
		If (FlxTilemap(objectOrGroup) <> Null) Then
			Local tilemap:FlxTilemap = FlxTilemap(objectOrGroup)
			Return tilemap.OverlapsAt(tilemap.x - (x - Self.x), tilemap.y - (y - Self.y), Self ,inScreenSpace, camera)
		End If
		
		Local object:FlxObject = FlxObject(objectOrGroup)
		
		If (Not inScreenSpace) Then
			Return (object.x + object.width > x) And (object.x < x + width) And
				(object.y + object.height > y) And (object.y < y + height)
		End If
		
		If (camera = Null) camera = FlxG.Camera
		Local objectScreenPos:FlxPoint = object.GetScreenXY(Null, camera)
		
		point.x = x - Int(camera.scroll.x * scrollFactor.x)
		point.y = y - Int(camera.scroll.y * scrollFactor.y)
		
		If (point.x > 0) Then
			point.x += 0.0000001
		Else
			point.x -= 0.0000001			
		End If
		
		If (point.y > 0) Then
			point.y += 0.0000001
		Else
			point.y -= 0.0000001			
		End If
		
		Return (objectScreenPos.x + object.width > _point.x) And (objectScreenPos.x < _point.x + width) And
			(objectScreenPos.y + object.height > _point.y) And (objectScreenPos.y < _point.y + height)
	End Method
	
	Method OverlapsPoint:Bool(point:FlxPoint, inScreenSpace:Bool = False, camera:FlxCamera = Null)
		If (Not inScreenSpace) Then
			Return (point.x > x) And (point.x < x + width) And (point.y > y) And (point.y < y + height)
		End If
		
		If (camera = Null) camera = FlxG.Camera
		
		Local x:Float = point.x - camera.scroll.x
		Local y:Float = point.y - camera.scroll.y
		GetScreenXY(_point, camera)
		
		Return (x > _point.x) And (x < _point.x + width) And (y > _point.y) And (y < _point.y + height)
	End Method	
	
	Method OnScreen:Bool(camera:FlxCamera = Null)
		If (camera = Null) camera = FlxG.Camera
		
		GetScreenXY(_point, camera)
		Return (_point.x + width > 0) And (_point.x < camera.Width) And (_point.y + height > 0) And (_point.y < camera.Height)
	End Method
	
	Method GetScreenXY:FlxPoint(point:FlxPoint = Null, camera:FlxCamera = Null)
		If (point = Null) point = New FlxPoint()
		If (camera = Null) camera = FlxG.Camera
		
		point.x = x - Int(camera.scroll.x * scrollFactor.x)
		point.y = y - Int(camera.scroll.y * scrollFactor.y)
		
		If (point.x > 0) Then
			point.x += 0.0000001
		Else
			point.x -= 0.0000001			
		End If
		
		If (point.y > 0) Then
			point.y += 0.0000001
		Else
			point.y -= 0.0000001			
		End If
		
		Return point
	End Method
	
	Method Flicker:Void(duration:Float = 1)
		_flickerTimer = duration
		If (_flickerTimer = 0) _flicker = False
	End Method
	
	Method Flickering:Bool() Property
		Return _flickerTimer <> 0
	End Method
	
	Method Solid:Bool() Property
		Return (allowCollisions & ANY) > NONE
	End Method
	
	Method Solid:Void(solid:Bool) Property
		If (solid) Then
			allowCollisions = ANY
		Else
			allowCollisions = NONE
		End If
	End Method
	
	Method GetMidpoint:FlxPoint(point:FlxPoint)
		If (point = Null) point = New FlxPoint()		
		point.x = x + width * .5
		point.y = y + height * .5		
		Return point
	End Method
	
	Method Reset:Void(x:Float, y:Float)
		Revive()
		touching = NONE
		wasTouching = NONE
		Self.x = x
		Self.y = y
		last.x = x
		last.y = y
		velocity.x = 0
		velocity.y = 0
	End Method
	
	Method IsTouching:Bool(direction:Int)
		Return (touching & direction) > NONE
	End Method
	
	Method JustTouched:Bool(direction:Int)
		Return (touching & direction) > NONE And (wasTouching & direction) <= NONE
	End Method
	
	Method Hurt:Void(damage:Float)
		health -= damage
		If (health <= 0) Kill()
	End Method
	
	Function Separate:Bool(object1:FlxObject, object2:FlxObject)
		Local separatedX:Bool = SeparateX(object1, object2)
		Local separatedY:Bool = SeparateY(object1, object2)
		
		Return separatedX Or separatedY
	End Function
	
	Function SeparateX:Bool(object1:FlxObject, object2:FlxObject)
		Local obj1immovable:Bool = object1.immovable
		Local obj2immovable:Bool = object2.immovable
		
		If (obj1immovable And obj2immovable) Return False
		
		If (FlxTilemap(object1) <> Null) Then
			Return FlxTilemap(object1).OverlapsWithCallback(object2, _separateXCallback)
		End If
		
		If (FlxTilemap(object2) <> Null) Then
			Return FlxTilemap(object2).OverlapsWithCallback(object1, _separateXCallback, True)
		End If
		
		Local overlap:Float = 0
		Local obj1delta:Float = object1.x - object1.last.x
		Local obj2delta:Float = object2.x - object2.last.x
		
		If (obj1delta <> obj2delta) Then
			Local obj1deltaAbs:Float = Abs(obj1delta)
			Local obj2deltaAbs:Float = Abs(obj2delta)
			Local obj1rect:FlxRect = New FlxRect(object1.x - Max(obj1delta, 0.0), object1.last.y, object1.width + obj1deltaAbs, object1.height)
			Local obj2rect:FlxRect = New FlxRect(object2.x - Max(obj2delta, 0.0), object2.last.y, object2.width + obj2deltaAbs, object2.height)
			
			If (obj1rect.x + obj1rect.width > obj2rect.x And obj1rect.x < obj2rect.x + obj2rect.width And obj1rect.y + obj1rect.height > obj2rect.y And obj1rect.y < obj2rect.y + obj2rect.height) Then
				Local maxOverlap:Float = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS
				
				If (obj1delta > obj2delta) Then
					overlap = object1.x + object1.width - object2.x
					
					If (overlap > maxOverlap Or Not (object1.allowCollisions & RIGHT) Or Not (object2.allowCollisions & LEFT)) Then
						overlap = 0
					Else
						object1.touching |= RIGHT
						object2.touching |= LEFT
					End If
					
				ElseIf (obj1delta < obj2delta) Then
					overlap = object1.x - object2.width - object2.x
					
					If (-overlap > maxOverlap Or Not (object1.allowCollisions & LEFT) Or Not (object2.allowCollisions & RIGHT)) Then
						overlap = 0
					Else
						object1.touching |= LEFT
						object2.touching |= RIGHT
					End If
				End If
			End If
		End If
		
		If (overlap <> 0) Then
			Local obj1v:Float = object1.velocity.x
			Local obj2v:Float = object2.velocity.x
			
			If (Not obj1immovable And Not obj2immovable) Then
				overlap *= .5
				object1.x -= overlap
				object2.x += overlap
				
				Local obj1velocity:Float = Sqrt((obj2v * obj2v * object2.mass) / object1.mass) * _Sgn(obj2v)
				Local obj2velocity:Float = Sqrt((obj1v * obj1v * object1.mass) / object2.mass) * _Sgn(obj1v)
				Local average:Float = (obj1velocity + obj2velocity) * .5
				
				obj1velocity -= average
				obj2velocity -= average
				object1.velocity.x = average + obj1velocity * object1.elasticity
				object2.velocity.x = average + obj2velocity * object2.elasticity
			
			ElseIf (Not obj1immovable) Then
				object1.x -= overlap
				object1.velocity.x = obj2v - obj1v * object1.elasticity
				
			ElseIf (Not obj2immovable) Then
				object2.x += overlap
				object2.velocity.x = obj1v - obj2v * object2.elasticity
			End If
			
			Return True
		Else
			Return False
		End If
	End Function
	
	Function SeparateY:Bool(object1:FlxObject, object2:FlxObject)
		Local obj1immovable:Bool = object1.immovable
		Local obj2immovable:Bool = object2.immovable
		
		If (obj1immovable And obj2immovable) Return False
		
		If (FlxTilemap(object1) <> Null) Then
			Return FlxTilemap(object1).OverlapsWithCallback(object2, _separateYCallback)
		End If
		
		If (FlxTilemap(object2) <> Null) Then
			Return FlxTilemap(object2).OverlapsWithCallback(object1, _separateYCallback, True)
		End If
		
		Local overlap:Float = 0
		Local obj1delta:Float = object1.y - object1.last.y
		Local obj2delta:Float = object2.y - object2.last.y
		
		If (obj1delta <> obj2delta) Then
			Local obj1deltaAbs:Float = Abs(obj1delta)
			Local obj2deltaAbs:Float = Abs(obj2delta)
			Local obj1rect:FlxRect = New FlxRect(object1.x, object1.y - Max(obj1delta, 0.0), object1.width, object1.height + obj1deltaAbs)
			Local obj2rect:FlxRect = New FlxRect(object2.x, object2.y - Max(obj2delta, 0.0), object2.width, object2.height +  + obj2deltaAbs)
			
			If (obj1rect.x + obj1rect.width > obj2rect.x And obj1rect.x < obj2rect.x + obj2rect.width And obj1rect.y + obj1rect.height > obj2rect.y And obj1rect.y < obj2rect.y + obj2rect.height) Then
				Local maxOverlap:Float = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS
				
				If (obj1delta > obj2delta) Then
					overlap = object1.y + object1.height - object2.y
					
					If (overlap > maxOverlap Or Not (object1.allowCollisions & DOWN) Or Not (object2.allowCollisions & UP)) Then
						overlap = 0
					Else
						object1.touching |= DOWN
						object2.touching |= UP
					End If
					
				ElseIf (obj1delta < obj2delta) Then
					overlap = object1.y - object2.height - object2.y
					
					If (-overlap > maxOverlap Or Not (object1.allowCollisions & UP) Or Not (object2.allowCollisions & DOWN)) Then
						overlap = 0
					Else
						object1.touching |= UP
						object2.touching |= DOWN
					End If
				End If
			End If
		End If
		
		If (overlap <> 0) Then
			Local obj1v:Float = object1.velocity.y
			Local obj2v:Float = object2.velocity.y
			
			If (Not obj1immovable And Not obj2immovable) Then
				overlap *= .5
				object1.y -= overlap
				object2.y += overlap
				
				Local obj1velocity:Float = Sqrt((obj2v * obj2v * object2.mass) / object1.mass) * _Sgn(obj2v)
				Local obj2velocity:Float = Sqrt((obj1v * obj1v * object1.mass) / object2.mass) * _Sgn(obj1v)
				Local average:Float = (obj1velocity + obj2velocity) * .5
				
				obj1velocity -= average
				obj2velocity -= average
				object1.velocity.y = average + obj1velocity * object1.elasticity
				object2.velocity.y = average + obj2velocity * object2.elasticity
			
			ElseIf (Not obj1immovable) Then
				object1.y -= overlap
				object1.velocity.y = obj2v - obj1v * object1.elasticity
				
				If (object2.active And object2.moves And obj1delta > obj2delta) Then
					object1.x += object2.x - object2.last.x
				End If
				
			ElseIf (Not obj2immovable) Then				
				object2.y += overlap
				object2.velocity.y = obj1v - obj2v * object2.elasticity
				
				If (object1.active And object1.moves And obj1delta < obj2delta) Then
					object2.x += object1.x - object1.last.x
				End If
			End If
			
			Return True
		Else
			Return False
		End If		
	End Function
	
	Method ToString:String()
		Return "FlxObject"	
	End Method
	
Private
	Method _UpdateMotion:Void()
		Local delta:Float
		Local velocityDelta:Float
		
		velocityDelta = (FlxU.ComputeVelocity(angularVelocity, angularAcceleration, angularDrag, maxAngular) - angularVelocity) / 2
		angularVelocity += velocityDelta
		angle += angularVelocity * FlxG.Elapsed
		angularVelocity += velocityDelta
		
		velocityDelta = (FlxU.ComputeVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x) - velocity.x) / 2
		velocity.x += velocityDelta
		delta = velocity.x * FlxG.Elapsed
		velocity.x += velocityDelta
		x += delta
		
		velocityDelta = (FlxU.ComputeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y) - velocity.y) / 2
		velocity.y += velocityDelta
		delta = velocity.y * FlxG.Elapsed
		velocity.y += velocityDelta
		y += delta
	End Method
	
	Method _AdvancePath:FlxPoint(snap:Bool = True)
		If (snap) Then
			Local oldNode:FlxPoint = path.nodes.Get(_pathNodeIndex)
			If (oldNode <> Null) Then
				If ((_pathMode & PATH_VERTICAL_ONLY) = 0) Then
					x = oldNode.x - width * .5
				End If
							
				If ((_pathMode & PATH_HORIZONTAL_ONLY) = 0) Then
					y = oldNode.y - height * .5				
				End If
			End If
		End If
		
		_pathNodeIndex += _pathInc
		
		If ((_pathMode & PATH_BACKWARD) > 0) Then
			If (_pathNodeIndex < 0) Then
				_pathNodeIndex = 0
				pathSpeed = 0			
			End If
			
		ElseIf ((_pathMode & PATH_LOOP_FORWARD) > 0) Then
			If (_pathNodeIndex >= path.nodes.Length()) Then
				_pathNodeIndex = 0
			End If
			
		ElseIf ((_pathMode & PATH_LOOP_BACKWARD) > 0) Then
			If (_pathNodeIndex < 0) Then
				_pathNodeIndex = path.nodes.Length() - 1
				If (_pathNodeIndex < 0) _pathNodeIndex = 0			 
			End If
			
		ElseIf ((_pathMode & PATH_YOYO) > 0)
			If (_pathInc > 0) Then
				If (_pathNodeIndex >= path.nodes.Length()) Then
					_pathNodeIndex = path.nodes.Length() - 2
					
					If (_pathNodeIndex < 0) _pathNodeIndex = 0
					_pathInc = -_pathInc
				End If
					
			ElseIf (_pathNodeIndex < 0) Then
					_pathNodeIndex = 1					
					If (_pathNodeIndex >= path.nodes.Length()) Then
						_pathNodeIndex = path.nodes.Length() -1
					End If
										
					If (_pathNodeIndex < 0) _pathNodeIndex = 0
					_pathInc = -_pathInc
			End If
			
		Else
			If (_pathNodeIndex >= path.nodes.Length()) Then
				_pathNodeIndex = path.nodes.Length() - 1
				pathSpeed = 0
			End If
		End If
		
		Return path.nodes.Get(_pathNodeIndex)
	End Method
	
	Method _UpdatePathMotion:Void()
		_point.x = x + width * .5
		_point.y = y + height * .5
		
		Local node:FlxPoint = path.nodes.Get(_pathNodeIndex)
		Local deltaX:Float = node.x - _point.x
		Local deltaY:Float = node.y - _point.y
		
		Local horizontalOnly:Bool = (_pathMode & PATH_HORIZONTAL_ONLY) > 0
		Local verticalOnly:Bool = (_pathMode & PATH_VERTICAL_ONLY) > 0
		
		If (horizontalOnly) Then
			If (Abs(deltaX) < pathSpeed * FlxG.Elapsed) node = _AdvancePath()
			
		ElseIf (verticalOnly) Then
			If (Abs(deltaY) < pathSpeed * FlxG.Elapsed) node = _AdvancePath()
			
		Else
			If (Sqrt(deltaX * deltaX + deltaY * deltaY) < pathSpeed * FlxG.Elapsed) Then
				node = _AdvancePath()		
			End If
		End If
		
		If (pathSpeed <> 0) Then
			_point.x = x + width * .5
			_point.y = y + height * .5
			If (horizontalOnly Or _point.y = node.y) Then
				If (_point.x < node.x) Then
					velocity.x = pathSpeed
				Else
					velocity.x = -pathSpeed
				End if
				
				If (velocity.x < 0) Then
					pathAngle = -90
				Else
					pathAngle = 90
				End If
				
				If (Not horizontalOnly) velocity.y = 0
												
			ElseIf (verticalOnly Or _point.x = node.x) Then
				If (_point.y < node.y) Then
					velocity.y = pathSpeed
				Else
					velocity.y = -pathSpeed	 
				End If
				
				If (velocity.y < 0) Then
					pathAngle = 0
				Else
					pathAngle = 180
				End If
				
				If (Not verticalOnly) velocity.x = 0
				
			Else
				pathAngle = FlxU.GetAngle(_point, node)
				FlxU.RotatePoint(0, pathSpeed, 0, 0, pathAngle, velocity)
			End If
			
			If (_pathRotate) Then
				angularVelocity = 0
				angularAcceleration = 0
				angle = pathAngle
			End If
		End If
	End Method
	
	Function _Sgn:Float(value:Float)
		If (value > 0) Return 1
		Return -1
	End function

End Class

Private
Class FlxObjectClass Implements FlxClass

	Method CreateInstance:Object()
		Return New FlxObject()
	End Method
	
	Method InstanceOf:Bool(object:Object)			
		Return (FlxObject(object) <> Null)
	End Method	
	
End Class

Class FlxObjectYComparator Implements FlxBasicComparator

	Method Compare:Int(lhs:FlxBasic, rhs:FlxBasic)
		Return FlxObject(lhs).y - FlxObject(rhs).y		
	End Method
	
End Class

Class FlxObjectXComparator Implements FlxBasicComparator

	Method Compare:Int(lhs:FlxBasic, rhs:FlxBasic)
		Return FlxObject(lhs).x - FlxObject(rhs).x		
	End Method
	
End Class

Class FlxObjectSeparateX Implements FlxTileOverlapChecker
	
	Method IsTileOverlap:Bool(object1:FlxObject, object2:FlxObject)
		Return FlxObject.SeparateX(object1, object2)
	End Method

End Class

Class FlxObjectSeparateY Implements FlxTileOverlapChecker

	Method IsTileOverlap:Bool(object1:FlxObject, object2:FlxObject)
		Return FlxObject.SeparateY(object1, object2)
	End Method

End Class

#Rem 
footer:Flixel is an open source game-making library that is completely free for personal or commercial use.
[quote]Copyright: Flixel - 2009-2011 Adam 'Atomic' Saltsman
Copyright: Monkey port - 2011 Arthur 'devolonter' Bikmullin

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

NOTE FROM THE AUTHOR: As far as I know, you only have to include
this license if you are redistributing source code that includes
the Flixel library.  There is no need (or way, afaik) to include
it in your compiled flash games and apps![/quote]
#End
