Strict

Import flixel.flxtext

Class FlxFontManager<T>

Private	
	Field _fonts:StringMap<T[]>

Public
	Method New()
		_fonts = New StringMap<T[]>()
	End Method
	
	Method GetFont:T(font:String, size:Int)
		If (Not _fonts.Contains(font)) Return Null
		Return 	_fonts.Get(font)[size - FlxText.MIN_SIZE]		
	End Method
	
	Method AddFont:Void(font:String, size:Int, value:T)
		Local fontArray:T[]
		fontArray = fontArray.Resize(FlxText.MAX_SIZE - FlxText.MIN_SIZE + 1) 
		_fonts.Set(font, fontArray)		
		_fonts.Get(font)[size - FlxText.MIN_SIZE] = value
	End Method 

End Class