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
	
Private
	Field _members:FlxBasicStack
	
	Field _maxSize:Int
	
	Field _marker:Int	
	
Public
	Method New(maxSize:Int = 0)
		Super.New()
		_members = New FlxBasicStack()
		_maxSize = maxSize
		_marker = 0
		length = 0
	End Method
	
	Method Members:Stack<FlxBasic>() Property
		Return _members
	End Method
		
	Method Destroy:Void()
		If (_members <> Null) Then
			For Local basic:FlxBasic = EachIn _members
				If (basic <> Null) basic.Destroy()
			Next 
			
			_members.Clear()
			_members = null	
		End If
	End Method
	
	Method Update:Void()
		For Local basic:FlxBasic = EachIn _members
			If (basic <> Null And basic.exists And basic.active) Then
				basic.PreUpdate()
				basic.Update()
				basic.PostUpdate()
			End If	
		Next
	End Method
	
	Method Draw:Void()
		For Local basic:FlxBasic = EachIn _members
			If (basic <> Null And basic.exists And basic.visible) basic.Draw()
		Next	
	End Method
	
	Method MaxSize:Int() Property
		Return _maxSize	
	End Method
	
	Method MaxSize:Void(size:Int) Property
		_maxSize = size		
		
		If (_marker >= _maxSize) _marker = 0			
		If (_maxSize = 0 Or _members = Null Or _maxSize >= _members.Length()) Return		
		
		Local basic:FlxBasic		
		For Local i:Int = _members.Length() - 1 To _maxSize Step -1		
			basic = _members.Pop()
			If (basic <> Null) basic.Destroy()
		Next
		
		length = _maxSize
	End Method
	
	Method Add:FlxBasic(object:FlxBasic)
		If (_members.Contains(object)) Return object
		
		Local l:Int = _members.Length() - 1
		For Local i:Int = 0 To l
			If (_members.Get(i) = Null) Then
				_members.Set(i, object)
				If (i > length)	length = i+1
				Return object
			End If
		Next
		
		If (_maxSize > 0 And _members.Length() >= _maxSize) Return Object	

		_members.Push(object)
		length+=1	
			
		Return object
	End Method
	
	Method Recycle:FlxBasic(creator:FlxClassCreator = null)
		If (_maxSize > 0) Then
			If (_members.Length() < _maxSize) Then
				If (creator = Null) Return Null				
				Return Add(creator.CreateInstance())
			Else				
				Local basic:FlxBasic = _members.Get(_marker)
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
		Local index:Int = _members.IndexOf(object)
		
		If (index < 0) Return Null
	
		If (splice) Then
			_members.Remove(index)
		Else 
			_members.Set(index, Null)
		End If
		
		length-=1
		Return object
	End Method
	
	Method Replace:FlxBasic(oldObject:FlxBasic, newObject:FlxBasic)
		Local index:Int  = _members.IndexOf(oldObject)
		If (index < 0) Return Null
		
		_members.Set(index, newObject)
		Return newObject
	End Method
	
	Method Sort:Void(comparator:FlxGroupComparator, order:Bool = ASCENDING)
		'TODO complete this method
	End Method
	
	Method SetAll:Void(setter:FlxGroupSetter, value:Object, recurse:Bool = True)
		For Local basic:FlxBasic = EachIn _members
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) Then
					FlxGroup(basic).SetAll(setter, value, recurse)	
				Else
					setter.Set(basic, value)
				End If
			End If
		Next
	End Method
	
	Method CallAll:Void(caller:FlxGroupCaller, recurse:Bool = True)
		For Local basic:FlxBasic = EachIn _members
			If (basic <> Null) Then
				If (recurse And FlxGroup(basic) <> Null) Then
					FlxGroup(basic).CallAll(caller, recurse)	
				Else
					caller.Call(basic)
				End If
			End If
		Next
	End Method
	
	Method GetFirstAvailable:FlxBasic(creator:FlxClassCreator = null)		
		For Local basic:FlxBasic = EachIn _members
			If (basic <> Null And Not basic.exists And 
				(creator = Null Or creator.InstanceOf(basic))) Return basic		
		Next
		
		Return Null
	End Method
	
	#Rem
	Method GetFirstNull:Int()
		Local l:Int = _members.Length() - 1
		Local basic:FlxBasic
		
		For Local i:Int = 0 To l
			basic = _members.Get(i)
			If (basic = Null) Return i 
		Next
		
		Return -1
	End Method
	#End
	
	Method ToString:String()
		Return "FlxGroup"
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

Private
Class FlxBasicStack Extends Stack<FlxBasic>
	
	Field comparator:FlxGroupComparator
	
	Method Compare:Int(lhs:FlxBasic, rhs:FlxBasic)
		Return comparator.Compare(lhs, rhs)			
	End Method
	
	Method IndexOf:Int(object:FlxBasic)
		Local i:Int = 0
		For Local basic:FlxBasic = EachIn Self
			If Equals(basic, object) Return i
			i+=1		
		Next
				
		Return -1
	End
		
End Class