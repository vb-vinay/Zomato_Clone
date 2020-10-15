//
//  LoginScreenViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 14/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

/// Displays the Facebook Login option and a Login Later button
class LoginScreenViewC: UIViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var loginLaterBtn: UIButton!
    

    //MARK: - Properties
    var fbProfileImage: UIImage?
    let defaultVal = Constants.UserDetailsDefaultValues.self
    
    
    //MARK: - Manager Instances
    let manager = TaskManager.sharedInstance
    let utils = Utils.shared
    let views = Constants.ViewC.self
    let userInfo = UserInfoManager.shared
    let fb = Constants.FacebookLogin.self
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        utils.setCornerRadius(of: facebookBtn)
        utils.setCornerRadius(of: loginLaterBtn)
    }
    
    
    //MARK: - Login Buttons
    
    /// On Clicking LoginLater Button
    @IBAction func loginLaterBtn(_ sender: Any) {
        if !userInfo.getUser().loggedIn{
            userInfo.saveUser(User(loginStatus: false))
        }
    }
    
    /// On Clicking Facebook Login Button
    @IBAction func fbBtnClicked(_ sender: Any) {
        
        /// checks if the user is already logged in or not
        if userInfo.getUser().loggedIn{
            Constants.ViewC.swReveal.view.makeToast("Already Logged In",duration: 3.5, position: .bottom)
            self.navigationController?.show(views.swReveal, sender: self)
        } else{
            let fbLoginManager = LoginManager()
            
            fbLoginManager.logIn(permissions: [fb.profile, fb.email], from: self) {
                (result,error) in
                
                if (error == nil) {
                    let fbloginresult = result!
                    /// if user cancel the login
                    if (fbloginresult.isCancelled){
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains(self.fb.email)) {
                        self.getFBUserData()
//                        UserInfoManager.shared.saveUser(User(loginStatus: true))
                    }
                }
            }
        }

    }
    
    //MARK: - Networking
    
    /// It calls GraphRequest Method and get profile details
    func getFBUserData(){
        
        if (AccessToken.current != nil) {
            
            self.manager.getFbProfileDetails()
            self.navigationController?.show(views.swReveal, sender: self)
            
        }
    }


    
}
