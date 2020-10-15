//
//  FallbackViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 03/10/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

class FallbackViewC: UIViewController {

    @IBOutlet weak var fallbackImg: UIImageView!
    @IBOutlet weak var retryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailsMatchingFallback()
    }
    
    @IBAction func retryClicked(_ sender: Any) {
        
    }
    func getDetailsMatchingFallback(){
        
    }
}
