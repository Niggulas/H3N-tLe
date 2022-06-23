//
//  SettingsTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        VStack {
            
            NavigationView {
                
                Form {
                    
					// Help section
                    Section(header: Text("Help")) {
                        
						// when you tap this element you get redirected to the "Hot to use" section of our github README file
                        Link(destination: URL(string: "https://github.com/Niggulas/H3N-tLe#how-to-use-h3n-tle")!,
                            label:{
                                Label("How to use", systemImage: "link")
                            })
						
						// when you tap this element you get redirected to the "Hot to install Plugins" section of our github README file
                        Link(destination: URL(string: "https://github.com/Niggulas/H3N-tLe#how-to-install-plugins")!,
                             label: {
                                Label("How to install Plugins", systemImage: "link")
                            })
                        
                    }
                    
					// Plugin section
                    Section(header: Text("Plugins")) {
                        
						// navigates to the PluginList.swift
                        NavigationLink(destination: PluginList(), label: {
                            Label("Plugin list", systemImage: "list.bullet")
                                .foregroundColor(.red)
                        })

                    }
					
					// Password information section
					Section(header: Text("Trust")) {
						
						NavigationLink(destination: InformationOnTrust(), label: {
							Label("Information about Passwords", systemImage: "info")
								.foregroundColor(.red)
						})

					}
                    
                }
                .navigationTitle("Settings")
            }
            
        }
		// define symbol and text for the Settings element in the tab bar
        .tabItem {
            Image(systemName: "gear")
            Text("Settings")
        }
        .tag(2)
    }
	
}
