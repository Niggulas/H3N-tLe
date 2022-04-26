//
//  HomeTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct HomeTab: View {
    
    var series: [SeriesInfo] = getAllSeriesInfo()//dummySeriesInfo
    @State var firstTime: Bool = true
    @State var isSeriesViewOpen: Bool = false
    @State var selectedSeries: SeriesInfo? = nil /*= SeriesInfo(
        localUrl: URL(fileURLWithPath: "file:///"),
        title: "Welcome",
        description: "Sorry this is a crappy fix :(",
        imageName: "Error"
    )*/
    @State var counter: Int = 0
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(series) { Series in
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                ButtonClick(Series: Series)
                            } label: {
                                if let imageName = Series.imageName {
                                    AsyncImage(url: Series.localUrl.appendingPathComponent(imageName)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 85)
                                                .cornerRadius(5)
                                        } else if phase.error != nil {
                                            Image("Cover")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 85)
                                                .cornerRadius(5)
                                        } else {
                                            Color(.systemGray6)
                                        }
                                    }
                                } else {
                                    Image("Cover")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 85)
                                        .cornerRadius(5)
                                }
                            }
                            
                            // plsHelp()
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Button {
                                    ButtonClick(Series: Series)
                                } label: {
                                    VStack (alignment: .leading){
                                        Text(Series.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        HStack {
                                            Text(Series.description ?? "")
                                                .foregroundColor(Color.secondary)
                                                .font(.body)
                                                .lineLimit(2)
                                            // TODO: check if the text is always aligned to the left
                                            
                                            Spacer()
                                            
                                        }
                                    }
                                }
                                .foregroundColor(Color.primary)
                                
                                Button {
                                    counter += 1
                                    // TODO: set popup variable to true and write index of item to a variable
                                } label: {
                                    Text("Continue")
                                        .font(.headline)
                                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(15)
                                }
                                //.frame(.minWidth: 0, .maxWidth: .infinity)
                                
                                
                            }
                        }
                        Divider()
                    }
                }
                //.listRowBackground(Color.init(white:0, opacity:0))
            }
            
            
            Spacer()
            
            Rectangle()
                .frame(height: 0)
                .background(.thinMaterial)
        }
        .sheet(isPresented: $isSeriesViewOpen, content: {
            if let toView = selectedSeries {
                SeriesSheet(Series: toView)/*
                    .onAppear(perform: {
                        if firstTime {
                            firstTime = false
                            isSeriesViewOpen = false
                        }
                    })*/
            }
        })
        .tabItem {
            Image(systemName: "books.vertical")
            Text("Library")
        }
        .tag(1)
        
    }
    
    func ButtonClick(Series: SeriesInfo) {
        print("ButtonClick called succesfully")
        if false && firstTime {
            print("Firt Time")
            isSeriesViewOpen = true
            //selectedSeries = SeriesInfo(title: "", description: "", imageName: "")
            //isSeriesViewOpen = false
            //firstTime.toggle()
        } else {
            selectedSeries = Series
            isSeriesViewOpen = true
        }
        
    }
    func hideSheet() {
        isSeriesViewOpen = false
    }
    
}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
            .previewLayout(.sizeThatFits)
            
    }
}
