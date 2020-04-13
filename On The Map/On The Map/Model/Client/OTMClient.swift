//
//  OTMClient.swift
//  On The Map
//
//  Created by Gokhan Namal on 12.04.2020.
//  Copyright © 2020 Gokhan Namal. All rights reserved.
//

import Foundation

class OTMClient {
    enum EndpointType {
        case location
        case auth
    }
    
    enum HTTPMethods: String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
    }
    
    struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    enum Endpoints {
        static let baseURL = "https://onthemap-api.udacity.com/v1/"
        static let signUpURL = "https://auth.udacity.com/sign-up"
        case session
        case signUp
        case getUserLocation
        case addUserLocation

        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .session: return Endpoints.baseURL + "session"
            case .signUp: return Endpoints.signUpURL
            case .getUserLocation: return Endpoints.baseURL + "StudentLocation?limit=100&order=-updatedAt"
            case .addUserLocation: return Endpoints.baseURL + "StudentLocation"
            }
        }
    }
    
    class func taskForPostRequest<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, endpoint: EndpointType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request  = URLRequest(url: url)
        request.httpBody = try! JSONEncoder().encode(body)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            // Check the request whether auth or not because we have to remove the first 5 characters if it is the auth request.
            var newData = data
            if endpoint == .auth {
                let range = (5..<data.count)
                newData = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorObject = try decoder.decode(OTMErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorObject)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForGetRequest<RequestType: Decodable>(url: URL, requestyType: RequestType.Type, completion: @escaping (RequestType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            do {
                let responseObject = try decoder.decode(RequestType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorObject = try decoder.decode(OTMErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorObject)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            }
        }
        task.resume()
    }
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: UserInformation(username: username, password: password))
        taskForPostRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: body, endpoint: .auth) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                print(Auth.userId)
                completion(true, nil)
            }  else {
                completion(false, error)
            }
        }
    }
    
    class func getUserLocation(completion: @escaping ([User], Error?)-> Void){
        taskForGetRequest(url: Endpoints.getUserLocation.url, requestyType: UserResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], nil)
            }
        }
    }
    
    class func addNewLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = UserLocationPost(uniqueKey: Auth.userId, firstName: "No", lastName: "Name", mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPostRequest(url: Endpoints.addUserLocation.url, responseType: UserLocationResponse.self, body: body, endpoint: .location) { response, error in
            if let _ = response {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = data {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
}
