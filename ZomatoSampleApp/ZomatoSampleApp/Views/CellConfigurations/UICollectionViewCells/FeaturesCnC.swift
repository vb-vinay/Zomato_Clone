//
//  FeaturesCnC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 29/07/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Cell used on the Home Screen for displaying the Features of the App in CollectionView Cell
class FeaturesCnC: UICollectionViewCell {
    
    //MARK: -IBOutlets
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    
    //MARK: -  Constants instances
    let lbl = Constants.Labels.self
    let imgLiterals = Constants.ImageLiterals.self
    
    //MARK: - Manager Class Instances
    let utils = Utils.shared
    
    //MARK: - Populate cell data
    func populateWithData(_ row: Int){
        
        featuredImage.image = imgLiterals.featureImg[row]
        upperLabel.text = lbl.upperLblTags[row]
        lowerLabel.text = lbl.lowerLblTags[row]
        
        utils.setCornerRadius(of: self)
        
    }
}
