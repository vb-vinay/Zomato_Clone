//
//  RestaurantsInfoTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 28/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Populate restaurant details on the Search screen
class RestaurantsInfoTbC: UITableViewCell {
    
    //MARK: - IBoutlets
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resRatingLabel: UILabel!
    @IBOutlet weak var resCuisineLabel: UILabel!
    @IBOutlet weak var resCostLabel: UILabel!
    @IBOutlet weak var resImage: UIImageView!
    
    //MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Populate data
    func populateWithData(_ restaurant: NearbyRestaurants.Restaurant){
        
        Utils.shared.setCornerRadius(of: resImage)
        resNameLabel.text = restaurant.name
        resCuisineLabel.text = restaurant.cuisines
        resRatingLabel.text = restaurant.userRating?.aggregateRating
        
        if let cost = restaurant.costForTwo{
            resCostLabel.text = String(cost)
        }
        
        let url = URL(string: (restaurant.featuredImage)!)
        NetworkManager.sharedInstance.getImage(from: url) {
            image in
            DispatchQueue.main.async {
                self.resImage.image = image
            }
        }
    }
    
}
