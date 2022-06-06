//
//  H3N_tLeApp.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 30.03.22.
//

import SwiftUI

@main
struct H3N_tLeApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView().onAppear {
				print()
				print()
				print()
				
				let seriesList = getAllSeriesInfo()
				print("Series List:")
				print(seriesList)
				
				let series = seriesList.first
				if series == nil {
					return
				}
				print("Series:")
				print(series!)
				
				let chapterList = series!.getCapterList()
				print("Chapter List:")
				print(chapterList)
				
				let chapter = chapterList.first
				if chapter == nil {
					return
				}
				print("Chapter: \(chapter!)")
				print("Chapter Image URLs:")
				print(series!.getChapterImageUrls(name: chapter!))
				
				print()
				print()
				print()
			}
		}
	}
}
