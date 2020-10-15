//
//  NoInternetViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 05/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// This screen pops up when there is no internet connectivity
class NoInternetViewC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        addNotificationObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationObservers()
    }
    
    //MARK: Notifications functions
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.notificationInternetIsOn,
                                               object: nil, queue: OperationQueue.main, using:
            { (notification: Notification) in
                self.dismiss(animated: true, completion: nil)
        })
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.notificationInternetIsOff,
                                                  object: nil)
    }
    

    @IBAction func returnBack(_ sender: Any) {
        let networkManager = NetworkManager.sharedInstance
        if(networkManager.isInternetAvailable()) {
            self.dismiss(animated: true, completion: nil)
        }
    }


}
