//
//  PluginList.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.04.22.
//

import SwiftUI

struct PluginList: View {
	
	// Get an array of all currently installed plugins
	@State var plugInList = plugInManager.getAllPlugInNames()
	
	var body: some View {
		
		// Use of a list, so that the plugins get displayed in a organized way
		List {
			
			// Loop that goes through the array of installed plugins
			ForEach(plugInList.map { IdentifieableAny(value: $0) } ) { plugInName in
				
				/*
				 if the maifest.json file of the plugin containes a link, you can tap the element to open the link
				 and in the right side of the element a "link" icon will apear
				 */
				if let url = plugInManager.getPlugInWebsite(plugIn: plugInName.value as! String) {
					// The Elements are Links, so they can lead to their repo
					Link(destination: url, label: {
						HStack{
							Text(plugInName.value as! String)
							Spacer()
							Image(systemName: "link")
						}
						
					})
					
				}
				
				// if the manifest.json file doesn't contain a link the element just contains the Name of the Plugin
				else {
					Text(plugInName.value as! String)
						.foregroundColor(.red)
				}
				
			}
			
		}
		
	}
	
}
