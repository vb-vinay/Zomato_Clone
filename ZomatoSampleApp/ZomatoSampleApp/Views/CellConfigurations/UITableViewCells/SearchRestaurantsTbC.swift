//
//  SearchRestaurantsTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 01/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Populate restaurant details on the Search screen
class SearchRestaurantsTbC: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resRating: UILabel!
    @IBOutlet weak var resCuisine: UILabel!
    @IBOutlet weak var avgCost: UILabel!
    
    
    //MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - Populate data
    func populateWithData(_ restaurant: RetrivedRestaurant.Restaurant?){
        
        Utils.shared.setCornerRadius(of: resImage)
        
        resName.text = restaurant?.name
        resCuisine.text = restaurant?.cuisines
        resRating.text = restaurant?.userRating?.aggregateRating
        
        if let cost = restaurant?.costForTwo{
            avgCost.text = String(cost)
        }
        
        let url = URL(string: (restaurant?.featuredImage)!)
        NetworkManager.sharedInstance.getImage(from: url) {
            image in
            DispatchQueue.main.async {
                self.resImage.image = image
            }
        }
    }
}
