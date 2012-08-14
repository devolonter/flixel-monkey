Changelog
=
______________________________________________________

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