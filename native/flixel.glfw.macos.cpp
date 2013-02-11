
class flixel {

public:
	
	static bool isMobile() {
		return false;
	}
	
	static void openURL(String url) {
		String command = "open ";
		command += url;
		system(command.ToCString<char>());
	}
	
};
