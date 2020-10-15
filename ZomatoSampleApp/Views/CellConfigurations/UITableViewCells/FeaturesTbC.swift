//
//  FeaturesTbC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 30/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// This is the first cell of the tableView which again consists of the CollectionView
class FeaturesTbC: UITableViewCell{
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    let imgLiterals = Constants.ImageLiterals.self
    
    
    //MARK: - Initializations
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
// MARK: - CollectionView Delegate Methods

extension FeaturesTbC: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgLiterals.featureImg.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: FeaturesCnC = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.featuresCnCell, for: indexPath) as? FeaturesCnC{
            
            cell.populateWithData(indexPath.row)
            return cell
            
        }
        return UICollectionViewCell()
    }
}
