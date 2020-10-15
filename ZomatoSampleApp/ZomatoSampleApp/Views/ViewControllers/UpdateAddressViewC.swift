//
//  UpdateAddressViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 09/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddressUpdateDelegate{
    func getUpdatedAddress(_ address: String)
}

/// The screen that displays the Address Updation Screen, User can enter the address text or choose his current location by clicking on the button
class UpdateAddressViewC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var userMapLocation: MKMapView!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    //MARK: - Properties
    var delegate: AddressUpdateDelegate?
    
    
    //MARK: - Manager Class Instances
    let utils = Utils.shared
    let manager = LocationManager.sharedInstance
    let userInfo = UserInfoManager.shared
    
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setCornerRadius(of: saveBtn)
        setupMap(userInfo.getUser().latitude!, userInfo.getUser().longitude!)
    }
    
    
    //MARK: Current Location and Save Address Button Implementations
    
    /// Calls the SetupLocation Method which prompts the User to turn on Device Location
    @IBAction func allowLocationAccess(_ sender: Any) {
        manager.setupLocationManager()
    }
    
    /// On clicking the Save Address button, new address is saved to the User Defaults and updated on the Home Screen
    @IBAction func saveAddress(_ sender: Any) {
        
        guard let addressLine1 = addressLine1.text else{ return }
        guard let  addressLine2 = addressLine2.text else { return }
        let address = "\(addressLine1) \(addressLine2)"
        delegate?.getUpdatedAddress(address)
        
        
        manager.getLocation(from: address){ location in
            
            guard let location = location else{return}
            self.utils.locUpdated = true
            self.userInfo.saveUser(User(latitude: location.latitude,longitude: location.longitude))
            
            self.setupMap(location.latitude,location.longitude)
            
            Constants.ViewC.updateAdd.view.makeToast("\tLocation Updated Successfully\nPress Home Button to View Restaurants", duration: 3.5, position: .bottom)
        }
        userInfo.saveUser(User(address: address))
        
        if utils.locUpdated == true{
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    //MARK: Setup MapView
    func setupMap(_ lat: Double,_ lon: Double){
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.userMapLocation.setRegion(region, animated: true)
    }


}

