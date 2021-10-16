//
//  APIManager.swift
//  OnTheMap
//
//  Created by Luis Alberto Rosas Arce on 10/10/21.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    private let logEnabled = true
    
    struct Auth {
        static var registered = false
        static var key = ""
        static var session = ""
    }
    
    private init() {}
    
    
    
    enum Endpoints {
        static let baseURL = "https://onthemap-api.udacity.com/"
        
        case login
        case logout
        case usersLocations
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseURL + "v1/session"
            case .usersLocations: return Endpoints.baseURL + "v1/StudentLocation?limit=100"
            case .logout: return Endpoints.baseURL + "v1/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    private func showLog(description: String, data: Data) {
        if logEnabled {
            print("============================")
            let responseString = String(data: data, encoding: .utf8) ?? ""
            print(description + "\n" + responseString)
            print("============================")
        }
    }
    
    
    @discardableResult private func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            self.showLog(description: "Response: \(url.absoluteString)", data: data)
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    private func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            var newData = data
            if url == Endpoints.login.url {
                let range = 5..<data.count
                newData = data.subdata(in: range)
                
            }
            
            self.showLog(description: "Response: \(url.absoluteString)",data: newData)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
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
    
    // MARK: - Managers
    func fetchUserLocations(completion: @escaping([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.usersLocations.url, responseType: StudentInformationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.key = response.account.key
                Auth.session = response.session.id
                Auth.registered = response.account.registered
                completion(true, nil)
            } else {
                completion(false, error)
            }
            
        }
    }
    
    func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
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
            // As the project specification doesn't tells about if logout request needs to be a right response. I think for a better user experience whatever the logout response, the app should dismiss the current view and should show the login screen.
            DispatchQueue.main.async {
                Auth.session = ""
                Auth.registered = false
                completion()
            }
            
            
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            self.showLog(description: "Response: \(request.url!.absoluteString)", data: data!)
        }
        
        task.resume()
    }
}
