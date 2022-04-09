//
//  LibraryUtils.swift
//  H3N-tLe
//
//  Created by Felix Wuttke on 03.04.22.
//

import Foundation

struct SeriesInfo {
    var id = UUID()
    var title: String
    var description: String?
    var author: String?
    var url: String?
    var cover: String?
    var status: String?
    var lastReadChapter: String?
    var tags: [String]?
}

// URL to the library directory inside the documents directory
let libraryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Library")

// Returns the list of all Series in the library
func getSeriesList() -> [String] {
    return listDirectories(url: libraryURL).map { $0.lastPathComponent }
}

// Reads the info.json file of the Series at the given URL
func getSeriesInfo(name: String) -> SeriesInfo? {
    let infoURL = libraryURL.appendingPathComponent(name).appendingPathComponent("info.json")
    let json = readJsonFromFile(url: infoURL) as? [String: Any]
    if let dict = json {
        if let title = dict["title"] as? String {
            return SeriesInfo(title: title, description: dict["description"] as? String, author: dict["author"] as? String, url: dict["url"] as? String, cover: dict["cover"] as? String, status: dict["status"] as? String, lastReadChapter: dict["last_read_chapter"] as? String, tags: dict["tags"] as? [String])
        }
    }
    return nil
}

// Returns an array with the info.json files of all Series in the library
func getAllSeriesInfo() -> [SeriesInfo] {
    var list = [SeriesInfo]()
    
    for name in getSeriesList() {
        if let info = getSeriesInfo(name: name) {
            list.append(info)
        }
    }
    
    return list
}
