Strict

Import flixel.flxbasic
Import flixel.flxgroup
Import flixel.flxobject
Import flixel.flxrect

Import flxlist

Class FlxQuadTree Extends FlxRect
	
	Const A_LIST:Int = 0
	
	Const B_LIST:Int = 1
	
	Global Divisions:Int
	
	Field exists:Bool
	
Private
	Field _canSubdivide:Bool
	
	Field _headA:FlxList
	
	Field _tailA:FlxList
	
	Field _headB:FlxList
	
	Field _tailB:FlxList
	
	Global _Min:Int
	
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
	
	Global _Object:FlxObject
	
	Global _ObjectLeftEdge:Float
	
	Global _ObjectTopEdge:Float
	
	Global _ObjectRightEdge:Float
	
	Global _ObjectBottomEdge:Float
	
	Global _List:Int
	
	Global _UseBothLists:Bool
	
	Global _ProcessingCallback:FlxOverlapProcessListener
	
	Global _NotifyCallback:FlxOverlapNotifyListener
	
	Global _Iterator:FlxList
	
	Global _ObjectHullX:Float
	
	Global _ObjectHullY:Float
	
	Global _ObjectHullWidth:Float
	
	Global _ObjectHullHeight:Float
	
	Global _CheckObjectHullX:Float
	
	Global _CheckObjectHullY:Float
	
	Global _CheckObjectHullWidth:Float
	
	Global _CheckObjectHullHeight:Float
	
	Global _listsCache:FlxListsCache = New FlxListsCache()
	
	Global _treesCache:FlxQuadTreesCache = New FlxQuadTreesCache()

Public
	Method New(x:Float, y:Float, width:Float, height:Float, parent:FlxQuadTree = Null)		
		_Reset(x, y, width, height, parent)
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
		
		_Object = Null
		_ProcessingCallback = Null
		_NotifyCallback = Null
		
		exists = False
	End Method
	
	Method Load:Void(objectOrGroup1:FlxBasic, objectOrGroup2:FlxBasic = Null, notifyCallback:FlxOverlapNotifyListener, processCallback:FlxOverlapProcessListener = Null)
		Add(objectOrGroup1, A_LIST)
		
		If (objectOrGroup2 <> Null) Then
			Add(objectOrGroup2, B_LIST)
			_UseBothLists = True
		Else
			_UseBothLists = False
		End If
		
		_NotifyCallback = notifyCallback
		_ProcessingCallback = processCallback
	End Method
	
	Method Add:Void(objectOrGroup:FlxBasic, list:Int)
		_List = list
		
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
						_Object = FlxObject(basic)
						
						If (_Object.exists And _Object.allowCollisions) Then
							_ObjectLeftEdge = _Object.x
							_ObjectTopEdge = _Object.y
							_ObjectRightEdge = _Object.x + _Object.width
							_ObjectBottomEdge = _Object.y + _Object.height
							_AddObject()
						End If
					End If
				End If
				i += 1
			Wend
		Else
			_Object = FlxObject(objectOrGroup)
			
			If (_Object.exists And _Object.allowCollisions) Then
				_ObjectLeftEdge = _Object.x
				_ObjectTopEdge = _Object.y
				_ObjectRightEdge = _Object.x + _Object.width
				_ObjectBottomEdge = _Object.y + _Object.height
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
				_Object = iterator.object
				
				If (_UseBothLists) Then
					_Iterator = _headB
				Else
					_Iterator = iterator.nextLink
				End If
				
				If (_Object.exists And _Object.allowCollisions > 0 And _Iterator <> Null And _Iterator.object <> Null And _Iterator.object.exists And _OverlapNode()) Then
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
	
	Function Recycle:FlxQuadTree(x:Float, y:Float, width:Float, height:Float, parent:FlxQuadTree = Null)
		Return _treesCache.Recycle(x, y, width, height, parent)
	End Function

Private
	Method _Reset:Void(x:Float, y:Float, width:Float, height:Float, parent:FlxQuadTree = Null)
		exists = True
		
		Make(x, y, width, height)		
				
		_tailA = _listsCache.Recycle()
		_headA = _tailA
		
		_tailB = _listsCache.Recycle()
		_headB = _tailB
		
		If (parent <> Null) Then
			Local iterator:FlxList
			Local ot:FlxList
			
			If (parent._headA.object <> Null) Then
				iterator = parent._headA
				
				While (iterator <> Null)
					If (_tailA.object <> Null) Then
						ot = _tailA
						_tailA = _listsCache.Recycle()
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
						_tailB = _listsCache.Recycle()
						ot.nextLink = _tailB
					End If
					
					_tailB.object = iterator.object
					iterator = iterator.nextLink
				Wend
			End If
		Else
			_Min = (width + height) / (2 * Divisions)
		End If
		
		_canSubdivide = (width > _Min Or height > _Min)
		
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

	Method _AddObject:Void()
		If (Not _canSubdivide Or (_leftEdge >= _ObjectLeftEdge And _rightEdge <= _ObjectRightEdge And _topEdge >= _ObjectTopEdge And _bottomEdge <= _ObjectBottomEdge)) Then
			_AddToList()
			Return	
		End If
		
		If (_ObjectLeftEdge > _leftEdge And _ObjectRightEdge < _midpointX) Then
			If (_ObjectTopEdge > _topEdge And _ObjectBottomEdge < _midpointY) Then
				If (_northWestTree = Null) Then
					_northWestTree = _treesCache.Recycle(_leftEdge, _topEdge, _halfWidth, _halfHeight, Self)
				End If
				
				_northWestTree._AddObject()
				Return
			End If
			
			If (_ObjectTopEdge > _midpointY And _ObjectBottomEdge < _bottomEdge) Then
				If (_southWestTree = Null) Then
					_southWestTree = _treesCache.Recycle(_leftEdge, _midpointY, _halfWidth, _halfHeight, Self)
				End If
				
				_southWestTree._AddObject()
				Return
			End If
		End If
		
		If (_ObjectLeftEdge > _midpointX And _ObjectRightEdge < _rightEdge) Then
			If (_ObjectTopEdge > _topEdge And _ObjectBottomEdge < _midpointY) Then
				If (_northEastTree = Null) Then
					_northEastTree = _treesCache.Recycle(_midpointX, _topEdge, _halfWidth, _halfHeight, Self)
				End If
				
				_northEastTree._AddObject()
				Return
			End If
			
			If (_ObjectTopEdge > _midpointY And _ObjectBottomEdge < _bottomEdge) Then
				If (_southEastTree = Null) Then
					_southEastTree = _treesCache.Recycle(_midpointX, _midpointY, _halfWidth, _halfHeight, Self)
				End If
				
				_southEastTree._AddObject()
				Return
			End If
		End If
		
		If (_ObjectRightEdge > _leftEdge And _ObjectLeftEdge < _midpointX And _ObjectBottomEdge > _topEdge And _ObjectTopEdge < _midpointY) Then
			If (_northWestTree = Null) Then
				_northWestTree = _treesCache.Recycle(_leftEdge, _topEdge, _halfWidth, _halfHeight, Self)
			End If
				
			_northWestTree._AddObject()
		End If
		
		If (_ObjectRightEdge > _midpointX And _ObjectLeftEdge < _rightEdge And _ObjectBottomEdge > _topEdge And _ObjectTopEdge < _midpointY) Then
			If (_northEastTree = Null) Then
				_northEastTree = _treesCache.Recycle(_midpointX, _topEdge, _halfWidth, _halfHeight, Self)
			End If
				
			_northEastTree._AddObject()
		End If
		
		If (_ObjectRightEdge > _midpointX And _ObjectLeftEdge < _rightEdge And _ObjectBottomEdge > _midpointY And _ObjectTopEdge < _bottomEdge) Then
			If (_southEastTree = Null) Then
				_southEastTree = _treesCache.Recycle(_midpointX, _midpointY, _halfWidth, _halfHeight, Self)
			End If
				
			_southEastTree._AddObject()
		End If
		
		If (_ObjectRightEdge > _leftEdge And _ObjectLeftEdge < _midpointX And _ObjectBottomEdge > _midpointY And _ObjectTopEdge < _bottomEdge) Then
			If (_southWestTree = Null) Then
				_southWestTree = _treesCache.Recycle(_leftEdge, _midpointY, _halfWidth, _halfHeight, Self)
			End If
				
			_southWestTree._AddObject()
		End If
	End Method
	
	Method _AddToList:Void()
		Local ot:FlxList
		
		If (_List = A_LIST) Then
			If (_tailA.object <> Null) Then
				ot = _tailA
				_tailA = _listsCache.Recycle()
				ot.nextLink = _tailA
			End If
			
			_tailA.object = _Object
		Else
			If (_tailB.object <> Null) Then
				ot = _tailB
				_tailB = _listsCache.Recycle()
				ot.nextLink = _tailB
			End If
			
			_tailB.object = _Object
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
		
		While (_Iterator <> Null)
			If (Not _Object.exists Or _Object.allowCollisions <= 0) Exit
			
			checkObject = _Iterator.object
			
			If (_Object = checkObject Or Not checkObject.exists Or checkObject.allowCollisions <= 0) Then
				_Iterator = _Iterator.nextLink
				Continue
			End If
			
			If (_Object.x < _Object.last.x) Then
				_ObjectHullX = _Object.x
			Else
				_ObjectHullX = _Object.last.x
			End If
			
			If (_Object.y < _Object.last.y) Then
				_ObjectHullY = _Object.y
			Else
				_ObjectHullY = _Object.last.y
			End If
			
			_ObjectHullWidth = _Object.x - _Object.last.x
			
			If (_ObjectHullWidth > 0) Then
				_ObjectHullWidth = _Object.width + _ObjectHullWidth
			Else
				_ObjectHullWidth = _Object.width - _ObjectHullWidth
			End If
			
			_ObjectHullHeight = _Object.y - _Object.last.y
			
			If (_ObjectHullHeight > 0) Then
				_ObjectHullHeight = _Object.height + _ObjectHullHeight
			Else
				_ObjectHullHeight = _Object.height - _ObjectHullHeight
			End If
			
			If (checkObject.x < checkObject.last.x) Then
				_CheckObjectHullX = checkObject.x
			Else
				_CheckObjectHullX = checkObject.last.x
			End If
			
			If (checkObject.y < checkObject.last.y) Then
				_CheckObjectHullY = checkObject.y
			Else
				_CheckObjectHullY = checkObject.last.y
			End If
			
			_CheckObjectHullWidth = checkObject.x - checkObject.last.x
			
			If (_CheckObjectHullWidth > 0) Then
				_CheckObjectHullWidth = checkObject.width + _CheckObjectHullWidth
			Else
				_CheckObjectHullWidth = checkObject.width - _CheckObjectHullWidth
			End If
			
			_CheckObjectHullHeight = checkObject.y - checkObject.last.y
			
			If (_CheckObjectHullHeight > 0) Then
				_CheckObjectHullHeight = checkObject.height + _CheckObjectHullHeight
			Else
				_CheckObjectHullHeight = checkObject.height - _CheckObjectHullHeight
			End If
			
			If (_ObjectHullX + _ObjectHullWidth > _CheckObjectHullX And _ObjectHullX < _CheckObjectHullX + _CheckObjectHullWidth And _ObjectHullY + _ObjectHullHeight > _CheckObjectHullY And _ObjectHullY < _CheckObjectHullY + _CheckObjectHullHeight) Then
				If (_ProcessingCallback = Null Or _ProcessingCallback.OnOverlapProcess(_Object, checkObject)) Then
					overlapProcessed = True
				End If
				
				If (overlapProcessed And _NotifyCallback <> Null) Then
					_NotifyCallback.OnOverlapNotify(_Object, checkObject)
				End If
			End If
			
			_Iterator = _Iterator.nextLink
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

Private

Class FlxListsCache

Private	
	Field _lists:FlxList[]
	
	Field _length:Int
	
Public
	Method New()
		_length = 0
	End Method

	Method Add:FlxList(list:FlxList)		
		If (_length = _lists.Length()) Then			
			_lists = _lists.Resize(_length * 2 + 10)
		End If

		_lists[_length] = list
		_length += 1	
			
		Return list
	End Method
	
	Method Recycle:FlxList()
		Local list:FlxList
		Local i:Int = 0	
			
		While(i < _length)
			list = _lists[i]
			If (list <> Null And Not list.exists) Then
				list.exists = True
				Return list
			End If
			i+=1
		Wend
		
		Return Add(New FlxList())
	End Method

End Class

Class FlxQuadTreesCache

Private	
	Field _trees:FlxQuadTree[]
	
	Field _length:Int
	
Public
	Method New()
		_length = 0
	End Method

	Method Add:FlxQuadTree(tree:FlxQuadTree)		
		If (_length = _trees.Length()) Then			
			_trees = _trees.Resize(_length * 2 + 10)
		End If

		_trees[_length] = tree
		_length += 1	
			
		Return tree
	End Method
	
	Method Recycle:FlxQuadTree(x:Float, y:Float, width:Float, height:Float, parent:FlxQuadTree = Null)
		Local tree:FlxQuadTree
		Local i:Int = 0
			
		While(i < _length)
			tree = _trees[i]
			If (tree <> Null And Not tree.exists) Then
				tree._Reset(x, y, width, height, parent)
				Return tree
			End If
			i+=1
		Wend
		
		Return Add(New FlxQuadTree(x, y, width, height, parent))
	End Method

End Class