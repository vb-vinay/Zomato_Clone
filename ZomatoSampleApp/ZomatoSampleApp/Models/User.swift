//
//  User.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 02/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

class User{
    var id: String
    var name: String
    var latitude: Double?
    var longitude: Double?
    var address: String
    var loggedIn: Bool
    var profileImg: Data
    public init(Id id: String = Constants.UserDetailsDefaultValues.id,
                Name name: String = Constants.UserDetailsDefaultValues.name,
                loginStatus status: Bool = UserInfoManager.shared.getUser().loggedIn,
                latitude lat: Double = Constants.UserDetailsDefaultValues.latitude,
                longitude lon: Double = Constants.UserDetailsDefaultValues.longitude,
                address add: String = Constants.UserDetailsDefaultValues.address,
                profileImg img: Data = Constants.UserDetailsDefaultValues.profileImg){
        
        self.name = name
        self.latitude = lat
        self.longitude = lon
        self.id = id
        self.loggedIn = status
        self.address = add
        self.profileImg = img
    }
}
