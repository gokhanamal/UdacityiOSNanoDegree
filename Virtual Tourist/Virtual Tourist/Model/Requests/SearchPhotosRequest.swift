//
//  SearchPhotosRequest.swift
//  Virtual Tourist
//
//  Created by Gokhan Namal on 14.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

struct SearchPhotosRequest: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let photo: [PhotoInfo]
    let pages: Int
}

struct PhotoInfo: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let isPublic: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case isPublic = "ispublic"
    }
}
