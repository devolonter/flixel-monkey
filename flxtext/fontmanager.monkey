Strict

Import flixel.flxtext

Class FontManager<T>

Private	
	Field _fonts:StringMap<T[]>

Public
	Method New()
		_fonts = New StringMap<T[]>()
	End Method
	
	Method GetFont:T(fontName:String, fontSize:Int)
		If (Not _fonts.Contains(fontName)) Return Null
		Return 	_fonts.Get(fontName)[fontSize - FlxText.MIN_SIZE]		
	End Method
	
	Method AddFont:Void(font:T, fontName:String, fontSize:Int)
		Local fontArray:T[]
		fontArray = fontArray.Resize(FlxText.MAX_SIZE - FlxText.MIN_SIZE + 1) 
		_fonts.Set(fontName,fontArray)		
		_fonts.Get(fontName)[fontSize - FlxText.MIN_SIZE] = font
	End Method 

End Class