//
//  EmptyHistoryViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 05/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

// This screen pops up when there are no previuos orders
class EmptyHistoryViewC: UIViewController {

    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Back button
    @IBAction func returnBack(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers
        {
            if viewControllers.contains(where: {
                return $0 is EmptyHistoryViewC
            }){
                self.navigationController?.popViewController(animated: true)
            }
        } else{
            self.dismiss(animated: true,completion: nil)
        }
    }



}
