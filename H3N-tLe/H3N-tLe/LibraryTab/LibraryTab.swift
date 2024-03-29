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
		NavigationView {
			VStack {
				
				Form{
					ForEach(seriesList) { series in
						// Series Element
						NavigationLink(destination: SeriesView(series: series), label: {
							
							// Cover image with option to
							HStack{
								AsyncImage(url: series.getCoverUrl()) { phase in
									
									if let image = phase.image {
										image
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: 85)
											.cornerRadius(5)
									} else if phase.error != nil {
										AsyncImage(url: series.getCoverUrl()) { phase in
											if let image = phase.image {
												image
													.resizable()
													.aspectRatio(contentMode: .fit)
													.frame(width: 85)
													.cornerRadius(5)
											} else {
												Image("Cover")
													.resizable()
													.aspectRatio(contentMode: .fit)
													.frame(width: 85)
													.cornerRadius(5)
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
							}
							
							// Series text & status
							VStack (alignment: .leading){
								
								// Title
								Text(series.title)
									.font(.headline)
									.lineLimit(1)
								
								// Description
								Text(series.description)
									.foregroundColor(Color.secondary)
									.font(.body)
									.lineLimit(2)
								
								// new line to seperate the status from the description and b/c .padding() wasn't the right thing
								Text("")
								
								// Show the status of the series in a color corralating to the status
								switch series.getStatus() {
								case "dropped" :
									Text(series.getStatus())
										.font(.body)
										.lineLimit(1)
										.foregroundColor(.red)
										.background(Color(.systemGray5))
										.cornerRadius(5)
									
								case "ongoing" :
									Text(series.getStatus())
										.font(.body)
										.lineLimit(1)
										.foregroundColor(.green)
										.background(Color(.systemGray5))
										.cornerRadius(5)
									
								case "hiatus" :
									Text(series.getStatus())
										.font(.body)
										.lineLimit(1)
										.foregroundColor(.yellow)
										.background(Color(.systemGray5))
										.cornerRadius(5)
									
								case "finished" :
									Text(series.getStatus())
										.font(.body)
										.lineLimit(1)
										.foregroundColor(.cyan)
										.background(Color(.systemGray5))
										.cornerRadius(5)
									
								default :
									Text(series.getStatus())
										.font(.body)
										.lineLimit(1)
										.foregroundColor(.red)
										.background(Color(.systemGray5))
										.cornerRadius(5)
								}
								
							}
							
						})
						
					}
					.onDelete(perform: { index in
						seriesList[index.first!].delete()
						library.updateSeriesList()
						seriesList = library.getSeriesList()
					})
				}
				.toolbar {
					Button {
						// Refresh PlugIns
						plugInManager.registerPlugIns()
						
						// Refresh Library
						library.updateSeriesList()
						seriesList = library.getSeriesList()
					} label: {
						Text("Refresh")
							.foregroundColor(.red)
					}
					
				}
				
			}
			.navigationTitle("Library")
		}
		.tabItem {
			Image(systemName: "books.vertical")
			Text("Library")
		}
		// use this tab if you open the app
		.tag(1)
		.onAppear{
			// auto refresh the library when you come from another tab
			library.updateSeriesList()
			seriesList = library.getSeriesList()
		}
		
	}
	
}
