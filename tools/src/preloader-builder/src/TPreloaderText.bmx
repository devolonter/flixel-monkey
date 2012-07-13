
Type TPreloaderText Extends TPreloaderObject

	Const MIN_SIZE:Int = 8

	Const MAX_SIZE:Int = 32

	Global Fonts:TImageFont[MAX_SIZE + 1]
	
	Field size:Int
	
	Field text:String
	
	Method New()
		If (Fonts[MIN_SIZE] = Null) Then
			For Local i:Int = MIN_SIZE To MAX_SIZE
				Fonts[i] = LoadImageFont("incbin::res\system\font.ttf", i)
			Next
		End If
		
		size = 12
		text = "Text Sample"
		Update()
	End Method
	
	Method SetText(text:String)
		Self.text = text
		Update()
	End Method
	
	Method SetSize(size:Int)
		Self.size = size
		Update()
	End Method
	
	Method Update()
		SetImageFont(Fonts[size])
		width = TextWidth(text)
		height = TextHeight(height)
	End Method
	
	Method Draw()
		SetImageFont(Fonts[size])
		SetColor(color.r, color.g, color.b)
		DrawText(text, x, y)
		SetColor(255, 255, 255)
	End Method

End Type
