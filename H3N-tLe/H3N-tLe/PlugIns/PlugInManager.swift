//
//  PlugInManager.swift
//  H3N-tLe
//
//  Created by RC-14 on 09.06.22.
//

import Foundation

class PlugInManager {
	static let pluginDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("PlugIns")
	
	init() {
		// Make sure the plugInDirectory exists before trying to do something with it
		if !isDirectory(url: PlugInManager.pluginDirectory) {
			if fileManager.fileExists(atPath: PlugInManager.pluginDirectory.path) {
				try! fileManager.removeItem(at: PlugInManager.pluginDirectory)
			}
			try! fileManager.createDirectory(at: PlugInManager.pluginDirectory, withIntermediateDirectories: true, attributes: nil)
		}
		
		// TLDR: Avoid an error - Explaination: Basiacally useless because they get overwritten immediately but required to be able to use self
		nameToPlugInMap = [String: PlugIn]()
		domainToPlugInNameListMap = [String: [String]]()
		
		registerPlugIns()
	}
	
	private var nameToPlugInMap: [String: PlugIn]
	private var domainToPlugInNameListMap: [String: [String]]
	
	private func registerPlugIns() {
		nameToPlugInMap = [String: PlugIn]()
		domainToPlugInNameListMap = [String: [String]]()
		
		listDirectories(url: PlugInManager.pluginDirectory).forEach { dir in
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
		// map is used to get a value of type [String] because "as [String]" doesn't work
		return nameToPlugInMap.keys.map { $0 }
	}
	
	func getPlugInNamesForDomain(_ domain: String) -> [String]? {
		return domainToPlugInNameListMap[domain]
	}
	
	func getPlugInJSForDomain(domain: String, plugInName: String) -> String? {
		return nameToPlugInMap[plugInName]?.getScriptForDomain(domain)
	}
	
	func deletePlugIn(name: String) -> Bool {
		do {
			try fileManager.removeItem(at: PlugInManager.pluginDirectory.appendingPathComponent(name))
			registerPlugIns()
			return true
		} catch {
			return false
		}
	}
}
