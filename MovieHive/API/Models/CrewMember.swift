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
    let profile_path: String?
}
