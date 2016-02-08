#Flixel for Monkey

This is a port of flixel to the [Monkey](http://www.monkeycoder.co.nz/) language.
The port is translated from [flixel](http://flixel.org/) v2.55 written by Adam 'Atomic' Saltsman.

###Requirements

Monkey v60 or higher

###Supported targets

HTML5, Flash, Android, iOS, XNA, GLFW, PSM, Win8, WP8

###Install

* For users with git installed:
	* Go to the Monkey modules directory 
	* Do `git clone git@github.com:devolonter/flixel-monkey.git flixel`
	* Optionally. Do `git submodule update --init` to get bananas
	
* For users without git:
	* Download archive [flixel-monkey-lastest-stable.zip](http://download.flixelmonkey.com/dist/v1.0.0-beta.1/flixel-monkey-v1.0.0-beta.1.zip) or [flixel-monkey-lastest-stable-full.zip](http://download.flixelmonkey.com/dist/v1.0.0-beta.1/flixel-monkey-v1.0.0-beta.1-full.zip) (with bananas) from downloads section 
	* Extract archive into the Monkey modules directory
	
###Upgrade to new version

* For users with git installed:
	* `git pull`
	* Optionally. Do `git submodule update` to update bananas
	
* For users without git:
	* Download the latest version of the library from downloads directory
	* Replace flixel module content by archive data
	
###Naming conventions

* All-caps case (eg: 'ALLCAPS' ): Constants
* Pascal case (eg: 'PascalCase' ): Globals, functions, class, methods, properties
* Camel case (eg: 'camelCase' ): Fields, locals and function parameters
	
###Notes

* FlxSave currently is not ported
* Debugger is absent
* To build  Windows Phone applications you must add a reference to Microsoft.Phone to the project 
	
###Demo

* [Mode Game](http://lab.devolonter.ru/libs/monkey-flixel/mode/html5.html)
* [Invaders Game](http://lab.devolonter.ru/libs/monkey-flixel/flxinvaders/html5.html)
* [Split Screen](http://lab.devolonter.ru/libs/monkey-flixel/splitscreen/html5.html)
* [Path Finding](http://lab.devolonter.ru/libs/monkey-flixel/pathfinding/html5.html) 
* [Replay](http://lab.devolonter.ru/libs/monkey-flixel/replay/html5.html) 
* [Collisions](http://lab.devolonter.ru/libs/monkey-flixel/collisions/html5.html) 
* [Tilemap](http://lab.devolonter.ru/libs/monkey-flixel/tilemap/html5.html) 
* [Particles](http://lab.devolonter.ru/libs/monkey-flixel/particles/html5.html)
* [Resolution policies](http://lab.devolonter.ru/libs/monkey-flixel/resolutionpolicy/html5.html)
* [Tweening](http://lab.devolonter.ru/libs/monkey-flixel/tweening/html5.html)
* [Platformer](http://lab.devolonter.ru/libs/monkey-flixel/platformer/html5.html)


###QuickStart

```
Import flixel

#REFLECTION_FILTER+="${MODPATH}*"

Function Main()
	New HelloWorld()
	Return 0
End Function

'Main class of the game
Class HelloWorld Extends FlxGame
	
	Method New()
		Super.New(640, 480, GetClass("HelloWorldState"))	
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
	
End Class
```

See more examples in the [bananas](https://github.com/devolonter/flixel-monkey-bananas) folder.
