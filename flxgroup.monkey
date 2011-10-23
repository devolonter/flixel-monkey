#rem
	header:This module contains the FlxGroup class.
#end

Import flxbasic

Class FlxGroup Extends FlxBasic

	Const ASCENDING:Bool = True
	
	Const DESCENDING:Bool = False	
	
Private
	Field _members:FlxBasicStack
	
	Field _maxSize:Int
	
	Field _marker:Int
	
	Field _isFragmented:Bool
	
	Field _length:Int
	
Public
	Method New(maxSize:Int = 0)
		Super.New()
		_members = New FlxBasicStack()
		_maxSize = maxSize
		_marker = 0
		_isFragmented = False
		_length = 0
	End Method
	
	Method Members:Stack<FlxBasic>() Property
		Return _members
	End Method
	
	Method Length:Int() Property
		Return _members.Length	
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
		If (_maxSize = 0 Or _members = Null Or _maxSize >= members.Length) Return		
		
		Local basic:FlxBasic		
		For Local i:Int = _memebers.Length - 1 To _maxSize Step -1		
			basic = _members.Pop()
			If (basic <> Null) basic.Destroy()
		Next
	End Method
	
	Method Add:FlxBasic(object:FlxBasic)
		If ((_maxSize > 0 And _length >= _maxSize) Or _members.Contains(object)) Return object
		
		If (_isFragmented) Then
			If (_length < _members.Length) Then			
				Local l:Int = _members.Length - 1
				Local basic:FlxBasic = new FlxBasic()
				
				For Local i = 0 To l
					basic = _members.Get(i)
					If (basic = Null) Then
						_members.Set(i, object)
						_length+=1
						Return object
					End if
				Next
			End If

			_isFragmented = False				
		End If
				
		_members.Push(object)
		_length+=1	
		Return object
	End Method
	
	Method Recycle(objectClass:FlxBasicClass = null)
					
	End Method
	
	Method Remove:FlxBasic(object:FlxBasic, splice:Bool = False)
		Local index:Int = _members.IndexOf(object)
		
		If (index < 0) Return Null
	
		If (splice) Then
			_members.Remove(index)
		Else 
			_members.Set(index, Null)
			_isFragmented = True
		End If
		
		_length-=1
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
Class FlxBasicStack Extends Stack<FlxBasic>
	
	Field comparator:FlxGroupComparator
	
	Method Compare:Int(lhs:FlxBasic, rhs:FlxBasic)
		Return comparator.Compare(lhs, rhs)			
	End Method
	
	Method IndexOf:Int(value:FlxBasic)
		Local i
		While i<length
			If Equals(data[i], value) Return i
		Wend
		
		Return -1
	End
		
End Class