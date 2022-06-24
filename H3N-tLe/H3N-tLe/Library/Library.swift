//
//  Library.swift
//  H3N-tLe
//
//  Created by RC-14 on 12.06.22.
//

import Foundation

class Library {
	static let libraryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Library")
	
	init() {
		// Make sure the library directory exists before trying to do something with it
		if !isDirectory(url: Library.libraryUrl) {
			if fileManager.fileExists(atPath: Library.libraryUrl.path) {
				try! fileManager.removeItem(at: Library.libraryUrl)
			}
			try! fileManager.createDirectory(at: Library.libraryUrl, withIntermediateDirectories: true, attributes: nil)
		}
		
		updateSeriesList()
	}
	
	private var isRunnerSet = false
	private var seriesList = [Series]()
	
	private var currentDownloadUrl: URL?
	private var currentDownloadPluginName: String?
	
	// Used to execute JavaScript (PlugIns)
	var runner = JSRunner(showView: {}, hideView: {}, isViewVisible: {false}, contentWorld: .defaultClient, defaultScripts: [String]())
	
	func getSeriesList() -> [Series] {
		return seriesList
	}
	
	func updateSeriesList() {
		seriesList.removeAll()
		
		let directories = listDirectories(url: Library.libraryUrl).map { $0.lastPathComponent }
		
		for name in directories {
			if let info = try? Series(existingSeriesName: name) {
				seriesList.append(info)
			}
		}
	}
	
	func download(url: URL, with pluginName: String) {
		// Stop whatever is currently running to make sure it doesn't mess with the preparations
		runner.stop()
		
		// Prepare
		runner.view.disallowJS()
		runner.view.disallowContent()
		
		// If for some reason there is no JavaScript even though the PlugIn was listed we don't want to do anything to prevent crashes (shouldn't ever happen
		if let js = plugInManager.getPlugInJSForHost(host: url.host!, plugInName: pluginName) {
			// These variables need to be set because we can't pass them to the downloadMessageHandler directly
			currentDownloadUrl = url
			currentDownloadPluginName = pluginName
			
			// Run the PlugIn
			runner.run(source: js, on: url)
		}
	}
	
	private func downloadMessageHandler(json: String) {
		// When this gets called the PlugIn should have done everything it needs to do
		runner.stop()
		
		let info = try? JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), options: []) as? [String: Any]
		if info == nil {
			return
		}
		
		/*
		 Series
		 
		 Here we set all the information related to the series.
		 This has to be done before we save the chapter because a chapter can't exist without a series.
		 */
		
		let seriesInfo = info!["series"] as? [String: Any]
		if (seriesInfo?["title"] as? String)?.isEmpty ?? true {
			// If no title for the series was provided we can't save the chapter and have to stop
			return
		}
		
		// Try to read an existing series from disc and if that fails create a new one
		var series = try? Series(existingSeriesName: seriesInfo!["title"] as! String)
		if series == nil {
			series = try! Series(title: seriesInfo!["title"] as! String, description: seriesInfo!["description"] as? String ?? "")
		}
		// Set al the additional information that the PlugIn might provide
		if let status = seriesInfo!["status"] as? String {
			series!.setStatus(status)
		}
		if let cover = seriesInfo!["cover"] as? [String: String] {
			do {
				let coverName = "cover" + cover["ext"]!
				let coverUrl = series!.localUrl.appendingPathComponent(coverName)
				
				if fileManager.fileExists(atPath: coverUrl.path) {
					try fileManager.removeItem(at: coverUrl)
				}
				
				try writeBase64ToFile(url: coverUrl, base64: cover["b64"]!)
				
				series!.setCoverName(coverName)
			} catch {}
		}
		series!.setRemoteUrl(currentDownloadUrl!.absoluteString)
		
		/*
		 Chapter
		 
		 We made sure the series exists and can now save the chapter. (after checking that we got what we needed)
		 */
		let chapterName = info!["chapterName"] as? String
		if chapterName == nil {
			return
		}
		let images = info!["images"] as? [[String: String]]
		if images == nil{
			return
		}
		
		series!.saveChapter(chapterName: chapterName!, images: images!)
		
		/*
		 Next Chapter
		 
		 If we got a URL to the next chapter we just simply repeat everything with that URL.
		 */
		
		if let nextUrlString = info!["nextUrl"] as? String {
			if let nextUrl = URL(string: nextUrlString) {
				/*
				 This only starts the PlugIn again and exits afterwards
				 It doesn't wait for it to finish executing which means we don't hang here until all chapters got downloaded.
				 */
				download(url: nextUrl, with: currentDownloadPluginName!)
			}
		}
	}
	
	// Dirty fix because we can't initialize the Library in DownloadTab but we have to initialize the runner there
	func setRunner(showView: @escaping () -> Void, hideView: @escaping () -> Void, isViewVisible: @escaping () -> Bool) {
		// Make sure the rnner gets only set once
		if isRunnerSet {
			return
		}
		
		// A script that gets executed before the PlugIn gets executed to provide ease of use functions for sending messages to the message handlers
		let libraryDefaultScript = try! String(contentsOf: Bundle.main.url(forResource: "LibraryDefaultScript", withExtension: "js")!)
		
		self.runner = JSRunner(showView: showView, hideView: hideView, isViewVisible: isViewVisible, contentWorld: .world(name: "PlugIn"), defaultScripts: [libraryDefaultScript])
		
		self.runner.addMessageHandlerThatReplies({ seriesTitle in
			return self.seriesList.contains(where: { $0.title == seriesTitle }) ? "present" : "absent"
		}, name: "DoesSeriesExist")
		
		self.runner.addMessageHandler(downloadMessageHandler, name: "SaveChapter")
		
		// Option for the PlugIn to tell us that it failed without passing faulty input to the downloadMessageHandler
		self.runner.addMessageHandler({ error in
			print(error)
			self.runner.stop()
		}, name: "Failed")
		
		isRunnerSet = true
	}
}
