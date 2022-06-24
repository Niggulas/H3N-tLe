//
//  PlugInManager.swift
//  H3N-tLe
//
//  Created by RC-14 on 09.06.22.
//

import Foundation

class PlugInManager {
	static let plugInsDirectoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("PlugIns")
	
	init() {
		// Make sure the PlugIn directory exists before trying to do something with it
		if !isDirectory(url: PlugInManager.plugInsDirectoryUrl) {
			if fileManager.fileExists(atPath: PlugInManager.plugInsDirectoryUrl.path) {
				try! fileManager.removeItem(at: PlugInManager.plugInsDirectoryUrl)
			}
			try! fileManager.createDirectory(at: PlugInManager.plugInsDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
		}
		
		nameToPlugInMap = [String: PlugIn]()
		domainToPlugInNameListMap = [String: [String]]()
		
		registerPlugIns()
	}
	
	private var nameToPlugInMap: [String: PlugIn]
	private var domainToPlugInNameListMap: [String: [String]]
	
	func registerPlugIns() {
		nameToPlugInMap.removeAll()
		domainToPlugInNameListMap.removeAll()
		
		listDirectories(url: PlugInManager.plugInsDirectoryUrl).forEach { dir in
			if let plugIn = try? PlugIn(name: dir.lastPathComponent) {
				nameToPlugInMap[plugIn.name] = plugIn
				
				plugIn.getSupportedDomains().forEach { domain in
					if domainToPlugInNameListMap[domain] == nil {
						domainToPlugInNameListMap[domain] = [String]()
					}
					domainToPlugInNameListMap[domain]!.append(plugIn.name)
				}
			}
		}
	}
	
	func getAllPlugInNames() -> [String] {
		// filter is used to get a value of type [String] because "as [String]" doesn't work
		return nameToPlugInMap.keys.filter { _ in true }
	}
	
	func getPlugInWebsite(plugIn name: String) -> URL? {
		return nameToPlugInMap[name]?.website
	}
	
	func getPlugInNamesForDomain(_ domain: String) -> [String] {
		return domainToPlugInNameListMap[domain] ?? [String]()
	}
	
	func getPlugInJSForDomain(domain: String, plugInName: String) -> String? {
		return nameToPlugInMap[plugInName]?.getScriptForDomain(domain)
	}
}
