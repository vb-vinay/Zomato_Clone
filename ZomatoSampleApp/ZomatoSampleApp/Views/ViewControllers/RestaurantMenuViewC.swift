//
//  RestaurantMenuViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 31/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import CoreData

/// Displays the Menu based on the cuisine of User selected Restaurant
class RestaurantMenuViewC: BaseViewC{
    
    //MARK: - IBOutlets
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    var rowsInSection : [Int]?
    @objc var dishCollection = [[Dish]]()
    
    
    //MARK: - Manager instances
    let utils = Utils.shared
    
    //MARK: - Initialization
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coredata.addAllDishesToCoreData()
        loadDishesFromCuisines(cuisines: Utils.shared.resCuisine)
        showCartButton()
        tableView.reloadData()
    }
    
    
    /// When cart is empty, cart button without label is shown and otherwise quantity is shown
    func showCartButton(){
        cartDishes = coredata.fetchCartDishesWithSomeQuantity()
        if cartDishes.isEmpty{
            showCartButtonOnly()
        } else{
            showDishesInCartButton(cartDishes.count)
        }
    }
    
    /// Separated Cuisines form a 2D array based on the separated cuisines
    func loadDishesFromCuisines(cuisines: String) {
        dishCollection = [[Dish]]()
        let splitCuisines = cuisines.components(separatedBy: ", ")
        for type in splitCuisines {
            dishCollection.append(coredata.fetchMenuWithCorrespondingCuisine(cuisine: type))
        }
    }
    
    //MARK: - Button Implementations
    
    /// Moves to the Cart Screen
    @IBAction func viewCartButton(_ sender: Any) {
        navigationController?.pushViewController(Constants.ViewC.cart, animated: true)
    }
    
    /// Updates/Increase Quantity correspondingly on the screen and saves to the CoreData
    @objc func incDishQty(_ sender: UIButton){
        
        let cell = sender.superview?.superview?.superview as! MenuListingTbC
        let dishId = sender.tag
        let dishesInMenu = dishCollection.flatMap { $0 }
        guard let qty = Int16("\(cell.dishQty.text ?? "0")") else{return}
        for i in 0..<dishesInMenu.count{
            if dishesInMenu[i].id == dishId{
                dishesInMenu[i].quantity = qty
                break
            }
        }
        coredata.save()
        cartDishes = coredata.fetchCartDishesWithSomeQuantity()
        
        if cartDishes.count == 1{
            showDishesInCartButton(cartDishes.count)
        }
        dishCountLabel.text = String(cartDishes.count)
    }
    
    /// Updates/Decrease Quantity correspondingly on the screen and saves to the CoreData
    @objc func decDishQty(_ sender: UIButton){
        
        let dishId = sender.tag
        let dishesInMenu = dishCollection.flatMap { $0 }
        let cell = sender.superview?.superview?.superview as! MenuListingTbC
        guard let qty = Int16("\(cell.dishQty.text ?? "0")") else {return}
        
        for i in 0..<dishesInMenu.count{
            if dishesInMenu[i].id == dishId{
                dishesInMenu[i].quantity = qty
                break
            }
        }
        coredata.save()
        cartDishes = coredata.fetchCartDishesWithSomeQuantity()
        
        if cartDishes.count == 0{
            dishCountLabel.isHidden = true
        }
        dishCountLabel.text = String(cartDishes.count)

    }

}


// MARK: - TableView Delegate Methods

extension RestaurantMenuViewC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        rowsInSection = [Int](repeating: 0, count: dishCollection.count)
        return rowsInSection?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        rowsInSection?[section] = dishCollection[section].count
        if(dishCollection[section].count == 0) {
            return 1
        } else {
            return dishCollection[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return utils.setHeaderLabel(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        let row = indexPath.row
        
        if(rowsInSection?[index] == 0) {
            if let cell: NoCuisineTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.noCuisineCell, for: indexPath) as? NoCuisineTbC{
                return cell
            }
        } else{
            if let cell: MenuListingTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.menuListingCell, for: indexPath) as? MenuListingTbC{
                
                resImage.image = Utils.shared.resImage
                
                cell.populateWithData(dishCollection[index],row)
                
                cell.incQty.tag = Int(dishCollection[index][row].id)
                cell.decQty.tag = Int(dishCollection[index][row].id)
                
                cell.incQty.addTarget(self, action: #selector(incDishQty), for: .touchUpInside)
                cell.decQty.addTarget(self, action: #selector(decDishQty), for: .touchUpInside)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
