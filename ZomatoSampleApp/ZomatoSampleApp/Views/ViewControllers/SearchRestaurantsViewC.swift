//
//  SearchRestaurantsViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 01/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// This screen displays the Searched Restaurants based on the user Search preferences
class SearchRestaurantsViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var resSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Properties
    var searchedRestaurants: [RetrivedRestaurant.Restaurants]?
    
    
    //MARK: - Manager class Instances
    let utils = Utils.shared
    
    
    //MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchedRestaurants == nil{
            actIndicator.startAnimating()
            searchRestaurants(query: "")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    //MARK: Networking
    
    func searchRestaurants(query: String?){
        NetworkManager.sharedInstance.getSearchedRestaurants(completionHandler: {
            searchedRestaurants in
            
            DispatchQueue.main.async {
                self.searchedRestaurants = searchedRestaurants.restaurants
                self.tableView.reloadData()
                self.actIndicator.stopAnimating()
            }
        }, query: query)
    }
}

//MARK: Searchbar delegates
extension SearchRestaurantsViewC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRestaurants(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchRestaurants(query: "")
    }
}

//MARK: TableView Delegate Methods

extension SearchRestaurantsViewC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchedRestaurants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        
        let cell: SearchRestaurantsTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.searchResCell) as! SearchRestaurantsTbC
        
        utils.setCornerRadius(of: cell)
        cell.populateWithData(searchedRestaurants?[index].restaurant)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.section
        
        if index != 0{
            
            utils.resName = (searchedRestaurants?[index].restaurant!.name)!
            utils.resAddress = (searchedRestaurants?[index].restaurant?.location!.address)!
            
            /// getImage will retrieve the images form the network and checks locally
            let url = URL(string: (searchedRestaurants?[index].restaurant!.featuredImage)!)
            NetworkManager.sharedInstance.getImage(from: url){
                image in
                self.utils.resImage = image
            }
            
        }
        navigationController?.pushViewController(Constants.ViewC.menu, animated: true)
    }
    
    
}
