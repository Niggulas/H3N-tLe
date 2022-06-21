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
                Button {
                    // Code
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(Color.red)
                .cornerRadius(15)
                
                
                
                HStack {
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
                    
                    Button {
                        // Code
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
                // NavigationLing to ChapterList
                /*NavigationLink(destination: ChapterList(), label: {
                    Label("Chapter List", systemImage: "book")
                        .font(.headline)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
                        .padding()
                        .foregroundColor(.red)
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                })*/
            
            VStack (spacing: 0) {
                ForEach(0..<20) { chapter in
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
                        
                        NavigationLink(destination: Reader(), label: {
                            HStack {
                                Text("Chapter \(chapter + 1)")
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
            
            // Seperator
            Divider()
                .padding()
            
            Button {
                // Code
            } label: {
                Text("Delete this series")
                    .font(.headline)
                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 20)
            }
            .padding()
            .background(Color.red)
            .foregroundColor(Color.primary)
            .cornerRadius(15)
            
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
