//
//  ChapterList.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 09.04.22.
//

import SwiftUI

struct ChapterList: View {
    var body: some View {
        List {
            ForEach(0..<20) { chapter in
                NavigationLink(destination: Reader(), label: {
                    Label("Chapter \(chapter + 1)", systemImage: "book")
                        .foregroundColor(.red)
                        .background(Color(.systemGray6))
                        .frame(idealWidth: .infinity,idealHeight: 20)
                        
                    
                        // set frame after background
                })
            }
        }
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
