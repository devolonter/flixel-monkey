Strict

Import flxpoint
Import flxrect
Import flxbasic
Import flxgroup
Import flxobject
Import flxsprite
Import flxtext
Import flxstate
Import flxtimer
Import flxg
Import flxgame
Import flxu

Import plugin.monkey.flxcolor
Import plugin.monkey.flxassetsmanager
Import plugin.monkey.flxresourcesmanager
Import plugin.monkey.flxfont

Import "native/flixel.${TARGET}.${LANG}"

Extern

#If LANG="cpp" Then
	Function SystemMillisecs:Int() = "flixel::systemMillisecs"
#Else
	Function SystemMillisecs:Int() = "flixel.systemMillisecs"
#End

Public

Interface FlxClass
	
	Method CreateInstance:FlxBasic()
	
	Method InstanceOf:Bool(object:FlxBasic)

End Interface

Interface FlxFunction
	
	Method Call:Void()

End Interface

Class FlxArray<T>
	
	Field data:T[]
	
	Method New(data:T[])
		Self.data = data
	End Method
	
	Method GetRandom:T(startIndex:Int = 0, length:Int = 0)
		If (data <> Null) Then
			Local l:Int = length
			
			If (l = 0 Or l > data.Length() - startIndex) Then
				l = data.Length() - startIndex
			End if
			
			If (l > 0) Return data[startIndex + int(Rnd()*l)]	
		End If
		
		Return Null
	End Method
	
	'Get safe random for replays/recordings
	Method GetSafeRandom:T(startIndex:Int = 0, length:Int = 0)
		If (data <> Null) Then
			Local l:Int = length
			
			If (l = 0 Or l > data.Length() - startIndex) Then
				l = data.Length() - startIndex
			End if
			
			If (l > 0) Return data[startIndex + int(FlxG.Random()*l)]	
		End If
		
		Return Null
	End Method
	
	Method Shuffle:Void(howManyTimes:Int)
		Local i:Int 
		Local index1:Int
		Local index2:Int
		Local object:T
		
		While(i < howManyTimes)
			index1 = Rnd() * data.Length()
			index2 = Rnd() * data.Length()
			object = data[index2]
			data[index2] = data[index1]
			data[index1] = object
			i += 1	
		Wend
	End Method
	
	'Safe shuffle for replays/recordings
	Method SafeShuffle:Void(howManyTimes:Int)
		Local i:Int 
		Local index1:Int
		Local index2:Int
		Local object:T
		
		While(i < howManyTimes)
			index1 = FlxG.Random() * data.Length()
			index2 = FlxG.Random() * data.Length()
			object = data[index2]
			data[index2] = data[index1]
			data[index1] = object
			i += 1	
		Wend	
	End Method

End Class
