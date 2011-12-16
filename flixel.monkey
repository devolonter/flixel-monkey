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
		
	End Method
	
	'Get safe random for replays/recordings
	Method GetSafeRandom:T(startIndex:Int = 0, length:Int = 0)
		
	End Method
	
	Method Shuffle:Void(howManyTimes:Int)
		
	End Method
	
	'Safe shuffle for replays/recordings
	Method SafeShuffle:Void(howManyTimes:Int)
		
	End Method

End Class
