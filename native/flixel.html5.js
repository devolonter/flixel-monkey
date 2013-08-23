
var flixel = {
	
	_validAudioExt: null,

	isMobile: function(undefined) {
		if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
			return true;
		}
		
		return false;
	},
	
	getValidSoundExt: function() {
		return flixel.getValidAudioExt();
	},
	
	getValidMusicExt: function() {
		return flixel.getValidAudioExt();
	},
	
	getValidAudioExt: function() {	
		if (flixel._validAudioExt === null) {
			var a = document.createElement('audio');
			var ext = 'wav';
			
			if (!!(a.canPlayType && a.canPlayType('audio/ogg; codecs="vorbis"').replace(/no/, ''))) {
				ext = 'ogg';
			} else if (!!(a.canPlayType && a.canPlayType('audio/mpeg;').replace(/no/, ''))) {
				ext = 'mp3';
			}
			
			flixel._validAudioExt = ext;
		}
		
		return flixel._validAudioExt;
	}

}
