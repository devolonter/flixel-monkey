
Type flixel
	
	Function isMobile:Int()
		Return False
	End Function

End Type

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
End Function
