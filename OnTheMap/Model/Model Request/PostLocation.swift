//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 17/10/21.
//

import Foundation

struct PostStudenLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
