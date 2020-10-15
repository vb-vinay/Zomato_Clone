//
//  LocationManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 02/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocation {
    
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void){
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}

/// Do all the Location fetching and saving operations
class LocationManager: NSObject,CLLocationManagerDelegate{
    
    //MARK: - Manager Class Instances
    static let sharedInstance = LocationManager()
    let userInfo = UserInfoManager.shared
    let defaults = Constants.UserDetailsDefaultValues.self
    
    
    //MARK: - Properties
    var locationManager : CLLocationManager!
    var lat: Double = Constants.UserDetailsDefaultValues.latitude
    var long: Double = Constants.UserDetailsDefaultValues.longitude
    var userAddress: String = ""
    
    
    //MARK: - Setup Location Manager to access Location Coordinates (lat & long)

    func setupLocationManager(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() == true{
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }

    
    /// It saves latest latitude, longitude and address to User Defaults
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locationValue.latitude
        long = locationValue.longitude
        userInfo.saveUser(User(latitude: lat, longitude: long))
        
        /// Calls method to get address and save to User Defaults
        getUserLocation{ address in
            self.userAddress = address
            self.userInfo.saveUser(User(address: self.userAddress))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Latitude and Longitude not available \(error)")
    }
    
    
    //MARK: - Converts Latitude and Longitude into Address String
 
    func getUserLocation(completionHandler: @escaping (String) -> ()){
        
        let location = CLLocation(latitude: lat, longitude: long)
        if lat == Constants.UserDetailsDefaultValues.latitude && long == Constants.UserDetailsDefaultValues.longitude{
            completionHandler(userAddress)
        } else{
            location.geocode{ placemark, error in
                if let error = error as? CLError {
                    print("CLError:", error)
                    return
                } else if let placemark = placemark?.first {
                    self.userAddress = self.convertPlacemarkToAddress(placemark)
                    completionHandler(self.userAddress)
                }
            }
        }
    }
    

    func convertPlacemarkToAddress(_ placemark: CLPlacemark)->(String){
        let placemarkArray = [placemark.name,placemark.subLocality,placemark.subAdministrativeArea,placemark.postalCode,placemark.country]
        for place in placemarkArray{
            if let place = place{
                if userAddress == ""{
                    userAddress = place
                } else{
                    userAddress = userAddress + ", " + place
                }
            }
        }
         return userAddress
    }
    
    //MARK: - Converts Address String into Latitude and Longitude
    
    /// It converts address string into corresponding latitude and longitude
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate
                else {
                    Constants.ViewC.updateAdd.view.makeToast("Sorry, we are unable to locate this address.", duration: 3.5, position: .center)
                    return
            }
            completion(location)
        }
    }
    

    
}

