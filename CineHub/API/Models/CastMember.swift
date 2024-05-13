//
//  CastMember.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import Foundation

struct CastMember: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}
