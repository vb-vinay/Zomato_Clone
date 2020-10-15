//
//  UserInfoManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 02/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

class UserInfoManager{
    
    static let shared = UserInfoManager()
    private init(){}


    func saveUser(_ user: User){
        // Save new value ONLY if it is not equal to the default value
        
        
        if(!getUser().loggedIn){
            UserDefaults.standard.set(user.name, forKey: Constants.UserDefaultKeys.name)
        }
        if(!getUser().loggedIn){
            UserDefaults.standard.set(user.id, forKey: Constants.UserDefaultKeys.id)
        }
        if(!getUser().loggedIn){
            UserDefaults.standard.set(user.profileImg, forKey: Constants.UserDefaultKeys.profileImg)
        }
//        if(user.email != Constants.LatestValues.email){
        UserDefaults.standard.set(user.loggedIn, forKey: Constants.UserDefaultKeys.loginStatus)
//        }
        if(user.latitude != Constants.LatestValues.latitude){
            UserDefaults.standard.set(user.latitude, forKey: Constants.UserDefaultKeys.latitude)
        }
        if(user.longitude != Constants.LatestValues.longitude){
            UserDefaults.standard.set(user.longitude, forKey: Constants.UserDefaultKeys.longitude)
        }
        if(user.address != Constants.LatestValues.address){
            UserDefaults.standard.set(user.address, forKey: Constants.UserDefaultKeys.address)
        }

    }
    
    func getUser() -> User {
        let name = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.name)
        let loginStatus = UserDefaults.standard.bool(forKey: Constants.UserDefaultKeys.loginStatus)
        let id = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.id)
        let latitude = UserDefaults.standard.double(forKey: Constants.UserDefaultKeys.latitude)
        let longitude = UserDefaults.standard.double(forKey: Constants.UserDefaultKeys.longitude)
        let address = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.address)
        let profileImg = UserDefaults.standard.data(forKey: Constants.UserDefaultKeys.profileImg)
        
        return User(Id: id ?? Constants.LatestValues.id,
                                Name: name ?? Constants.LatestValues.name,
                                loginStatus: loginStatus ,
                                latitude: latitude , longitude: longitude ,
                                address: address ?? Constants.LatestValues.address,
                                profileImg: profileImg ?? Constants.LatestValues.profileImg
                             )
    }
}
