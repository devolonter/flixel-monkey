Strict

Import flixel.flxtext

Import flixel.plugin.monkey.flxfont

Class FlxAssetsManager

Private
	Global _fonts:StringMap<FlxFont>[] = New StringMap<FlxFont>[FlxText.DRIVER_ANGELFONT+1]
	
Public	
	Function Init:Void()
		Local l:Int = _fonts.Length()
		For Local i:Int = 0 Until l
			_fonts[i] = New StringMap<FlxFont>()
		Next
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

End Class