//
//  Series.swift
//  H3N-tLe
//
//  Created by RC-14 on 12.06.22.
//

import Foundation

class Series: Identifiable {
	private enum SeriesErrors: Error {
		case SeriesDoesntExist
		case SeriesAlreadyExist
		case InvalidCoverFileName
		case InvalidSeriesInfoFile
	}
	
	/*
	 Allowed status for a series
	 
	 dropped: story not finished but doesn't get continued
	 ongoing: story is not finished and there are still chapters to come
	 hiatus: author takes a break but will come back to continue the series
	 finished: story is finished - there may still be bonus chapters coming
	 unknown: selfexplanatory
	 */
	static let STATUS_STRINGS = ["dropped", "ongoing", "hiatus", "finished", "unknown"]
	
	// Init to read a series that already exists
	init(existingSeriesName name: String) throws {
		localUrl = Library.libraryUrl.appendingPathComponent(name)
		infoUrl = localUrl.appendingPathComponent("info.json")
		
		// Throw an error if the series doesn't exist
		if !isDirectory(url: localUrl) || !fileManager.fileExists(atPath: infoUrl.path) {
			throw SeriesErrors.SeriesDoesntExist
		}
		
		let json = readJsonFromFile(url: infoUrl) as? [String: Any]
		
		if json?["title"] as? String == nil {
			throw SeriesErrors.InvalidSeriesInfoFile
		}
		
		// Get the attributes of the series from the serialized JSON data
		self.title = json!["title"] as! String
		description = json!["description"] as? String ?? ""
		
		if let coverName = json!["cover"] as? String {
			// Make sure the name doesn't point to anything outside the Series directory
			if coverName.contains("..") || coverName.isEmpty {
				throw SeriesErrors.InvalidCoverFileName
			}
			self.coverName = coverName
		} else {
			self.coverName = nil
		}
		
		remoteUrl = json!["url"] as? String
		status = json!["status"] as? String
		if status == nil || !Series.STATUS_STRINGS.contains(status!) {
			status = nil
		}
		
		lastReadChapter = json!["last_read_chapter"] as? String
	}
	
	// Init for a series that doesn't exist yet
	init(title: String, description: String) throws {
		self.title = title
		self.description = description
		
		localUrl = Library.libraryUrl.appendingPathComponent(title)
		infoUrl = localUrl.appendingPathComponent("info.json")
		
		// Throw an error if the series already exists
		if isDirectory(url: localUrl) && fileManager.fileExists(atPath: infoUrl.path) && !isDirectory(url: infoUrl) {
			throw SeriesErrors.SeriesAlreadyExist
		}
		
		writeInfo()
	}
	
	let id = UUID()
	let localUrl: URL
	let infoUrl: URL
	let title: String
	let description: String
	private var coverName: String?
	private var remoteUrl: String?
	private var status: String?
	private var lastReadChapter: String?
	
	func getCoverUrl() -> URL? {
		if coverName?.isEmpty ?? true {
			return nil
		}
		return localUrl.appendingPathComponent(coverName!)
	}
	
	func setCoverName(_ name: String) {
		if name.isEmpty || name.contains("..") {
			return
		}
		coverName = name
		writeInfo()
	}
	
	func getRemoteUrl() -> URL? {
		if remoteUrl?.isEmpty ?? true {
			return nil
		} else if let remoteUrl = URL(string: remoteUrl!) {
			return remoteUrl
		}
		return nil
	}
	
	func setRemoteUrl(_ urlString: String) {
		let url = URL(string: urlString)
		
		if url?.isFileURL ?? true {
			return
		}
		
		remoteUrl = url!.absoluteString
		writeInfo()
	}
	
	func clearRemoteUrl() {
		remoteUrl = nil
		writeInfo()
	}
	
	func getStatus() -> String {
		return status ?? "unknown"
	}
	
	func setStatus(_ status: String) {
		if Series.STATUS_STRINGS.contains(status) {
			self.status = status
		}
		
		writeInfo()
	}
	
	/*
	 Mark chapters as read and check if a chapter was read
	 */
	
	func getLastReadChapter() -> String? {
		return lastReadChapter
	}
	
	func setLastReadChapter(chapter: String) {
		lastReadChapter = chapter
		
		writeInfo()
	}
	
	func clearLastReadChapter() {
		lastReadChapter = nil
		
		writeInfo()
	}
	
	func getNextChapter() -> String {
		if lastReadChapter != nil {
			var nextChapterIndex = (getChapterList().firstIndex(of: lastReadChapter!) ?? -1) + 1
			
			if nextChapterIndex == getChapterList().count {
				nextChapterIndex = getChapterList().count - 1
			}
			
			return getChapterList()[nextChapterIndex]
		} else {
			return getChapterList()[0]
		}
	}
	
	/*
	 Get a list of downloaded Chapters, their images or save a chapter
	 */
	
	func getChapterList() -> [String] {
		// Returns a list of the names of all folders in the directory of the series
		return listDirectories(url: self.localUrl).map { $0.lastPathComponent }
	}
	
	func getChapterImageUrls(name: String) -> [URL] {
		// No special checks if the file really is an image because there is no reason for a chapter to contain anything else
		return listFiles(url: self.localUrl.appendingPathComponent(name))
	}
	
	// Saves Base64 encoded images to a chapter if it doesn't already exist or is empty
	func saveChapter(chapterName: String, images: [[String: String]]) {
		if chapterName == "info.json" {
			return
		}
		
		let chapterUrl = localUrl.appendingPathComponent(chapterName)
		
		// Do nothing if a chapter with that name akready exists and has images in it
		if isDirectory(url: chapterUrl) && !listFiles(url: chapterUrl).isEmpty {
			return
		}
		
		if fileManager.fileExists(atPath: chapterUrl.path) && !isDirectory(url: chapterUrl) {
			try! fileManager.removeItem(at: chapterUrl)
		}
		if !isDirectory(url: chapterUrl) {
			try! fileManager.createDirectory(at: chapterUrl, withIntermediateDirectories: true)
		}
		
		// Save the images and skip ones where something fails
		for i in 0..<images.count {
			do {
				let imageName: String = "\(i)." + images[i]["ext"]!
				try writeBase64ToFile(url: chapterUrl.appendingPathComponent(imageName), base64: images[i]["b64"]!)
			} catch {}
		}
	}
	
	// Write current values of all attributes to the info.json file
	private func writeInfo() {
		if !isDirectory(url: localUrl) {
			try? fileManager.removeItem(at: localUrl)
			try! fileManager.createDirectory(at: localUrl, withIntermediateDirectories: true)
		}
		if isDirectory(url: infoUrl) {
			try! fileManager.removeItem(at: infoUrl)
		}
		
		var info = [String: Any]()
		
		info["title"] = title
		if !description.isEmpty {
			info["description"] = description
		}
		if !(coverName?.isEmpty ?? true) {
			info["cover"] = coverName!
		}
		if !(remoteUrl?.isEmpty ?? true) {
			info["url"] = remoteUrl!
		}
		if status != "unknown" {
			info["status"] = status
		}
		if !(lastReadChapter?.isEmpty ?? true) {
			info["last_read_chapter"] = lastReadChapter!
		}
		
		try! writeJsonToFile(url: infoUrl, json: info)
	}
}
