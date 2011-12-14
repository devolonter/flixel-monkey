Strict

Class FlxFont
Private
	Field _minSize:Int = 65536
	Field _maxSize:Int = -1
	Field _paths:IntMap<String>
	Field _name:String
	
Public
	Method New(name:String)
		_name = name
		_paths = New IntMap<String>()
	End Method

	Method GetValidSize:Int(size:Int)
		Return Clamp(size, _minSize, _maxSize)		
	End Method
	
	Method MinSize:Int() Property
		Return _minSize
	End Method
	
	Method MinSize:Void(size:Int) Property
		_minSize = Min(_minSize, size)
	End Method
	
	Method MaxSize:Int() Property
		Return _maxSize
	End Method
	
	Method MaxSize:Void(size:Int) Property
		_maxSize = Max(_maxSize, size)
	End Method
	
	Method SetPath:Void(size:Int, path:String)		
		_paths.Set(size, path)
		
		MinSize = size
		MaxSize = size
	End Method
	
	Method GetPath:String(size:Int)
		Return _paths.Get(size)
	End Method
	
	Method Name:String() Property
		Return _name
	End Method
			
End Class