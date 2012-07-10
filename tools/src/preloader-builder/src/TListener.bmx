'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TListener Abstract

	Field context:TApplication
	
	Method Create(context:TApplication)
		Self.context = context
	End Method
	
	Method OnEvent() Abstract

End Type
