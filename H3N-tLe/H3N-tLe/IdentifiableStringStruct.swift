//
//  IdentifiableStringStruct.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 21.06.22.
//

import Foundation

struct IdentifieableString: Identifiable {
    var id = UUID()
    var value: String
}
