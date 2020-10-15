//
//  HomeScreenViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 16/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//
import MapKit
import CoreLocation
import UIKit

/// This is the main screen of the app that displays the Nearby Restaurants
class HomeScreenViewC: BaseViewC{
    
    //MARK: - IBOutlets
    @IBOutlet weak var hamburgerIcon: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    var nearbyRestaurants : [NearbyRestaurants.Restaurants]?
    
    
    //MARK: - Manager Class instances
    let manager = TaskManager.sharedInstance
    let userInfo = UserInfoManager.shared
    let utils = Utils.shared
    let imgLiterals = Constants.ImageLiterals.self
    
    
    //MARK: - Initializations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Setting SWReveal Controller
        hamburgerIcon.target = self.revealViewController()
        hamburgerIcon.action = #selector(SWRevealViewController.revealToggle(_:))
        
        setLocationLabelAsGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.ViewC.updateAdd.delegate = self
        
        if nearbyRestaurants == nil || Utils.shared.locUpdated{
            actIndicator.startAnimating()
            getNearbyRestaurants()
            utils.locUpdated = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
//        removeAddressNotificationObservers()
    }
    
    
    //MARK: Tap Gesture Implementation
    
    /// Location Label Acts as Tap Gesture
    func setLocationLabelAsGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateAddress))
        locationLabel.text = userInfo.getUser().address
        locationLabel.addGestureRecognizer(tapGesture)
        locationLabel.isUserInteractionEnabled = true
        
    }
    @objc func updateAddress(){
        navigationController?.pushViewController(Constants.ViewC.updateAdd, animated: true)
    }
    
    
    /// Hits Zomato Geocode API and fetch Restaurants based on user location
    func getNearbyRestaurants(){
        NetworkManager.sharedInstance.getNearbyRestaurants(completionHandler: {
            nearbyRestaurants in
            DispatchQueue.main.async { [unowned self] in
                
                self.nearbyRestaurants = nearbyRestaurants.nearbyRestaurants
                self.tableView.reloadData()
                if self.nearbyRestaurants != nil{
                    self.actIndicator.stopAnimating()
                }
            }
        })
    }
    
}


// MARK: - TableView Delegate Methods
extension HomeScreenViewC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (nearbyRestaurants?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        
        ///Index 0 reflects the CollectionView Cell which is placed inside the tableView Cell
        if index == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.featuresCell, for: indexPath) as! FeaturesTbC
            return cell
            
        } else{
            /// Index other than 0 is always a Restaurant
            if let cell: RestaurantsInfoTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.nearbyResCell, for: indexPath) as? RestaurantsInfoTbC{
                
                cell.populateWithData((nearbyRestaurants?[index-1].restaurant)!)
                    Utils.shared.setCornerRadius(of: cell)
                return cell
                
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.section
        let nearbyRes = nearbyRestaurants?[index-1].restaurant!
        
        if index != 0{
            
            utils.resName = (nearbyRes?.name)!
            utils.resAddress = (nearbyRes?.location!.address)!
            
            /// This is a network request to get the images
            let url = URL(string: (nearbyRes?.featuredImage)!)
            NetworkManager.sharedInstance.getImage(from: url){
                image in
                    self.utils.resImage = image
            }
            utils.resCuisine = (nearbyRes?.cuisines)!
        }
        navigationController?.pushViewController(Constants.ViewC.menu, animated: true)
    }
    

}

//MARK: SearchBar and Address Update Implementation

/// On clicking the searchbar, Search Restaurants screen appears
extension HomeScreenViewC: UISearchBarDelegate,AddressUpdateDelegate {
    
    //Whenever user searches, search text is considered and API call is made with it
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.pushViewController(Constants.ViewC.search, animated: true)
        //Keyboard won't open when the user comes back to this screen
        searchBar.resignFirstResponder()
    }
    
    func getUpdatedAddress(_ address: String) {
        locationLabel.text = address
    }
}
