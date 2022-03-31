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

struct SettingsTab: View {
    var body: some View {
        VStack {
            Text("SETTINGS TAB")
                .font(.largeTitle)
        }
        .tabItem {
            Image(systemName: "gear")
            Text("Settings")
        }
        .tag(2)
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
