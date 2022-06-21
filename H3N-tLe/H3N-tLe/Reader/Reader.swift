//
//  Reader.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 11.05.22.
//

import SwiftUI

struct Reader: View {
    
    init(series: Series, chapter: String) {
        self.series = series
        chapterIndex = series.getChapterList().firstIndex(of: chapter)!
    }
    
    let series: Series
    @State var chapterIndex: Int
    
    func isFirstChapter() -> Bool {
        return chapterIndex == 0
    }
    func isLastChapter() -> Bool {
        return chapterIndex == series.getChapterList().count - 1
    }
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false, content: {
            // Top Buttons
            HStack {
                if !isFirstChapter() {
                    Button {
                        chapterIndex -= 1
                    } label: {
                        Image(systemName: "arrow.left")
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                
                if !isLastChapter() {
                    Button {
                        chapterIndex += 1
                    } label: {
                        Image(systemName: "arrow.right")
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                
            }
            
            // Images
            VStack(spacing: 0) {            // Removes the spacing between the images
                // Display Images
                ForEach(series.getChapterImageUrls(name: series.getChapterList()[chapterIndex]).map { IdentifieableAny(value: $0) } ) { url in
                    AsyncImage(url: url.value as? URL) { image in
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
                if !isFirstChapter() {
                    Button {
                        chapterIndex -= 1
                    } label: {
                        Image(systemName: "arrow.left")
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                
                if !isLastChapter() {
                    Button {
                        chapterIndex += 1
                    } label: {
                        Image(systemName: "arrow.right")
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                
            }
            
            
        })
        //.ignoresSafeArea()
        .tabItem {
            Image(systemName: "eyeglasses")
            Text("Reader")
        }
    }
}
