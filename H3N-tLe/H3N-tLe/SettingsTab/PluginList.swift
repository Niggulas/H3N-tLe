//
//  PluginList.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.04.22.
//

import SwiftUI

struct PluginList: View {
    
    var body: some View {
        List {
            ForEach(0..<20) { plugin in
                Link(destination: URL(string: "https://google.com")!,
                     label: {
                    Label("Plugin \(plugin)", systemImage: "link")
                    
                })
                
            }
            .onDelete(perform: {
                indexSet in
                
                
            })
            
        }
    }
}

struct PluginList_Previews: PreviewProvider {
    static var previews: some View {
        PluginList()
            .preferredColorScheme(.dark)
    }
}
