//
//  DownloadTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct DownloadTab: View {
	
	@State var searchBarContent = ""
	@State var isWebViewSheetVisible = false
	
	var body: some View {
		
		VStack {
			
			Form {
				
				// TODO: TextField with go button
				
				HStack {
					TextField("URL to series", text: $searchBarContent, onCommit: {
						// TODO: call a funnction to add entered URL
					})
					
					Button {
						// TODO: call a funnction to add entered URL
						
					} label: {
						Image(systemName: "magnifyingglass").onTapGesture {
							library.runner.addMessageHandler({print($0)}, name: "print")
							library.runner.view.disallowJS()
							library.runner.view.disallowContent()
							
							let js = """
							"""
							
							library.runner.run(source: js, on: URL(string: searchBarContent))
							library.runner.showPage()
						}
					}
				}
			}
			.sheet(isPresented: $isWebViewSheetVisible) {
				// TODO: Warning not to get your passwords stolen here
				library.runner.view
			}
			
			/*
			 Spacer()
			 Rectangle()
			 .frame(height: 0)
			 .background(.thinMaterial)
			 */
		}
		
		.tabItem {
			Image(systemName: "plus")
			Text("Add")
		}
		.tag(0)
		.onAppear {
			library.setRunner(JSRunner(
				showView: {
					isWebViewSheetVisible = true
				},
				hideView: {
					isWebViewSheetVisible = false
				},
				isViewVisible: {
					return isWebViewSheetVisible
				},
				contentWorld: .world(name: "PlugIns")
			))
		}
	}
}
