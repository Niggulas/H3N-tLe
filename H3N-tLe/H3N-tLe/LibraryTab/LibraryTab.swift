//
//  LibraryTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct LibraryTab: View {
    
    var seriesList = library.getSeriesList()
    @State var firstTime: Bool = true
    @State var isSeriesViewOpen: Bool = false
    @State var selectedSeries: Series? = nil
    @State var counter: Int = 0
    
    var body: some View {
        VStack {
            NavigationView {
                
                    Form{           // was a VStack
                        ForEach(seriesList) { series in
                            // Series Element
                            NavigationLink(destination: SeriesView(series: series), label: {
                                
                                HStack{
                                    if series.getCoverUrl() != nil {
                                        AsyncImage(url: series.getCoverUrl()) { phase in
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
                                
                                VStack (alignment: .leading){
                                    Text(series.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                    
                                    //HStack {
                                    Text(series.description)
                                        .foregroundColor(Color.secondary)
                                        .font(.body)
                                        .lineLimit(2)
                                    // TODO: check if the text is always aligned to the left
                                    
                                    //Spacer()
                                    //}
                                }
                            })
                            
                            /*VStack {
                                HStack {
                                    Spacer()
                                    
                                    // Cover Image
                                    Button {
                                        ButtonClick(series: series)
                                    } label: {
                                        if series.getCoverUrl() != nil {
                                            AsyncImage(url: series.getCoverUrl()) { phase in
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
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading){
                                        Button {
                                            ButtonClick(series: series)
                                        } label: {
                                            VStack (alignment: .leading){
                                                Text(series.title)
                                                    .font(.headline)
                                                    .lineLimit(1)
                                                
                                                HStack {
                                                    Text(series.description ?? "")
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
                            }*/
                        }
                    }
                    .navigationTitle("Library")
                    //.listRowBackground(Color.init(white:0, opacity:0))
                    
                
            }
            
        }
        .sheet(isPresented: $isSeriesViewOpen, content: {
            if let toView = selectedSeries {
                SeriesSheet(series: toView)/*
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
    
    func ButtonClick(series: Series) {
        print("ButtonClick called succesfully")
        if false && firstTime {
            print("Firt Time")
            isSeriesViewOpen = true
            //selectedSeries = SeriesInfo(title: "", description: "", imageName: "")
            //isSeriesViewOpen = false
            //firstTime.toggle()
        } else {
            selectedSeries = series
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