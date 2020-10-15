//
//  Constants.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 03/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation
import UIKit

/// Consists of all the Constants required by the App
class Constants{
    
    
    static let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    //MARK: - Stored Properties
    
    /// Image Labels and tags
    class Labels{
        static let upperLblTags = ["Safely","Express","Great","Trending","New","Zomato","The"]
        static let lowerLblTags = ["Sealed","Delivery","Offers","Places","Arrivals","Exclusive","Finest"]
        static let navMenuOptions = ["Login", "My Cart", "My Orders", "Logout"]
    }
    
    /// Image Literals and icons
    class ImageLiterals{
        static let featureImg = [#imageLiteral(resourceName: "safely_sealed"),#imageLiteral(resourceName: "express_delivery"),#imageLiteral(resourceName: "great_offers"),#imageLiteral(resourceName: "trending_places"),#imageLiteral(resourceName: "new_arrivals"),#imageLiteral(resourceName: "zomato_exclusive"),#imageLiteral(resourceName: "the_finest")]
        static let menuDishesImg = [#imageLiteral(resourceName: "paneer_butter_masala"),#imageLiteral(resourceName: "dal_makhani"),#imageLiteral(resourceName: "hakka_noodles"),#imageLiteral(resourceName: "spring_roll"),#imageLiteral(resourceName: "veggie_lover_pizza"),#imageLiteral(resourceName: "garlic_bread")]
        static let navMenuIcons = [#imageLiteral(resourceName: "fb_icon"),#imageLiteral(resourceName: "shopping_cart_icon"),#imageLiteral(resourceName: "order_history_icon"),#imageLiteral(resourceName: "logout_icon")]
    }
    
    ///Images used by name
    class ImageAssets{
        static let cart = "cart_icon"
        static let defaultRes = "default_restaurant_img"
    }
    
    /// Strings for facebook logn
    class FacebookLogin{
        static let profile = "public_profile"
        static let email = "email"
    }
    
    /// Http Methods used in the App
    enum HttpMethod{
        static let get = "GET"
    }
    
    /// Request types used for API calls
    enum RequestType {
        case nearbyRestaurants
        case searchRestaurants
        case none
    }
    
    /// Fallback ViewControllers
    enum FallbackComponents {
        case noInternet
        case emptyCart
        case emptyHistory
        case genericError
    }
    
    /// Storyboard Ids for View Controllers
    class StoryBoardIDs {
        public static let LoginScreenVC = "loginScreenVC"
        public static let HomeScreenVC = "homeScreenVC"
        public static let SWRevealVC = "swRevealVC"
        public static let SearchRestaurantsVC = "searchResVC"
        public static let UpdateAddressVC = "manageAddressVC"
        public static let RestaurantMenuVC = "menuScreenVC"
        public static let HamburgerMenuVC = "hamburgerVC"
        public static let CartVC = "cartVC"
        public static let OrderHistoryVC = "orderHistoryVC"
        
        public static let FallbackVC = "fallbackVC"
        
        public static let EmptyCartVC = "emptyCartVC"
        public static let NoInternetVC = "noInternetVC"
        public static let EmptyHistoryVC = "emptyHistoryVC"
        public static let GenericErrorVC = "genericErrorVC"
    }
    
    /// Cell Indentifiers defined for both TableViewCells and CollectionViewCells
    class CellIdentifiers {
        public static let featuresCell = "featuresCell"
        public static let nearbyResCell = "nearbyResCell"
        public static let featuresCnCell = "featuresCnCell"
        public static let searchResCell = "searchResCell"
        public static let hamburgerMenuCell = "hamburgerMenuCell"
        public static let noCuisineCell = "noCuisineCell"
        public static let menuListingCell = "menuListingCell"
        public static let cartCell = "cartCell"
        public static let orderHistoryCell = "orderHistoryCell"
        public static let dishesInCartTV = "DishesInCartTBCell"
        public static let noDishInCuisine = "NoDishInCuisine"
        public static let dishDetailsCell = "dishDetailsCell"
    }
    
    /// View Controllers object for direct calling/pushing
    class ViewC{
        
        public static let login = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.LoginScreenVC) as! LoginScreenViewC
        
        public static let home = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.HomeScreenVC) as! HomeScreenViewC
        
        public static let swReveal = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.SWRevealVC) as! SWRevealViewController
        
        public static let search = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.SearchRestaurantsVC) as! SearchRestaurantsViewC
        
        public static let updateAdd = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.UpdateAddressVC) as! UpdateAddressViewC
        
        public static let hamburgerMenu = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.HamburgerMenuVC) as! HamburgerMenuViewC
        
        public static let menu = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.RestaurantMenuVC) as! RestaurantMenuViewC
        
        public static let cart = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.CartVC) as! CartViewC
        
        public static let history = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.OrderHistoryVC) as! OrderHistoryViewC
        
        public static let emptyCart = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.EmptyCartVC) as! EmptyCartViewC

        public static let noInternet = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.NoInternetVC) as! NoInternetViewC

        public static let emptyHistory = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.EmptyHistoryVC) as! EmptyHistoryViewC

        public static let genError = storyboard.instantiateViewController(withIdentifier: StoryBoardIDs.GenericErrorVC) as! GenericErrorViewC
        
    }
    

    
    /// Default Values of User used for storing in User Defaults
    class UserDetailsDefaultValues {
        public static let name = "User Name";
        public static let id = "100";
        public static let loginStatus = false;
        public static let latitude = 28.645876;
        public static let longitude = 77.275631;
        public static let address = "Choose your Location"
        public static let profileImg = (UIImage(named: "profile_icon")?.pngData() as Data?)!
    }
    class LatestValues{
        public static var name = "User Name";
        public static var id = "100";
        public static let email = "xyz@gmail.com";
        public static let latitude = 28.645876;
        public static let longitude = 77.275631;
        public static let address = "Choose your Location"
        public static var profileImg = (UIImage(named: "profile_icon")?.pngData() as Data?)!
    }
    /// Entities used by CoreData
    class CoreDataEntities{
        public static let Dish = "Dish"
        public static let Cart = "Cart"
        public static let Restaurant = "Restaurant"
    }
    
    /// Dish Types used in CoreData
    class DishTypesCD{
        public static let added = "added"
        public static let basic = "default"
    }
    
    /// UserDefault Constants for addressing
    class UserDefaultKeys {
        public static let name = "name"
        public static let loginStatus = "status"
        public static let id = "id"
        public static let latitude = "latitude"
        public static let longitude = "longitude"
        public static let address = "address"
        public static let profileImg = "profileImg"
    }
    
    ///Extra data which network requests require
    class NetworkUtils {
        public static let parameter_userkey = "user-key"
        public static let API_Key = "0fe4f3c6aba3c7540b912af5376cf7e1"
    }
    
    /// URLs used for Zomato APIs
    class BaseURLs {
        public static let BaseURL = "https://developers.zomato.com/api/v2.1/"
        public static let nearbyResExtURL = "geocode?"
        public static let searchResExtURL = "search?"
    }
    
    
}
