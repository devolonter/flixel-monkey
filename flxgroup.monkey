#rem
	header:This module contains the FlxGroup class and next inerfaces: FlxGroupCaller, FlxGroupSetter, FlxGroupComparator.
#end
Strict


Import flxbasic

#Rem
summary:This is an organizational class that can update and render a bunch of FlxBasics.
[i][b]NOTE:[/b] Although [a flxgroup.monkey.html]FlxGroup[/a] extends [a flxbasics.monkey.html]FlxBasic[/a], it will not automatically add itself to the global collisions quad tree, it will only add its members.[/i]
#End
Class FlxGroup Extends FlxBasic

	'summary:Use with [a #Sort]Sort()[/a] to sort in ascending order.	
	Const ASCENDING:Bool = True
	
	Const DESCENDING:Bool = False
	
	Field length:Int
	
	Field members:FlxBasic[]	
	
Private	
	Field _maxSize:Int
	
	Field _marker:Int	
	
Public
	Method New(maxSize:Int = 0)
		Super.New()
		_maxSize = maxSize
		_marker = 0
		length = 0
	End Method
			
	Method Destroy:Void()
		Local basic:FlxBasic
		Local i:Int = 0		
			
		While(i < length)
			basic = members[i]
			If (basic <> Null) basic.Destroy()
			i+=1		
		Wend
		
		length = 0
	End Method
	
	Method Update:Void()
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < length)
			basic = members[i]
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
			
		While(i < length)
			basic = members[i]
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
		If (_maxSize = 0 Or _maxSize >= members.Length()) Return		
		
		Local basic:FlxBasic
		Local i:Int = _maxSize
		Local l:Int = members.Length()
		
		While(i < l)
			basic = members[i]
			If (basic <> Null) basic.Destroy()
			i+=1		
		Wend
		
		members = members.Resize(_maxSize)		
		length = _maxSize
	End Method
	
	Method Add:FlxBasic(object:FlxBasic)		
		If (_IndexOf(object) >= 0) Return object		
		
		Local i:Int = 0
		Local l:Int = members.Length()		
		
		While (i < l)
			If (members[i] = Null) Then
				members[i] = object
				If (i >= length) length = i+1
				Return object		
			End If
			i+=1
		Wend			
		
		If (_maxSize > 0) Then			
			If (members.Length() >= _maxSize) Then
				Return object
			ElseIf (members.Length()*2 + 10 <= _maxSize)
				members = members.Resize(members.Length()*2 + 10)
			Else
				members = members.Resize(_maxSize)		 		
			End If
		Else			
			members = members.Resize(members.Length()*2 + 10)
		End If

		members[i] = object
		length+=1	
			
		Return object
	End Method
	
	Method Recycle:FlxBasic(creator:FlxClassCreator = null)
		If (_maxSize > 0) Then
			If (length < _maxSize) Then
				If (creator = Null) Return Null				
				Return Add(creator.CreateInstance())
			Else				
				Local basic:FlxBasic = members[_marker]
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
			Local l:Int = members.Length()
			
			While(i < length - 1)
				members[i] = members[i+1]
				i+=1		
			Wend			
			
			i = length - 1
			While(i < l)
				members[i] = Null
				i+=1		
			Wend
			
			length-=1
		Else 
			members[index] = Null
		End If
		
		Return object
	End Method
	
	Method Replace:FlxBasic(oldObject:FlxBasic, newObject:FlxBasic)
		Local index:Int  = _IndexOf(oldObject)
		If (index < 0) Return Null
		
		members[index] = newObject
		Return newObject
	End Method
	
	Method Sort:Void(comparator:FlxGroupComparator, order:Bool = ASCENDING)
		'TODO complete this method
	End Method
	
	Method SetAll:Void(setter:FlxGroupSetter, value:Object, recurse:Bool = True)
		Local basic:FlxBasic
		Local i:Int = 0	
			
		While(i < length)
			basic = members[i]
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
			
		While(i < length)
			basic = members[i]
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
			
		While(i < length)
			basic = members[i]
			If (basic <> Null And Not basic.exists And 
					(creator = Null Or creator.InstanceOf(basic))) Return basic
			i+=1
		Wend

		Return Null
	End Method
	
	#Rem
	Method GetFirstNull:Int()
		Local l:Int = members.Length() - 1
		Local basic:FlxBasic
		
		For Local i:Int = 0 To l
			basic = members.Get(i)
			If (basic = Null) Return i 
		Next
		
		Return -1
	End Method
	#End
	
	Method ObjectEnumerator:Enumerator()
		Return New Enumerator(Self)
	End
	
	Method ToString:String()
		Return "FlxGroup"
	End Method
	
Private

	Method _IndexOf:Int(object:FlxBasic)
		Local i:Int = 0		
			
		While(i < length)
			If (members[i] = object) Return i
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
		Self.group = group
	End

	Method HasNext:Bool()
		Return index < group.length
	End

	Method NextObject:FlxBasic()
		index+=1
		Return group.members[index-1]
	End

Private

	Field group:FlxGroup
	Field index:Int

End