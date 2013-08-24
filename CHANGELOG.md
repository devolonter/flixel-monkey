#Changelog

###v1.0.0-beta.1 (2013.08.24)
* See: http://flixelmonkey.tumblr.com/post/59159365865/release-v1-0-0-beta-1

###v1.0a5 (2013.03.19)
* Compatibility with Monkey V67 and higher
* Win8/WP8 targets support added

###v1.0a4 (2012.08.14)
* Now minimal required Monkey version is V60
* Added resolution policies. These allow you to easily control the behavior of the screen when you change the size of the device. The following resolution policies are available: FillResolutionPolicy (by default), RatioResolutionPolicy, FixedResolutionPolicy and RelativeResolutionPolicy. In order to set the resolution policy, use the `FlxG.SetResolutionPolicy:Void(resolutionPolicy:FlxResolutionPolicy)`
* Added tweening system. The following tweenings are supported: Alarm, AngleTween, ColorTween, MultiVarTween, NumTween, VarTween and faders for sound effects. Also tweening system includes the following motion tweenings: CircularMotion, CubicMotion, LinearMotion, LinearPath, QuadMotion and QuadPath
* PSM target support added
* Full version now includes plugins from photonstorm
* The constructor of the class FlxGame accepts ClassInfo by the third parameter. For example, `New FlxGame (640, 480, GetClass ("HelloWorldState"))`
* FlxGroup.SetAll accepts the string field name (properties are also supported) by the first parameter 
* FlxGroup.CallAll accepts the string name of the function by the first parameter 
* FlxGroup.Sort accepts the string field name by the first parameter
* All globals ClassObject:Object declared inside each class are automatically initialized at the time of creating an instance of the game.
* There is no need to override GetClass method of the FlxState class
* The cursor and sound tray are no longer part of the main camera. Thus the zoom of the camera and its position doesn't act on them. Now they are the part of the screen and only valid screen size and global device scale factor act on them
* FlxSound.GetValidExt and FlxMusic.GetValidExt functions now return “ogg” for GLFW target
* The following interfaces are removed: FlxClass, FlxBasicSetter, FlxBasicInvoker, FlxBasicComparator
* FlxGame.useVirtualResolution field and FlxG.FullScreen function have been removed. Use resolution policies
* Fixed the cursor scale bug
* Fixed work of a few the buttons in several cameras
* Method FlxTilemap.Ray bug fixed
* Fixed auto tiling bug with FlxTilemap.ALT option
* Some minor bug fixes

###v1.0a3 (2012.06.28)
* Bug fixes

###v1.0a2 (2012.05.04)
* Compatibility with Monkey v58
* Added support of the Jungle IDE automatic module updater
* The prefix of internal library assets was changed by suffix _flx. Now you can filter the application resources using standard Monkey tools, without breaking the framework. For example, #IMAGE_FILES = "* _flx.png|* _your_filter.png"
* Added implementation of Revive method for FlxGroup class. This API is absent in original flixel
* Simplified the use of FlxBasic.Cameras property. Now, to specify object cameras use a simple snippet: object.Cameras = [id1, id2, ..]. Note that now FlxBasic.Cameras is a property, rather than a field and, therefore, a CamelCase is used
* Added support of the Cameras property for class FlxGroup. This API is absent in original flixel
* Added FlxText.GetFontObject method. In order for you to have the opportunity to customize the font properties for a particular object
* Added FlxG.RemoveBitmap function. This API is absent in original flixel
* Added the accelerometer support in WP7
* Improved class FlxQuadTree FlxObject.SeparateX and FlxObject.SeparateY functions. Now they do not generate a huge amount of garbage
* The use of class FlxArray is simplified. All methods are replaced by functions, and now you have to use it static. For example, `FlxArray<Int>.GetRandom(array)`
* Many other bug fixes 

###v1.0a (2012.02.15)
* Initial release