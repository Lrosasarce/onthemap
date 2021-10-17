//
//  File.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 17/10/21.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
