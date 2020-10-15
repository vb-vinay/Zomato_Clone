//
//  OrderHistoryViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 23/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

class OrderHistoryViewC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var carts = [Cart]()
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
//        carts = CoreDataManager.shared.fetchCarts()
    }
    override func viewWillAppear(_ animated: Bool) {
        carts = CoreDataManager.shared.fetchCarts()
        tableView.reloadData()
    }
    
}


//MARK: - TableView Delegate Methods

extension OrderHistoryViewC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return carts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: OrderHistoryTbC = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.orderHistoryCell, for: indexPath) as? OrderHistoryTbC{
            
            cell.populateWithData(indexPath.row,carts)
            return cell
            }
            return UITableViewCell()
    }
}
