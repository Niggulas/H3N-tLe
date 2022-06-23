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
	private var whiteList = [String]()
	private var blackList = ["hidden"]
	
	private var currentDownloadUrl: URL?
	private var currentDownloadPluginName: String?
	
	var runner = JSRunner(showView: {}, hideView: {}, isViewVisible: {false})
	
	// Returns a filtered list of all series
	func getSeriesList() -> [Series] {
		return seriesList.filter { series in
			// Check if we need to loop
			if series.getTags().isEmpty {
				// If the series doesn't have tags it will always pass the black list filter
				return whiteList.isEmpty
			}
			
			// White list filter
			if !whiteList.isEmpty {
				for tag in whiteList {
					if !series.hasTag(tag) {
						return false
					}
				}
			}
			
			// Black list filter
			if !blackList.isEmpty {
				for tag in blackList {
					if series.hasTag(tag) {
						return false
					}
				}
			}
			
			return true
		}
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
	
	func addNewSeriesToSeriesList(_ series: Series) {
		seriesList.insert(series, at: 0)
	}
	
	func download(url: URL, with pluginName: String) {
		runner.stop()
		runner.view.disallowJS()
		runner.view.disallowContent()
		
		if let js = plugInManager.getPlugInJSForDomain(domain: url.host!, plugInName: pluginName) {
			currentDownloadUrl = url
			currentDownloadPluginName = pluginName
			runner.run(source: js, on: url)
		}
	}
	
	func updateChaptersForAll() {
		getSeriesList().forEach { $0.updateChapters() }
	}
	
	private func downloadMessageHandler(json: String) {
		runner.stop()
		
		let info = try? JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), options: []) as? [String: Any]
		if info == nil {
			return
		}
		
		/*
		 Series related
		 */
		
		let seriesInfo = info!["series"] as? [String: Any]
		if (seriesInfo?["title"] as? String)?.isEmpty ?? true {
			return
		}
		
		var series = try? Series(existingSeriesName: seriesInfo!["title"] as! String)
		if series == nil {
			series = try! Series(title: seriesInfo!["title"] as! String, description: seriesInfo!["description"] as? String ?? "")
		}
		if let author = seriesInfo!["author"] as? String {
			series!.setAuthor(author)
		}
		if let status = seriesInfo!["status"] as? String {
			series!.setStatus(status)
		}
		if let cover = seriesInfo!["cover"] as? [String: String] {
			do {
				let coverName = "cover" + cover["ext"]!
				let coverUrl = series!.localUrl.appendingPathComponent(coverName)
				let coverData = Data(base64Encoded: cover["b64"]!)
				
				if fileManager.fileExists(atPath: coverUrl.path) {
					try fileManager.removeItem(at: coverUrl)
				}
				try coverData?.write(to: coverUrl)
				
				series!.setCoverName(coverName)
			} catch {}
		}
		series!.setRemoteUrl(currentDownloadUrl!.absoluteString)
		
		/*
		 Chapter related
		 */
		let chapterName = info!["chapterName"] as? String
		if chapterName == nil {
			return
		}
		
		let images = info!["images"] as? [[String: String]]
		if images == nil{
			return
		}
		
		// The actual download
		series!.saveChapter(chapterName: chapterName!, images: images!)
		
		/*
		 Next chapter download related
		 */
		if currentDownloadPluginName?.isEmpty ?? true {
			return
		}
		series!.setLastPluginName(currentDownloadPluginName!)
		
		if let nextUrlString = info!["nextUrl"] as? String {
			if let nextUrl = URL(string: nextUrlString) {
				print("Next url: \(nextUrl.absoluteString)")
				download(url: nextUrl, with: currentDownloadPluginName!)
			}
		}
	}
	
	// Dirty fix because we can't initialize the Library in DownloadTab but we have to initialize the runner there
	func setRunner(showView: @escaping () -> Void, hideView: @escaping () -> Void, isViewVisible: @escaping () -> Bool) {
		if isRunnerSet {
			return
		}
		
		let libraryDefaultScript = try! String(contentsOf: Bundle.main.url(forResource: "LibraryDefaultScript", withExtension: "js")!)
		
		self.runner = JSRunner(showView: showView, hideView: hideView, isViewVisible: isViewVisible, contentWorld: .world(name: "PlugIn"), defaultScripts: [libraryDefaultScript])
		
		self.runner.addMessageHandlerThatReplies({ seriesTitle in
			return self.seriesList.contains(where: { $0.title == seriesTitle }) ? "present" : "absent"
		}, name: "DoesSeriesExist")
		
		self.runner.addMessageHandler(downloadMessageHandler, name: "DownlaodChapter")
		
		self.runner.addMessageHandler({ error in
			print(error)
			self.runner.stop()
		}, name: "Failed")
		
		isRunnerSet = true
	}
}
