//
//  PluginList.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 01.04.22.
//

import SwiftUI

struct PluginList: View {
    
    // Get an array of currently installed plugins
    @State var plugInList = plugInManager.getAllPlugInNames()
    
    var body: some View {
        
        // Use of a list, so that the plugins get displayed in a organized way
        List {
            // Loop that goes throu the array of installed plugins
            ForEach(plugInList.map { IdentifieableAny(value: $0) } ) { plugInName in
                
                if let url = plugInManager.getPlugInWebsite(plugIn: plugInName.value as! String) {
                    // The Elements are Links, so they can lead to their repo
                    Link(destination: url, label: { // TODO: make the Link dynamic to the website of the plugin
                        HStack{
                            Text(plugInName.value as! String)
                            Spacer()
                            Image(systemName: "link")
                        }
                    })
                    
                    
                } else {
                    Text(plugInName.value as! String)
                        .foregroundColor(.red)
                }
                
                
            }
            
        }
        
    }
    
}

struct PluginList_Previews: PreviewProvider {
    static var previews: some View {
        PluginList()
            .preferredColorScheme(.dark)
    }
}
