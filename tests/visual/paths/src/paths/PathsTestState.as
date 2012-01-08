package paths 
{
	import org.flixel.*;
	
	public class PathsTestState extends FlxState 
	{
		
		public var pathFrowardedObject:FlxObject;
		public var pathForward:FlxPath;
		
		public var pathBackwardedObject:FlxObject;
		public var pathBackward:FlxPath;
		
		public var pathLoopForwadedObject:FlxObject;
		public var pathLoopForward:FlxPath;
		
		public var pathLoopBackwardedObject:FlxObject;
		public var pathLoopBackward:FlxPath;
		
		override public function create():void 
		{	
			var offsetX:Number = 90
			
			pathForward = new FlxPath();
			pathForward.add(offsetX + 75, 125);
			pathForward.add(offsetX + 75, 325);
			
			pathFrowardedObject = new FlxObject(offsetX + 50, 200, 50, 50);			
			add(pathFrowardedObject);
			
			pathBackward = new FlxPath();
			pathBackward.add(offsetX + 175, 125);
			pathBackward.add(offsetX + 175, 325);
			
			pathBackwardedObject = new FlxObject(offsetX + 150, 200, 50, 50);			
			add(pathBackwardedObject);
			
			pathLoopForward = new FlxPath();
			pathLoopForward.add(offsetX + 275, 125);
			pathLoopForward.add(offsetX + 275, 325);
			
			pathLoopForwadedObject = new FlxObject(offsetX + 250, 200, 50, 50);			
			add(pathLoopForwadedObject);
			
			pathLoopBackward = new FlxPath();
			pathLoopBackward.add(offsetX + 375, 125);
			pathLoopBackward.add(offsetX + 375, 325);
			
			pathLoopBackwardedObject = new FlxObject(offsetX + 350, 200, 50, 50);			
			add(pathLoopBackwardedObject);
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("SPACE")) {
				pathFrowardedObject.followPath(pathForward, 50, FlxObject.PATH_FORWARD);
				pathBackwardedObject.followPath(pathBackward, 50, FlxObject.PATH_BACKWARD);
				pathLoopForwadedObject.followPath(pathLoopForward, 50, FlxObject.PATH_LOOP_FORWARD);
				pathLoopBackwardedObject.followPath(pathLoopBackward, 50, FlxObject.PATH_LOOP_BACKWARD);
			}
			
			super.update();
		}
		
	}

}