
Type TPreloaderObject Abstract

	Field x:Int
	
	Field y:Float
	
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
	
	Method Update() Abstract
	
	Method Draw() Abstract

End Type
