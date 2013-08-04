#rem
	header:This module contains the FlxGroup class
#end
Strict

Import reflection

Import flxextern
Import flxbasic
Import flxobject
Import flxu
Import system.flxarray

Private
Import brl.pool

Public

#Rem
summary:This is an organizational class that can update and render a bunch of FlxBasics.
[i][b]NOTE:[/b] Although FlxGroup extends [a flxbasic.monkey.html]FlxBasic[/a], it will not automatically add itself to the global collisions quad tree, it will only add its members.[/i]
#End
Class FlxGroup Extends FlxBasic

	Global ClassObject:Object

	#Rem
	summary:See detail.
	Use with [a #Sort]Sort()[/a] to sort in ascending order.
	#End	
	Const ASCENDING:Bool = False
	
	#Rem
	summary:See detail.
	Use with [a #Sort]Sort()[/a] to sort in descending order.
	#End
	Const DESCENDING:Bool = True
	
Private

	Field _maxSize:Int
	
	Field _marker:Int
	
	Field _length:Int
	
	Field _members:FlxBasic[]
	
	Field _comparators:StringMap<Comparator>
	
	Field _comparator:Comparator
	
	Field _slowIndex:String
	
	Field _sortDescending:Bool
	
	Field _dirty:Bool
	
	Field _defrag:Bool
	
Public
	#Rem
	summary:Constructor
	Params:
	[list]
	[*]maxSize:Int - the maximum capacity of this group.
	[/list]
	#End
	Method New(maxSize:Int = 0)
		Super.New()
		_maxSize = maxSize
		_marker = 0
		_length = 0
		_cameras = Null
		_comparators = New StringMap<Comparator>()
		_dirty = False
		_defrag = False
	End Method
	
	#Rem
	summary:The number of entries in the members array.
	For performance and safety you should check this variable instead of members.length unless you really know what you're doing!
	#End
	Method Length:Int() Property
		Return _length	
	End Method
	
	#Rem
	summary:See detail.
	Array of all the [a flxbasic.monkey.html]FlxBasic[/a]s that exist in this group.
	#End
	Method Members:FlxBasic[]() Property
		Return _members	
	End Method
	
	#Rem
	summary:Override this function to handle any deleting or "shutdown" type operations you might need,such as removing traditional Monkey/Mojo children like Images objects.
	#End		
	Method Destroy:Void()
		Local basic:FlxBasic
		Local i:Int = 0		
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) basic.Destroy()
			i+=1		
		Wend
		
		_length = 0
		_members = _members.Resize(_length)
		_cameras = Null
		
		If (_comparator <> Null) Then
			_comparator.Clear()
			_comparator = Null
		End If
		
		_comparators.Clear()
		_comparators = Null
		
		Super.Destroy()
	End Method
	
	#Rem
	summary:Just making sure we don't increment the active objects count.
	#End
	Method PreUpdate:Void()
	
	End Method
	
	#Rem
	summary:Automatically goes through and calls update on everything you added.
	#End
	Method Update:Void()
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists And basic.active) Then
				basic.PreUpdate()
				basic.Update()
				If (basic.HasTween) basic.UpdateTweens()
				basic.PostUpdate()
			End If
			i+=1		
		Wend
		
		If (HasTween) UpdateTweens()
	End Method
	
	#Rem
	summary:Automatically goes through and calls render on everything you added.
	#End
	Method Draw:Void()
		If (_cameras <> Null And Not _cameras.Contains(FlxG._CurrentCamera)) Return
	
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists And basic.visible) basic.Draw()
			i+=1		
		Wend	
	End Method
	
	#Rem
	summary:The maximum capacity of this group.  Default is 0, meaning no max capacity, and the group can just grow.
	#End
	Method MaxSize:Int() Property
		Return _maxSize	
	End Method
	
	Method MaxSize:Void(size:Int) Property
		_maxSize = size		
		
		If (_marker >= _maxSize) _marker = 0			
		If (_maxSize = 0 Or _maxSize >= _length) Return		
		
		Local basic:FlxBasic
		Local i:Int = _maxSize
		Local l:Int = _length
		
		While(i < l)
			basic = _members[i]
			If (basic <> Null) basic.Destroy()
			i+=1		
		Wend
		
		_members = _members.Resize(_maxSize)		
		_length = _maxSize
	End Method
	
	#Rem
	summary:See details.
	Adds a new [a flxbasic.monkey.html]FlxBasic[/a] subclass ([a flxbasic.monkey.html]FlxBasic[/a], [a flxsprite.monkey.html]FlxSprite[/a], Enemy, etc) to the group. FlxGroup will try to replace a null member of the array first. Failing that, FlxGroup will add it to the end of the member array, assuming there is room for it, and doubling the size of the array if necessary.	
	
	[b]WARNING[/b]: If the group has a maxSize that has already been met, the object will NOT be added to the group!
	
	Params:
	[list]
	[*][a flxbasic.monkey.html]object:FlxBasic[/a] - the object you want to add to the group.	
	[/list]
	Return the same [a flxbasic.monkey.html]FlxBasic[/a] object that was passed in.
	#End
	Method Add:FlxBasic(object:FlxBasic)		
		If (_IndexOf(object) >= 0) Return object
		_dirty = True
		
		Local i:Int = 0

		While (i < _length)
			If (_members[i] = Null) Then
				_members[i] = object
				If (i >= _length) _length = i+1
				Return object		
			End If
			i+=1
		Wend			
		
		If (_maxSize > 0) Then
			If (_length = _members.Length()) Then				
				If (_length >= _maxSize) Then
					Return object
				ElseIf (_length*2 + 10 <= _maxSize)
					_members = _members.Resize(_length*2 + 10)
				Else
					_members = _members.Resize(_maxSize)		 		
				End If
			End if
		Else
			If (_length = _members.Length()) Then			
				_members = _members.Resize(_length*2 + 10)
			End If
		End If

		_members[i] = object
		_length+=1	
			
		Return object
	End Method
	
	#Rem
	summary:Recycling is designed to help you reuse game objects without always re-allocating or "newing" them.
	If you specified a maximum size for this group (like in [a flxemitter.monkey.html]FlxEmitter[/a],then recycle will employ what we're calling "rotating" recycling. Recycle() will first check to see if the group is at capacity yet. If group is not yet at capacity, Recycle() returns a new object. If the group IS at capacity, then Recycle() just returns the next object in line
	
	If you did NOT specify a maximum size for this group, then Recycle() will employ what we're calling "grow-style" recycling. Recycle() will return either the first object with exists = false, or, finding none, add a new object to the array, doubling the size of the array if necessary.
	
	[b]WARNING:[/b] If this function needs to create a new object, and no object class was provided, it will return null instead of a valid object!
	
	Params:
	[list]
	[*]objectClass:FlxClass - the type objectClass implements FlxClass you want to recycle (e.g. FlxSpriteClass, EvilRobotClass, etc). Do NOT "new" the class in the parameter!	
	[/list]
	Return a reference to the object that was created. Don't forget to cast it back to the objectClass you want (e.g. myObject = myObjectClass(myGroup.recycle(myObjectClassClass))).
	#End
	Method Recycle:FlxBasic(objectClass:ClassInfo = Null)
		If (_maxSize > 0) Then
			If (_length < _maxSize) Then
				If (objectClass = Null) Return Null
				_dirty = True
				Return Add(FlxBasic(objectClass.NewInstance()))
			Else				
				Local basic:FlxBasic = _members[_marker]
				_marker+=1
				If (_marker >= _maxSize) _marker = 0
				Return basic		
			End If
		Else						
			Local basic:FlxBasic = GetFirstAvailable(objectClass)
			If (basic <> Null) Return basic
			If (objectClass = Null) Return Null
			_dirty = True
			Return Add(FlxBasic(objectClass.NewInstance()))				
		End If
	End Method
	
	#Rem
	summary:Removes an object from the group.
	Params:
	[list]
	[*][a flxbasic.monkey.html]object:FlxBasic[/a] - The [a flxbasic.monkey.html]FlxBasic[/a] you want to remove.
	[*]splice:Bool - whether the object should be cut from the array entirely or not.
	[/list]	
	Return the removed object.
	#End
	Method Remove:FlxBasic(object:FlxBasic, splice:Bool = False)
		Local index:Int = _IndexOf(object)
		
		If (index < 0) Return Null
	
		If (splice) Then
			Local i:Int = index
			Local l:Int = _length
			
			While(i < _length - 1)
				_members[i] = _members[i+1]
				i+=1		
			Wend			
			
			_length-=1
		Else 
			_members[index] = Null
		End If
		
		_dirty = True
		Return object
	End Method
	
	#Rem
	summary:Replaces an existing [a flxbasic.monkey.html]FlxBasic[/a] with a new one.
	Params:
	[list]
	[*][a flxbasic.monkey.html]oldObject:FlxBasic[/a] - the object you want to replace.
	[*][a flxbasic.monkey.html]newObject:FlxBasic[/a] - the new object you want to use instead.
	[/list]
	Return the new object.
	#End
	Method Replace:FlxBasic(oldObject:FlxBasic, newObject:FlxBasic)
		Local index:Int  = _IndexOf(oldObject)
		If (index < 0) Return Null
		
		_members[index] = newObject
		_dirty = True
		Return newObject
	End Method
	
	#Rem
	summary:Call this function to sort the group according to a particular value and order. 
	For example, to sort game objects for Zelda-style overlaps you might call myGroup.Sort(FlxObject.YComparator, FlxGroup.ASCENDING) at the bottom of your [a flxstate.monkey.html]FlxState.Update()[/a] override. To sort all existing objects after a big explosion or bomb attack, you might call myGroup.Sort(FlxBasic.ExistsComparator, FlxGroup.DESCENDING)
	Params:
	[list]
	[*]comparator:FlxBasicComparator - The FlxBasicComparator you want to sort on. Default value is FlxObject.YComparator.
	[*]order:Bool - A FlxGroup constant that defines the sort order. Possible values are ASCENDING and DESCENDING. Default value is ASCENDING.
	[/list]
	Return the new object.
	#End	
	Method Sort:Void(index:String = "y", order:Bool = ASCENDING)
		If (_dirty) _Validate()
		
		If ( Not _defrag) Then
			Local b:FlxBasic = GetFirstNotNull()
			If (b = Null) Return
			
			_comparator = _GetComparator(GetFirstNotNull().GetClassInfo().GetField(index))
			If (_comparator = Null) Return
		
			_sortDescending = order
			_FastQSort(0, _length - 1)
		Else
			_slowIndex = index
			_sortDescending = order
			_SlowQSort(0, _length - 1)
		End If
	End Method	
	
	Method SetAll:Void(variableName:String, value:Object, recurse:Bool = True)
		If (_dirty) _Validate()
		
		If ( Not _defrag) Then
			_FastSetAll(variableName, value, recurse)
		Else
			_SlowSetAll(variableName, value, recurse)
		End If
	End Method
	
	Method CallAll:Void(functionName:String, recurse:Bool = True)
		If (_dirty) _Validate()
		
		If ( Not _defrag) Then
			_FastCallAll(functionName, recurse)
		Else
			_SlowCallAll(functionName, recurse)
		End If
	End Method
	
	Method GetFirstAvailable:FlxBasic(objectClass:ClassInfo = null)
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And Not basic.exists And 
					(objectClass = Null Or basic.GetClassInfo().ExtendsClass(objectClass))) Return basic
			i+=1
		Wend

		Return Null
	End Method
	
	Method GetFirstNull:Int()
		Local i:Int = 0	
			
		While(i < _length)
			If (_members[i] = Null) Return i
			i+=1
		Wend

		Return -1	
	End Method
	
	Method GetFirstNotNull:FlxBasic()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) Return basic
			i+=1
		Wend

		Return Null	
	End Method
	
	Method GetFirstExtant:FlxBasic()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists) Return basic
			i+=1
		Wend

		Return Null	
	End Method
	
	Method GetFirstAlive:FlxBasic()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists And basic.alive) Return basic
			i+=1
		Wend

		Return Null	
	End Method
	
	Method GetFirstDead:FlxBasic()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And Not basic.alive) Return basic
			i+=1
		Wend

		Return Null	
	End Method
	
	Method CountLiving:Int()
		Local count:Int = -1
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) Then
				If (count < 0) count = 0
				If (basic.exists And basic.alive) count+=1	
			End If
			i+=1
		Wend

		Return count	
	End Method
	
	Method CountDead:Int()
		Local count:Int = -1
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) Then
				If (count < 0) count = 0
				If (Not basic.alive) count+=1	
			End If
			i+=1
		Wend

		Return count	
	End Method
	
	Method GetRandom:FlxBasic(startIndex:Int = 0, length:Int = 0)
		If (length = 0) length = _length
		Return FlxArray<FlxBasic>.GetSafeRandom(_members, startIndex, length)
	End Method
	
	Method Clear:Void()
		_length = 0
	End Method
	
	Method ReviveAll:Void()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And Not basic.exists) Then
				If (FlxGroup(basic) <> Null) Then
					FlxGroup(basic).ReviveAll()
				Else
					basic.Revive()
				End If
			End If
			i+=1
		Wend

		Super.Revive()
	End Method
	
	Method Kill:Void()
		Local i:Int = 0
		Local basic:FlxBasic
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists) basic.Kill()
			i+=1
		Wend

		Super.Kill()	
	End Method
	
	Method ObjectEnumerator:Enumerator()
		Return _Enumerators.Allocate()._Reset(Self)
	End
	
Private
	Method _FastSetAll:Void(variableName:String, value:Object, recurse:Bool = True)
		Local basic:FlxBasic = GetFirstNotNull()
		If (basic = Null) Return
		
		Local f:FieldInfo = basic.GetClassInfo().GetField(variableName)

		If (f = Null) Then
			Local prop:MethodInfo = basic.GetClassInfo().GetMethod(variableName,[GetClass(value)])
			If (prop <> Null) _FastCallAll(prop,[value], recurse)
			Return
		End If
		
		Local i:Int = 0
		
		While(i < _length)
			basic = _members[i]
			
			If (basic <> Null) Then
				If (FlxGroup(basic) <> Null) Then
					If (recurse) FlxGroup(basic).SetAll(variableName, value, recurse)
					Local groupField:FieldInfo = basic.GetClassInfo().GetField(variableName)
					
					If (groupField = Null) Then
						Local groupProp:MethodInfo = basic.GetClassInfo().GetMethod(variableName,[GetClass(value)])
						If (groupProp <> Null) _FastCallAll(groupProp,[value], recurse)
					Else
						groupField.SetValue(basic, value)
					End If
				Else
					f.SetValue(basic, value)
				End If
			End If
			
			i+=1		
		Wend
	End Method
	
	Method _SlowSetAll:Void(variableName:String, value:Object, recurse:Bool = True)
		Local basic:FlxBasic, f:FieldInfo, p:MethodInfo
		Local valClass:ClassInfo[] =[GetClass(value)]
		Local valArray:Object[] =[value]
		
		Local i:Int = 0
		
		While (i < _length)
			basic = _members[i]
			
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) FlxGroup(basic)._SlowSetAll(variableName, value, recurse)
				f = basic.GetClassInfo().GetField(variableName)
				
				If (f = Null) Then
					p = basic.GetClassInfo().GetMethod(variableName, valClass)
					If (p <> Null) p.Invoke(basic, valArray)
				Else
					f.SetValue(basic, value)
				End If
			End If
			
			i += 1
		Wend
	End Method
	
	Method _FastCallAll:Void(methodName:String, recurse:Bool = True)
		Local basic:FlxBasic = GetFirstNotNull()
		If (basic = Null) Return
		
		Local m:MethodInfo = basic.GetClassInfo().GetMethod(methodName,[])
		If (m <> Null) Then
			_FastCallAll(m,[], recurse)
		End If
	End Method
	
	Method _FastCallAll:Void(methodObject:MethodInfo, values:Object[], recurse:Bool = True)
		Local basic:FlxBasic
		Local i:Int = 0

		While(i < _length)
			basic = _members[i]
			
			If (basic <> Null) Then				
				If (FlxGroup(basic) <> Null) Then
					If (recurse) FlxGroup(basic)._FastCallAll(methodObject, values, recurse)
					Local groupMethod:MethodInfo
					
					If (values.Length() > 0) Then
						groupMethod = basic.GetClassInfo().GetMethod(methodObject.Name,[GetClass(values[0])])
					Else
						groupMethod = basic.GetClassInfo().GetMethod(methodObject.Name,[])
					End If
					
					If (groupMethod <> Null) groupMethod.Invoke(basic, values)
				Else
					methodObject.Invoke(basic, values)
				End If
			End If
			
			i += 1
		Wend
	End Method
	
	Method _SlowCallAll:Void(methodName:String, recurse:Bool = True)
		Local basic:FlxBasic, m:MethodInfo
		Local i:Int = 0
		
		While (i < _length)
			basic = _members[i]
			
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) FlxGroup(basic)._SlowCallAll(methodName, recurse)
				m = basic.GetClassInfo().GetMethod(methodName,[])
				
				If (m <> Null) Then
					m.Invoke(basic,[])
				End If
			End If
			
			i += 1
		Wend
	End Method

	Method _Validate:Void()
		_dirty = False
		_defrag = False
		
		Local basic:FlxBasic = GetFirstNotNull()
		If (basic = Null) Then Return
	
		Local i:Int = 0
		Local first:ClassInfo = basic.GetClassInfo()
			
		While (i < _length)
			If (_members[i] <> Null And Not first.ExtendsClass(_members[i].GetClassInfo()) And FlxGroup(_members[i]) = Null) Then
				_defrag = True
				Return
			End If
			
			i+=1		
		Wend
	End Method

	Method _IndexOf:Int(object:FlxBasic)
		Local i:Int = 0		
			
		While(i < _length)
			If (_members[i] = object) Return i
			i+=1		
		Wend
		
		Return -1
	End Method
	
	Method _FastQSort:Void(left:Int, right:Int)
		If (right > left) Then
			Local pivot:Int = left + (right-left)/2
			Local newPivot:Int = _FastDoSort(left, right, pivot)
			
			_FastQSort(left, newPivot - 1)
			_FastQSort(newPivot + 1, right)
		End If
	End Method
	
	Method _FastDoSort:Int(left:Int, right:Int, pivot:Int)
		Local basic:FlxBasic = _members[pivot]
		
		_members[pivot] = _members[right]
		_members[right] = basic
		
		Local store:Int = left
		Local basicToCompare:FlxBasic
		Local i:Int = left
		
		While (i < right)
			basicToCompare = _members[i]

			If (basicToCompare = Null Or basic = Null) Then
				If (basicToCompare <> Null And basic = Null) Then
					_members[i] = _members[store]
					_members[store] = basicToCompare
					store+=1	
				End If
				
				i += 1
				Continue
			End If
				
			If (_sortDescending) Then
				If (_comparator.Compare(basicToCompare, basic) >= 0) Then
					_members[i] = _members[store]
					_members[store] = basicToCompare
					store+=1	
				End If
			Else
				If (_comparator.Compare(basicToCompare, basic) <= 0) Then
					_members[i] = _members[store]
					_members[store] = basicToCompare
					store+=1	
				End If
			End If
			
			i+=1
		Wend
		
		basic = _members[store]
		_members[store] = _members[right]
		_members[right] = basic
		
		Return store	
	End Method
	
	Method _SlowQSort:Void(left:Int, right:Int)
		If (right > left) Then
			Local pivot:Int = left + (right-left)/2
			Local newPivot:Int = _SlowDoSort(left, right, pivot)
			
			_SlowQSort(left, newPivot - 1)
			_SlowQSort(newPivot + 1, right)
		End If
	End Method
	
	Method _SlowDoSort:Int(left:Int, right:Int, pivot:Int)
		Local basic:FlxBasic = _members[pivot]
		
		_members[pivot] = _members[right]
		_members[right] = basic
		
		Local store:Int = left
		Local basicToCompare:FlxBasic
		Local i:Int = left
		
		While (i < right)
			basicToCompare = _members[i]

			If (basicToCompare = Null Or basic = Null) Then
				If (basicToCompare <> Null And basic = Null) Then
					_members[i] = _members[store]
					_members[store] = basicToCompare
					store+=1	
				End If
				
				i += 1
				Continue
			End If
			
			_comparator = _GetComparator(basicToCompare.GetClassInfo().GetField(_slowIndex))
			
			If (_comparator <> Null) Then
				If (_sortDescending) Then
					If (_comparator.Compare(basicToCompare, basic) >= 0) Then
						_members[i] = _members[store]
						_members[store] = basicToCompare
						store+=1	
					End If
				Else
					If (_comparator.Compare(basicToCompare, basic) <= 0) Then
						_members[i] = _members[store]
						_members[store] = basicToCompare
						store+=1	
					End If
				End If
			End If
			
			i+=1
		Wend
		
		basic = _members[store]
		_members[store] = _members[right]
		_members[right] = basic
		
		Return store	
	End Method
	Method _GetComparator:Comparator(sortIndex:FieldInfo)
		If (sortIndex = Null) Return Null
	
		Local key:String = sortIndex.Type.Name
		Local comparator:Comparator = _comparators.Get(key)
		
		If (comparator = Null) Then
			Select key
				Case FloatClass().Name
					comparator = New FloatComparator()
			
				Case IntClass().Name
					comparator = New IntComparator()
					
				Case BoolClass().Name
					comparator = New BoolComparator()
					
				Case StringClass().Name
					comparator = New StringComparator()
					
				Default
					key = FlxU.GetObjectClass().Name
					comparator = _comparators.Get(key)
					
					If (comparator = Null) comparator = New ObjectComparator()
			End Select
			
			_comparators.Set(key, comparator)
		End If
		
		comparator.Clear()
		
		If (key <> FlxU.GetObjectClass().Name) Then
			comparator.Reset(sortIndex)
		Else
			Local sortMethod:MethodInfo = sortIndex.Type.GetMethod("Compare",[sortIndex.Type])
			If (sortMethod = Null) sortMethod = sortIndex.Type.GetMethod("Compare",[FlxU.GetObjectClass()])
			
			If (sortMethod <> Null) Then
				comparator.Reset(sortIndex, sortMethod)
			Else
				comparator = Null
			End If
		End If
		
		Return comparator
	End Method
	
End Class

Class Enumerator

	Method HasNext:Bool()
		If (_dirty) Then
			_dirty = False
			_hasNext = False
			
			Repeat
				If (_nextIndex = _group._length) Then
					_Enumerators.Free(Self)
					Return _hasNext
				End If
			
				_basic = _group._members[_nextIndex]
				
				_nextIndex += 1
			Until (_basic <> Null)
			
			_hasNext = True
		End If
		
		If ( Not _hasNext) _Enumerators.Free(Self)
		Return _hasNext
	End

	Method NextObject:FlxBasic()
		If (_dirty And Not HasNext()) Return Null
		
		_dirty = True
		Return _basic
	End
	
	Method Destroy:Void()
		_Reset(Null)
		_basic = Null
	End Method

Private

	Field _group:FlxGroup
	
	Field _index:Int
	
	Field _nextIndex:Int
	
	Field _hasNext:Bool
	
	Field _dirty:Bool
	
	Field _basic:FlxBasic
	
	Method _Reset:Enumerator(group:FlxGroup)
		_group = group
		_nextIndex = 0
		_hasNext = False
		_dirty = True
		
		Return Self
	End Method

End

Private

Global _Enumerators:Pool<Enumerator> = New Pool<Enumerator>()

Class Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic) Abstract
	
	Method Reset:Comparator(sortIndex:FieldInfo, sortMethod:MethodInfo = Null)
		_sortIndex = sortIndex
		_sortMethod = sortMethod
		
		Return Self
	End Method
	
	Method Clear:Void()
		_sortIndex = Null
		_sortMethod = Null
	End Method
	
Private

	Field _sortIndex:FieldInfo
	
	Field _sortMethod:MethodInfo

End Class

Class BoolComparator Extends Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic)
		Return Int(UnboxBool(_sortIndex.GetValue(basic1))) - Int(UnboxBool(_sortIndex.GetValue(basic2)))
	End Method

End Class

Class IntComparator Extends Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic)
		Return UnboxInt(_sortIndex.GetValue(basic1)) - UnboxInt(_sortIndex.GetValue(basic2))
	End Method

End Class

Class FloatComparator Extends Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic)
		Return UnboxFloat(_sortIndex.GetValue(basic1)) - UnboxFloat(_sortIndex.GetValue(basic2))
	End Method

End Class

Class StringComparator Extends Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic)
		Return UnboxString(_sortIndex.GetValue(basic1)).Compare(UnboxString(_sortIndex.GetValue(basic2)))
	End Method

End Class

Class ObjectComparator Extends Comparator
	
	Method Compare:Int(basic1:FlxBasic, basic2:FlxBasic)
		Return UnboxInt(_sortMethod.Invoke(_sortIndex.GetValue(basic1),[_sortIndex.GetValue(basic2)]))
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