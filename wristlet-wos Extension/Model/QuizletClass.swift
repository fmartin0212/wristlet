//
//  Class.swift
//  wristlet
//
//  Created by Frank Martin Jr on 8/21/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

struct TopLevelClassDictionary: Decodable {
    let classes: [QuizletClass]
}

struct QuizletClass: Decodable {
    let name: String
    let id: Int
}
