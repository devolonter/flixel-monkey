Strict

#rem
	header:This module contains the FlxObject class.
#end
Import flxbasic
Import flxpoint
Import flxpath
Import flxg
Import flxu

#Rem
summary:This is the base class for most of the display objects (FlxSprite, FlxText, etc).
It includes some basic attributes about game objects, including retro-style flickering, 
basic state information, sizes, scrolling, and basic physics and motion.
#End
Class FlxObject Extends FlxBasic

	Global CLASS_OBJECT:FlxClass = new FlxObjectClass()
	
	Global X_COMPARATOR:FlxBasicComparator = new FlxObjectXComparator()
	
	Global Y_COMPARATOR:FlxBasicComparator = new FlxObjectYComparator()
	
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
	
Private
	Global _pZero:FlxPoint = New FlxPoint()
	
	Field _flicker:Bool
	
	Field _flickerTimer:Float
	
	Field _point:FlxPoint
	
	Field _rect:FlxRect	
	
	Field _pathNodeIndex:Int
	
	Field _pathMode:Int
	
	Field _pathInc:Int
	
	Field _pathRotate:Bool
	
Public	
	Method New(x:Float, y:Float, width:Float = 0, height:Float = 0)
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
		cameras = Null
		If (path <> Null) path.Destroy()
		path = Null	
	End Method
	
	Method PreUpdate:Void()
		_ACTIVECOUNT += 1
		
		If (_flickerTimer <> 0) Then
			If (_flickerTimer > 0) Then
				_flickerTimer -= FlxG.elapsed
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
	
	Method GetMidpoint:FlxPoint(point:FlxPoint)
		If (point = Null) point = New FlxPoint()		
		point.x = x + width * .5
		point.y = y + height * .5		
		Return point
	End Method
	
	Method ToString:String()
		Return "FlxObject"	
	End Method
	
Private	
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
					
				ElseIf (_pathNodeIndex < 0) Then
					_pathNodeIndex = 1					
					If (_pathNodeIndex >= path.nodes.Length()) Then
						_pathNodeIndex = path.nodes.Length() -1
					End If
										
					If (_pathNodeIndex < 0) _pathNodeIndex = 0
					_pathInc = -_pathInc
				End If
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
			If (Abs(deltaX) < pathSpeed * FlxG.elapsed) node = _AdvancePath()
			
		ElseIf (verticalOnly) Then
			If (Abs(deltaY) < pathSpeed * FlxG.elapsed) node = _AdvancePath()
			
		Else
			If (Sqrt(deltaX * deltaX + deltaY * deltaY) < pathSpeed * FlxG.elapsed) Then
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

End Class

Private	
Class FlxObjectClass Implements FlxClass

	Method CreateInstance:FlxBasic()
		Return New FlxObject()
	End Method
	
	Method InstanceOf:Bool(object:FlxBasic)			
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
