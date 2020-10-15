//
//  Network.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 01/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

/// Lowest layer of network requests. Used only by the Network Manager
class Network{
    
    static let sharedInstance = Network()
    private init(){}
    
    let userInfo = UserInfoManager.shared
    
    /// Generic function for getting data through API (GET)
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - query: query, if any
    ///   - requestType: request type
    ///   - completionHandler: completion handler
    func getData<T : Decodable>(urlString: String,
                                query: String = "",
                                requestType: Constants.RequestType = Constants.RequestType.none,
                                completionHandler: @escaping(T?) -> ()){
        let baseURL = (Constants.BaseURLs.BaseURL + urlString)

        guard let lat = userInfo.getUser().latitude else{return}
        guard let long = userInfo.getUser().longitude else{return}
        
        var jsonUrlStr = ""
        
        switch(requestType){
        case Constants.RequestType.nearbyRestaurants:
            jsonUrlStr = baseURL + "lat=" + "\(lat)" + "&" +
                "lon=" + "\(long)"
            
        case Constants.RequestType.searchRestaurants:
            if(query == ""){
                jsonUrlStr = baseURL + "lat=" + "\(lat)" + "&" +
                    "lon=" + "\(long)"
            }else{
                jsonUrlStr = baseURL+"q="+"\(query)"+"&lat=" + "\(lat)" + "&" +
                    "lon=" + "\(long)"
            }
            
        default:
            print("Unhandled case")
            jsonUrlStr = baseURL + "lat=" + "\(lat)" + "&" +
                "lon=" + "\(long)"
        }
        
        guard let url = URL(string: jsonUrlStr) else { return }
        let request = URLRequest(url: url)
        
        requestData(rqst: request) { (data : T?) in
            completionHandler(data)
        }
    }
    
    /// It requests the data by starting URL Session
    ///
    /// - Parameters:
    ///   - rqst: request type(GET)
    ///   - completionHandler: completion handler
    func requestData<T: Decodable>( rqst: URLRequest, completionHandler: @escaping(T?) -> ()){
        
        var request = rqst
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Constants.NetworkUtils.API_Key, forHTTPHeaderField: Constants.NetworkUtils.parameter_userkey)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(T.self, from: dataResponse)
                completionHandler(data)
            } catch let parsingError {
                completionHandler(nil)
                print("Error",parsingError)
            }
        }
        task.resume()
    }
    
    /// Downloads image for a given url
    ///
    /// - Parameters:
    ///   - completionHandler: Completion Handler
    ///   - url: image url
    func downloadImgFromURL(completionHandler: @escaping (UIImage) -> (),from url: URL?){
        
        guard let url = url else {
            completionHandler(UIImage(named: "login_bg") ?? UIImage())
            return
        }
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard let recData = data, error == nil else{
                print("Image download failed")
                return
            }
            
            completionHandler(UIImage(data: recData) ?? UIImage())
            }.resume()
    }
    
}

