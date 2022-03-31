//
//  ContentView.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 30.03.22.
//

import SwiftUI

struct ContentView: View {
    
    let steelGray = Color.init(white: 0.15)
    
    @State var selectedTab: Int = 1
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            AddTab()
            
            HomeTab()
            
            SettingsTab()
            
        }
        .accentColor(.red)
        .background(.thinMaterial)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
            .previewLayout(.sizeThatFits)
            
    }
}
