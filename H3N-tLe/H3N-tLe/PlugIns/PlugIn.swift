//
//  PlugIn.swift
//  H3N-tLe
//
//  Created by RC-14 on 09.06.22.
//

import Foundation

class PlugIn {
	enum PlugInError: Error {
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
		
		if manifest == nil || !(manifest?.keys.contains(PlugIn.manifestVersionKey) ?? false) {
			throw PlugInError.InvalidManifest
		} else if manifest?[PlugIn.manifestVersionKey] != PlugIn.manifestVersion {
			throw PlugInError.UnsupportedManifestVersion
		}
		
		if let url = URL(string: manifest![PlugIn.websiteKey] ?? "") {
			website = url
		}
		
        let domains = manifest!.keys.filter { $0 != PlugIn.manifestVersionKey && $0 != PlugIn.websiteKey }
		
		try! domains.forEach {
			let path = manifest![$0]!
			
			if path.contains("..") {
				throw PlugInError.ManifestContainsInvalidPath
			}
			
			let url = URL(string: path, relativeTo: directory)!
			
			if !fileManager.fileExists(atPath: url.path) || isDirectory(url: url) {
				throw PlugInError.ManifestContainsInvalidPath
			}
			
			domainToScriptUrlMap[$0] = url
		}
	}
	
	let name: String
    let website: URL?
	private let directory: URL
	private var domainToScriptUrlMap = [String: URL]()
	
	func getSupportedDomains() -> [String] {
		// map is used to get a value of type [String] because "as [String]" doesn't work
		return domainToScriptUrlMap.keys.map { $0 }
	}
	
	func getScriptForDomain(_ domain: String) -> String? {
		if domainToScriptUrlMap[domain] == nil {
			return nil
		}
		
		return try? String(contentsOf: domainToScriptUrlMap[domain]!)
	}
    
}
