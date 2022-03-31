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
            Text("HOME TAB")
                .font(.largeTitle)
        }
        .tabItem {
            Image(systemName: "book")
            Text("Library")
        }
        .tag(1)
    }
}
