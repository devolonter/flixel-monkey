
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
