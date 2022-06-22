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
							//.padding()
						} else if phase.error != nil {
						} else {
							Color(.systemGray6)
						}
					}
				}
				
				// Title & Description
				VStack {
					// Title
					Text(series.title)
						.font(.title)
						.bold()
						.padding()
					
					// Description
					Text(series.description)
						.font(.body)
					
					Spacer()
					
				}
			}
			
			// Seperator
			Divider()
				.padding()
			
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
				
				// Update & mark as read buttons
				HStack {
					
					// Update button
					Button {
						// Code
					} label: {
						Text("Update")
							.font(.headline)
							.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
					}
					.padding()
					.background(Color(.systemGray6))
					.foregroundColor(Color.red)
					.cornerRadius(15)
					
					// Mark as read button
					Button {
						series.markAllChaptersAsRead()
					} label: {
						Text("Mark as read")
							.font(.headline)
							.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
					}
					.padding()
					.background(Color(.systemGray6))
					.foregroundColor(Color.red)
					.cornerRadius(15)
					
				}
			}
			
			// Seperator
			Divider()
				.padding()
			
			// Chapter List
			VStack (spacing: 0) {
				
				ForEach(series.getChapterList().map { IdentifieableAny(value: $0) } ) { chapter in
					
					// Chapter element
					HStack (spacing: 0){
						
						Button {
							// Code
							// toggle chapterStatus
						} label: {
							/*  Changing of eye pseudo code
							 if chapterStatus = read
							 Image(systemName: "eye")
							 .frame(...)
							 else
							 Image(systemName: "eye.slash")
							 .frame(...)
							 
							 propably need the functions "getChapterStatus" and "setChapterStatus" somewhere
							 */
							Image(systemName: "eye")
								.frame(minWidth: 50, maxWidth: 50, minHeight: 20)
						}
						.padding()
						.background(Color(.systemGray6))
						.foregroundColor(Color.red)
						
						NavigationLink(destination: Reader(series: series, chapter: chapter.value as! String), label: {
							HStack {
								Text(chapter.value as! String)
								Spacer()
								Image(systemName: "chevron.right")
							}
							//Label("Chapter \(chapter + 1)", systemImage: "book")
							.font(.headline)
							.frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
							.padding()
							.foregroundColor(.red)
							.background(Color(.systemGray6))
							//.cornerRadius(15)
							// set frame after background
						})
						
						
					}
					Divider()
				}
			}
			.cornerRadius(15)
			
		})
		
	}
}
