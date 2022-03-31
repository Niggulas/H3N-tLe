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
                    
                    Section(header: Text("Appearance")) {
                        
                        
                        
                    }
                    Section(header: Text("Help")) {
                        
                        Link(destination: URL(string: "https://google.com")!,
                            label:{
                                Label("How to use", systemImage: "link")
                            })
                        
                        Link(destination: URL(string: "https://github.com/Niggulas/H3N-tLe#how-to-install-plugins")!,
                             label: {
                                Label("How to install Plugins", systemImage: "link")
                            })
                        
                    }
                }
                .navigationTitle("Settings")
            }
            
            Spacer()
            
            Rectangle()
                .frame(height: 0)
                .background(.thinMaterial)
        }
        .tabItem {
            Image(systemName: "gear")
            Text("Settings")
        }
        .tag(2)
    }
}
