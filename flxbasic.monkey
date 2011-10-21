#Rem 
Header:This is a useful "generic" Flixel object.
Both [code]FlxObject[/code] and [code]FlxGroup[/code] extend this class, 
as do the plugins.  Has no size, position or graphical data.

[b]Author:[/b] Adam Atomic
[b]Ported:[/b] Arthur Bikmullin (@devolonter)
#End

Import flxcamera
Import flxg

Class FlxBasic

Private
	Global _ACTIVECOUNT:Int
	Global _VISIBLECOUNT:Int	

Public
	#Rem
	summary: IDs seem like they could be pretty useful, huh?
	They're not actually used for anything yet though.
	#End
	Field ID:Int
	
	#Rem
	summary: Controls whether [code]update()[/code] and [code]draw()[/code] 
	are automatically called by FlxState/FlxGroup.
	#End
	Field exists:Bool
	
	#Rem
	summary: Controls whether [code]update()[/code] is automatically called by FlxState/FlxGroup.
	#End
	Field active:Bool
	
	#Rem
	summary: Controls whether [code]draw()[/code] is automatically called by FlxState/FlxGroup.
	#End
	Field visible:Bool
	
	#Rem
	summary: Useful state for many game objects - "dead" (!alive) vs alive.
	[code]kill()[/code] and [code]revive()[/code] both flip this switch (along with exists, but you can override that).
	#End
	Field alive:Bool
	
	#Rem
	summary: An array of camera objects that this object will use during [code]draw()[/code].
	This value will initialize itself during the first draw to automatically
	point at the main camera list out in [code]FlxG[/code] unless you already set it.
	You can also change it afterward too, very flexible!
	#End
	Field cameras:Stack<FlxCamera>
	
	#Rem
	summary: Setting this to true will prevent the object from appearing
	when the visual debug mode in the debugger overlay is toggled on.
	#End
	Field ignoreDrawDebug:Bool
	
	#Rem
	summary: Instantiate the basic flixel object.
	#End	
	Method New()
		ID = -1
		exists = True
		active = True
		visible = True
		alive = True
		ignoreDrawDebug = False	
	End Method
	
	#Rem
	summary: Override this function to null out variables or manually call
	[code]destroy()[/code] on class members if necessary.
	Don't forget to call [code]super.destroy()[/code]!
	#End
	Method destroy:Void()		
	End Method
	
	#Rem
	summary: Pre-update is called right before [code]update()[/code] on each object in the game loop.
	#End
	Method preUpdate:Void()
		_ACTIVECOUNT+=1
	End Method
	
	#Rem
	summary: Override this function to update your class's position and appearance.
	This is where most of your game rules and behavioral code will go.
	#End
	Method update:Void()
	End Method
	
	#Rem
	summary: Post-update is called right after [code]update()[/code] on each object in the game loop.
	#End
	Method postUpdate:Void()
	End Method
	
	#Rem
	summary: Override this function to control how the object is drawn.
	Overriding [code]draw()[/code] is rarely necessary, but can be very useful.
	#End
	Method draw:Void()		
		If (cameras = null) cameras = FlxG.cameras
		
		For Local camera:FlxCamera = EachIn cameras
			_VISIBLECOUNT+=1			
			If (FlxG.visualDebug And Not ignoreDrawDebug) drawDebug(camera)				
		Next
	End Method
	
	#Rem
	summary: Override this function to draw custom "debug mode" graphics to the
	specified camera while the debugger's visual mode is toggled on.
	
	[b]camera:[/b] Camera Which camera to draw the debug visuals to.
	#End
	Method drawDebug:Void(camera:FlxCamera = null)
	End Method
	
	#Rem
	summary: Handy function for "killing" game objects.
	Default behavior is to flag them as nonexistent AND dead.
	However, if you want the "corpse" to remain in the game,
	like to animate an effect or whatever, you should override this,
	setting only alive to false, and leaving exists true.
	#End
	Method kill:Void()
		alive = False
		exists = False
	End Method
	
	#Rem
	summary: Handy function for bringing game objects "back to life". Just sets alive and exists back to true.
	In practice, this function is most often called by [code]FlxObject.reset()[/code].
	#End
	Method revive:Void()
		alive = True
		exists = True
	End Method
	
	Method toString:String()
		Return "FlxBasic"
	End Method

End Class