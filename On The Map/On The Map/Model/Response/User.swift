//
//  User.swift
//  On The Map
//
//  Created by Gokhan Namal on 13.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: Date
    let updatedAt: Date
}
