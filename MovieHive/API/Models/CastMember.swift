//
//  CastMember.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import Foundation

struct CastMember: Decodable, Identifiable {
    let name: String
    let character: String
    let id: Int
    let profile_path: String?
}
