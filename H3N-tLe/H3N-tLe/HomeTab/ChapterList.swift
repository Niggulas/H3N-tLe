//
//  ChapterList.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 09.04.22.
//

import SwiftUI

struct ChapterList: View {
    var body: some View {
        
        ForEach(0..<20) { plugin in
            NavigationLink(destination: Reader(),
                           label: {
                Label("Plugin \(plugin)", systemImage: "link")
                
            })
            
        }
        .onDelete(perform: {
            indexSet in
            
            if let i = indexSet.first {
                // TODO: remove plugin
                // e.g. plugins.remove(at:i)
            }
        })
        .tabItem {
            Image(systemName: "books.vertical")
            Text("Chapter")
        }
    }
}

struct ChapterList_Previews: PreviewProvider {
    static var previews: some View {
        ChapterList()
    }
}
