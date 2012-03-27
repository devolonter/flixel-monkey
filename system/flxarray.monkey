Strict

Import flixel.flxg

Class FlxArray<T>
	
	Function GetRandom:T(arr:T[], startIndex:Int = 0, length:Int = 0)
		If (arr.Length() <> 0) Then
			Local l:Int = length
			
			If (l = 0 Or l > arr.Length() - startIndex) Then
				l = arr.Length() - startIndex
			End if
			
			If (l > 0) Return arr[startIndex + int(Rnd()*l)]	
		End If
		
		Return Null
	End Function
	
	'Get safe random for replays/recordings
	Function GetSafeRandom:T(arr:T[], startIndex:Int = 0, length:Int = 0)
		If (arr.Length() <> 0) Then
			Local l:Int = length
			
			If (l = 0 Or l > arr.Length() - startIndex) Then
				l = arr.Length() - startIndex
			End if
			
			If (l > 0) Return arr[startIndex + int(FlxG.Random()*l)]	
		End If
		
		Return Null
	End Function
	
	Function Shuffle:Void(arr:T[], howManyTimes:Int)
		Local i:Int 
		Local index1:Int
		Local index2:Int
		Local object:T
		
		While(i < howManyTimes)
			index1 = Rnd() * arr.Length()
			index2 = Rnd() * arr.Length()
			object = arr[index2]
			arr[index2] = arr[index1]
			arr[index1] = object
			i += 1	
		Wend
	End Function
	
	'Safe shuffle for replays/recordings
	Function SafeShuffle:Void(arr:T[], howManyTimes:Int)
		Local i:Int 
		Local index1:Int
		Local index2:Int
		Local object:T
		
		While(i < howManyTimes)
			index1 = FlxG.Random() * arr.Length()
			index2 = FlxG.Random() * arr.Length()
			object = arr[index2]
			arr[index2] = arr[index1]
			arr[index1] = object
			i += 1	
		Wend	
	End Function
	
	Function Format:String(arr:T[])
		If (arr.Length() = 0) Return ""
				
		Local result:StringStack = New StringStack()
		result.Push(arr[0])
		
		Local i:Int = 1
		Local l:Int = arr.Length()
		
		While (i < l)
			result.Push("," + arr[i])
			i += 1
		Wend
		
		Return result.Join("")
	End Function

End Class