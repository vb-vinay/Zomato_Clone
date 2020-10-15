//
//  Utils.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 29/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

/// Handles the Utility functions of the App
class Utils{
    
    /// Shared Instance
    static let shared = Utils()
    private init(){}
    
    //MARK: - Manager Class Instances
    static let userInfo = UserInfoManager.shared
    static let defaults = Constants.UserDetailsDefaultValues.self
    
    //MARK: - Properties
    var resName = "New Manjeet Food Plaza"
    var resAddress = "House 6, New Colony, New Delhi"
    var resImage = UIImage(named: "default_restaurant_img")
    var resCuisine = "Chinese, South Indian, Pizza"
    var locUpdated = false
    var loggedIn =  false
    
    //MARK: - UILayout Settings
    
    /// Sets the corner radius in the app
    func setCornerRadius(of: UIView) {
        of.layer.cornerRadius = 20
        of.layer.borderWidth = 0.5
        of.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    /// Only called by Order History tableview cell
    func makeSelfAdjustingLayout(_ collectionView: UICollectionView!){
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 180, height: 40)
    }
    
    /// Only called by Menu Screen to set label
    func setHeaderLabel(_ section: Int)->UIView{
        let label = UILabel()
        label.text = resCuisine.components(separatedBy: ", ")[section]
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        return label
    }
    
    //MARK: - Checks login status
//    static func isLoggedIn()  -> Bool {
//        let userDetails = userInfo.getUser()
//        return userDetails.id != Constants.LatestValues.id
//    }
}

