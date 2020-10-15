//
//  GenericErrorViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 05/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

class GenericErrorViewC: UIViewController {
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Retry button 
    @IBAction func retryFetching(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name.notificationGenericError, object: self)
    }

}
