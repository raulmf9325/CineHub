//
//  Credits.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import Foundation

struct Credits: Decodable {
    let cast: [CastMember]
    let crew: [CrewMember]
}
