//
//  SeriesSheet.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 05.04.22.
//

import SwiftUI

struct SeriesSheet: View {
    
    var Series: SeriesModel
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false, content: {
            VStack {
                
                // Series information
                HStack {
                    Image(Series.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130)
                        .cornerRadius(5)
                        .padding()
                    
                    Spacer()
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                //hideSheet()
                            } label: {
                                Image(systemName: "xmark")
                                    .padding()
                                    .frame(width: 30)
                                    .foregroundColor(Color.secondary)
                            }
                            
                        }
                        
                        Text(Series.title)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Text(Series.description)
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
                
                Divider()
                
                // Chapter list
                
                Form {
                    Section(header: Text("Chapters")) {
                        Button {
                            // Code
                        } label: {
                            Text("")
                        }

                        //ForEach(0..<20) { index in
                        //   Text("Chapter \(index)")
                        //}
                    }
                }
                
                // End of chapter list
                
            }
        })
    }
    
    func debugPrint(Series: SeriesModel) {
        print("content of 'Series' is \(Series)")
    }
}
