//
//  Reader.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 11.05.22.
//

import SwiftUI

struct Reader: View {
    var body: some View {
        ScrollView (.vertical, showsIndicators: false, content: {
            List {
                ForEach(0..<20) { chapter in
                    NavigationLink(destination: PluginList(), label: {
                        Label("Plugin list", systemImage: "list.bullet")
                            .foregroundColor(.red)
                    })
                }
            }
            
            // Top Buttons
            HStack {
                Button {
                    // Code
                } label: {
                    Text("Previous Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
                
                Button {
                    // Code
                } label: {
                    Text("Next Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
            }
            
            VStack(spacing: 0) {
                // Display Images
                ForEach(0..<8) { index in
                    AsyncImage(url: library.getSeriesList()[0].getChapterImageUrls(name: "chapter-1")[index]) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 1, idealWidth: .infinity, maxWidth: .infinity) //Komische dinge passieren
                    // Image wird breiter geladen, als der screen weit ist
                    // muss schauen wie man das auf den screen begrenzt bekommt
                }
            }
            // Bottom Buttons
            HStack {
                Button {
                    // Code
                } label: {
                    Text("Previous Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
                
                Button {
                    // Code
                } label: {
                    Text("Next Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
            }
            
            
        })
        //.ignoresSafeArea()
        .tabItem {
            Image(systemName: "eyeglasses")
            Text("Reader")
        }
    }
}

struct Reader_Previews: PreviewProvider {
    static var previews: some View {
        Reader()
    }
}
