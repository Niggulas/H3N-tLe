//
//  DownloadTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct DownloadTab: View {
    
    @State var searchBarContent = ""
    @State var plugInList = plugInManager.getAllPlugInNames()
    @State var isWebViewSheetVisible = true
    
    var body: some View {
        
        VStack {
            // URL Bar
            HStack {
                TextField("URL to series", text: $searchBarContent).onChange(of: searchBarContent) { newValue in
                    if let domain = URL(string: searchBarContent)?.host {
                        plugInList = plugInManager.getPlugInNamesForDomain(domain)
                    } else if searchBarContent.isEmpty {
                        plugInList = plugInManager.getAllPlugInNames()
                    } else {
                        plugInList = [String]()
                    }
                }
                .foregroundColor(Color.primary)
                
                Button {
                    // TODO: call a funnction to add entered URL
                    
                } label: {
                    Image(systemName: "square.and.arrow.down").onTapGesture {
                        /*library.runner.addMessageHandler({print($0)}, name: "print")
                         library.runner.view.disallowJS()
                         library.runner.view.disallowContent()
                         
                         let js = """
                         """
                         
                         library.runner.run(source: js, on: URL(string: searchBarContent))
                         library.runner.showPage()*/
                    }
                    .foregroundColor(Color.red)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding()
            .sheet(isPresented: $isWebViewSheetVisible) {
                // TODO: Warning not to get your passwords stolen here
                // TODO: Melde nich nicht an wenn du dem pluginautor nicht vertraust
                // die TODO darüber wurde erledigt
                
				VStack (spacing: 0) {
                    
                    HStack {
						
						Button {
							isWebViewSheetVisible = false
						} label: {
							Text("Hide")
								.font(.headline)
						}
						.padding()
						//.background(Color(.systemGray4))
						.foregroundColor(Color.red)
						
						Spacer()
                    }
                    
                    library.runner.view
                        
                }
                .ignoresSafeArea()
                
            }
            
            Spacer()
            
            // List of Plugins that are compatible with the site
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(spacing: 0){
                    ForEach(plugInList.map { IdentifieableAny(value: $0) } ) { plugInName in
                        Button (action: {
                            library.runner.addMessageHandler({print($0)}, name: "print")
                            library.runner.view.disallowJS()
                            library.runner.view.disallowContent()
                            
                        }, label: {
                            HStack {
                                Text(plugInName.value as! String)//\(plugInList[plugin])")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "square.and.arrow.down")
                            }
                        })
                        .font(.headline)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        .padding()
                        .foregroundColor(.red)
                        .background(Color(.systemGray6))
                        
                        Divider()
                        
                        
                    }
                }
                
                .cornerRadius(15)
                .padding()
                
            })
        }
        
        .tabItem {
            Image(systemName: "square.and.arrow.down.on.square.fill")
            Text("Download")
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

struct DownloadTab_Previews: PreviewProvider {
	static var previews: some View {
		DownloadTab()
			.preferredColorScheme(.dark)
			.previewDevice("iPhone 12")
			.previewLayout(.sizeThatFits)
			
	}
}
