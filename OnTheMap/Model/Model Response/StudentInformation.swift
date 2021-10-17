//
//  File.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import Foundation

struct StudentInformationResponse: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
    func getFormatName() -> String {
        return firstName + " " + lastName
    }
}
