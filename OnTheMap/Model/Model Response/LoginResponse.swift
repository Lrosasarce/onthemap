//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: LoginSession
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct LoginSession: Codable {
    let id: String
    let expiration: String
}
