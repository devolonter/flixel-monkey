#rem
	header:This module contains the FlxPoint class.
	[b]IMPORTANT![/b] When porting the library were excluded following original Flixel library FlxPoint class methods:
	[code]copyFromFlash, copyToFlash[/code]
#end
Strict

#Rem
summary:Stores a 2D floating point coordinate.
#End
Class FlxPoint

	'summary:The X-coordinate of the point in space.
	Field x:Float
	
	'summary:The Y-coordinate of the point in space.
	Field y:Float
	
	#Rem
	summary:Instantiate a new point object.
	Params:
	[list]
	[*]x: The X-coordinate of the point in space.
	[*]y: The Y-coordinate of the point in space.
	[/list]
	#End
	Method New(x:Float = 0, y:Float = 0)
		Self.x = x
		Self.y = y	
	End Method
	
	#Rem
	summary:Instantiate a new point object.
	Params:
	[list]
	[*]x: The X-coordinate of the point in space.
	[*]y: The Y-coordinate of the point in space.
	[/list]
	#End
	Function Make:FlxPoint(x:Float = 0, y:Float = 0)
		Return New FlxPoint(x, y)
	End Function
	
	#Rem
	summary:Helper function, just copies the values from the specified point.
	Return a reference to itself.
	[list]
	[*]point: Any [a flxpoint.monkey.html]FlxPoint[/a]
	[/list] 
	#End
	Method CopyFrom:FlxPoint(point:FlxPoint)
		x = point.x
		y = point.y
		return Self
	End Method
	
	#Rem
	summary:Helper function, just copies the values from this point to the specified point.
	Return A reference to the altered point parameter.
	[list]
	[*]point: Any [a flxpoint.monkey.html]FlxPoint[/a]
	[/list] 
	#End
	Method CopyTo:FlxPoint(point:FlxPoint)
		point.x = x
		point.y = y
		return point
	End Method
	
	Method ToString:String()
		Return "FlxPoint"
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
