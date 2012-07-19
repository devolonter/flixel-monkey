
Type TPreloaderObject Abstract

	Global inc:Int

	Field x:Int
	
	Field y:Int
	
	Field width:Int
	
	Field height:Int	
	
	Field weight:Int
	
	Field color:TColor
	
	Field context:TCanvas
	
	Method New()
		color = New TColor
		weight = inc
		TPreloaderObject.inc:+1
	End Method
	
	Method Create:TPreloaderObject(context:TCanvas)
		Self.context = context
		Return Self
	End Method
	
	Method Destroy()
		color = Null
		context = Null
	End Method
	
	Method GetApplication:TApplication()
		Return context.context
	End Method
	
	Method Draw() Abstract

End Type
