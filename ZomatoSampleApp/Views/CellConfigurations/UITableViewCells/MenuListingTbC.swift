//
//  MenuListingTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 13/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import CoreData

/// Cell that displays the Menu items
class MenuListingTbC: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishCuisine: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishQty: UILabel!
    @IBOutlet weak var decQty: UIButton!
    @IBOutlet weak var incQty: UIButton!

    
    //MARK: - Properties
    var count: Int = 0
    var dish: Dish?
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    
    
    //MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utils.shared.setCornerRadius(of: dishImage)
        dishQty.isHidden = true
        decQty.setTitle("Add", for: .normal)
        incQty.setTitle("+", for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Increase and Decrease Quantity buttons
    @IBAction func increaseDishQty(_ sender: Any) {
        count+=1
        dishQty.isHidden = false
        dishQty.text = String(count)
        dishQty.textColor = UIColor.red
        decQty.setTitle("-", for: .normal)
    }
    
    @IBAction func decreaseDishqty(_ sender: Any) {
        if decQty.currentTitle == "Add"{
            count = 0
            increaseDishQty(sender)
        }
        if dishQty.text == "1"{
            count-=1
            dishQty.text = String(count)
            dishQty.isHidden = true
            decQty.setTitle("Add", for: .normal)
        } else {
            count-=1
            dishQty.text = String(count)
        }
    }
    
    
    //MARK: - Populate data
    func populateWithData(_ dishes: [Dish],_ row: Int){
        dishName.text = dishes[row].name
        dishPrice.text = String(dishes[row].price)
        dishCuisine.text = dishes[row].cuisine
        dishImage.image = UIImage(data: dishes[row].dishImg!)
    }

}
