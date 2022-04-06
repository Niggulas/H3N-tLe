//
//  SeriesSheet.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 05.04.22.
//

import SwiftUI

struct SeriesSheet: View {
    
    var Series: SeriesModel
    
    var body: some View {
        VStack {
            HStack {
                Image(Series.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            //hideSheet()
                        } label: {
                            Image(systemName: "xmark")
                                .padding()
                                .frame(width: 30)
                                .foregroundColor(Color.secondary)
                        }

                    }
                    Spacer()
                    
                    Text(Series.title)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Text(Series.description)
                        .font(.body)
                    
                    Spacer()
                }
                
                Spacer()
                
            }
            
            Divider()
            
            Button {
                debugPrint(Series: Series)
            } label: {
                Text("DEBUG")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            
            Divider()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                List {
                    ForEach(0..<20) { plugin in
                        Link(destination: URL(string: "https://google.com")!,
                             label: {
                                Label("Plugin \(plugin)", systemImage: "link")
                            
                        })
                        
                    }
                }
            })
        }
    }
    
    func debugPrint(Series: SeriesModel) {
        print("content of 'Series' is \(Series)")
    }
}
