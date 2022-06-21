Object.defineProperty(window, 'Chapter', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: class {
		constructor(chapterName, urls, { title, description, ... }) {
			// Check series info
	
			// Check chapterName
			if (typeof chapterName !== 'string') {
				throw new Error(`Invalid value for chapterName: ${chapterName}`);
			}
			chapterName = chapterName.trim().replace(/\n|\r/gi, '');
			if (chapterName.length === 0) {
				throw new Error('chapterName is too short (legnth 0)');
			}
			this.#name = chapterName;
			
			// Check urls
			if (!Array.isArray(urls)) {
				throw new Error('urls list is not an Array');
			}
			// Make sure all entries of urls are strings, valid URLs and use http or https
			for (let i = 0; i < urls.length; i++) {
				if (urls[i] instanceof URL) {
					urls[i] = urls[i].href;
				} else if (typeof urls[i] !== 'string') {
					throw new Error(`Invalid value for urls[${i}]: ${urls[i]}`);
				} else if (urls[i].length < 10) {
					throw new Error(`urls[${i}] is too short (legnth < 10)`);
				}
	
				try {
					urls[i] = new URL(urls[i]);
				} catch (e) {
					throw new Error(`urls[${i}] is not a URL: ${urls[i]}`);
				}
	
				if (urls[i].protocol.match(/^https?$/i) === null) {
					throw new Error(`urls[${i}] is not a HTTP(S) URL: ${urls[i].href}`);
				}
	
				urls[i] = urls[i].href;
			}
			this.#urls = urls;
		}
	
		#series;
		#name;
		#urls;
	
		getSeries() {
			return this.#series;
		}
	
		getName() {
			return this.#name;
		}
	
		getUrls() {
			return this.#urls;
		}
	
		getJSON() {
			return JSON.stringify({
				series: this.#series,
				name: this.#name,
				urls: this.#urls
			});
		}
	}
});

Object.defineProperty(window, 'downloadChapter', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: (chapterInfo) => {
		if (
			typeof chapterInfo?.getSeries()?.title !== 'string' ||
			typeof chapterInfo?.getName() !== 'string' ||
			!Array.isArray(chapterInfo?.getUrls()) ||
			typeof chapterInfo?.getJSON() !== 'string'
		) {
			throw new Error('Invalid chapterInfo');
		}
		window.postWebKitMessage(['DownlaodChapter', chapterInfo.getJSON()]);
	}
});