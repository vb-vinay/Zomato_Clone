//
//  TaskManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 25/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//
import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData

/// Singleton class that manages the common tasks of the app and called by multiple view controllers
class TaskManager{
    
    //MARK: Singleton Class Instance
    static let sharedInstance = TaskManager()
    private init(){}
    
    
    //MARK: - Manager Class Instances
    let userInfo = UserInfoManager.shared
    let network = NetworkManager.sharedInstance
    
    
    //MARK: - Properties
    var userAddress: String = ""
    var fbProfileImage: UIImage?
    var fbProfileName: String?
    var fbProfileId: String?
    var restaurants: [RetrivedRestaurant.Restaurants]?
    
    
    /// Hits Graph request and save the retrived data to user defaults
    func getFbProfileDetails(){
        
        let request = GraphRequest(graphPath: "/me", parameters: ["fields" : "email, name, picture"], httpMethod: HTTPMethod(rawValue: Constants.HttpMethod.get))
    
        self.saveDetailsToUserDefaults(request)
    
    }
    
    /// Save the details to User Defaults
    func saveDetailsToUserDefaults(_ request: GraphRequest){
        
        request.start( completionHandler: { (connection,result,error) in
            DispatchQueue.main.async { [unowned self] in
                if error == nil{
                    
                    guard let userInfo = result as? [String: Any] else {return}
                    
                    
                    let imgUrlStr = ((userInfo["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
                    let fbImg = self.convertStringToImage(imgUrlStr)
                    
                    if let fbName = userInfo["name"] as? String,
                    let fbId = userInfo["id"] as? String,
                    let fbImageData = fbImg.pngData() as NSData?
                    {
                        self.userInfo.saveUser(User(Id: fbId, Name: fbName,loginStatus: true, profileImg: fbImageData as Data))
                    }
                    
                } else{
                    print("Error Getting the User Info from Facebook")
                }
            }

        })
    }
    
    ///Only called by saveDetailsToUserDefaults
    func convertStringToImage(_ imgStr: String?)->UIImage{
        if let imageUrl = URL(string: imgStr!){
            self.network.getImage(from: imageUrl){
                image in
                DispatchQueue.main.async {
                    self.fbProfileImage = image
                }
            }
        }
        return fbProfileImage ?? UIImage(data: UserInfoManager.shared.getUser().profileImg)!
    }
    
    //MARK: - Alert Message on Navigation Menu
    func displayAlertMsg(_ vc: UIViewController){
        let alertController = UIAlertController(title: "Logout from Facebook", message: "Do you really want to logout", preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "Ok", style: .cancel
            , handler: nil)
        alertController.addAction(alerAction)
        vc.present(alertController,animated: true,completion: nil)
    }
}
