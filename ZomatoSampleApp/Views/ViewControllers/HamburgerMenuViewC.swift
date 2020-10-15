//
//  HamburgerMenuViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 04/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import FBSDKLoginKit

/// Displays the Navigation Menu on Clicking the Hamburger Icon from Home Screen
class HamburgerMenuViewC: UIViewController{
    
    //MARK: - IBOutlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var navTableview: UITableView!
    
    
    //MARK: - Manager Class Instances
    let manager = TaskManager.sharedInstance
    let coredata = CoreDataManager.shared
    let userInfo = UserInfoManager.shared
    let imgLiterals = Constants.ImageLiterals.self
    let defaultVal = Constants.UserDetailsDefaultValues.self
    let labels = Constants.Labels.self
    let views = Constants.ViewC.self
    
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFbProfileDetails()
        
    }
    
    // MARK: - Populate With Facebook Profile Details
    func populateFbProfileDetails(){
        userName.text = UserInfoManager.shared.getUser().name
        profileImg.image = UIImage(data: UserInfoManager.shared.getUser().profileImg)
    }

}

// MARK: - TableView Delegate Methods
extension HamburgerMenuViewC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return labels.navMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = indexPath.row
        let cell = navTableview.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.hamburgerMenuCell, for: indexPath)
        cell.textLabel?.text = labels.navMenuOptions[row]
        cell.imageView?.image = imgLiterals.navMenuIcons[row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        /// 1st Row in Navigation Drawer Menu shows Login
        if row == 0{
            if UserInfoManager.shared.getUser().loggedIn{
                views.swReveal.view.makeToast("Already Logged In", duration: 3.5, position: .center)
            } else{
                self.navigationController?.popViewController(animated: true)
                goToLoginScreen()
            }
        }
        
        /// 2nd Row in Navigation Drawer Menu shows Cart
        if row == 1{
            let dishesInCart = coredata.fetchCartDishesWithSomeQuantity()
            
            if(dishesInCart.isEmpty){
                goToEmptyCartScreen()
            } else{
                goToCartScreen()
            }
        }
        
        /// 3rd Row in Navigation Drawer Menu shows Order History
        if row == 2{
            let cartsInHistory = coredata.fetchCarts()
            
            if(cartsInHistory.isEmpty){
                goToEmptyHistoryScreen()
            } else{
                goToHistoryScreen()
            }
        }
        
        /// 4th Row in Navigation Drawer Menu shows Facebook Logout
        if row == 3{
            if UserInfoManager.shared.getUser().loggedIn{
                let loginManager = LoginManager()
                loginManager.logOut()
                userInfo.saveUser(User(loginStatus: false))
                goToLoginScreen()
            } else{
                views.swReveal.view.makeToast("Already Logged Out", duration: 3.5, position: .center)
            }
            
        }
        
    }

}

//MARK: - Push To View Controllers

extension HamburgerMenuViewC{
    func goToEmptyCartScreen(){
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(views.emptyCart, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    func goToCartScreen(){
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(views.cart, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    func goToEmptyHistoryScreen(){
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(views.emptyHistory, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    func goToHistoryScreen(){
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(views.history, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }

    func goToLoginScreen(){
        let frontVC = revealViewController().frontViewController as? UINavigationController
        if let viewControllers = self.navigationController?.viewControllers
        {
            if viewControllers.contains(where: {
                return $0 is SWRevealViewController
            }){
                self.navigationController?.popViewController(animated: true)
            } else{
                frontVC?.pushViewController(views.swReveal, animated: false)
            }
        }
    }
}
