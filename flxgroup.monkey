#rem
	header:This module contains the FlxGroup class.
#end

Import flxbasic

Class FlxGroup Extends FlxBasic

	Const ASCENDING:Bool = True
	
	Const DESCENDING:Bool = False
	
	Field length:Int
	
Private
	Field _members:FlxBasicList
	
	Field _maxSize:Int
	
	Field _marker:Int
	
Public
	Method New(maxSize:Int = 0)
		Super.New()
		_members = New FlxBasicList()
		length = 0
		_maxSize = maxSize
		_marker = 0
	End Method
	
	Method Members:List<FlxBasic>() Property
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
		If (_maxSize = 0 Or _members = Null Or _maxSize >= _members.Count()) Return
		
		Local basic:FlxBasic	
		Local l:Int = _members.Count() - 1
		
		For Local i:Int = _maxSize To l		
			basic = _members.Last()
			If (basic <> Null) basic.Destroy()
			
			_members.RemoveLast()
		Next

		length = _maxSize
	End Method
	
	Method Add:FlxBasic(object:FlxBasic)
		If (_members.Contains(object)) Return object	
		
		If (_maxSize > 0) Then
			If (_members.Count() < _maxSize) Then	
				_members.AddLast(object)	
				length+=1
			End If
			
			Return object
		End if
		
		_members.AddLast(object)	
		length+=1
		Return object
	End Method
	
	Method Recycle(objectClass:FlxBasicClass = null)
					
	End Method
	
	Method Remove:FlxBasic(object:FlxBasic)
		_members.RemoveEach(object)
		length-=1
		Return object
	End Method
	
	Method GetFirstAvailable(objectClass:FlxBasicClass = null)
	
	End Method
	
End Class

Interface FlxGroupCaller
	
	Method Call(obj:FlxBasic)

End Interface

Interface FlxGroupComparator

	Method Compare:Int(lhs:FlxBasic,rhs:FlxBasic)

End Interface

Private
Class FlxBasicList Extends List<FlxBasic>
	
	Field comparator:FlxGroupComparator
	
	Method Compare:Int(lhs:FlxBasic, rhs:FlxBasic)
		Return comparator.Compare(lhs, rhs)			
	End Method
		
End Class