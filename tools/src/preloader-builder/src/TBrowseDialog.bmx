
Type TBrowseDialog Extends TDialog

	Field result:TGadget
	
	Field browse:TGadget

	Method OnBuild()
		Local resultWidth:Int = window.width *.8
		Local resultHeight:Int = 22
		Local padding:Int = 6
		Local margin:Int = 10
		Local browseWidth:Int = window.width - (resultWidth + padding * 2 + margin)
		
		result = CreateTextField(padding, padding, resultWidth - margin, resultHeight, window)
		browse = CreateButton("...", resultWidth + padding + margin,  ..
							padding, browseWidth, resultHeight, window)
		
	End Method
	
	Method OnConfirm:Int()
		Return True
	End Method
	
	Method GetResult:String()
		Return result.GetText()
	End Method

End Type
