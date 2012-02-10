
#include <time.h>
#include <math.h>
#include <Shellapi.h>

class flixel {

public:

	static int systemMillisecs() {
		double n;
		time_t t;
		struct tm * timeinfo;		
		time(&t);
		timeinfo = localtime(&t);
		int seconds = (timeinfo->tm_sec + timeinfo->tm_min * 60 + timeinfo->tm_hour * 3600);
		return  (seconds + modf(glfwGetTime(), &n)) * 1000;
	}
	
	static void showMouse() {
		ShowCursor(true);
	}
	
	static void hideMouse() {
		ShowCursor(false);
	}
	
	static bool isMobile() {
		return false;
	}
	
	static void openURL(String url) {
		LPCSTR request = url.ToCString<char>();
		ShellExecute(HWND_DESKTOP, "open", request, NULL, NULL, SW_SHOWNORMAL);
	}
	
};
