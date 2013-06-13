#rem
	header:This module contains the FlxBasic class and FlxClass interface.
#end
Strict

Import reflection

Import flxextern
Import flxcamera
Import flxg
Import system.tweens.flxtween

#Rem
summary:This is a useful "generic" Flixel object.
Both [a flxobject.monkey.html]FlxObject[/a] and [a flxgroup.monkey.html]FlxGroup[/a] extend this class, 
as do the plugins.  Has no size, position or graphical data.
#End
Class FlxBasic

	Global ClassObject:Object

	Global _ActiveCount:Int
	
	Global _VisibleCount:Int

	#Rem
	summary:IDs seem like they could be pretty useful, huh?
	They're not actually used for anything yet though.
	#End
	Field ID:Int
	
	#Rem
	summary:See details.
	Controls whether [a #Update]Update()[/a] and [a #Draw]Draw()[/a] are automatically called by [a flxstate.monkey.html]FlxState[/a]/[a flxgroup.monkey.html]FlxGroup[/a].
	#End
	Field exists:Bool
	
	#Rem
	summary:See details.
	Controls whether [a #Update]Update()[/a] is automatically called by [a flxstate.monkey.html]FlxState[/a]/[a flxgroup.monkey.html]FlxGroup[/a].
	#End
	Field active:Bool
	
	#Rem
	summary:See details.
	Controls whether [a #Draw]Draw()[/a] is automatically called by[a flxstate.monkey.html]FlxState[/a]/[a flxgroup.monkey.html]FlxGroup[/a].
	#End
	Field visible:Bool
	
	#Rem
	summary:Useful state for many game objects - "dead" (!alive) vs alive.
	[a #Kill]Kill()[/a] and [a #Recive]Revive()[/a] both flip this switch (along with exists, but you can override that).
	#End
	Field alive:Bool	
	
	#Rem
	summary:Setting this to true will prevent the object from appearing when the visual debug mode in the debugger overlay is toggled on.
	#End
	Field ignoreDrawDebug:Bool
	
	Field autoClear:Bool
	
	Field _cameras:IntSet
	
Private
	Field _tweens:List<FlxTween>

	Field _classInfo:ClassInfo
	
	#Rem
	summary:Instantiate the basic flixel object.
	#End	
	Method New()
		ID = -1
		exists = True
		active = True
		visible = True
		alive = True
		ignoreDrawDebug = False
		autoClear = True
		
		_classInfo = GetClass(Object(Self))
	End Method	
	
	#Rem
	summary:See details.
	Override this function to null out variables or manually call [a #Destroy]Destroy()[/a] on class members if necessary.
	Don't forget to call [b]super.Destroy()[/b]!
	#End
	Method Destroy:Void()
		If (autoClear And HasTween) Then			
			ClearTweens(True)
		End If
		
		_classInfo = Null
	End Method
	
	#Rem
	summary:See details.
	Pre-update is called right before [a #Update]Update()[/a] on each object in the game loop.
	#End
	Method PreUpdate:Void()
	#If FLX_DEBUG_ENABLED = "1"
		_ActiveCount += 1
	#End	
	End Method
	
	#Rem
	summary:Override this function to update your class's position and appearance.
	This is where most of your game rules and behavioral code will go.
	#End
	Method Update:Void()
	End Method
	
	#Rem
	summary:See details.
	Post-update is called right after [a #Update]Update()[/a] on each object in the game loop.
	#End
	Method PostUpdate:Void()
	End Method
	
	#Rem
	summary:Override this function to control how the object is drawn.
	Overriding [a #Draw]Draw()[/a] is rarely necessary, but can be very useful.
	#End
	Method Draw:Void()
	#If FLX_DEBUG_ENABLED = "1"
		_VisibleCount += 1
	#End	
	End Method
	
	#Rem
	summary:Override this function to draw custom "debug mode" graphics to the specified camera while the debugger's visual mode is toggled on.
	Params:
	[list]
	[*][a flxcamera.monkey.html]camera:FlxCamera[/a] - which camera to draw the debug visuals to.
	[/list]
	#End
	Method DrawDebug:Void(camera:FlxCamera = Null)
	End Method
	
	#Rem
	summary: Handy function for "killing" game objects.
	Default behavior is to flag them as nonexistent AND dead.
	However, if you want the "corpse" to remain in the game,
	like to animate an effect or whatever, you should override this,
	setting only alive to false, and leaving exists true.
	#End
	Method Kill:Void()
		alive = False
		exists = False
	End Method
	
	#Rem
	summary:Handy function for bringing game objects "back to life". Just sets alive and exists back to true.
	In practice, this function is most often called by [a flxobject.monkey.html#Reset]FlxObject.Reset()[/a].
	#End
	Method Revive:Void()
		alive = True
		exists = True
	End Method
	
	Method Cameras:Void(cameras:Int[]) Property
		If (cameras.Length() = 0) Then
			_cameras = Null
			Return
		End If
		
		If (_cameras = Null) _cameras = New IntSet()
		
		Local l:Int = cameras.Length()
		Local i:Int = 0
		
		While (i < l)
			_cameras.Insert(cameras[i])
			i += 1
		Wend
	End Method
	
	Method AddTween:FlxTween(tween:FlxTween, start:Bool = False)
		If (tween._parent <> Null) Then
			FlxG.Log("WARNING: Cannot add a FlxTween object more than once")
			Return tween
		End If
		
		tween._parent = Self
		
		If (_tweens = Null) _tweens = New List<FlxTween>()
		_tweens.AddLast(tween)
		
		If (start) tween.Start()
		
		Return tween
	End Method
	
	Method RemoveTween:FlxTween(tween:FlxTween, destroy:Bool = False)
		If (_tweens = Null) Return
	
		If (tween._parent <> Self) Then
			FlxG.Log("WARNING: Core object does not contain FlxTween")
			Return tween
		End If
		
		_tweens.RemoveEach(tween)
		
		If (destroy) tween.Destroy()
		tween.active = False
		
		Return tween
	End Method
	
	Method ClearTweens:Void(destroy:Bool = False)
		If (_tweens = Null) Return
	
		Local node:= _tweens.FirstNode()
		Local tween:FlxTween
				
		While (node <> Null)
			tween = node.Value()
			If (destroy) tween.Destroy()
			tween.active = False
			node = node.NextNode()
		Wend
		
		_tweens = Null
	End Method
	
	Method UpdateTweens:Void()
		If (_tweens = Null) Return
	
		Local node:= _tweens.FirstNode()
		Local tween:FlxTween
				
		While (node <> Null)
			tween = node.Value()
			
			If (tween.active) Then
				tween.Update()
				
				If (tween._finish) Then
					tween.Finish()
				End If
			End If
			
			node = node.NextNode()
		Wend
	End Method
	
	Method HasTween:Bool() Property
		Return(_tweens <> Null)
	End Method
	
	Method GetClassInfo:ClassInfo()
		Return _classInfo
	End Method
	
	#Rem
	summary:Convert object to readable string name.  Useful for debugging, save games, etc.
	#End
	Method ToString:String()
		Return _classInfo.Name[_classInfo.Name.FindLast(".")+1..]
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
