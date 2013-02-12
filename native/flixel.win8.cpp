
class flixel {

public:
	
	static bool isMobile() {
		return true;
	}
	
	static void openURL(String url) {
		auto uriToLaunch = ref new Platform::String(url.Data(), url.Length());
		auto uri = ref new Windows::Foundation::Uri(uriToLaunch);
		concurrency::task<bool> launchUriOperation(Windows::System::Launcher::LaunchUriAsync(uri));
	}
	
};
