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
		
		let seriesInfo = info!["series"] as? [String: String]
		if seriesInfo?["title"]?.isEmpty ?? true {
			return
		}
		
		var series = try? Series(existingSeriesName: seriesInfo!["title"]!)
		if series == nil {
			series = try! Series(title: seriesInfo!["title"]!, description: seriesInfo!["description"] ?? "")
		}
		if let author = seriesInfo!["author"] {
			series!.setAuthor(author)
		}
		if let status = seriesInfo!["status"] {
			series!.setStatus(status)
		}
		if let coverUrl = URL(string: seriesInfo!["coverUrl"] ?? "") {
			let coverName = "cover" + coverUrl.lastPathComponent.split(separator: ".").last!
			if fileManager.fileExists(atPath: series!.localUrl.appendingPathComponent(coverName+".tmp").path) {
				try! fileManager.removeItem(at: series!.localUrl.appendingPathComponent(coverName+".tmp"))
			}
			
			do {
				try downloadFile(from: coverUrl, to: series!.localUrl.appendingPathComponent(coverName+".tmp"))
				
				if fileManager.fileExists(atPath: series!.localUrl.appendingPathComponent(coverName).path) {
					try! fileManager.removeItem(at: series!.localUrl.appendingPathComponent(coverName))
				}
				try fileManager.moveItem(at: series!.localUrl.appendingPathComponent(coverName+".tmp"), to: series!.localUrl.appendingPathComponent(coverName))
				
				series!.setCoverName(coverName)
			} catch {
				if fileManager.fileExists(atPath: series!.localUrl.appendingPathComponent(coverName+".tmp").path) {
					try! fileManager.removeItem(at: series!.localUrl.appendingPathComponent(coverName+".tmp"))
				}
			}
		}
		series!.setRemoteUrl(currentDownloadUrl!.absoluteString)
		
		/*
		 Chapter related
		 */
		let chapterName = info!["chapterName"] as? String
		if chapterName == nil {
			return
		}
		
		let imageUrlStrings = info!["urls"] as? [String]
		if imageUrlStrings == nil {
			return
		}
		let imageUrls = imageUrlStrings!.map { URL(string: $0) ?? URL(string: "faulty://url")! }
		for imageUrl in imageUrls {
			if imageUrl.scheme! != "http" && imageUrl.scheme! != "https" {
				return
			}
		}
		
		// The actual download
		series!.downloadChapter(chapterName: chapterName!, imageUrls: imageUrls)
		
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
		
		isRunnerSet = true
	}
}
