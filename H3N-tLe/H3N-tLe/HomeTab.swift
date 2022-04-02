//
//  HomeTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct HomeTab: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("HOME TAB")
                .font(.largeTitle)
            
            Spacer()
            
            Rectangle()
                .frame(height: 0)
                .background(.thinMaterial)
        }
        .tabItem {
            Image(systemName: "books.vertical")
            Text("Library")
        }
        .tag(1)
    }
}
