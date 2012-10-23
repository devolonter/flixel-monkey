
Type flixel

	Function systemMillisecs:Int()
		Return Millisecs()
	End Function
	
	Function hideMouse()
		bmxHideMouse()
	End Function
	
	Function showMouse()
		bmxShowMouse()
	End Function
	
	Function isMobile:Int()
		Return False
	End Function
	
	Function openURL(url:String)
		bmxOpenURL(url)
	End Function

End Type

Function bmxHideMouse()
	HideMouse()
EndFunction

Function bmxShowMouse()
	ShowMouse()
EndFunction

Function bmxOpenURL(url:String)
	OpenURL(url)
End Function

Function resize_array_array_XYZRecord:bb_xyzrecord__1X_1Y_1Z_1Record[][] (arr:bb_xyzrecord__1X_1Y_1Z_1Record[][], leng:Int)
	Local i:Int = arr.length
	arr = arr[..leng]
	
	If( leng<=i ) Return arr

	For Local l:Int = 0 Until Len(arr)
		arr[l] = arr[l][..leng]
	Next
	
	While( i<leng )
		arr[0][i]= Null
		i:+1
	Wend
	
	Return arr
EndFunction
