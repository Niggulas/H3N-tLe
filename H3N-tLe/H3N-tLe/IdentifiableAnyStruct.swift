//
//  IdentifiableStringStruct.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 21.06.22.
//

import Foundation

/*
 This struct is needed so you can make things identifiable
 you need to do this, if you want to list an array of things
 but only if the size of that array can change while using the app
 */

struct IdentifieableAny: Identifiable {
    var id = UUID()
    var value: Any
}
