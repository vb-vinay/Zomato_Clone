//
//  CartTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 20/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import CoreData

/// Cell that populates data on the Cart Screen
class CartTbC: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dishPriceOnQuantity: UILabel!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishQty: UILabel!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    
    
    //MARK: - Properties
    var dishes = [Dish]()
    var row: Int = 0
    var price: Int = 0
    var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    
    //MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - Increase and Decrease Quantity buttons
    
    @IBAction func plusButton(_ sender: Any) {
        dishQty.textColor = UIColor.red
        dishQty.text = String(Int(dishQty.text!)! + 1)
        dishes[row].quantity = Int16(dishQty.text!)!
    }

    @IBAction func minusButton(_ sender: Any) {
        let qty = Int16(dishQty.text!)! - 1
        if dishQty.text == "1"{
            dishes[row].quantity = qty
        } else{
            dishes[row].quantity = qty
            dishQty.text = String(qty)
        }
    }
    
    
    //MARK: - Populate data
    func populateWithData(_ row: Int, _ dishes: [Dish]){
        self.row = row
        self.dishes = dishes
        dishName.text = dishes[row].name
        dishPrice.text = String(dishes[row].price)
        dishQty.text = String(dishes[row].quantity)
        dishPriceOnQuantity.text = String(Int(dishQty.text!)! * Int(dishPrice.text!)!)
    }
}
