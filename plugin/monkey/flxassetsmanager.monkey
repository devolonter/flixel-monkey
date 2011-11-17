Strict

Import flixel.flxtext

Class FlxAssetsManager

	Global _fonts:FlxAssetsFontsList[] = New FlxAssetsFontsList[FlxText.DRIVER_ANGELFONT+1]
	
	Function Init:Void()
		Local l:Int = _fonts.Length()
		For Local i:Int = 0 Until l
			_fonts[i] = New FlxAssetsFontsList()
		Next
	End Function
	
	Function RegisterFont:Void(name:String, size:Int, path:String, driver:Int = FlxText.DRIVER_FONTMACHINE)
		_fonts[driver].AddFontPath(name, size, path)	
	End Function
	
	Function UnregisterFont:Void(name:String, size:Int, driver:Int = FlxText.DRIVER_FONTMACHINE)
		_fonts[driver].RemoveFontPath(name, size)	
	End Function
	
	Function GetFontPath:String(name:String, size:Int, driver:Int = FlxText.DRIVER_FONTMACHINE)
		Return _fonts[driver].GetFontPath(name, size)	
	End Function
	
	Function GetValidFontSize:Int(name:String, size:Int, driver:Int = FlxText.DRIVER_FONTMACHINE)
		Return _fonts[driver].GetValidFontSize(name, size)
	End Function

End Class

Private
Class FlxAssetsFontsList Extends StringMap<String>

	Method New()
		_fontSizes = New StringMap<FlxFontSizes>()
	End Method

	Method GetFontPath:String(name:String, size:Int)
		Return Get(name+"/"+size)
	End Method

	Method AddFontPath:Void(name:String, size:Int, path:String)
		If (Not _fontSizes.Contains(name)) Then
			_fontSizes.Set(name, New FlxFontSizes())	
		End If
		
		Local fontSize:FlxFontSizes = _fontSizes.Get(name)
	
		fontSize.min = Min(fontSize.min, size)
		fontSize.max = Max(fontSize.max, size)		
		
		Set(name+"/"+size, path)
	End Method
	
	Method RemoveFontPath:Int(name:String, size:Int)
		Local fontSize:FlxFontSizes = _fontSizes.Get(name)
	
		If (size = fontSize.min) Then
			If (fontSize.min <> fontSize.max) Then
				fontSize.min+=1
			Else
				_fontSizes.Remove(name)
			End If
		End If
		
		Return Remove(name+"/"+size)
	End Method
	
	Method GetValidFontSize:Int(name:String, size:Int)
		Local fontSize:FlxFontSizes = _fontSizes.Get(name)	
		Return Clamp(size, fontSize.min, fontSize.max)		
	End Method

Private	
	Field _fontSizes:StringMap<FlxFontSizes>	

End Class

Private
Class FlxFontSizes
	Field min:Int = 65536
	Field max:Int = -1		
End Class