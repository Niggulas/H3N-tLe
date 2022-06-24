//
//  SeriesView.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.06.22.
//

import SwiftUI

struct SeriesView: View {
	
	@State var series: Series
	
	var body: some View {
		ScrollView (.vertical, showsIndicators: false, content:{
			// Series Information
			Text(series.title)
				.font(.title)
				.bold()
				.padding()
				.frame(alignment: .center)
			
			HStack {
				// Cover
				if series.getCoverUrl() != nil {
					AsyncImage(url: series.getCoverUrl()) { phase in
						if let image = phase.image {
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 130)
								.cornerRadius(5)
						} else if phase.error != nil {
						} else {
							Color(.systemGray6)
						}
					}
				}
				
				// Description
				Text(series.description)
					.font(.body)
					.lineLimit(9)
				
			}
			
			/*
			 Spaceholder to get some padding below the series information
			 Can't use .padding() on the Divider() because we need .padding() on the buttons so they don't go edge to edge
			 Can't use .padding() on the HStack because we don't want it to be pushed in on the sides
			 */
			Text("")
			Text("")
			
			// Seperator
			Divider()
			
			// Upper Buttons
			VStack {
				
				// Continue button: open the first unread chapter
				NavigationLink (destination: Reader(series: series, chapter: series.getNextUnreadChapter() ), label: {
					Text("Continue")
						.font(.headline)
						.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
				})
				.padding()
				.background(Color(.systemGray6))
				.foregroundColor(Color.red)
				.cornerRadius(15)
				
				// Clear last read chapter button
				Button {
					series.clearLastReadChapter()
				} label: {
					Text("Clear last read chapter")
						.font(.headline)
						.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
				}
				.padding()
				.background(Color(.systemGray6))
				.foregroundColor(Color.red)
				.cornerRadius(15)
				.padding()
			}
			.padding()
			
			// Seperator
			Divider()
			
			// Chapter List
			VStack (spacing: 0) {
				
				ForEach(series.getChapterList().map { IdentifieableAny(value: $0) } ) { chapter in
					
					// Chapter element
					HStack (spacing: 0){
						
						// Chapter element
						NavigationLink(destination: Reader(series: series, chapter: chapter.value as! String), label: {
							HStack {
								Text(chapter.value as! String)
								Spacer()
								Image(systemName: "chevron.right")
							}
							.font(.headline)
							.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
							.padding()
							.foregroundColor(.red)
							.background(Color(.systemGray6))
						})
						
						
					}
					Divider()
				}
			}
			.cornerRadius(15)
			.padding()
			
			
		})
		
	}
}
