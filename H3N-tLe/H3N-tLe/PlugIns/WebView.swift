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
final class WebView: NSObject, UIViewRepresentable {
	override init() {
		super.init()
		
		initConfig()
	}
	
	init(url: URL?) {
		super.init()
		
		initConfig()
		
		if url != nil {
			load(url: url!)
		}
	}
	
	init(html: String, baseUrl: URL?) {
		super.init()
		
		initConfig()
		
		load(html: html, baseUrl: baseUrl)
	}
	
	init(html: String) {
		super.init()
		
		initConfig()
		
		load(html: html)
	}
	
	let wkWebView = WKWebView()
	
	private var contentAllowed = true
	private var contentBlockerRuleList = WKContentRuleList()
	
	var url: URL?
	var html: String?
	
	// Configurations that have to run in all inits
	private func initConfig() {
		wkWebView.configuration.limitsNavigationsToAppBoundDomains = false
		
		disallowJS()
		
		// Create the content blocker
		WKContentRuleListStore.default().compileContentRuleList(
			forIdentifier: "ContentBlocker",
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
				// Handle error
				if ruleList == nil {
					return
				}
				
				// Write rule to variable
				self.contentBlockerRuleList = ruleList!
				
				// Apply the rule list
				self.disallowContent()
			}
		)
	}
	
	/*
	 (Re)Load a page
	 */
	
	func load(url: URL) {
		self.url = url
		self.html = nil
		wkWebView.load(URLRequest(url: url))
	}
	
	func load(html: String, baseUrl: URL?) {
		self.url = baseUrl
		self.html = html
		wkWebView.loadHTMLString(html, baseURL: baseUrl)
	}
	
	func load(html: String) {
		load(html: html, baseUrl: nil)
	}
	
	func reload() {
		wkWebView.reload()
	}
	
	/*
	 Allow/Disallow Content (loading of images, videos, frames, styles, scripts, XHR, ...)
	 */
	
	func isContentAllowed() -> Bool {
		return contentAllowed
	}
	
	func allowContent() {
		if isContentAllowed() {
			return
		}
		
		contentAllowed = true
		
		// Stop blocking of all requests
		wkWebView.configuration.userContentController.remove(contentBlockerRuleList)
	}
	
	func disallowContent() {
		if !isContentAllowed() {
			return
		}
		
		contentAllowed = false
		
		// Start blocking of all requests
		wkWebView.configuration.userContentController.add(contentBlockerRuleList)
		
		wkWebView.stopLoading()
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
