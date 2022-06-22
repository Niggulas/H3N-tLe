//
//  LibraryTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI
import WebKit

struct LibraryTab: View {
    
    @State var seriesList = library.getSeriesList()
    
    var body: some View {
        VStack {
            NavigationView {
                
                    Form{
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
                                    
                                    Text(series.description)
                                        .foregroundColor(Color.secondary)
                                        .font(.body)
                                        .lineLimit(2)
									
                                }
                            })
                            
                        }
						.onDelete(perform: { index in
							seriesList[index.first!].delete()
							library.updateSeriesList()
							seriesList = library.getSeriesList()
						})
                    }
                    .navigationTitle("Library")
					.toolbar {
						Button {
							library.updateSeriesList()
							seriesList = library.getSeriesList()
						} label: {
							Text("Refresh")
								.foregroundColor(.red)
						}

					}
                    
            }
            
        }
        .tabItem {
            Image(systemName: "books.vertical")
            Text("Library")
        }
        .tag(1)
		.onDisappear(perform: {
			library.updateSeriesList()
			seriesList = library.getSeriesList()
		})
        
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
