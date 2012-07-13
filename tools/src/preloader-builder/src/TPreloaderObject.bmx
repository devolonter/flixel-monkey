
Type TPreloaderObject Abstract

	Field x:Int
	
	Field y:Int
	
	Field width:Int
	
	Field height:Int
	
	Field color:TColor
	
	Field context:TCanvas
	
	Method New()
		color = New TColor
	End Method
	
	Method Create:TPreloaderObject(context:TCanvas)
		Self.context = context
		Return Self
	End Method
	
	Method GetApplication:TApplication()
		Return context.context
	End Method

End Type
