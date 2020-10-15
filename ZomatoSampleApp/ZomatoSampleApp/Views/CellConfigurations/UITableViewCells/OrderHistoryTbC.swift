//
//  OrderHistoryTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 28/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Cell that shows Order History of the user displaying restaurant details
class OrderHistoryTbC: UITableViewCell{

    //MARK: - IBOutlets
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resAddress: UILabel!
    @IBOutlet weak var totalCartPrice: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var dishes = [Dish]()
    
    //MARK: - Manager Class Instances
    let utils = Utils.shared
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        utils.makeSelfAdjustingLayout(collectionView)
        utils.setCornerRadius(of: resImage)
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func populateWithData(_ row: Int, _ carts: [Cart]){
        /// Cart details of different restaurants is saved to savedRes
        let savedRes = carts[row].resDetail
        
        resName.text = savedRes?.name
        resAddress.text = savedRes?.address
        resImage.image = UIImage(data: (savedRes?.image)!)
        totalCartPrice.text = String(carts[row].totalPrice)
        self.dishes = carts[row].dishes?.allObjects as! [Dish]
    }
}

//MARK: - CollectionView Delegate Methods

extension OrderHistoryTbC: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DishDetailsCnC = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.dishDetailsCell, for: indexPath) as! DishDetailsCnC
        
        cell.populateWithData(indexPath.row, dishes)
        return cell
        
    }

}
