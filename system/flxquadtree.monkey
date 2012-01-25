Strict

Import flixel.flxbasic
Import flixel.flxgroup
Import flixel.flxobject
Import flixel.flxrect

Import flxlist

Class FlxQuadTree Extends FlxRect
	
	Const A_LIST:Int = 0
	
	Const B_LIST:Int = 1
	
	Global divisions:Int
	
Private
	Field _canSubdivide:Bool
	
	Field _headA:FlxList
	
	Field _tailA:FlxList
	
	Field _headB:FlxList
	
	Field _tailB:FlxList
	
	Global _min:Int
	
	Field _northWestTree:FlxQuadTree
	
	Field _northEastTree:FlxQuadTree
	
	Field _southEastTree:FlxQuadTree
	
	Field _southWestTree:FlxQuadTree
	
	Field _leftEdge:Float
	
	Field _rightEdge:Float
	
	Field _topEdge:Float
	
	Field _bottomEdge:Float
	
	Field _halfWidth:Float
	
	Field _halfHeight:Float
	
	Field _midpointX:Float
	
	Field _midpointY:Float
	
	Global _object:FlxObject
	
	Global _objectLeftEdge:Float
	
	Global _objectTopEdge:Float
	
	Global _objectRightEdge:Float
	
	Global _objectBottomEdge:Float
	
	Global _list:Int
	
	Global _useBothLists:Bool
	
	Global _processingCallback:FlxOverlapProcessListener
	
	Global _notifyCallback:FlxOverlapNotifyListener
	
	Global _iterator:FlxList
	
	Global _objectHullX:Float
	
	Global _objectHullY:Float
	
	Global _objectHullWidth:Float
	
	Global _objectHullHeight:Float
	
	Global _checkObjectHullX:Float
	
	Global _checkObjectHullY:Float
	
	Global _checkObjectHullWidth:Float
	
	Global _checkObjectHullHeight:Float

Public
	Method New(x:Float, y:Float, width:Float, height:Float, parent:FlxQuadTree = Null)
		Super.New(x, y, width, height)
		_tailA = New FlxList()
		_headA = _tailA
		
		_tailB = New FlxList()
		_headB = _tailB
		
		If (parent <> Null) Then
			Local iterator:FlxList
			Local ot:FlxList
			
			If (parent._headA.object <> Null) Then
				iterator = parent._headA
				
				While (iterator <> Null)
					If (_tailA.object <> Null) Then
						ot = _tailA
						_tailA = New FlxList()
						ot.nextLink = _tailA
					End If
					
					_tailA.object = iterator.object
					iterator = iterator.nextLink
				Wend
			End If
			
			If (parent._headB.object <> Null) Then
				iterator = parent._headB
				
				While (iterator <> Null)
					If (_tailB.object <> Null) Then
						ot = _tailB
						_tailB = New FlxList()
						ot.nextLink = _tailB
					End If
					
					_tailB.object = iterator.object
					iterator = iterator.nextLink
				Wend
			End If
		Else
			_min = (width + height) / (2 * divisions)
		End If
		
		_canSubdivide = (width > _min Or height > _min)
		
		_northWestTree = Null
		_northEastTree = Null
		_southEastTree = Null
		_southWestTree = Null
		_leftEdge = x
		_rightEdge = x + width
		_halfWidth = width / 2
		_midpointX = _leftEdge + _halfWidth
		_topEdge = y
		_bottomEdge = y + height
		_halfHeight = height / 2
		_midpointY = _topEdge + _halfHeight
	End Method

	Method Destroy:Void()
		_headA.Destroy()
		_headA = Null
		_tailA.Destroy()
		_tailA = Null
		_headB.Destroy()
		_headB = Null
		_tailB.Destroy()
		_tailB = Null
		
		If (_northWestTree <> Null) _northWestTree.Destroy()
		_northWestTree = Null
		
		If (_northEastTree <> Null) _northEastTree.Destroy()
		_northEastTree = Null
		
		If (_southEastTree <> Null) _southEastTree.Destroy()
		_southEastTree = Null
		
		If (_southWestTree <> Null) _southWestTree.Destroy()
		_southWestTree = Null
		
		_object = Null
		_processingCallback = Null
		_notifyCallback = Null
	End Method
	
	Method Load:Void(objectOrGroup1:FlxBasic, objectOrGroup2:FlxBasic = Null, notifyCallback:FlxOverlapNotifyListener, processCallback:FlxOverlapProcessListener = Null)
		Add(objectOrGroup1, A_LIST)
		
		If (objectOrGroup2 <> Null) Then
			Add(objectOrGroup2, B_LIST)
			_useBothLists = True
		Else
			_useBothLists = False
		End If
		
		_notifyCallback = notifyCallback
		_processingCallback = processCallback
	End Method
	
	Method Add:Void(objectOrGroup:FlxBasic, list:Int)
		_list = list
		
		If (FlxGroup(objectOrGroup) <> Null) Then
			Local i:Int = 0
			Local basic:FlxBasic
			Local members:FlxBasic[] = FlxGroup(objectOrGroup).Members
			Local l:Int = FlxGroup(objectOrGroup).Length
			
			While (i < l)
				basic = members[i]
				
				If (basic <> Null And basic.exists) Then
					If (FlxGroup(basic) <> Null) Then
						Add(basic, list)
						
					ElseIf (FlxObject(basic) <> Null)
						_object = FlxObject(basic)
						
						If (_object.exists And _object.allowCollisions) Then
							_objectLeftEdge = _object.x
							_objectTopEdge = _object.y
							_objectRightEdge = _object.x + _object.width
							_objectBottomEdge = _object.y + _object.height
							_AddObject()
						End If
					End If
				End If
				i += 1
			Wend
		Else
			_object = FlxObject(objectOrGroup)
			
			If (_object.exists And _object.allowCollisions) Then
				_objectLeftEdge = _object.x
				_objectTopEdge = _object.y
				_objectRightEdge = _object.x + _object.width
				_objectBottomEdge = _object.y + _object.height
				_AddObject()
			End If
		End If
	End Method
	
	Method Execute:Bool()
		Local overlapProcessed:Bool = False
		Local iterator:FlxList
		
		If (_headA.object <> Null) Then
			iterator = _headA
			
			While (iterator <> Null)
				_object = iterator.object
				
				If (_useBothLists) Then
					_iterator = _headB
				Else
					_iterator = iterator.nextLink
				End If
				
				If (_object.exists And _object.allowCollisions > 0 And _iterator <> Null And _iterator.object <> Null And _iterator.object.exists And _OverlapNode()) Then
					overlapProcessed = True					
				End If
				
				iterator = iterator.nextLink
			Wend
		End If
		
		If (_northWestTree <> Null And _northWestTree.Execute()) Then
			overlapProcessed = True
		End If
		
		If (_northEastTree <> Null And _northEastTree.Execute()) Then
			overlapProcessed = True
		End If
		
		If (_southEastTree <> Null And _southEastTree.Execute()) Then
			overlapProcessed = True
		End If
		
		If (_southWestTree <> Null And _southWestTree.Execute()) Then
			overlapProcessed = True
		End If
		
		Return overlapProcessed
	End Method

Private	
	Method _AddObject:Void()
		If (Not _canSubdivide Or (_leftEdge >= _objectLeftEdge And _rightEdge <= _objectRightEdge And _topEdge >= _objectTopEdge And _bottomEdge <= _objectBottomEdge)) Then
			_AddToList()
			Return	
		End If
		
		If (_objectLeftEdge > _leftEdge And _objectRightEdge < _midpointX) Then
			If (_objectTopEdge > _topEdge And _objectBottomEdge < _midpointY) Then
				If (_northWestTree = Null) Then
					_northWestTree = New FlxQuadTree(_leftEdge, _topEdge, _halfWidth, _halfHeight, Self)
				End If
				
				_northWestTree._AddObject()
				Return
			End If
			
			If (_objectTopEdge > _midpointY And _objectBottomEdge < _bottomEdge) Then
				If (_southWestTree = Null) Then
					_southWestTree = New FlxQuadTree(_leftEdge, _midpointY, _halfWidth, _halfHeight, Self)
				End If
				
				_southWestTree._AddObject()
				Return
			End If
		End If
		
		If (_objectLeftEdge > _midpointX And _objectRightEdge < _rightEdge) Then
			If (_objectTopEdge > _topEdge And _objectBottomEdge < _midpointY) Then
				If (_northEastTree = Null) Then
					_northEastTree = New FlxQuadTree(_midpointX, _topEdge, _halfWidth, _halfHeight, Self)
				End If
				
				_northEastTree._AddObject()
				Return
			End If
			
			If (_objectTopEdge > _midpointY And _objectBottomEdge < _bottomEdge) Then
				If (_southEastTree = Null) Then
					_southEastTree = New FlxQuadTree(_midpointX, _midpointY, _halfWidth, _halfHeight, Self)
				End If
				
				_southEastTree._AddObject()
				Return
			End If
		End If
		
		If (_objectRightEdge > _leftEdge And _objectLeftEdge < _midpointX And _objectBottomEdge > _topEdge And _objectTopEdge < _midpointY) Then
			If (_northWestTree = Null) Then
				_northWestTree = New FlxQuadTree(_leftEdge, _topEdge, _halfWidth, _halfHeight, Self)
			End If
				
			_northWestTree._AddObject()
		End If
		
		If (_objectRightEdge > _midpointX And _objectLeftEdge < _rightEdge And _objectBottomEdge > _topEdge And _objectTopEdge < _midpointY) Then
			If (_northEastTree = Null) Then
				_northEastTree = New FlxQuadTree(_midpointX, _topEdge, _halfWidth, _halfHeight, Self)
			End If
				
			_northEastTree._AddObject()
		End If
		
		If (_objectRightEdge > _midpointX And _objectLeftEdge < _rightEdge And _objectBottomEdge > _midpointY And _objectTopEdge < _bottomEdge) Then
			If (_southEastTree = Null) Then
				_southEastTree = New FlxQuadTree(_midpointX, _midpointY, _halfWidth, _halfHeight, Self)
			End If
				
			_southEastTree._AddObject()
		End If
		
		If (_objectRightEdge > _leftEdge And _objectLeftEdge < _midpointX And _objectBottomEdge > _midpointY And _objectTopEdge < _bottomEdge) Then
			If (_southWestTree = Null) Then
				_southWestTree = New FlxQuadTree(_leftEdge, _midpointY, _halfWidth, _halfHeight, Self)
			End If
				
			_southWestTree._AddObject()
		End If
	End Method
	
	Method _AddToList:Void()
		Local ot:FlxList
		
		If (_list = A_LIST) Then
			If (_tailA.object <> Null) Then
				ot = _tailA
				_tailA = New FlxList()
				ot.nextLink = _tailA
			End If
			
			_tailA.object = _object
		Else
			If (_tailB.object <> Null) Then
				ot = _tailB
				_tailB = New FlxList()
				ot.nextLink = _tailB
			End If
			
			_tailB.object = _object
		End If
		
		If (Not _canSubdivide) Return
		
		If (_northWestTree <> Null) _northWestTree._AddToList()
		If (_northEastTree <> Null) _northEastTree._AddToList()
		If (_southEastTree <> Null) _southEastTree._AddToList()
		If (_southWestTree <> Null) _southWestTree._AddToList()
	End Method
	
	Method _OverlapNode:Bool()
		Local overlapProcessed:Bool = False
		Local checkObject:FlxObject
		
		While (_iterator <> Null)
			If (Not _object.exists Or _object.allowCollisions <= 0) Exit
			
			checkObject = _iterator.object
			
			If (_object = checkObject Or Not checkObject.exists Or checkObject.allowCollisions <= 0) Then
				_iterator = _iterator.nextLink
				Continue
			End If
			
			If (_object.x < _object.last.x) Then
				_objectHullX = _object.x
			Else
				_objectHullX = _object.last.x
			End If
			
			If (_object.y < _object.last.y) Then
				_objectHullY = _object.y
			Else
				_objectHullY = _object.last.y
			End If
			
			_objectHullWidth = _object.x - _object.last.x
			
			If (_objectHullWidth > 0) Then
				_objectHullWidth = _object.width + _objectHullWidth
			Else
				_objectHullWidth = _object.width - _objectHullWidth
			End If
			
			_objectHullHeight = _object.y - _object.last.y
			
			If (_objectHullHeight > 0) Then
				_objectHullHeight = _object.height + _objectHullHeight
			Else
				_objectHullHeight = _object.height - _objectHullHeight
			End If
			
			If (checkObject.x < checkObject.last.x) Then
				_checkObjectHullX = checkObject.x
			Else
				_checkObjectHullX = checkObject.last.x
			End If
			
			If (checkObject.y < checkObject.last.y) Then
				_checkObjectHullY = checkObject.y
			Else
				_checkObjectHullY = checkObject.last.y
			End If
			
			_checkObjectHullWidth = checkObject.x - checkObject.last.x
			
			If (_checkObjectHullWidth > 0) Then
				_checkObjectHullWidth = checkObject.width + _checkObjectHullWidth
			Else
				_checkObjectHullWidth = checkObject.width - _checkObjectHullWidth
			End If
			
			_checkObjectHullHeight = checkObject.y - checkObject.last.y
			
			If (_checkObjectHullHeight > 0) Then
				_checkObjectHullHeight = checkObject.height + _checkObjectHullHeight
			Else
				_checkObjectHullHeight = checkObject.height - _checkObjectHullHeight
			End If
			
			If (_objectHullX + _objectHullWidth > _checkObjectHullX And _objectHullX < _checkObjectHullX + _checkObjectHullWidth And _objectHullY + _objectHullHeight > _checkObjectHullY And _objectHullY < _checkObjectHullY + _checkObjectHullHeight) Then
				If (_processingCallback = Null Or _processingCallback.OnOverlapProcess(_object, checkObject)) Then
					overlapProcessed = True
				End If
				
				If (overlapProcessed And _notifyCallback <> Null) Then
					_notifyCallback.OnOverlapNotify(_object, checkObject)
				End If
			End If
			
			_iterator = _iterator.nextLink
		Wend
		
		Return overlapProcessed
	End Method
	
End Class

Interface FlxOverlapNotifyListener

	Method OnOverlapNotify:Void(object1:FlxObject, object2:FlxObject)

End Interface

Interface FlxOverlapProcessListener

	Method OnOverlapProcess:Bool(object1:FlxObject, object2:FlxObject)

End Interface