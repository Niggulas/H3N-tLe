//
//  SeriesView.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.06.22.
//

import SwiftUI

struct SeriesView: View {
    
    var series: Series
    
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
            
            // Buttons
            VStack {
                HStack {
                    Button {
                        // Code
                    } label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                    
                    Button {
                        // Code
                    } label: {
                        Text("Update")
                            .font(.headline)
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                HStack {
                    Button {
                        // Code
                    } label: {
                        Text("Mark as read")
                            .font(.headline)
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                    
                    Button {
                        // Code
                    } label: {
                        Text("Delete")
                            .font(.headline)
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.primary)
                    .cornerRadius(15)
                }
            }
            
            // Seperator
            Divider()
                .padding()
            
            // Chapter List
            ChapterList()
            
            /*ForEach(0..<20) { chapter in
                NavigationLink(destination: Reader(), label: {
                    Label("Chapter \(chapter + 1)", systemImage: "book")
                        .foregroundColor(.red)
                        .background(Color(.systemGray6))
                        .frame(idealWidth: .infinity,idealHeight: 20)
                        
                    
                        // set frame after background
                })
            }*/
            
            
        })
        
        /*NavigationView {
            
            VStack {
                
                // Series information
                HStack {
                    if series.getCoverUrl() != nil {
                        AsyncImage(url: series.getCoverUrl()) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130)
                                    .cornerRadius(5)
                                    .padding()
                            } else if phase.error != nil {
                            } else {
                                Color(.systemGray6)
                            }
                        }
                    }
                    Spacer()
                    
                    
                    VStack {
                        
                        Text(series.title)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Text(series.description ?? "")
                            .font(.body)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
                
                // End of series information
                
                Divider()
                    .padding()
                
                // Buttons
                
                VStack {
                    HStack {
                        Button {
                            // Code
                        } label: {
                            Text("Continue")
                                .font(.headline)
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(Color.red)
                        .cornerRadius(15)
                        
                        Button {
                            // Code
                        } label: {
                            Text("Update")
                                .font(.headline)
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(Color.red)
                        .cornerRadius(15)
                    }
                    HStack {
                        Button {
                            // Code
                        } label: {
                            Text("Mark as read")
                                .font(.headline)
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(Color.red)
                        .cornerRadius(15)
                        
                        Button {
                            // Code
                        } label: {
                            Text("Delete")
                                .font(.headline)
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(Color.primary)
                        .cornerRadius(15)
                    }
                }
                
                // End of buttons
                
                Divider()
                    .padding()
                
                // Chapter list
                List {
                    ForEach(0..<20) { chapter in
                        NavigationLink(destination: Reader(), label: {
                            Label("Chapter \(chapter + 1)", systemImage: "book")
                                .foregroundColor(.red)
                        })
                    }
                }
                /*ForEach(0..<20) { plugin in
                 NavigationLink(destination: Reader(),
                 label: {
                 Label("Plugin \(plugin)", systemImage: "link")
                 
                 })
                 
                 }*/
                
                // End of chapter list
                
            }
            
        }//)  */
    }
}
