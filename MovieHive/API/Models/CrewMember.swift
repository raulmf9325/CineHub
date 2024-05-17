//
//  CrewMember.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import Foundation

struct CrewMember: Decodable {
    let name: String
    let job: String
    let id: Int
    let profile_path: String?
}
