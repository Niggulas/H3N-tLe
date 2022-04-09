//
//  LibraryUtils.swift
//  H3N-tLe
//
//  Created by Felix Wuttke on 03.04.22.
//

import Foundation

// URL to the library directory inside the documents directory
let libraryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Library")

// Reads the info.json file of the Series at the given URL
func getSeriesInfo(at url: URL) -> [String: String] {
    let infoURL = url.appendingPathComponent("info.json")
    return readJsonFromFile(url: infoURL) as! [String : String]
}
