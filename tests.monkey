'This is a not module

Import unittest

Import flxpoint
Import flxrect

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

End Class

Class FlxPointNewUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		Return (UnitTest.AssertEqualsF(x, p1.x) And UnitTest.AssertEqualsF(y, p1.y))
	End Method

	Method GetName:String()
		Return "FlxPoint.New"
	End Method

End Class

Class FlxPointMakeUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p1 = FlxPoint.Make(x, y)
		Return (UnitTest.AssertEqualsF(x, p1.x) And UnitTest.AssertEqualsF(y, p1.y))
	End Method

	Method GetName:String()
		Return "FlxPoint.Make"
	End Method

End Class

Class FlxPointCopyToUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p1.CopyTo(p2)
		Return (UnitTest.AssertEqualsF(p2.x, p1.x) And UnitTest.AssertEqualsF(p2.y, p1.y))
	End Method

	Method GetName:String()
		Return "FlxPoint.CopyTo"
	End Method

End Class

Class FlxPointCopyFromUnitTest Extends FlxPointUnitTestBase

	Method Run:Bool()
		p2.CopyFrom(p1)
		Return (UnitTest.AssertEqualsF(p2.x, p1.x) And UnitTest.AssertEqualsF(p2.y, p1.y))
	End Method

	Method GetName:String()
		Return "FlxPoint.CopyFrom"
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
		
		
	End Method
	
	Method GetName:String()
		Return "Flixel library"	
	End Method

End Class