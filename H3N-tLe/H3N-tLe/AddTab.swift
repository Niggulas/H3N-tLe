//
//  AddTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct AddTab: View {
    var body: some View {
        VStack {
            Text("ADD TAB")
                .font(.largeTitle)
        }
        .tabItem {
            Image(systemName: "plus")
            Text("Add")
        }
        .tag(0)
    }
}
