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
                        
                        Toggle(isOn: .constant(true), label: {
                            Text("Automatic")
                        })
                    }
                    Section() {
                        
                        
                        
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
