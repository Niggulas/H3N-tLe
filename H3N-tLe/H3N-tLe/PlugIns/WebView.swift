//
//  WebView.swift
//  H3N-tLe
//
//  Created by RC-14 on 10.06.22.
//

import Foundation
import WebKit
import SwiftUI

// Because WKWebView isn't SwiftUI compatible we need to wrap it with UIViewRepresentable to be able to show it
struct WebView: UIViewRepresentable {
	init() {
		wkWebView.configuration.limitsNavigationsToAppBoundDomains = false
		
		disallowJS()
		
		var instance = self
		
		WKContentRuleListStore.default().compileContentRuleList(
			forIdentifier: contentRuleListIdentifier,
			// The actual ruels in JSON
			// first part blocks all (no exception for PlugIns) requests, second part adds an exception for the document of the main frame
			encodedContentRuleList: """
				[
					{
						"trigger": {
							"url-filter": ".*"
						},
						"action": {
							"type": "block"
						}
					},
					{
						"trigger": {
							"url-filter": ".*",
							"resource-type": ["document"],
							"load-type": ["first-party"],
							"load-context": ["top-frame"]
						},
						"action": {
							"type": "ignore-previous-rules"
						}
					}
				]
			""",
			completionHandler: { ruleList, error in
				if ruleList == nil {
					return
				}
				
				instance.disallowRemoteContent()
			}
		)
	}
		
	init(url: URL?) {
			self.init()
			
			if url != nil {
				load(url: url!)
		}
	}
	
	init(html: String, baseUrl: URL?) {
		self.init()
		
		load(html: html, baseUrl: baseUrl)
	}
	
	init(html: String) {
		self.init()
		
		load(html: html)
	}
	
	let wkWebView = WKWebView()
	
	private var remoteContentAllowed = true
	private var contentRuleListIdentifier = "RemoteContentBlocker"
	
	var url: URL?
	var html: String?
	
	/*
	 (Re)Load a page
	 */
	
	mutating func load(url: URL) {
		self.url = url
		self.html = nil
		wkWebView.load(URLRequest(url: url))
	}
	
	mutating func load(html: String, baseUrl: URL?) {
		self.url = baseUrl
		self.html = html
		wkWebView.loadHTMLString(html, baseURL: baseUrl)
	}
	
	mutating func load(html: String) {
		load(html: html, baseUrl: nil)
	}
	
	func reload() {
		wkWebView.reload()
	}
	
	/*
	 Allow/Disallow Remote Content (loading of images, videos, frames, styles, scripts, XHR, ...)
	 */
	
	func isRemoteContentAllowed() -> Bool {
		return remoteContentAllowed
	}
	
	mutating func allowRemoteContent() {
		if isRemoteContentAllowed() {
			return
		}
		
		remoteContentAllowed = true
		
		let wkWebView = self.wkWebView
		
		WKContentRuleListStore.default().lookUpContentRuleList(forIdentifier: contentRuleListIdentifier) { list, error in
			if list == nil {
				fatalError("Didn't get RemoteContentBlockerList")
			}
			
			// Stop blocking of all requests
			wkWebView.configuration.userContentController.remove(list!)
		}
	}
	
	mutating func disallowRemoteContent() {
		if !isRemoteContentAllowed() {
			return
		}
		
		remoteContentAllowed = false
		
		let wkWebView = self.wkWebView
		
		WKContentRuleListStore.default().lookUpContentRuleList(forIdentifier: contentRuleListIdentifier) { list, error in
			if list == nil {
				fatalError("Didn't get RemoteContentBlockerList")
			}
			
			// Start blocking of all requests
			wkWebView.configuration.userContentController.add(list!)
			wkWebView.stopLoading()
		}
	}
	
	/*
	 Allow/Disallow JavaScript
	 */
	
	func isJSAllowed() -> Bool {
		return wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript
	}
	
	func allowJS() {
		if isJSAllowed() {
			return
		}
		wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
	}
	
	func disallowJS() {
		if !isJSAllowed() {
			return
		}
		wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = false
	}
	
	// For compliance with UIViewRepresentable
	
	func makeUIView(context: Context) -> WKWebView {
		return wkWebView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {}
}
