//
//  Reader.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 11.05.22.
//

import SwiftUI

struct Reader: View {
    var body: some View {
        ScrollView (.vertical, showsIndicators: false, content: {
            HStack {
                Button {
                    // Code
                } label: {
                    Text("Previous Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
                
                Button {
                    // Code
                } label: {
                    Text("Next Chapter")
                        .font(.headline)
                        .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                }
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(Color.red)
                .cornerRadius(15)
            }
            
            ForEach(0..<20) { index in
                Image("aNiceThumbNail")
                    .frame(minWidth: 1, idealWidth: .infinity, maxWidth: .infinity, minHeight: 1, idealHeight: .infinity, maxHeight: .infinity) //Komische dinge passieren
                    // Image wird breiter geladen, als der screen weit ist
                    // muss schauen wie man das auf den screen begrenzt bekommt
            }
            
            VStack {
                HStack {
                    Button {
                        // Code
                    } label: {
                        Text("Previous Chapter")
                            .font(.headline)
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                    
                    Button {
                        // Code
                    } label: {
                        Text("Next Chapter")
                            .font(.headline)
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
                HStack{
                    Button {
                        // Code
                    } label: {
                        Text("Foo")
                            .font(.headline)
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                    
                    Button {
                        // Code
                    } label: {
                        Text("Bar")
                            .font(.headline)
                            .frame(minWidth: 1, maxWidth: .infinity, minHeight: 20)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(Color.red)
                    .cornerRadius(15)
                }
            }
        })
        .tabItem {
            Image(systemName: "eyeglasses")
            Text("Reader")
        }
    }
}

struct Reader_Previews: PreviewProvider {
    static var previews: some View {
        Reader()
    }
}
