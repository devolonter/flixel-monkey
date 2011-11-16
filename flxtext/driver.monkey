Strict

Import flixel.flxg

Class FlxTextDriver

	Field name:String
	
	Field _system:Bool	

Private
	Field _filename:String = ""		

Public
	Method GetFileName:String(fontName:String)	
		If (_filename.Length <> 0) Then
			Return _filename
		End If		
		
		_filename = fontName + "_" + GetName() + "_font_"
		Return _filename
	End Method
	
	Method SetFormat:Void(fontName:String, size:Int, alignment:Int) Abstract
	
	Method GetName:String() Abstract
	
	Method SetWidth:Void(width:Int) Abstract
	
	Method SetFontName:Void(font:String) Abstract
	
	Method GetFontName:String() Abstract
	
	Method SetSize:Void(size:Int) Abstract
	
	Method GetSize:Int() Abstract

	Method SetText:Void(text:String) Abstract	
	
	Method GetText:String() Abstract
	
	Method SetAlignment:Void(alignment:Float) Abstract	
	
	Method GettAlignment:Float() Abstract	

	Method Draw:Void(x:Float, y:Float) Abstract
	
	Method Destroy:Void() Abstract
	
End Class