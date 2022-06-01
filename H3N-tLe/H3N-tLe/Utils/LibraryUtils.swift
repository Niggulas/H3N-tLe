//
//  LibraryUtils.swift
//  H3N-tLe
//
//  Created by Felix Wuttke on 03.04.22.
//

import Foundation

var libraryExists = false

// URL to the library directory inside the documents directory
let libraryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Library")

class Series: Identifiable {
	static func makeSureLibraryExists() {
		if libraryExists || isDirectory(url: libraryURL) {
			libraryExists = true
			return
		}
		if fileManager.fileExists(atPath: libraryURL.path) {
			try! fileManager.removeItem(at: libraryURL)
		}
		try! fileManager.createDirectory(at: libraryURL, withIntermediateDirectories: true, attributes: nil)
		libraryExists = true
	}


	init(name: String) throws {
		Series.makeSureLibraryExists()
		
		self.name = name
		self.localUrl = libraryURL.appendingPathComponent(name)
		
		let infoURL = self.localUrl.appendingPathComponent("info.json")
		let json = readJsonFromFile(url: infoURL) as? [String: Any]
		
		if let dict = json {
			if let title = dict["title"] as? String {
				self.title = title
				
				self.status = dict["status"] as? String
				self.lastReadChapter = dict["last_read_chapter"] as? String
				self.description = dict["description"] as? String
				self.author = dict["author"] as? String
				self.remoteUrl = dict["url"] as? String
				if let coverName = dict["cover"] as? String {
					// Make sure the name doesn't point to anything outside the Series directory
					if coverName.contains("..") {
						throw InvalidFileNameError()
					}
					self.coverUrl = self.localUrl.appendingPathComponent(coverName)
				} else {
					self.coverUrl = nil
				}
				self.tags = dict["tags"] as? [String]
				
				return
			} else {
				throw InvalidSeriesInfoFile()
			}
		} else {
			throw InvalidSeriesInfoFile()
		}
	}
	
	let id = UUID()
	let name: String
	let localUrl: URL
	let title: String
	let status: String?
	let lastReadChapter: String?
	let description: String?
	let author: String?
	let remoteUrl: String?
	let coverUrl: URL?
	let tags: [String]?
}

// Returns the list of all Series in the library
func getSeriesList() -> [String] {
	return listDirectories(url: libraryURL).map { $0.lastPathComponent }
}

// Returns an array with the info.json files of all Series in the library
func getAllSeriesInfo() -> [Series] {
	var list = [Series]()
	
	for name in getSeriesList() {
		if let info = try? Series(name: name) {
			list.append(info)
		}
	}
	
	return list
}
