
var flixel = new Object();

flixel.systemMillisecs = function() {
	return (new Date).getTime()
}

flixel.showMouse = function() {
	document.getElementById("GameCanvas").style.cursor = 'default';
}

flixel.hideMouse = function() {
	document.getElementById("GameCanvas").style.cursor = 'url(data/flx_empty_cursor.png), auto';
}
