'This is a not module

Import unittest

Import flxbasic
Import flxpoint
Import flxrect
Import flxgroup

'#Region FlxPoint tests bundle

Class FlxPointUnitTestBase Implements IUnitTest Abstract
	
	Field x:Float = 10, y:Float = 100
	Field p1:FlxPoint, p2:FlxPoint
	
	Method New()
		p1 = New FlxPoint(x, y)
		p2 = New FlxPoint()
	End Method
	
	Method Run:Bool() Abstract
	
	Method GetName:String() Abstract

private	
	Method _AssertPoint:Bool()
		Return (UnitTest.AssertEqualsF(x, p1.x) And UnitTest.AssertEqualsF(y, p1.y))	
	End Method
	
	Method _AssertPoints:Bool()
		Return (UnitTest.AssertEqualsF(p2.x, p1.x) And UnitTest.AssertEqualsF(p2.y, p1.y))	
	End Method

End Class

Class FlxPointNewUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		Return _AssertPoint()	
	End Method

	Method GetName:String()
		Return "FlxPoint.New"
	End Method

End Class

Class FlxPointMakeUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p1 = FlxPoint.Make(x, y)
		Return _AssertPoint()
	End Method

	Method GetName:String()
		Return "FlxPoint.Make"
	End Method

End Class

Class FlxPointCopyToUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p1.CopyTo(p2)
		Return _AssertPoints()
	End Method

	Method GetName:String()
		Return "FlxPoint.CopyTo"
	End Method

End Class

Class FlxPointCopyFromUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p2.CopyFrom(p1)
		Return _AssertPoints()
	End Method

	Method GetName:String()
		Return "FlxPoint.CopyFrom"
	End Method

End Class

'#End Region

'#Region FlxRect tests bundle

Class FlxRectUnitTestBase Implements IUnitTest Abstract
	
	Field x:Float = 10, y:Float = 100
	Field width:Float = 110, height:Float = 1000
	Field r1:FlxRect, r2:FlxRect
	
	Method New()
		r1 = New FlxRect(x, y, width, height)
		r2 = New FlxRect()
	End Method
	
	Method Run:Bool() Abstract
	
	Method GetName:String() Abstract
	
Private
	Method _AssertRect:Bool()
		Return (UnitTest.AssertEqualsF(x, r1.x) And UnitTest.AssertEqualsF(y, r1.y) And 
			UnitTest.AssertEqualsF(width, r1.width) And UnitTest.AssertEqualsF(height, r1.height))	
	End Method
	
	Method _AssertRects:Bool()
		Return (UnitTest.AssertEqualsF(r2.x, r1.x) And UnitTest.AssertEqualsF(r2.y, r1.y) And 
			UnitTest.AssertEqualsF(r2.width, r1.width) And UnitTest.AssertEqualsF(r2.height, r1.height))	
	End Method

End Class

Class FlxRectNewUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		Return _AssertRect()
	End Method

	Method GetName:String()
		Return "FlxRect.New"
	End Method

End Class

Class FlxRectMakeUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		r1 = FlxRect.Make(x, y, width, height)
		Return _AssertRect()
	End Method

	Method GetName:String()
		Return "FlxRect.Make"
	End Method

End Class

Class FlxRectLeftUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		Return UnitTest.AssertEqualsF(x, r1.Left)
	End Method

	Method GetName:String()
		Return "FlxRect.Left"
	End Method

End Class

Class FlxRectRightUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		Return UnitTest.AssertEqualsF(x + width, r1.Right)
	End Method

	Method GetName:String()
		Return "FlxRect.Right"
	End Method

End Class

Class FlxRectTopUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		Return UnitTest.AssertEqualsF(y, r1.Top)
	End Method

	Method GetName:String()
		Return "FlxRect.Top"
	End Method

End Class

Class FlxRectBottomUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		Return UnitTest.AssertEqualsF(y + height, r1.Bottom)
	End Method

	Method GetName:String()
		Return "FlxRect.Bottom"
	End Method

End Class

Class FlxRectCopyToUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		r1.CopyTo(r2)
		Return _AssertRects()
	End Method

	Method GetName:String()
		Return "FlxRect.CopyTo"
	End Method

End Class

Class FlxRectCopyFromUnitTest Extends FlxRectUnitTestBase

	Method Run:Bool()
		r2.CopyFrom(r1)
		Return _AssertRects()
	End Method

	Method GetName:String()
		Return "FlxRect.CopyFrom"
	End Method

End Class

'#End Region

'#Region FlxGroup tests bundle

Class FlxGroupUnitTestBase Implements IUnitTest Abstract

	Field countObjects:Int = 10
	Field objects:FlxBasic[]
	Field group:FlxGroup
	
	Method New()
		objects = new FlxBasic[countObjects]
		
		For Local i:Int = 0 To countObjects - 1
			objects[i] = New FlxBasic()
			objects[i].ID = i
		Next
	End Method
	
	Method Run:Bool() Abstract
	
	Method GetName:String() Abstract	

End Class

Class FlxGroupAddUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		Local i:Int = 0
		For Local basic:FlxBasic = EachIn group.Members
			UnitTest.AssertEqualsI(basic.ID, objects[i].ID)
			i+=1
		Next
		
		If (Not UnitTest.AssertEqualsI(countObjects, group.Length)) Return False		
		
		Local maxSize:Int = 5	
		group = New FlxGroup(maxSize)		
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next		
		
		i = 0
		For Local basic:FlxBasic = EachIn group.Members			
			If (basic <> Null) UnitTest.AssertEqualsI(basic.ID, objects[i].ID)
			i+=1
		Next
		
		Return UnitTest.AssertEqualsI(i, maxSize)
	End Method

	Method GetName:String()
		Return "FlxGroup.Add"
	End Method
	
End Class

Class FlxGroupRemoveUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		For Local basic:FlxBasic = EachIn objects
			If (Not UnitTest.AssertNotNull(group.Remove(basic))) Return False
		Next
		
		If (Not UnitTest.AssertEqualsI(countObjects, group.Length)) Return False		
		
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next		
		
		For Local basic:FlxBasic = EachIn objects
			If (Not UnitTest.AssertNotNull(group.Remove(basic, True))) Return False
		Next
		
		Return UnitTest.AssertEqualsI(0, group.Length)
	End Method

	Method GetName:String()
		Return "FlxGroup.Remove"
	End Method
	
End Class

Class FlxGroupReplaceUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		group.Replace(objects[0], objects[countObjects - 1])		
		Return UnitTest.AssertEqualsI(countObjects - 1, group.Members.Get(0).ID)
	End Method

	Method GetName:String()
		Return "FlxGroup.Replace"
	End Method
	
End Class

'#End Region

Class FlixelUnitTest Extends UnitTestApp

	Method Setup:Void()
		'#Region add FlxPoint tests bundle
		
		AddTest(New FlxPointNewUnitTest())
		AddTest(New FlxPointMakeUnitTest())
		AddTest(New FlxPointCopyToUnitTest())
		AddTest(New FlxPointCopyFromUnitTest())
		
		'#End Region
		
		'#Region add FlxRect tests bundle
		
		AddTest(New FlxRectNewUnitTest())
		AddTest(New FlxRectMakeUnitTest())
		AddTest(New FlxRectLeftUnitTest())
		AddTest(New FlxRectRightUnitTest())
		AddTest(New FlxRectTopUnitTest())
		AddTest(New FlxRectBottomUnitTest())
		AddTest(New FlxRectCopyToUnitTest())
		AddTest(New FlxRectCopyFromUnitTest())
		
		'#End Region
		
		'#Region add FlxGroup tests bundle
		
		AddTest(New FlxGroupAddUnitTest())
		AddTest(New FlxGroupRemoveUnitTest())
		AddTest(New FlxGroupReplaceUnitTest())
		
		'#End Region
		
	End Method
	
	Method GetName:String()
		Return "Flixel library"	
	End Method

End Class
