//
//  OTMErrorResponse.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

struct OTMErrorResponse: Codable {
    let error: String
    let status: Int
}

extension OTMErrorResponse: LocalizedError {
    var errorDescription: String? {
        return self.error
    }
}
