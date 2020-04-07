//
//  DogAPI.swift
//  Randog
//
//  Created by Gokhan Namal on 7.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogCollections
        case randomImageForBreed(String)
        case breedList
        var url: URL {
            return URL(string:  self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogCollections:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case.breedList:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?)-> Void) {
        let session = URLSession.shared.dataTask(with: url) {data,response,error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
        session.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let endPoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: endPoint) {data,response,error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    class func listAllBreeds(completionHandler: @escaping (Breed?, Error?) -> Void) {
        let endPoint = DogAPI.Endpoint.breedList.url
        
        let task = URLSession.shared.dataTask(with: endPoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let breedList = try decoder.decode(Breed.self, from: data)
                completionHandler(breedList, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
}
