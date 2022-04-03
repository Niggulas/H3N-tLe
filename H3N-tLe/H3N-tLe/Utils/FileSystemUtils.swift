//
//  FileSystemUtils.swift
//  H3N-tLe
//
//  Created by Felix Wuttke on 03.04.22.
//

import Foundation

func getUrlForFileInDocuments(name: String) -> URL {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileUrl = documentsUrl.appendingPathComponent(name)
    return fileUrl
}

// Check if a URL is a directory and not a file
func isDirectory(url: URL) -> Bool {
    let fileManager = FileManager.default
    var isDir: ObjCBool = false
    fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
    return isDir.boolValue
}

// List all directories in a directory
func listDirectories(url: URL) -> [URL] {
    let fileManager = FileManager.default
    let directoryContents = try! fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
    return directoryContents.filter { isDirectory(url: $0) }
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
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        try data.write(to: url, options: [])
    } catch {
        print("Failed to write file: \(error)")
    }
}
