//
//  Utils.swift
//  H3N-tLe
//
//  Created by Felix Wuttke on 03.04.22.
//

import Foundation

// Check if a URL is a directory and not a file
func isDirectory(url: URL) -> Bool {
    var isDir: ObjCBool = false
    fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
    return isDir.boolValue
}

// Sort URLs by the name od the file they're pointing to - ["2.txt", "3.txt", "1.txt"] -> ["1.txt", "2.txt", "3.txt"]
func sortFileUrlsByFileName(urls: [URL]) -> [URL] {
	return urls.sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
}

// List all directories in a directory
func listDirectories(url: URL) -> [URL] {
    let directoryContents = try! fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
	let directories = directoryContents.filter { isDirectory(url: $0) }
	return sortFileUrlsByFileName(urls: directories)
}

// List all files in a directory
func listFiles(url: URL) -> [URL] {
    let directoryContents = try! fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
	let files = directoryContents.filter { !isDirectory(url: $0) }
    return sortFileUrlsByFileName(urls: files)
}

// Read a json file and return the json object
func readJsonFromFile(url: URL) -> Any? {
    do {
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        return json
    } catch {
        print("Failed to read file: \(error)")
        return nil
    }
}

// write a json object to a file
func writeJsonToFile(url: URL, json: Any) {
	do {
		let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
		try data.write(to: url, options: [])
	} catch {
		print("Failed to write file: \(error)")
	}
}
