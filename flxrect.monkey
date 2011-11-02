#rem
	header:This module contains the FlxRect class.
	[b]IMPORTANT![/b] When porting the library were excluded following original Flixel library FlxPoint class methods:
	[code]copyFromFlash, copyToFlash[/code]
#end
Strict

#Rem
summary:Stores a rectangle.
#End
Class FlxRect
	
	'summary:The X-coordinate of the point in space.
	Field x:Float
	
	'summary:The Y-coordinate of the point in space.
	Field y:Float
	
	'summary:Width of the rectangle..
	Field width:Float
	
	'summary:Height of the rectangle.
	Field height:Float
	
	#Rem
	summary:Instantiate a new point object.
	Params:
	[list]
	[*]x: The X-coordinate of the point in space.
	[*]y: The Y-coordinate of the point in space.
	[*]width: Desired width of the rectangle.
	[*]height: Desired height of the rectangle.
	[/list]
	#End
	Method New(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height	
	End Method
	
	'summary:The X-coordinate of the left side of the rectangle.
	Method Left:Float() Property
		Return x
	End Method
	
	'summary:The X-coordinate of the right side of the rectangle.
	Method Right:Float() Property
		Return x + width
	End Method
	
	'summary:The Y-coordinate of the top side of the rectangle.
	Method Top:Float() Property
		Return y
	End Method
	
	'summary:The Y-coordinate of the bottom side of the rectangle.
	Method Bottom:Float() Property
		Return y + height
	End Method
	
	#Rem
	summary:Instantiate a new point object.
	Params:
	[list]
	[*]x: The X-coordinate of the point in space.
	[*]y: The Y-coordinate of the point in space.
	[*]width: Desired width of the rectangle.
	[*]height: Desired height of the rectangle.
	[/list]
	#End
	Function Make:FlxRect(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0)
		Return New FlxRect(x ,y, width, height)
	End Function
	
	#Rem
	summary:Helper function, just copies the values from the specified rectangle.
	Return a reference to itself.
	[list]
	[*]rect: Any [a flxrect.monkey.html]FlxRect[/a]
	[/list] 
	#End
	Method CopyFrom:FlxRect(rect:FlxRect)
		x = rect.x
		y = rect.y
		width = rect.width
		height = rect.height
		return Self
	End Method
	
	#Rem
	summary:Helper function, just copies the values from this rectangle to the specified rectangle.
	Return a reference to the altered rectangle parameter.
	[list]
	[*]point: Any [a flxrect.monkey.html]FlxRect[/a]
	[/list] 
	#End
	Method CopyTo:FlxRect(rect:FlxRect)
		rect.x = x
		rect.y = y
		rect.width = width
		rect.height = height
		return rect
	End Method
	
	Method ToString:String()
		Return "FlxRect"	
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
