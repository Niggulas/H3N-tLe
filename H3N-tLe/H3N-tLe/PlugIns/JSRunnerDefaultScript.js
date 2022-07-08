// Function to make the postMessage functions more accessible
Object.defineProperty(window, 'postWebKitMessage', {
	configurable: false,
	enumerable: false,
	writable: false,
	value: (message, expectReply = false) => {
		if (!Array.isArray(message)) {
			throw new Error('Message must be an array');
		} else if (message.length !== 2) {
			throw new Error('Message must be an array of length 2');
		} else if (typeof message[0] !== 'string' || typeof message[1] !== 'string') {
			throw new Error('Message must be an array of strings');
		}
		// Depending on if we expect a reply we have to send the message to a diffrent message handler
		if (expectReply) {
			return webkit.messageHandlers.reply.postMessage(message);
		}
		webkit.messageHandlers.noReply.postMessage(message);
	}
});

/*
 Define functions to manage the visibility of the webview
 */

Object.defineProperty(window, 'showView', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['View', 'show']);
	}
});

Object.defineProperty(window, 'hideView', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['View', 'hide']);
	}
});

Object.defineProperty(window, 'isViewVisible', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		return new Promise((resolve, reject) => {
			window.postWebKitMessage(['View', 'state'], true).then((state) => {
				if (state === 'visible') {
					resolve(true);
					return
				} else if (state === 'hidden') {
					resolve(false);
					return
				}
				reject(new Error('Unknown visibility state: ' + state));
			});
		});
	}
});

/*
 Define functions to manage content blocking
 */

Object.defineProperty(window, 'allowRemoteContent', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['RemoteContent', 'allow']);
	}
});

Object.defineProperty(window, 'disallowRemoteContent', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['RemoteContent', 'disallow']);
	}
});

Object.defineProperty(window, 'isRemoteContentAllowed', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		return new Promise((resolve, reject) => {
			window.postWebKitMessage(['RemoteContent', 'state'], true).then((state) => {
				if (state === 'allowed') {
					resolve(true);
					return
				} else if (state === 'forbidden') {
					resolve(false);
					return
				}
				reject(new Error('Unknown content blocking state: ' + state));
			});
		});
	}
});

/*
 Define functions to manage the execution of scripts
 */

Object.defineProperty(window, 'allowJS', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['JavaScript', 'allow']);
	}
});

Object.defineProperty(window, 'disallowJS', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		window.postWebKitMessage(['JavaScript', 'disallow']);
	}
});

Object.defineProperty(window, 'isJSAllowed', {
	configurable: false,
	enumerable: true,
	writable: false,
	value: () => {
		return new Promise((resolve, reject) => {
			window.postWebKitMessage(['JavaScript', 'state'], true).then((state) => {
				if (state === 'allowed') {
					resolve(true);
					return
				} else if (state === 'forbidden') {
					resolve(false);
					return
				}
				reject(new Error('Unknown JavaScript blocking state: ' + state));
			});
		});
	}
});
