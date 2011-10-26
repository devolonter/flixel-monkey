#rem
	header:This module contains the FlxGroup class and next inerfaces: FlxGroupCaller, FlxGroupSetter, FlxGroupComparator.
#end
Strict


Import flxbasic

#Rem
summary:This is an organizational class that can update and render a bunch of FlxBasics.
[i][b]NOTE:[/b] Although [a flxgroup.monkey.html]FlxGroup[/a] extends [a flxbasics.monkey.html]FlxBasic[/a], it will not automatically add itself to the global collisions quad tree, it will only add its _members.[/i]
#End
Class FlxGroup Extends FlxBasic

	'summary:Use with [a #Sort]Sort()[/a] to sort in ascending order.	
	Const ASCENDING:Bool = True
	
	Const DESCENDING:Bool = False		
	
Private	
	Field _maxSize:Int
	
	Field _marker:Int
	
	Field _length:Int
	
	Field _members:FlxBasic[]	
	
Public
	Method New(maxSize:Int = 0)
		Super.New()
		_maxSize = maxSize
		_marker = 0
		_length = 0
	End Method
	
	Method Length:Int() Property
		Return _length	
	End Method
	
	Method Members:FlxBasic[]() Property
		Return _members	
	End Method
			
	Method Destroy:Void()
		Local basic:FlxBasic
		Local i:Int = 0		
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) basic.Destroy()
			i+=1		
		Wend
		
		_length = 0
	End Method
	
	Method Update:Void()
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists And basic.active) Then
				basic.PreUpdate()
				basic.Update()
				basic.PostUpdate()
			End If
			i+=1		
		Wend
	End Method
	
	Method Draw:Void()
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And basic.exists And basic.visible) basic.Draw()
			i+=1		
		Wend	
	End Method
	
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
	
	Method Add:FlxBasic(object:FlxBasic)		
		If (_IndexOf(object) >= 0) Return object		
		
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
	
	Method Recycle:FlxBasic(creator:FlxClassCreator = null)
		If (_maxSize > 0) Then
			If (_length < _maxSize) Then
				If (creator = Null) Return Null				
				Return Add(creator.CreateInstance())
			Else				
				Local basic:FlxBasic = _members[_marker]
				_marker+=1
				If (_marker >= _maxSize) _marker = 0
				Return basic		
			End If
		Else						
			Local basic:FlxBasic = GetFirstAvailable(creator)
			If (basic <> Null) Return basic
			If (creator = Null) Return Null
			Return Add(creator.CreateInstance())				
		End If
	End Method
	
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
		
		Return object
	End Method
	
	Method Replace:FlxBasic(oldObject:FlxBasic, newObject:FlxBasic)
		Local index:Int  = _IndexOf(oldObject)
		If (index < 0) Return Null
		
		_members[index] = newObject
		Return newObject
	End Method
	
	Method Sort:Void(comparator:FlxGroupComparator, order:Bool = ASCENDING)
		'TODO complete this method
	End Method
	
	Method SetAll:Void(setter:FlxGroupSetter, value:Object, recurse:Bool = True)
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) Then
					FlxGroup(basic).SetAll(setter, value, recurse)	
				Else
					setter.Set(basic, value)
				End If
			End If
			i+=1		
		Wend
	End Method
	
	Method CallAll:Void(caller:FlxGroupCaller, recurse:Bool = True)
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) Then
					FlxGroup(basic).CallAll(caller, recurse)	
				Else
					caller.Call(basic)
				End If
			End If
			i+=1		
		Wend
	End Method
	
	Method GetFirstAvailable:FlxBasic(creator:FlxClassCreator = null)
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < _length)
			basic = _members[i]
			If (basic <> Null And Not basic.exists And 
					(creator = Null Or creator.InstanceOf(basic))) Return basic
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
	
	Method ObjectEnumerator:Enumerator()
		Return New Enumerator(Self)
	End
	
	Method ToString:String()
		Return "FlxGroup"
	End Method
	
Private

	Method _IndexOf:Int(object:FlxBasic)
		Local i:Int = 0		
			
		While(i < _length)
			If (_members[i] = object) Return i
			i+=1		
		Wend
		
		Return -1
	End Method
	
End Class

Interface FlxGroupCaller
	
	Method Call:Void(object:FlxBasic)

End Interface

Interface FlxGroupSetter
	
	Method Set:Void(object:FlxBasic, value:Object)

End Interface

Interface FlxGroupComparator

	Method Compare:Int(lhs:FlxBasic,rhs:FlxBasic)

End Interface

Class Enumerator

	Method New(group:FlxGroup)
		_group = group
	End

	Method HasNext:Bool()
		Return _index < _group.Length
	End

	Method NextObject:FlxBasic()
		_index+=1
		Return _group.Members[_index-1]
	End

Private

	Field _group:FlxGroup
	Field _index:Int

End