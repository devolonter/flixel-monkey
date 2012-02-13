Strict

Import flixel.flxextern
Import flixel.flxtext

Import flixel.system.flxfont

Class FlxAssetsManager

Private
	Global _Fonts:StringMap<FlxFont>[]
	Global _Images:StringMap<String>
	Global _Sounds:StringMap<String>
	Global _Music:StringMap<String>
	Global _Cursors:StringMap<String>
	Global _Strings:StringMap<String>
	
Public	
	Function Init:Void()
		_Fonts = New StringMap<FlxFont>[FlxText.DRIVER_ANGELFONT+1]
	
		Local l:Int = _Fonts.Length()
		For Local i:Int = 0 Until l
			_Fonts[i] = New StringMap<FlxFont>()
		Next
		
		_Images = New StringMap<String>()
		_Sounds = New StringMap<String>()
		_Music = New StringMap<String>()
		_Cursors = New StringMap<String>()
		_Strings = New StringMap<String>()
	End Function
	
	Function AddFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Local font:FlxFont = _Fonts[driver].Get(name)
		If (font <> Null) Return font
		
		font = New FlxFont(name)
		_Fonts[driver].Set(name, font)
		
		Return font	
	End Function
	
	Function RemoveFont:Void(name:String, size:Int, driver:Int = FlxText.DRIVER_NATIVE)
		_Fonts[driver].RemoveFontPath(name, size)	
	End Function
	
	Function GetFonts:StringMap<FlxFont>(driver:Int = FlxText.DRIVER_NATIVE)
		Return _Fonts[driver]
	End Function
	
	Function GetFont:FlxFont(name:String, driver:Int = FlxText.DRIVER_NATIVE)
		Return _Fonts[driver].Get(name)
	End Function
	
	Function AddImage:Void(name:String, path:String)
		_Images.Set(name, path)
	End Function
	
	Function RemoveImage:Void(name:String)
		_Images.Remove(name)
	End Function
	
	Function GetImagePath:String(name:String)
		Return _Images.Get(name)
	End Function
	
	Function AllImages:MapKeys()
		Return _Images.Keys()
	End Function
	
	Function AddSound:Void(name:String, path:String)
		_Sounds.Set(name, path)
	End Function
	
	Function RemoveSound:Void(name:String)
		_Sounds.Remove(name)
	End Function
	
	Function GetSoundPath:String(name:String)
		Return _Sounds.Get(name)
	End Function
	
	Function AllSounds:MapKeys()
		Return _Sounds.Keys()
	End Function
	
	Function AddMusic:Void(name:String, path:String)
		_Music.Set(name, path)
	End Function
	
	Function RemoveMusic:Void(name:String)
		_Music.Remove(name)
	End Function
	
	Function GetMusicPath:String(name:String)
		Return _Music.Get(name)
	End Function
	
	Function AllMusic:MapKeys()
		Return _Music.Keys()
	End Function
	
	Function AddCursor:Void(cursor:String, path:String)
		_Cursors.Set(cursor, path)
	End Function
	
	Function RemoveCursor:Void(cursor:String)
		_Cursors.Remove(cursor)
	End Function
	
	Function GetCursorPath:String(cursor:String)
		Return _Cursors.Get(cursor)
	End Function
	
	Function AllCursors:MapKeys()
		Return _Cursors.Keys()
	End Function
	
	Function AddString:Void(string:String, path:String)
		_Strings.Set(string, path)
	End Function
	
	Function RemoveString:Void(string:String)
		_Strings.Remove(string)
	End Function
	
	Function GetString:String(string:String)
		Return LoadString(_Strings.Get(string))
	End Function
	
	Function AllStrings:MapKeys()
		Return _Cursors.Keys()
	End Function

End Class