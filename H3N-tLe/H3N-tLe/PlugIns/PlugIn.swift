//
//  PlugIn.swift
//  H3N-tLe
//
//  Created by RC-14 on 09.06.22.
//

import Foundation

class PlugIn {
	private enum PlugInError: Error {
		case NoManifestFound
		case InvalidManifest
		case UnsupportedManifestVersion
		case ManifestContainsInvalidPath
	}
	
	static let manifestVersionKey = "manifest_version"
	static let manifestVersion = "1"
    static let websiteKey = "website"
	
	init(name: String) throws {
		self.name = name
		directory = PlugInManager.plugInsDirectoryUrl.appendingPathComponent(name)
		
		let manifestURL = directory.appendingPathComponent("manifest.json")
		
		if !fileManager.fileExists(atPath: manifestURL.path) || isDirectory(url: manifestURL) {
			throw PlugInError.NoManifestFound
		}
		
		let manifest = readJsonFromFile(url: manifestURL) as? [String: String]
		
		// Throw an error if the manifest is invalid or if the manifest version is nit the currently supported one
		if !(manifest?.keys.contains(PlugIn.manifestVersionKey) ?? false) {
			throw PlugInError.InvalidManifest
		} else if manifest?[PlugIn.manifestVersionKey] != PlugIn.manifestVersion {
			throw PlugInError.UnsupportedManifestVersion
		}
		
		if let url = URL(string: manifest![PlugIn.websiteKey] ?? "") {
			website = url
        } else {
            website = nil
        }
		
        let hosts = manifest!.keys.filter { $0 != PlugIn.manifestVersionKey && $0 != PlugIn.websiteKey }
		
		try! hosts.forEach {
			let path = manifest![$0]!
			
			// Make sure the PlugIn can only use files in its directory
			if path.contains("..") {
				throw PlugInError.ManifestContainsInvalidPath
			}
			
			let url = URL(string: path, relativeTo: directory)!
			
			// Throw an error if the file doesn't exist or isn't a file
			if !fileManager.fileExists(atPath: url.path) || isDirectory(url: url) {
				throw PlugInError.ManifestContainsInvalidPath
			}
			
			hostToScriptUrlMap[$0] = url
		}
	}
	
	let name: String
    let website: URL?
	private let directory: URL
	private var hostToScriptUrlMap = [String: URL]()
	
	func getSupportedHosts() -> [String] {
		// filter is used to get a value of type [String] because "as [String]" doesn't work
		return hostToScriptUrlMap.keys.filter { _ in true }
	}
	
	func getScriptForHost(_ host: String) -> String? {
		if hostToScriptUrlMap[host] == nil {
			return nil
		}
		
		return try? String(contentsOf: hostToScriptUrlMap[host]!)
	}
    
}
