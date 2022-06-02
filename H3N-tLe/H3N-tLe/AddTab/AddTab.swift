//
//  AddTab.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 31.03.22.
//

import SwiftUI

struct AddTab: View {
    
    @State var searchBarContent: String = ""
    
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
                        Image(systemName: "magnifyingglass")
                            
                    }

                }
                
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
    }
}
