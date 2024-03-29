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
		ScrollView(.vertical, showsIndicators: false) {
			// Top Buttons
			buttons
			
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
					.frame(minWidth: 1, idealWidth: .infinity, maxWidth: .infinity)
				}
			}
			
			// Bottom Buttons
			buttons
		}
		.navigationTitle(series.getChapterList()[chapterIndex])
	}
	
	var buttons: some View {
		HStack {
			
			// Check if it is the firs chapter, if not, then show a previous chapter button
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
			
			// Check if it is the last chapter, if not, then show a next chapter button
			if !isLastChapter() {
				Button {
					series.markChapterAsRead(chapter: series.getChapterList()[chapterIndex])
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
	}
	
}
