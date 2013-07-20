Strict

Import flixel.flxextern
Import flixel.flxtext

Import flixel.system.flxfont

Class FlxAssetsManager

Private
	Global _Fonts:StringMap<FlxFont>
	Global _Images:StringMap<String>
	Global _Sounds:StringMap<String>
	Global _Music:StringMap<String>
	Global _Cursors:StringMap<String>
	Global _Strings:StringMap<String>
	
Public	
	Function Init:Void()
		_Fonts = New StringMap<FlxFont>()
		_Images = New StringMap<String>()
		_Sounds = New StringMap<String>()
		_Music = New StringMap<String>()
		_Cursors = New StringMap<String>()
		_Strings = New StringMap<String>()
	End Function
	
	Function AddFont:FlxFont(name:String)
		Local font:FlxFont = _Fonts.Get(name)
		If (font <> Null) Return font
		
		font = New FlxFont(name)
		_Fonts.Set(name, font)
		
		Return font	
	End Function
	
	Function RemoveFont:Void(name:String)
		_Fonts.Remove(name)
	End Function
	
	Function GetFonts:StringMap<FlxFont>()
		Return _Fonts
	End Function
	
	Function GetFont:FlxFont(name:String)
		Return _Fonts.Get(name)
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
	
	Function AllImages:MapKeys<String, String>()
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
	
	Function AllSounds:MapKeys<String, String>()
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
	
	Function AllMusic:MapKeys<String, String>()
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
	
	Function AllCursors:MapKeys<String, String>()
		Return _Cursors.Keys()
	End Function
	
	Function AddString:Void(name:String, path:String)
		_Strings.Set(name, path)
	End Function
	
	Function RemoveString:Void(name:String)
		_Strings.Remove(name)
	End Function
	
	Function GetStringPath:String(name:String)
		Return _Strings.Get(name)
	End Function
	
	Function GetString:String(name:String)
		Return LoadString(_Strings.Get(name))
	End Function
	
	Function AllStrings:MapKeys<String, String>()
		Return _Cursors.Keys()
	End Function

End Class