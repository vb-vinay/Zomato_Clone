//
//  DishDetailsCnC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 28/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Collection Cell in OrderHistory screen that displays Dish details
class DishDetailsCnC: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dishDetail: UILabel!
    
    //MARK: - Populate cell data
    func populateWithData(_ row: Int,_ dishes: [Dish]){
        
        let details = "\(String(dishes[row].quantity)) X \(dishes[row].name ?? "Spring Rolls")"
        dishDetail.text = details
        
    }
}
