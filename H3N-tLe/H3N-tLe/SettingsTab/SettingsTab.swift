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
                    
                    Section(header: Text("Help")) {
                        
                        Link(destination: URL(string: "https://github.com/Niggulas/H3N-tLe#how-to-use-h3n-tle")!,
                            label:{
                                Label("How to use", systemImage: "link")
                            })
                        
                        Link(destination: URL(string: "https://github.com/Niggulas/H3N-tLe#how-to-install-plugins")!,
                             label: {
                                Label("How to install Plugins", systemImage: "link")
                            })
                        
                    }
                    
                    // TODO: TAG SYSTEM
                    
                    Section(header: Text("Plugins")) {
                        
                        NavigationLink(destination: PluginList(), label: {
                            Label("Plugin list", systemImage: "list.bullet")
                                .foregroundColor(.red)
                        })

                    }
					
					Section(header: Text("Trust")) {
						
						NavigationLink(destination: InformationOnTrust(), label: {
							Label("Information about Passwords", systemImage: "info")
								.foregroundColor(.red)
						})

					}
                    //Debug section with Reader in it
                    /*Section(header: Text("Debug")) {
                        NavigationLink(destination: Reader(), label: {
                            Label("Reader", systemImage: "eyeglasses")
                                .foregroundColor(.red)
                        })
                    } */
                    
                }
                .navigationTitle("Settings")
            }
            
        }
        .tabItem {
            Image(systemName: "gear")
            Text("Settings")
        }
        .tag(2)
    }
}
