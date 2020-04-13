//
//  SessionRequest.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

struct SessionRequest: Codable {
    let udacity: UserInformation
}

struct UserInformation: Codable {
    let username: String
    let password: String
}
