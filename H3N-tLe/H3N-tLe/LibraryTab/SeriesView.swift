//
//  SeriesView.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.06.22.
//

import SwiftUI

struct SeriesView: View {
	
	@State var isSheetVisible = false
	@State var series: Series?
	/*
	 @State var refresh = false
	 @State private var eye = "eye.slash"
	 
	 func chooseEye (index: String) {
	 if series!.didReadChapter(index) {
	 eye = "eye"
	 } else {
	 eye = "eye.slash"
	 }
	 }
	 */
	func refresh() {
		//series = library.getSeriesList()[0]
		//series = library.getSeriesList()[1]
		let tmp = series
		series = nil
		series = tmp
	}
	
	var body: some View {
		ScrollView (.vertical, /*showsIndicators: false,*/ content:{
			// Series Information
			// Title
			HStack {
				Text(series!.title)
					.font(.title)
					.bold()
					.padding()
					.frame(alignment: .leading)
				Spacer()
			}
			// Cover & Description
			HStack {
				// Cover
				if series!.getCoverUrl() != nil {
					AsyncImage(url: series!.getCoverUrl()) { phase in
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
				
				// Description
				Button {
					isSheetVisible = true
				} label: {
					Text(series!.description)
						.font(.body)
						.lineLimit(9)
						.multilineTextAlignment(.leading)
				}
				.foregroundColor(.primary)
				
			}
			
			/*
			 Spaceholder to get some padding below the series information
			 Can't use .padding() on the Divider() because we need .padding() on the buttons so they don't go edge to edge
			 Can't use .padding() on the HStack because we don't want it to be pushed in on the sides
			 */
			//Text("")
			
			// Seperator
			Divider()
			
			// Upper Buttons
			HStack {
				
				Spacer()
				
				// Continue button: open the first unread chapter
				NavigationLink (destination: Reader(series: series!, chapter: series!.getNextUnreadChapter() ), label: {
					Text("Continue")
						.font(.headline)
						.frame(minWidth: 100, maxWidth: 120, minHeight: 10)
				})
				.padding(12)
				.background(Color(.systemGray6))
				.foregroundColor(Color.red)
				.cornerRadius(15)
				
				Spacer()
				
				// Update button
				Button {
					series!.updateChapters()
				} label: {
					Text("Update")
						.font(.headline)
						.frame(minWidth: 100, maxWidth: 120, minHeight: 20)
				}
				.padding(12)
				.background(Color(.systemGray6))
				.foregroundColor(Color.red)
				.cornerRadius(15)
				
				Spacer()
				
				// Mark as read button
				/*
				 Button {
				 series!.markAllChaptersAsRead()
				 refresh()
				 } label: {
				 Text("Mark as read")
				 .font(.headline)
				 .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
				 }
				 .padding()
				 .background(Color(.systemGray6))
				 .foregroundColor(Color.red)
				 .cornerRadius(15)
				 */
				
				
			}
			
			// Seperator
			Divider()
			
			// Chapter List
			HStack {
				Spacer()
				VStack (spacing: 0) {
					
					ForEach(series!.getChapterList().map { IdentifieableAny(value: $0) } ) { chapter in
						
						// Chapter element
						HStack (spacing: 0){
							
							// Eye Button
							/*
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
							 */
							
							if series!.didReadChapter(chapter.value as! String) {
								
								Button {
									// TODO: Wait for a markChapterAsUnread funtion
									series!.markChapterAsUnread(chapter: chapter.value as! String)
									refresh()
								} label: {
									Image(systemName: "eye")
										.frame(minWidth: 50, maxWidth: 50, minHeight: 20)
										.padding()
										.background(Color(.systemGray6))
										.foregroundColor(Color.red)
									
								}
							} else {
								Button  {
									series!.markChapterAsRead(chapter: chapter.value as! String)
									refresh()
								} label: {
									Image(systemName: "eye.slash")
										.frame(minWidth: 50, maxWidth: 50, minHeight: 20)
										.padding()
										.background(Color(.systemGray6))
										.foregroundColor(Color.red)
								}
								
							}
							
							
							// Chapter element
							NavigationLink(destination: Reader(series: series!, chapter: chapter.value as! String), label: {
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
				Spacer()
			}
			//Mark as unread button
			/*
			 // Seperator
			 Divider()
			 
			 // Mark as unread
			 Button {
			 series!.clearReadChapters()
			 series!.clearLastReadChapter()
			 refresh()
			 } label: {
			 Text("Mark as unread")
			 .font(.headline)
			 .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
			 }
			 .padding()
			 .background(Color(.systemGray6))
			 .foregroundColor(Color.red)
			 .cornerRadius(15)
			 .padding()
			 */
			
		})
		.navigationTitle("")
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $isSheetVisible) {
			// TODO: Warning not to get your passwords stolen here
			// TODO: Melde nich nicht an wenn du dem pluginautor nicht vertraust
			// die TODO darüber wurde erledigt
			
			VStack (spacing: 0) {
				
				HStack {
					
					Button {
						isSheetVisible = false
					} label: {
						Text("Hide")
							.font(.headline)
					}
					.padding()
					//.background(Color(.systemGray4))
					.foregroundColor(Color.red)
					
					Spacer()
				}
				
				Divider()
				
				Text("Description:")
					.font(.title)
					.bold()
					.padding()
					.multilineTextAlignment(.leading)
				
				Text(series!.description)
				
				Spacer()
				
			}
			.ignoresSafeArea()
			
		}
		.onAppear {
			refresh()
		}
		/*.toolbar{
		 Button {
		 isSheetVisible = true
		 } label: {
		 Label("Tags", systemImage: "tag")
		 
		 //Text("Tags")
		 }
		 
		 }
		 
		 */
	}
	
}
