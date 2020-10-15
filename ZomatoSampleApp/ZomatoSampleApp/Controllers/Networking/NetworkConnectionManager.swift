//
//  NetworkConnectionManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 05/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation

/// Manages Internet Connection. Notifies using NotificationCenter when connection to internet is lost/found
class NetworkConnectionManager{
    
    //MARK: Properties
    var reachability: Reachability?
    let hostNames = ["google.com"]
    var hostIndex = 0
    
    
    //MARK: Initialisation
    init(){
        startHost(at: 0)
    }
    
    
    //MARK: - Reachability Setup
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 1)
        }
    }
    
    /// Reachability setup function
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
        } else {
            reachability = try? Reachability()
        }
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.postNotification_InternetON()
            }
            reachability?.whenUnreachable = { reachability in
                self.postNotification_InternetOFF()
            }
        } else {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
        }
    }
    
    //MARK: - Notifiers
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    
    //MARK: Notification Methods
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .unavailable {
        } else {
            //Internet unavailable
        }
    }
    
    func postNotification_InternetON() {
        NotificationCenter.default.post(name: NSNotification.Name.notificationInternetIsOn, object: self)
    }
    
    func postNotification_InternetOFF() {
        NotificationCenter.default.post(name: Notification.Name.notificationInternetIsOff, object: self)
    }
    
    // MARK: CleanUP
    deinit {
        stopNotifier()
    }}
