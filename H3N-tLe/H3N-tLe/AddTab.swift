//
//  AddTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct AddTab: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("ADD TAB")
                    .font(.largeTitle)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 0)
                    .background(.thinMaterial)
            }
        }
            .tabItem {
            Image(systemName: "plus")
            Text("Add")
        }
        .tag(0)
    }
}
