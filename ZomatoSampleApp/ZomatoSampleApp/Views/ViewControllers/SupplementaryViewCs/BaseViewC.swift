//
//  BaseViewC.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 04/09/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import UIKit

/// Base View Controller. Contains functionality common to multiple ViewControllers
class BaseViewC: UIViewController {
    
    
    //MARK: -  Properties
    let dishCountLabel = UILabel(frame: CGRect(x: 20, y: -7, width: 20, height: 20))
    let cartButton = UIButton.init(type: .custom)
    let cartIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
    let cartButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    var cartDishes = [Dish]()
    
    //MARK: - Manager class instances
    let coredata = CoreDataManager.shared
    let icon = Constants.ImageAssets.self
    let identifier = Constants.StoryBoardIDs.self
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        addNotificationObservers()
        cartDishes = coredata.fetchCartDishesWithSomeQuantity()
        if cartDishes.isEmpty{
            showCartButtonOnly()
        } else{
            showDishesInCartButton(cartDishes.count)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        removeNotificationObservers()
    }

   
    //MARK: - Cart button With/Without label
    
    func showDishesInCartButton(_ dishesInCart: Int){
        
        cartButton.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
        cartIcon.image = UIImage(named: icon.cart)
        
        dishCountLabel.isHidden = false
        setLabelLayout(dishCountLabel)
        dishCountLabel.text = String(dishesInCart)
        
        cartButton.frame = cartButtonView.frame
        
        cartButtonView.addSubview(cartButton)
        cartButtonView.addSubview(cartIcon)
        cartButtonView.addSubview(dishCountLabel)
        
        let rightBarButton = UIBarButtonItem.init(customView: cartButtonView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    func addLabelToCartBtn(){

        setLabelLayout(dishCountLabel)

        cartButtonView.addSubview(cartButton)
        cartButtonView.addSubview(cartIcon)
        cartButtonView.addSubview(dishCountLabel)

        let rightBarButton = UIBarButtonItem.init(customView: cartButtonView)
        self.navigationItem.rightBarButtonItem = rightBarButton

    }

    func showCartButtonOnly(){
        
        dishCountLabel.isHidden = true
        
        let cartButton = UIButton.init(type: .custom)
        cartButton.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
        
        let cartIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        cartIcon.image = UIImage(named: icon.cart)
        
        let cartButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cartButton.frame = cartButtonView.frame
        
        cartButtonView.addSubview(cartButton)
        cartButtonView.addSubview(cartIcon)
        
        let rightBarButton = UIBarButtonItem.init(customView: cartButtonView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    /// Called when cart button is pressed
    @objc func cartButtonPressed(){
        let dishesInCart = coredata.fetchCartDishesWithSomeQuantity()
        
        if(dishesInCart.isEmpty){
            presentEmptyCartScreen()
        } else{
            navigationController?.pushViewController(Constants.ViewC.cart, animated: true)
        }
    }
    
    /// This sets the layout of the label
    func setLabelLayout(_ label: UILabel){
        label.layer.cornerRadius = dishCountLabel.frame.height/2
        label.layer.masksToBounds = true
        label.layer.backgroundColor = UIColor.red.cgColor
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
    }

    
    //MARK: Notification Observers
    
    func addNotificationObservers(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.notificationInternetIsOff, object: nil, queue: OperationQueue.main, using:{
                (notification: Notification) in
                    self.presentNoInternetScreen()
//                    self.presentFallbackScreen()
        })
    }
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.notificationInternetIsOff, object: nil)
        //This notification observer is set in "genericErrorOccured()"
        NotificationCenter.default.removeObserver(self, name: Notification.Name.notificationGenericError, object: nil)
    }
    
    func genericErrorOccured(completionHandler: @escaping ()->Void){
        presentGenericErrorScreen()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.notificationGenericError, object: nil, queue: OperationQueue.main, using:{
                (notification: Notification) in
                //Try to fetch data again using completionHandler
                    completionHandler()
        })
    }
    
    //MARK: - Present ViewControllers
//    func presentFallbackScreen(){
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let fallbackVC = storyboard.instantiateViewController(withIdentifier: identifier.FallbackVC) as! FallbackViewC
//        self.present(fallbackVC, animated: true, completion: nil)
//    }
    
    func presentNoInternetScreen(/*_ fallbackValue: String*/){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let noInternetVC = storyBoard.instantiateViewController(withIdentifier: identifier.NoInternetVC) as! NoInternetViewC
        self.present(noInternetVC, animated:true, completion:nil)
    }
    func presentEmptyCartScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let emptyCartVC = storyboard.instantiateViewController(withIdentifier: identifier.EmptyCartVC) as! EmptyCartViewC
        self.present(emptyCartVC,animated: true)
    }
    func presentGenericErrorScreen(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let errorVC = storyBoard.instantiateViewController(withIdentifier: identifier.GenericErrorVC) as! GenericErrorViewC
        self.present(errorVC, animated:true, completion:nil)
    }

}
