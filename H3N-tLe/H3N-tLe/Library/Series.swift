//
//  Series.swift
//  H3N-tLe
//
//  Created by RC-14 on 12.06.22.
//

import Foundation

class Series: Identifiable {
	enum SeriesErrors: Error {
		case SeriesDoesntExist
		case SeriesAlreadyExist
		case InvalidCoverFileName
		case InvalidSeriesInfoFile
	}
	
	static let STATUS_STRINGS = ["dropped", "ongoing", "<paused but the word used by the scanlation teams>", "finished", "unknown"]
	
	// Init for an existing series
	init(existingSeriesName name: String) throws {
		localUrl = Library.libraryUrl.appendingPathComponent(name)
		infoUrl = localUrl.appendingPathComponent("info.json")
		
		if !isDirectory(url: localUrl) {
			throw SeriesErrors.SeriesDoesntExist
		}
		
		let json = readJsonFromFile(url: infoUrl) as? [String: Any]
		
		if json?["title"] as? String == nil {
			throw SeriesErrors.InvalidSeriesInfoFile
		}
		
		self.title = json!["title"] as! String
		description = json!["description"] as? String ?? ""
		author = json!["author"] as? String

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
		
		tags = json!["tags"] as? [String]
        readChapterList = json!["read_chapters"] as? [String]
		lastReadChapter = json!["last_read_chapter"] as? String
	}
	
	// Init for a series that doesn't exist yet
	init(newSeriesName name: String, title: String, description: String) throws {
		self.title = title
		self.description = description
		
		localUrl = Library.libraryUrl.appendingPathComponent(name)
		infoUrl = localUrl.appendingPathComponent("info.json")
		
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
	private var author: String?
	private var coverName: String?
	private var remoteUrl: String?
	private var status: String?
	private var tags: [String]?
	private var lastReadChapter: String?
    private var readChapterList: [String]?
	
	func getAuthor() -> String {
		return author ?? ""
	}
	
	func setAuthor(_ author: String) {
		self.author = author.replacingOccurrences(of: "\n", with: "")
        writeInfo()
	}
	
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
	
	func getTags() -> [String] {
		return tags ?? [String]()
	}
	
	func hasTag(_ tag: String) -> Bool {
		return tags?.contains(tag) ?? false
	}
	
	func addTag(_ tag: String) {
		let safeTag = tag.replacingOccurrences(of: "\n", with: "")
		
		if hasTag(safeTag) {
			return
		}
		tags?.append(safeTag)
        
        writeInfo()
	}
	
	func removeTag(_ tagToRemove: String) {
		tags?.removeAll(where: { tag in
			return tag == tagToRemove
		})
        
        writeInfo()
	}
	
    /*
     Mark chapters as read and check if a chapter was read
     */
    
    func markChapterAsRead(chapter: String) {
        if readChapterList == nil {
            readChapterList = [String]()
        }
        
        if getChapterList().contains(chapter) {
            if !readChapterList!.contains(chapter) {
                readChapterList!.append(chapter)
            }
            lastReadChapter = chapter
        }
        writeInfo()
    }
    
    func markAllChaptersAsRead() {
        getChapterList().forEach { markChapterAsRead(chapter: $0) }
    }
    
    func didReadChapter(_ name: String) -> Bool {
        return readChapterList?.contains(name) ?? false
    }
    
    func getLastReadChapter() -> String? {
        return lastReadChapter
    }
    
    func getNextUnreadChapter() -> String {
        if getLastReadChapter() != nil {
            return getLastReadChapter()!
        } else {
            return getChapterList()[0]
        }
    }
    
	func clearLastReadChapter() {
		lastReadChapter = nil
        
        writeInfo()
	}
	
    /*
     Get a list of downloaded Chapters, their images or download a chapter
     */
    
	func getChapterList() -> [String] {
		return listDirectories(url: self.localUrl).map { $0.lastPathComponent }
	}
	
	func getChapterImageUrls(name: String) -> [URL] {
		return listFiles(url: self.localUrl.appendingPathComponent(name))
	}
	
	func downloadChapter(chapterName: String, imageUrls: [URL]) {
		let chapterUrl = localUrl.appendingPathComponent(chapterName.trimmingCharacters(in: [" "]))
		
		if isDirectory(url: chapterUrl) && !listFiles(url: chapterUrl).isEmpty {
			return
		}
		
		// TODO: implement function
	}
	
	func writeInfo() {
		if !isDirectory(url: localUrl) {
			try! fileManager.removeItem(at: localUrl)
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
		if !(author?.isEmpty ?? true) {
			info["author"] = author!
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
		if !(tags?.isEmpty ?? true) {
			info["tags"] = tags!
		}
        if !(readChapterList?.isEmpty ?? true) {
            info["read_chapters"] = readChapterList!
        }
		if !(lastReadChapter?.isEmpty ?? true) {
			info["last_read_chapter"] = lastReadChapter!
		}
		
		writeJsonToFile(url: infoUrl, json: info)
	}
}
