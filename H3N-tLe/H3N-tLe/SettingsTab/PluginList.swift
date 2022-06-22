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
                
                // The Elements are Links, so they can lead to their repo
                Link(destination: URL(string: "example.com")!, label: { // TODO: make the Link dynamic to the website of the plugin
                    Label(plugInName.value as! String, systemImage: "link")
                })
                
            }
            // this makes the elements able to be swiped left to delete them
            .onDelete(perform: {
                indexSet in
                
                PlugInManager.deletePlugIn(<#T##self: PlugInManager##PlugInManager#>)
                // TODO: write action to remove plugin
            })
            
        }
    }
}

struct PluginList_Previews: PreviewProvider {
    static var previews: some View {
        PluginList()
            .preferredColorScheme(.dark)
    }
}
