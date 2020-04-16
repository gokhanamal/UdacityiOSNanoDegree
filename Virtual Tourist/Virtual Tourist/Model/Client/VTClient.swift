//
//  VTClient.swift
//  Virtual Tourist
//
//  Created by Gokhan Namal on 14.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class VTClient {
    struct Auth {
        static let apiKey = "24be76e2f5563986a4bb8c9de90e7b1d"
        static let apiSecret = "79c3fe038e067b5d"
    }

    enum Endpoints {
        static let baseURL  = "https://api.flickr.com/services/rest?format=json&nojsoncallback=1&per_page=12"
        static let apiKeyParams = "&api_key=" + Auth.apiKey
        
        case getPhotosForLocation(Double, Double, Int)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case let .getPhotosForLocation(lat, lon, page):
                return Endpoints.baseURL + "&method=flickr.photos.search" + Endpoints.apiKeyParams + "&lat=" + String(lat) + "&lon=" + String(lon) + "&page="+String(page)
            }
        }
    }
    
    class func getPhotos(lat: Double, lon: Double, page: Int, completion: @escaping ([String], Error?) -> Void) {
   
        let task = URLSession.shared.dataTask(with: Endpoints.getPhotosForLocation(lat, lon, page).url) {data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            do {
               let responseObject = try JSONDecoder().decode(SearchPhotosRequest.self, from: data)
                DispatchQueue.main.async {
                    let publicPhotos = responseObject.photos.photo.filter{$0.isPublic == 1}
                    let photoURLs = publicPhotos.map({createImageURL(photo: $0)})
                    completion(photoURLs, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    class func createImageURL(photo: PhotoInfo) -> String  {
        return "https://farm\(String(photo.farm)).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
    
    class func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }  
        }
        task.resume()
    }
}

