Strict

Import flixel.flxextern
Import flixel.flxtext

Import flixel.system.flxfont

Class FlxAssetsManager

Private
	Global _fonts:StringMap<FlxFont>[]
	Global _images:StringMap<String>
	Global _sounds:StringMap<String>
	Global _music:StringMap<String>
	Global _cursors:StringMap<String>
	Global _strings:StringMap<String>
	
Public	
	Function Init:Void()
		_fonts = New StringMap<FlxFont>[FlxText.DRIVER_ANGELFONT+1]
	
		Local l:Int = _fonts.Length()
		For Local i:Int = 0 Until l
			_fonts[i] = New StringMap<FlxFont>()
		Next
		
		_images = New StringMap<String>()
		_sounds = New StringMap<String>()
		_music = New StringMap<String>()
		_cursors = New StringMap<String>()
		_strings = New StringMap<String>()
	End Function
	
	Function AddFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Local font:FlxFont = _fonts[driver].Get(name)
		If (font <> Null) Return font
		
		font = New FlxFont(name)
		_fonts[driver].Set(name, font)
		
		Return font	
	End Function
	
	Function RemoveFont:Void(name:String, size:Int, driver:Int = FlxText.DRIVER_NATIVE)
		_fonts[driver].RemoveFontPath(name, size)	
	End Function
	
	Function GetFonts:StringMap<FlxFont>(driver:Int = FlxText.DRIVER_NATIVE)
		Return _fonts[driver]
	End Function
	
	Function GetFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Return _fonts[driver].Get(name)
	End Function
	
	Function AddImage:Void(name:String, path:String)
		_images.Set(name, path)
	End Function
	
	Function RemoveImage:Void(name:String)
		_images.Remove(name)
	End Function
	
	Function GetImagePath:String(name:String)
		Return _images.Get(name)
	End Function
	
	Function AddSound:Void(name:String, path:String)
		_sounds.Set(name, path)
	End Function
	
	Function RemoveSound:Void(name:String)
		_sounds.Remove(name)
	End Function
	
	Function GetSoundPath:String(name:String)
		Return _sounds.Get(name)
	End Function
	
	Function AddMusic:Void(name:String, path:String)
		_music.Set(name, path)
	End Function
	
	Function RemoveMusic:Void(name:String)
		_music.Remove(name)
	End Function
	
	Function GetMusicPath:String(name:String)
		Return _music.Get(name)
	End Function
	
	Function AddCursor:Void(cursor:String, path:String)
		_cursors.Set(cursor, path)
	End Function
	
	Function RemoveCursor:Void(cursor:String)
		_cursors.Remove(cursor)
	End Function
	
	Function GetCursorPath:String(cursor:String)
		Return _cursors.Get(cursor)
	End Function
	
	Function AddString:Void(string:String, path:String)
		_strings.Set(string, path)
	End Function
	
	Function RemoveString:Void(string:String)
		_strings.Remove(string)
	End Function
	
	Function GetString:String(string:String)
		Return LoadString(_strings.Get(string))
	End Function

End Class