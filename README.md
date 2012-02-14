Flixel For Monkey
=================

This is a port of flixel to the Monkey language.
The port is translated from [flixel](http://flixel.org/) v2.55 written by Adam 'Atomic' Saltsman.

Requirements
------------

Monkey v53 or higher

Install
-------

* For users with git installed:
	* Go to the Monkey modules directory 
	* Do **git clone git@github.com:devolonter/flixel-monkey.git flixel**
	* Optionally. Do git **submodule update --init** to get bananas
	
* For users without git:
	* Download archive [flixel-monkey-lastest-stable.zip](https://github.com/downloads/devolonter/flixel-monkey/flixel-monkey-lastest-stable.zip) or [flixel-monkey-lastest-stable-full.zip](https://github.com/downloads/devolonter/flixel-monkey/flixel-monkey-lastest-stable-full.zip) (with bananas) from downloads directory 
	* Extract archive into the Monkey modules directory
	
Upgrade to new version
----------------------

* For users with git installed:
	* **git pull**
	* Optionally. Do git **submodule update** to update bananas
	
* For users without git:
	* Download the latest version of the library from downloads directory
	* Replace flixel module content by archive data
	
Naming conventions
------------------

* All-caps case (eg: 'ALLCAPS' ): Constants
* Pascal case (eg: 'PascalCase' ): Globals, functions, class, methods, properties
* Camel case (eg: 'camelCase' ): Fields, locals and function parameters
	
Notes
-----

* FlxSave currently is not ported
* Debugger is absent
* To build  Windows Phone applications you must add a reference to Microsoft.Phone to the project 
	
Demo
----

* [Mode Game](http://lab.devolonter.ru/libs/monkey-flixel/mode/html5.html)
* [Invaders Game](http://lab.devolonter.ru/libs/monkey-flixel/flxinvaders/html5.html)
* [Split Screen](http://lab.devolonter.ru/libs/monkey-flixel/splitscreen/html5.html)
* [Path Finding](http://lab.devolonter.ru/libs/monkey-flixel/pathfinding/html5.html) 
* [Replay](http://lab.devolonter.ru/libs/monkey-flixel/replay/html5.html) 
* [Collisions](http://lab.devolonter.ru/libs/monkey-flixel/collisions/html5.html) 
* [Tilemap](http://lab.devolonter.ru/libs/monkey-flixel/tilemap/html5.html) 
* [Particles](http://lab.devolonter.ru/libs/monkey-flixel/particles/html5.html)	

QuickStart
----------

```
Import flixel

Function Main()
	New HelloWorld()
	Return 0
End Function

'Main class of the game
Class HelloWorld Extends FlxGame
	
	Method New()
		Super.New(640, 480, HelloWorldState.ClassObject)	
	End Method
	
	'Optional
	Method OnContentInit:Void()
		#Rem
		Register here all your assets, to use within application
		Example:
		FlxAssetsManager.AddImage("ball", "graphics/ball.png")
		
		Now you can load an image in the game this way:
		Local sprite:FlxSprite = New FlxSprite(0, 0, "ball")
		#End
	End Method

End Class

'Main game state 
Class HelloWorldState Extends FlxState

	'necessary to the FlxGame constructor, also used to reset game
	Global ClassObject:FlxClass = new HelloWorldClass()
	
	Method Create:Void()		
		Local helloWorld:FlxText = New FlxText(10, 10, 620, "Hello World!")	
		helloWorld.SetFormat(FlxText.SYSTEM_FONT, 16, FlxG.WHITE, FlxText.ALIGN_CENTER)	
		Add(helloWorld)		
	End Method
	
	Method Update:Void()
		'put your game logic here
		Super.Update()
		'... or here
	End Method
	
	'If you do not use FlxG.ResetState, FlxG.ReloadReplay, FlxG.RecordReplay, it is optional to override this method.
	Method GetClass:FlxCalss()
		Return ClassObject
	End Method
	
End Class

'Monkey currently does not support reflection, so here we emulate necessary functional
Class HelloWorldClass Implements FlxClass

	'Creates new instance of an object
	Method CreateInstance:Object()
		Return New HelloWorldState()
	End Method
	
	'checks that the scanned object belongs to a class
	Method InstanceOf:Bool(object:Object)
		Return (HelloWorldState(object) <> Null)
	End Method

End Class
```

See more examples in the [bananas](https://github.com/devolonter/flixel-monkey-bananas) folder.