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
                        
                        Button {
                            // TODO: Check for updates
                        } label: {
                            Label("Check for updates", systemImage: "magnifyingglass")
                        }
                        
                        // TODO: if update is available show a button element to update plugins
                        
                        Button {
                            // TODO: Install base Plugin
                        } label: {
                            Label("Install base plugin", systemImage: "puzzlepiece.extension")
                        }

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
