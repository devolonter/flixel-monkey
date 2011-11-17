Strict

Import flixel.flxtext

Class FlxFontManager<T>

Private	
	Field _fonts:StringMap<IntMap<T>>

Public
	Method New()
		_fonts = New StringMap<IntMap<T>>()
	End Method
	
	Method GetFont:T(font:String, size:Int)
		If (Not _fonts.Contains(font)) Return Null
		Return 	_fonts.Get(font).Get(size)		
	End Method
	
	Method AddFont:Void(font:String, size:Int, value:T)
		If (Not _fonts.Contains(font)) _fonts.Set(font, New IntMap<T>())
		_fonts.Get(font).Set(size, value)
	End Method 

End Class