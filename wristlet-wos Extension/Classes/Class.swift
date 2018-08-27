//
//  Class.swift
//  wristlet
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

struct TopLevelClassDictionary: Decodable {
    let classes: [Class]
}

struct Class: Decodable {
    let name: String
    let id: Int
}
