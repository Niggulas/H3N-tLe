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
	
	var runner = JSRunner(showView: {}, hideView: {}, isViewVisible: {return false})
	
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
	
	// Dirty fix because we can't initialize the Library in AddTab but we have to initialize the runner there
	func setRunner(_ runner: JSRunner) {
		if isRunnerSet {
			return
		}
		isRunnerSet = true
		
		self.runner = runner
		
		// TODO: Register message handler for downloadChapter and add a default script to make it easier to use
		self.runner.addMessageHandler({ chapterInfoJson in
			let chapterInfo = try? JSONSerialization.jsonObject(with: chapterInfoJson.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), options: []) as? [String: Any]
			
			if chapterInfo == nil {
				return
			}
			
			
			
		}, name: "DownlaodChapter")
	}
}
