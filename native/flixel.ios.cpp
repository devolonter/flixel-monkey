class flixel {public:	static int systemMillisecs() {		uint64_t nanos=mach_absolute_time();		nanos*=timeInfo.numer;		nanos/=timeInfo.denom;		return nanos/1000000L;	}		static void showMouse() {	}		static void hideMouse() {	}		static bool isMobile() {		return true;	}	}