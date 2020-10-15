//
//  SearchAPIModel.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 02/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

class RetrivedRestaurant: Codable{
    
    private static var shared : RetrivedRestaurant?
    private init(){}
    
    var restaurants: [Restaurants]?
    
    static func getInstance() -> RetrivedRestaurant{
        if shared == nil{
            shared = RetrivedRestaurant()
        }
        return shared!
    }
   
    struct Restaurants: Codable{
        let restaurant: Restaurant?
    }
    
    struct Restaurant: Codable{
        let name: String?
        let cuisines: String?
        let costForTwo: Int?
        let userRating: UserRating?
        let featuredImage: String?
        let location: Address?
        
        enum CodingKeys: String, CodingKey {
            case name,cuisines
            case costForTwo = "average_cost_for_two"
            case userRating = "user_rating"
            case featuredImage = "featured_image"
            case location
        }
    }
    
    struct Address: Codable{
        let address: String?
    }
    
    struct UserRating: Codable{
        let aggregateRating: String?
        
        enum CodingKeys: String, CodingKey{
            case aggregateRating = "aggregate_rating"
        }
        
        init(aggregateRating: String?){
            self.aggregateRating = aggregateRating
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let integerRating = try? container.decode(Int.self, forKey: .aggregateRating){
                aggregateRating = String(integerRating)
            } else{
                aggregateRating = try container.decode(String?.self, forKey: .aggregateRating)
            }
        }
    }
    
}
