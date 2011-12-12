SuperStrict

Framework brl.filesystem
Import brl.retro

Global section:String = "char"

For Local i:Int = 1 To AppArgs.length - 1
	ParseFile(AppArgs[i])
Next

Function ParseFile(filename$)
	Local in:TStream = ReadFile(filename)
	If (Not in) Return
	Local out:TStream = WriteFile(StripExt(filename)+".txt")
	If (Not out) Return
	
	WriteLine out, "id,x,y,width,height,xoffset,yoffset,xadvance,page,chnl"
	While Not Eof(in)
		Local before$ = ReadLine(in)
		Local after$ = ParseLine(before)
		If after <> "" WriteLine out, after
	Wend
	CloseFile out
	CloseFile in

	RenameFile(StripExt(filename) + "_0.png", StripExt(filename) + ".png")
End Function


Function ParseLine$(line$)
	Local result$ = ""
	line = Trim(line)
	If line.StartsWith("char id=")
		Local parts$[] = line.Split(" ")
		For Local part$ = EachIn parts
			If part.Contains("=")
				Local dec$[] = part.Split("=")
				result :+ dec[1]+","
				result = Replace(result,Chr(34),"")
			EndIf
			
		Next
		result = result[..result.length-1]
	EndIf
	Return result
End Function





