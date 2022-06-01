//
//  PlugInUtils.swift
//  H3N-tLe
//
//  Created by RC-14 on 24.05.22.
//

import Foundation
import WebKit
import SwiftUI

class plugInViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let config = WKWebViewConfiguration()
		
		let contentController = WKUserContentController()
		
		contentController.add(self, name: "test")
		
		let scriptSource = "document.body.style.backgroundColor = `red`;"
		let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		contentController.addUserScript(script)
		config.userContentController = contentController
		
		let webView = WKWebView(frame: .zero, configuration: config)
		
		view.addSubview(webView)
		
		let layoutGuide = view.safeAreaLayoutGuide
		
		webView.translatesAutoresizingMaskIntoConstraints = false
		webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
		webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
		webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
		webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
		
		if let url = URL(string: "https://www.google.com") {
			webView.load(URLRequest(url: url))
		}
	}
}

extension plugInViewController: WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		if message.name == "test", let messageBody = message.body as? String {
			print(messageBody)
		}
	}
}
