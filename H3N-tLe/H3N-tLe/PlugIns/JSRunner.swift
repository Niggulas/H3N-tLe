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
		
		// Add the message handlers to the WebView (the ones that receive all messages and then decide which message processor function to execute)
		view.wkWebView.configuration.userContentController.add(self, contentWorld: contentWorld, name: "noReply")
		view.wkWebView.configuration.userContentController.addScriptMessageHandler(self, contentWorld: contentWorld, name: "reply")
		
		/*
		 Add default message processors
		 */
		
		// Add a message processor for requests to show and hide the view
		addMessageProcessor({ message in
			if message == "show" {
				self.showPage()
			} else if message == "hide" {
				self.hidePage()
			}
		}, name: "View")
		
		// Add a message processor that answers requests for the current state of the view ("hidden" or "visisble")
		addMessageProcessorThatReplies({message in
			if message == "state" {
				return self.isViewVisible() ? "visible" : "hidden"
			}
			return ""
		}, name: "View")
		
		// Add a message processor for requests to allow and disallow the loading of content such as images or styles
		addMessageProcessor({ message in
			if message == "allow" {
				self.view.allowRemoteContent()
			} else if message == "disallow" {
				self.view.disallowRemoteContent()
			}
		}, name: "RemoteContent")
		
		// Add a message processor that answers requests for the current state of content blocking ("allowed" or "forbidden")
		addMessageProcessorThatReplies({message in
			if message == "state" {
				return self.view.isRemoteContentAllowed() ? "allowed" : "forbidden"
			}
			return ""
		}, name: "RemoteContent")
		
		// Add a message processor for requests to allow and disallow the execution of JavaScript
		addMessageProcessor({ message in
			if message == "allow" {
				self.view.allowJS()
			} else if message == "disallow" {
				self.view.disallowJS()
			}
		}, name: "JavaScript")
		
		// Add a message processor that answers requests for the current state of JavaScript blocking ("allowed" or "forbidden")
		addMessageProcessorThatReplies({message in
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
	private var messageProcessors = [String: (String) -> Void]()
	private var messageProcessorsThatReply = [String: (String) -> String?]()
	
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
	 Message Processors
	 */
	
	// Add message processors
	func addMessageProcessor(_ processor: @escaping (String) -> Void, name: String) {
		messageProcessors.updateValue(processor, forKey: name)
	}
	
	func addMessageProcessorThatReplies(_ processor: @escaping (String) -> String?, name: String) {
		messageProcessorsThatReply.updateValue(processor, forKey: name)
	}
	
	// Remove message processors
	func removeMessageProcessor(name: String) {
		messageProcessors.removeValue(forKey: name)
	}
	
	func removeMessageProcessorThatReplies(name: String) {
		messageProcessorsThatReply.removeValue(forKey: name)
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
		
		let processorName = messageBody.first!
		let stringMessage = messageBody.last!
		
		// Do nothing if the message processor doesn't exist
		if !messageProcessors.keys.contains(processorName) {
			return
		}
		
		// Execute the message processor
		messageProcessors[processorName]!(stringMessage)
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
		
		let processorName = messageBody.first!
		let stringMessage = messageBody.last!
		
		// Send an error back if the message processor doesn't exist
		if !messageProcessorsThatReply.keys.contains(processorName) {
			replyHandler(nil, "No processor with that name: \(processorName)")
			return
		}
		
		// Execute the message processor and send back the reply
		replyHandler(messageProcessorsThatReply[processorName]!(stringMessage) ?? false, nil)
	}
}
