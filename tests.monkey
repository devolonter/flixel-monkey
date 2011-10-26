'This is a not module
Strict

Import unittest

Import flxbasic
Import flxpoint
Import flxrect
Import flxobject
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
			If (Not UnitTest.AssertEqualsI(basic.ID, objects[i].ID)) Return False
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
			If (Not UnitTest.AssertEqualsI(basic.ID, objects[i].ID)) Return False
			i+=1
		Next
		
		Return UnitTest.AssertEqualsI(i, maxSize)
	End Method

	Method GetName:String()
		Return "FlxGroup.Add"
	End Method
	
End Class

Class FlxGroupRecycleUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup(10)
		
		Local recycled:FlxBasic 
		For Local i:Int = 0 To group.MaxSize - 1
			recycled = group.Recycle(FlxBasic.CREATOR)
			If (Not UnitTest.AssertNotNull(recycled)) Return False
			recycled.ID = i		
		Next
		
		For Local basic:FlxBasic = EachIn objects
			recycled = group.Recycle()	
			If (Not UnitTest.AssertNotNull(recycled)) Return False		
			If (Not UnitTest.AssertEqualsI(basic.ID, recycled.ID)) Return False
		Next
		
		group = New FlxGroup()
		
		For Local i:Int = 0 To 9
			recycled = group.Recycle(FlxBasic.CREATOR)
			If (Not UnitTest.AssertNotNull(recycled)) Return False
			recycled.ID = i		
		Next
		
		recycled = group.Recycle(FlxBasic.CREATOR)
		If (Not UnitTest.AssertNotNull(recycled)) Return False		
		If (Not UnitTest.AssertEqualsI(-1, recycled.ID)) Return False
		
		group.Members.Get(5).Kill()
		recycled = group.Recycle(FlxBasic.CREATOR)
		If (Not UnitTest.AssertNotNull(recycled)) Return False		
		If (Not UnitTest.AssertEqualsI(5, recycled.ID)) Return False
						
		Return True
	End Method

	Method GetName:String()
		Return "FlxGroup.Recycle"
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

Class FlxGroupAddRemoveUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		Local i:Int = 0
		For Local basic:FlxBasic = EachIn objects
			If (i > 4 And i < 7) group.Remove(basic)
			i+=1
		Next
		
		Local newBasic:FlxBasic = new FlxBasic()
		newBasic.ID = 10
		group.Add(newBasic)		
		
		If (Not UnitTest.AssertEqualsI(group.Members.Get(5).ID, newBasic.ID)) Return False
		
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		i = 0
		For Local basic:FlxBasic = EachIn objects
			If (i > 4 And i < 7) group.Remove(basic, True)
			i+=1
		Next
		
		group.Add(newBasic)		
		If (Not UnitTest.AssertEqualsI(group.Members.Get(8).ID, newBasic.ID)) Return False	
		
		group = New FlxGroup(6)
		
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		i = 0
		For Local basic:FlxBasic = EachIn objects
			If (i > 4 And i < 7) group.Remove(basic)
			i+=1
		Next
		
		group.Add(newBasic)		
		If (Not UnitTest.AssertEqualsI(group.Members.Get(5).ID, newBasic.ID)) Return False	
		
		group = New FlxGroup(6)
		
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		i = 0
		For Local basic:FlxBasic = EachIn objects
			If (i > 4 And i < 7) group.Remove(basic, True)
			i+=1
		Next
		
		group.Add(newBasic)		
		Return (UnitTest.AssertEqualsI(group.Members.Get(5).ID, newBasic.ID))		
	End Method

	Method GetName:String()
		Return "FlxGroup.Add/Remove"
	End Method
	
End Class

Class FlxGroupMaxSizeUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)
		Next
		
		group.MaxSize = 15
		
		If (Not UnitTest.AssertEqualsI(objects.Length, group.Length)) Return False
		
		Local i:Int = 0
		For Local basic:FlxBasic = EachIn group.Members
			If (Not UnitTest.AssertEqualsI(basic.ID, objects[i].ID)) Return False
			i+=1
		Next
		
		group.MaxSize = 6
		If (Not UnitTest.AssertEqualsI(group.MaxSize, group.Length)) Return False
		i = 0
		For Local basic:FlxBasic = EachIn group.Members
			If (Not UnitTest.AssertEqualsI(basic.ID, objects[i].ID)) Return False
			i+=1
		Next		
		
		Return True
	End Method

	Method GetName:String()
		Return "FlxGroup.MaxSize"
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

Class FlxGroupGetFirstAvailableUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		Local i:Int = 0
		For Local basic:FlxBasic = EachIn objects
			group.Add(basic)			
			If (i > 4 And i < 7) Then basic.Kill()		
			i+=1
		Next
		
		Local basic:FlxBasic = group.GetFirstAvailable(FlxBasic.CREATOR)
		
		If (UnitTest.AssertNotNull(basic) And UnitTest.AssertEqualsI(5, basic.ID)) Then
			basic = group.GetFirstAvailable()
			
			If (Not UnitTest.AssertNotNull(basic) Or Not UnitTest.AssertEqualsI(5, basic.ID)) Return False
		
			Local object:FlxObject = FlxObject(group.Add(new FlxObject()))	
			object.ID = 10
			
			object = FlxObject(group.Add(new FlxObject()))	
			object.ID = 11
			object.Kill()
			
			object = FlxObject(group.GetFirstAvailable(FlxObject.CREATOR))
			Return (UnitTest.AssertNotNull(object) And UnitTest.AssertEqualsI(11, object.ID))	
		End If
		
		Return False
	End Method

	Method GetName:String()
		Return "FlxGroup.GetFirstAvailable"
	End Method
	
End Class

Class FlxGroupFinalUnitTest Extends FlxGroupUnitTestBase

	Method Run:Bool()	
		group = New FlxGroup()
		
		group.Update()
		group.Draw()
		group.DrawDebug()
		group.ToString()
		
		Return True
	End Method

	Method GetName:String()
		Return "FlxGroup final"
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
		AddTest(New FlxGroupRecycleUnitTest())
		AddTest(New FlxGroupRemoveUnitTest())
		AddTest(New FlxGroupAddRemoveUnitTest())
		AddTest(New FlxGroupMaxSizeUnitTest())
		AddTest(New FlxGroupReplaceUnitTest())
		AddTest(New FlxGroupGetFirstAvailableUnitTest())
		AddTest(New FlxGroupFinalUnitTest())		
		
		'#End Region
		
	End Method
	
	Method GetName:String()
		Return "Flixel library"	
	End Method

End Class
