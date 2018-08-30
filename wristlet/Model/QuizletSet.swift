//
//  Set.swift
//  wristlet
//
//  Created by Frank Martin Jr on 8/9/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import Foundation

struct QuizletSet: Decodable {
    let id: Int
    let title: String
    let count: Int
    let terms: [Term]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case count = "term_count"
        case terms
    }
}

struct Term: Decodable {
    let term: String
    let definition: String
}
