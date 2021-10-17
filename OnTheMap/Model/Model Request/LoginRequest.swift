//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: LoginUdacity
    
    init(username: String, password: String) {
        self.udacity = LoginUdacity(username: username, password: password)
    }
}

struct LoginUdacity: Codable {
    let username: String
    let password: String
}
