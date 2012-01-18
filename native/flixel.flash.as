
import flash.ui.Mouse;

class flixel {

	static public function systemMillisecs():int {
		return (new Date).getTime();
	}	
	
	static public function showMouse():void {
		Mouse.show();
	}
	
	static public function hideMouse():void {
		Mouse.hide();
	}

}
