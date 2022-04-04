//
//  HomeTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct HomeTab: View {
    
    var series: [SeriesModel] = dummySeriesModel
    
    var body: some View {
        VStack {
            
            List {
                
                ForEach(series) { series in
                    HStack {
                        
                        Image(series.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 85)
                        
                        VStack(alignment: .leading){
                            Text(series.title)
                                .font(.headline)
                                .lineLimit(1)
                            Text(series.description)
                                .font(.body)
                                .lineLimit(2)
                            HStack {
                                Button {
                                    // TODO: set popup variable to true and write index of item to a variable
                                } label: {
                                    Text("Read First")
                                }
                                .padding()
                                .background(Color.red)
                                .foregroundColor(Color.primary)
                                .cornerRadius(15)
                                
                                Spacer()
                                
                                Button {
                                    // TODO: set popup variable to true and write index of item to a variable
                                } label: {
                                    Text("Continue")
                                }
                                .padding()
                                .background(Color.green)
                                .foregroundColor(Color.primary)
                                .cornerRadius(15)


                            }
                        }
                    }
                }
            }
            
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

struct SeriesModel: Identifiable {
    var id = UUID()
    
    var title: String
    var description: String
    var imageName: String
}

let dummySeriesModel = [SeriesModel(title:"A beautiful title",
                                    description: "A very well thought out description which describes the series in a very correct and inviting manner",
                                    imageName: "aNiceThumbNail"),
                        SeriesModel(title: "Short title",                   description: "A short desctiption",
                                    imageName: "aSquareThumbNail")]

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
            .previewLayout(.sizeThatFits)
            
    }
}
