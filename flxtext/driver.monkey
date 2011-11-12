Strict

Import flixel.flxg

Class TextDriver<T>

	Field name:String

Private
	Field _filename:String = Null	

Public
	Method GetFileName:String(fontName:String, fontSize:Int, system:Bool = False)	
		If (_filename <> Null) Then
			If (Not system) Return _filename
			Return FlxG.DATA_PREFIX + _filename
		End If		
		
		_filename = fontName + "_" + name + "_" + fontSize
		If (Not system) Return _filename
		Return FlxG.DATA_PREFIX + _filename
	End Method
	
	Method SetFormat:Void(font:String, size:Int, color:Color, alignment:Int, shadowColor:Color)
		SetFontName(font)
		SetSize(size)
		SetFontColor(color)
		SetAlignment(alignment)
		SetShadow(shadowColor)
	End Method
	
	Method SetFontName:Void(font:String) Abstract
	
	Method GetFontName:String() Abstract
	
	Method SetSize:Void(size:Int) Abstract
	
	Method GetSize:Int() Abstract

	Method SetText:Void(text:String) Abstract	
	
	Method GetText:String() Abstract
	
	Method SetFontColor:Void(color:Color) Abstract	
	
	Method GetFontColor:Color() Abstract
	
	Method SetAlignment:Void(alignment:Int) Abstract	
	
	Method GettAlignment:Int() Abstract
	
	Method SetShadow:Void(color:Color) Abstract	
	
	Method GetShadow:Color() Abstract		

	Method Draw:Void() Abstract
	
	Method Destroy:Void()
	
End Class