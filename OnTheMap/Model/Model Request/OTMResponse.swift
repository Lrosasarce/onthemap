//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 11/10/21.
//

import Foundation

struct OTMResponse: Codable {
    let statusCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorMessage = "error"
    }
    
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
