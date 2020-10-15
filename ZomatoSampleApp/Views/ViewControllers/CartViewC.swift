//
//  CartViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 20/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Displays the dishes along with their price based on the Quantity and also calculates the Total Cart Price and Place Order
class CartViewC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resAddress: UILabel!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    //MARK: - Properties
    var dishes = [Dish]()
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    
    
    //MARK: - Manager instances
    let userInfo = UserInfoManager.shared
    let coreData = CoreDataManager.shared
    let utils = Utils.shared
    
    
    //MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        utils.setCornerRadius(of: placeOrderBtn)
//        utils.setCornerRadius(of: resImage)
//        dishes = coreData.fetchCartDishesWithSomeQuantity()
//        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        utils.setCornerRadius(of: placeOrderBtn)
        utils.setCornerRadius(of: resImage)
        dishes = coreData.fetchCartDishesWithSomeQuantity()
        tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape{
            placeOrderBtn.setTitle("Your cart value is \(coreData.calcCartTotal()).........Place Order", for: .normal)
        } else{
            placeOrderBtn.setTitle("Place Order", for: .normal)
        }
    }
    //MARK: - Button Implementations
    
    /// Saves to coredata
    @IBAction func placeOrder(_ sender: Any) {
        
        let cartTotal = Int16(coreData.calcCartTotal())
        coreData.saveToAllEntities(dishes,cartTotal ?? 500)
        Constants.ViewC.swReveal.view.makeToast("Placed Successfully", duration: 4.0, position: .bottom)
        Constants.ViewC.home.view.makeToast("Order Placed Successfully", duration: 1000, position: .bottom)
        navigationController?.popToRootViewController(animated: true)
//        Constants.ViewC.swReveal.view.makeToast("Placed Successfully", duration: 1000, position: .bottom)
//        Constants.ViewC.home.view.makeToast("Order Placed Successfully", duration: 1000, position: .bottom)

        
    }
    
    /// Updates/Increase Quantity correspondingly on the screen and saves to the CoreData
    @objc func increaseQty(_ sender: UIButton){
        tableView.reloadData()
        coreData.save()
        totalPrice.text = coreData.calcCartTotal()
    }
    
    /// Updates/Decrease Quantity correspondingly on the screen and saves to the CoreData
    @objc func decreaseQty(_ sender: UIButton){
        tableView.reloadData()
        coreData.save()
        totalPrice.text = coreData.calcCartTotal()
    }
}


//MARK: TableView Delegate Methods

extension CartViewC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishes = dishes.filter{ $0.quantity > 0 }
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: CartTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.cartCell, for: indexPath) as? CartTbC{
            
            cell.populateWithData(indexPath.row,dishes)
            
            cell.plusButtonOutlet.tag = indexPath.row
            cell.minusButtonOutlet.tag = indexPath.row
            
            cell.plusButtonOutlet.addTarget(self, action: #selector(increaseQty), for: .touchUpInside)
            cell.minusButtonOutlet.addTarget(self, action: #selector(decreaseQty), for: .touchUpInside)
            
            totalPrice.text = coreData.calcCartTotal()
            userAddress.text = userInfo.getUser().address
            resName.text = utils.resName
            resAddress.text = utils.resAddress
            resImage.image = utils.resImage

            return cell
            
        }
        return UITableViewCell()
    }
    
}
