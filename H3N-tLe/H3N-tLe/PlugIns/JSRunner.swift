//
//  JSRunner.swift
//  H3N-tLe
//
//  Created by RC-14 on 10.06.22.
//

import Foundation
import WebKit
import SwiftUI

class JSRunner: NSObject, WKScriptMessageHandler, WKScriptMessageHandlerWithReply {
	init(showView: @escaping () -> Void, hideView: @escaping () -> Void, isViewVisible: @escaping () -> Bool, contentWorld: WKContentWorld, defaultScripts: [String]) {
		self.contentWorld = contentWorld
		
		self.showView = showView
		self.hideView = hideView
		self.isViewVisible = isViewVisible
		
		super.init()
		
		// Add the message handlers to the WebView (the ones that receive all messages and then decide which message handler function to execute)
		view.wkWebView.configuration.userContentController.add(self, contentWorld: contentWorld, name: "noReply")
		view.wkWebView.configuration.userContentController.addScriptMessageHandler(self, contentWorld: contentWorld, name: "reply")
		
		/*
		 Add default message handlers
		 */
		
		// Add a message handler for requests to show and hide the view
		addMessageHandler({ message in
			if message == "show" {
				self.showPage()
			} else if message == "hide" {
				self.hidePage()
			}
		}, name: "View")
		
		// Add a message handler that answers requests for the current state of the view ("hidden" or "visisble")
		addMessageHandlerThatReplies({message in
			if message == "state" {
				return self.isViewVisible() ? "visible" : "hidden"
			}
			return ""
		}, name: "View")
		
		// Add a message handler for requests to allow and disallow the loading of content such as images or styles
		addMessageHandler({ message in
			if message == "allow" {
				self.view.allowContent()
			} else if message == "disallow" {
				self.view.disallowContent()
			}
		}, name: "Content")
		
		// Add a message handler that answers requests for the current state of content blocking ("allowed" or "forbidden")
		addMessageHandlerThatReplies({message in
			if message == "state" {
				return self.view.isContentAllowed() ? "allowed" : "forbidden"
			}
			return ""
		}, name: "Content")
		
		// Add a message handler for requests to allow and disallow the execution of JavaScript
		addMessageHandler({ message in
			if message == "allow" {
				self.view.allowJS()
			} else if message == "disallow" {
				self.view.disallowJS()
			}
		}, name: "JavaScript")
		
		// Add a message handler that answers requests for the current state of JavaScript blocking ("allowed" or "forbidden")
		addMessageHandlerThatReplies({message in
			if message == "state" {
				return self.view.isJSAllowed() ? "allowed" : "forbidden"
			}
			return ""
		}, name: "JavaScript")
		
		/*
		 Add default scripts
		 */
		
		// Add the JSRunner default script that provides ease of use functions for sending messages to the message handlers
		let runnerDefaultScript = try! String(contentsOf: Bundle.main.url(forResource: "JSRunnerDefaultScript", withExtension: "js")!)
		self.defaultScripts.append(WKUserScript(source: runnerDefaultScript, injectionTime: .atDocumentStart, forMainFrameOnly: true, in: contentWorld))
		
		// Create the other default script objects
		for defaultScript in defaultScripts {
			self.defaultScripts.append(WKUserScript(source: defaultScript, injectionTime: .atDocumentStart, forMainFrameOnly: true, in: contentWorld))
		}
	}
	
	let view = WebView()
	let contentWorld: WKContentWorld
	
	private var showView: () -> Void
	private var hideView: () -> Void
	private var isViewVisible: () -> Bool
	private var defaultScripts = [WKUserScript]()
	private var messageHandlers = [String: (String) -> Void]()
	private var messageHandlersThatReply = [String: (String) -> String?]()
	
	/*
	 Handle the visibility of the WebView
	 */
	
	func showPage() {
		showView()
	}
	
	func hidePage() {
		hideView()
	}
	
	func isPageVisible() -> Bool {
		return isViewVisible()
	}
	
	/*
	 Run JavaScript (and stop it)
	 */
	
	func run(source js: String, on page: URL?) {
		stop()
		
		// Add the default scripts to make
		for defaultScript in defaultScripts {
			view.wkWebView.configuration.userContentController.addUserScript(defaultScript)
		}
		
		// Add the JavaScript source code to exevute it on every page
		let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true, in: contentWorld)
		view.wkWebView.configuration.userContentController.addUserScript(script)
		
		if page == nil {
			view.load(html: "")
		} else {
			view.load(url: page!)
		}
	}
	
	func stop() {
		// Remove all scripts that would get loaded when the page loads
		view.wkWebView.configuration.userContentController.removeAllUserScripts()
		// Load an empty website that doesn't do anything to overwrite the current website and what it does
		view.load(html: "")
	}
	
	/*
	 Message Handlers
	 */
	
	// Add message handlers
	func addMessageHandler(_ handler: @escaping (String) -> Void, name: String) {
		messageHandlers.updateValue(handler, forKey: name)
	}
	
	func addMessageHandlerThatReplies(_ handler: @escaping (String) -> String?, name: String) {
		messageHandlersThatReply.updateValue(handler, forKey: name)
	}
	
	// Remove message handlers
	func removeMessageHandler(name: String) {
		messageHandlers.removeValue(forKey: name)
	}
	
	func removeMessageHandlerThatReplies(name: String) {
		messageHandlersThatReply.removeValue(forKey: name)
	}
	
	// Handle messages from JS
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		// Make sure to only handle messages that are meant for us
		if message.name != "noReply" {
			return
		}
		// Do nothing if the message body isn't a string array
		if message.body as? [String] == nil {
			return
		}
		
		let messageBody = message.body as! [String]
		
		// Do nothing if the string array does not have exactly 2 entries
		if messageBody.count != 2 {
			return
		}
		
		let handlerName = messageBody.first!
		let stringMessage = messageBody.last!
		
		// Do nothing if the message handler doesn't exist
		if !messageHandlers.keys.contains(handlerName) {
			return
		}
		
		// Execute the message handler
		messageHandlers[handlerName]!(stringMessage)
	}
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
		// Make sure to only handle messages that are meant for us
		if message.name != "reply" {
			return
		}
		// Send an error back if the message body isn't a string array
		if message.body as? [String] == nil {
			replyHandler(nil, "Message is not a String Array")
			return
		}
		
		let messageBody = message.body as! [String]
		
		// Send an error back if the string array does not have exactly 2 entries
		if messageBody.count != 2 {
			replyHandler(nil, "Message is a String Array but it's length is not 2")
			return
		}
		
		let handlerName = messageBody.first!
		let stringMessage = messageBody.last!
		
		// Send an error back if the message handler doesn't exist
		if !messageHandlersThatReply.keys.contains(handlerName) {
			replyHandler(nil, "No handler with that name: \(handlerName)")
			return
		}
		
		// Execute the message handler and send back the reply
		replyHandler(messageHandlersThatReply[handlerName]!(stringMessage) ?? false, nil)
	}
}
