//
//  SessionResponse.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: SessionAccount
    let session: SessionDetails
}

struct SessionAccount: Codable {
    let registered: Bool
    let key: String
}

struct SessionDetails: Codable {
    let id: String
    let expiration: String
}
