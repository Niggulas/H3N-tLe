// Function to check if the series already present in the library
Object.defineProperty(window, 'doesSeriesExist', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: (seriesName) => {
		if (typeof seriesName !== 'string') {
			throw new Error('Series name must be a String');
		} else if (seriesName.length < 1) {
			throw new Error("Series name can't be empty");
		}

		return new Promise((resolve, reject) => {
			window.postWebKitMessage(['DoesSeriesExist', seriesName], true).then((state) => {
				if (state === 'present') {
					resolve(true);
					return;
				} else if (state === 'absent') {
					resolve(false);
					return;
				}
				reject(new Error('Unkown series state: ' + state));
			});
		});
	}
});

// Function to download a chapter and send some other information to swift (url to next chapter, description of the series, ...)
Object.defineProperty(window, 'save', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: (chapterInfo) => {
		if (
			typeof chapterInfo !== 'object' ||
			typeof chapterInfo.series?.title !== 'string' ||
			typeof chapterInfo.chapterName !== 'string' ||
			!Array.isArray(chapterInfo.images)
		) {
			throw new Error('Invalid chapterInfo');
		}
		window.postWebKitMessage(['SaveChapter', JSON.stringify(chapterInfo)]);
	}
});

// Function to tell swift that whatever was being done failed
Object.defineProperty(window, 'fail', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: (error = 'Unknown error in JS') => {
		if (typeof error !== 'string') {
			throw new Error('Error must be a string');
		}
		window.postWebKitMessage(['Failed', error]);
	}
});
