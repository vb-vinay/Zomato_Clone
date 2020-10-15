//
//  APIManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 08/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

/// Handles/Manages all the network requests taking place in the app
class NetworkManager{
    
    //MARK: - Properties
    static let sharedInstance = NetworkManager()
    private init(){}
    let netConnectionManager = NetworkConnectionManager()
    let network = Network.sharedInstance
    static let cache = NSCache<NSString,UIImage>()
    let urls = Constants.BaseURLs.self

    
    //MARK: - Nearby Restaurants
    
    /// It gets the nearby restaurants by hitting the geocode api
    func getNearbyRestaurants(completionHandler: @escaping (NearbyRestaurants) -> ()){
        
        let nearbyResExtURL = urls.nearbyResExtURL
        
        /// getData uses latitude and longitude from the UserDefaults
        network.getData(urlString: nearbyResExtURL, query: "", requestType: Constants.RequestType.nearbyRestaurants) { (nearbyRestaurantsRecieved : NearbyRestaurants?)  in
            
            //Save data in model if available, else throw error
            if nearbyRestaurantsRecieved != nil{
                NearbyRestaurants.getInstance().nearbyRestaurants = nearbyRestaurantsRecieved?.nearbyRestaurants
                completionHandler(nearbyRestaurantsRecieved!)
            } else{
                completionHandler(NearbyRestaurants.getInstance())
            }
        }
    }
    
    
    //MARK: - Searched Restaurants
    
    /// It gets the searched restaurants by hitting the search api
    func getSearchedRestaurants(completionHandler: @escaping (RetrivedRestaurant) -> (), query: String?) {
        //Data is not saved, fetch it from API
        if(RetrivedRestaurant.getInstance().restaurants == nil || query ?? "" != ""){
            let searchResExtURL = urls.searchResExtURL
            
            network.getData(urlString: searchResExtURL, query: query ?? "" , requestType: Constants.RequestType.searchRestaurants) { (searchedRestaurantsRecieved : RetrivedRestaurant?)  in
                
                //Save data in model if available, else throw error
                if searchedRestaurantsRecieved != nil{
                    // We only save data for when query is blank
                    if query == ""{
                        RetrivedRestaurant.getInstance().restaurants = searchedRestaurantsRecieved!.restaurants
                    }
                    completionHandler(searchedRestaurantsRecieved!)
                }else{
                    completionHandler(RetrivedRestaurant.getInstance())
                }
            }
        }
        else {
            //Data is saved in singleton, simply return that
            completionHandler(RetrivedRestaurant.getInstance())
            return
        }
    }
    

    //MARK: - Image downloading
    
    /// It is used to download the image from the url if it is notfound in Cache
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completion: completion escaping
    func getImage(from url: URL?, completion: @escaping (_ image: UIImage?) -> ()){
        
        guard let url = url else {
            completion(UIImage(named: Constants.ImageAssets.defaultRes) ?? UIImage())
            return
        }
        if let image = NetworkManager.cache.object(forKey: url.absoluteString as NSString){
            completion(image)
        } else{
            downloadImageFromURL(from: url, completionHandler: completion)
        }
    }
    /// Actual download happens here and image is stored in cache memory
    func downloadImageFromURL(from url: URL, completionHandler: @escaping (UIImage) -> ()){
        network.downloadImgFromURL(completionHandler: { (downloadedImage) in
            NetworkManager.cache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
            completionHandler(downloadedImage)
        }, from: url)
    }
    
    //MARK: - Network availability
    func isInternetAvailable() -> Bool {
        return netConnectionManager.reachability!.connection != .unavailable
    }
}
