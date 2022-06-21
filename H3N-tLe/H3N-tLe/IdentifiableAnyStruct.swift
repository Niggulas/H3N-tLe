//
//  IdentifiableStringStruct.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 21.06.22.
//

import Foundation

struct IdentifieableAny: Identifiable {
    var id = UUID()
    var value: Any
}
