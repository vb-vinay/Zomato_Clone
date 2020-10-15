//
//  CoreDataManager.swift
//  ZomatoSampleApp
//
//  Created by Vinay Bharwani on 20/08/19.
//  Copyright © 2019 mindfire. All rights reserved.
//

import Foundation
import CoreData

/// Contains the Default Menu Dishes and also Manages the Fetching and Saving of data using CoreData
class CoreDataManager{
    
    /// Shared Instance
    static let shared = CoreDataManager()
    private init(){}
    
    //MARK: -
    var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    let entity = Constants.CoreDataEntities.self
    let dishType = Constants.DishTypesCD.self
    let imgLiterals = Constants.ImageLiterals.self
    let utils = Utils.shared
    
    //MARK: - Properties
    var menuDishes = [Dish]()
    var dishes = [Dish]()
    var carts = [Cart]()
    var restaurant = [Restaurant]()
    
    
    //MARK: - Adding Default Dishes to CoreData
    
    
    /// Fetch dishes and checks if they are empty add all Basic dishes otherwise return as there is no need to add Dishes again (creates duplicacy)
    func addAllDishesToCoreData(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Dish)
        do{
            let filterPredicate = NSPredicate(format: "dishType == %@",dishType.basic)
            fetchRequest.predicate = filterPredicate
            do{
                if let results = try managedObjectContext.fetch(fetchRequest) as? [Dish]{
                    if results.isEmpty{
                        addDishes()
                    } else{ return }
                }
            } catch{
                print("There was a fetch error!")
            }
        }
    }
    
    
    /// Creates Dish Entity and Add Dishes to it
    func addDishes(){
        guard let entity = NSEntityDescription.entity(forEntityName: entity.Dish, in:  managedObjectContext) else{
            fatalError("Could not find entity description!")
        }
        let dish = createDishObjects(entity)
        addDishesToMenu(dish)
        save()
        //       let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        //       print(paths[0])
    }
    
    
    /// Creates Six Dishes object
    func createDishObjects(_ entity: NSEntityDescription)->[Dish]{
        var dish = [Dish]()
        for _ in 0...5 {
            let dishObj = Dish(entity: entity, insertInto: managedObjectContext)
            dish.append(dishObj)
        }
        return dish
    }
    
    
    /// Dishes are added to fill the Dish entity with various attributes in the CoreData
    func addDishesToMenu(_ dish: [Dish]){
        
        dish[0].id = 1
        dish[0].name = "Paneer Butter Masala"
        dish[0].price = 260
        dish[0].cuisine = "North Indian"
        dish[0].dishImg = imgLiterals.menuDishesImg[0].pngData() as Data?
        dish[0].dishType = dishType.basic
        
        dish[1].id = 2
        dish[1].name = "Dal Makhni"
        dish[1].price = 220
        dish[1].cuisine = "North Indian"
        dish[1].dishImg = imgLiterals.menuDishesImg[1].pngData() as Data?
        dish[1].dishType = dishType.basic
        
        dish[2].id = 3
        dish[2].name = "Veg Hakka Noodles"
        dish[2].price = 200
        dish[2].cuisine = "Chinese"
        dish[2].dishImg = imgLiterals.menuDishesImg[2].pngData() as Data?
        dish[2].dishType = dishType.basic
        
        dish[3].id = 4
        dish[3].name = "Spring Roll"
        dish[3].price = 200
        dish[3].cuisine = "Chinese"
        dish[3].dishImg = imgLiterals.menuDishesImg[3].pngData() as Data?
        dish[3].dishType = dishType.basic
        
        dish[4].id = 5
        dish[4].name = "Veggie Lover Pizza"
        dish[4].price = 299
        dish[4].cuisine = "Italian"
        dish[4].dishImg = imgLiterals.menuDishesImg[4].pngData() as Data?
        dish[4].dishType = dishType.basic
        
        dish[5].id = 6
        dish[5].name = "Garlic Bread"
        dish[5].price = 99
        dish[5].cuisine = "Italian"
        dish[5].dishImg = imgLiterals.menuDishesImg[5].pngData() as Data?
        dish[5].dishType = dishType.basic
    }
    
    
    //MARK: - Fetching Dishes/Cart from CoreData

    /// Filter only the dishes which contains the cuisine which are same to that of the cuisine of selected restaurant
    ///
    /// - Parameter cuisineType: takes the Cuisine of the selected restaurant
    /// - Returns: Dishes as [Dish]
    func fetchMenuWithCorrespondingCuisine(cuisine cuisineType : String?)->[Dish]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Dish)
        do{
            if (cuisineType != nil){
                /// filter the dishes that match with that of the selected cuisineType
                let filterPredicate = NSPredicate(format: "cuisine == %@ AND dishType == %@", cuisineType!, dishType.basic)
                fetchRequest.predicate = filterPredicate
            }else {
                /// filter all the saved Dishes
                let filterPredicate = NSPredicate(format: "dishType == %@", dishType.basic)
                fetchRequest.predicate = filterPredicate
            }
            /// return empty dishes if cuisine does not have corresponding cuisine results
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Dish]{
                if results.isEmpty{
                    menuDishes = [Dish]()
                } else{
                    menuDishes = results
                }
            }
        } catch{
            print("There was a fetch error!")
        }
        return menuDishes
    }
    

    /// Useful to get the Dishes which are present in the Current Cart
    /// (holds Cart Persistency)
    /// - Returns: [Dish] and provides persistent for current dishes saved in Cart
    
    func fetchCartDishesWithSomeQuantity()->[Dish]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Dish)
        do{
            /// filter dishes with non-zero quantity and dishType set as "default"
            let filterPredicate = NSPredicate(format: "quantity != %@ AND dishType == %@","",dishType.basic)
            fetchRequest.predicate = filterPredicate
            
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Dish]{
                dishes = results
            }
        } catch{
            print("There was a fetch error!")
        }
        return dishes
    }
    
    
    /// Used to fetch carts which are created when user places the Order on Clicking the Place Order Button (useful to show My Orders)
    ///
    /// - Returns: All the Carts as [Cart] i.e. Cart Array
    
    func fetchCarts()->[Cart]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Cart)
        do{

            if let results = try managedObjectContext.fetch(fetchRequest) as? [Cart]{
                carts = results
            }
        } catch{
            print("There was a fetch error!")
        }
        return carts
    }
    
    
    /// Default Dishes which are fetched to make their default quantities to Zero for futher fetching in the app
    /// (only called when final order is made for Order History)
    /// - Returns: Default Menu Dishes as [Dish]
    
    func fetchDefaultDishes()->[Dish]{
        var defaultDishes = [Dish]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Dish)
        do{
            /// filter dishes with dishType set as "default"
            let filterPredicate = NSPredicate(format: "dishType == %@", dishType.basic)
            fetchRequest.predicate = filterPredicate
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Dish]{
                defaultDishes = results
            }
        } catch{
            print("There was a fetch error!")
        }
        return defaultDishes
    }



    //MARK: - Saving to CoreData
    
    /// Save to CoreData storage
    func save(){
        do {
            try managedObjectContext.save()
        } catch let error as NSError{
            print("Error saving the Managed Object Context \(error)")
        }
    }
    
    /// Only called by Place Order Button
    func saveToAllEntities(_ dishes: [Dish], _ totalPrice: Int16){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.Cart)
        do{
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Cart]{
                carts = results
            }
        } catch{
            print("There was a fetch error!")
        }
        
        let dishesInCart = dishes.count
        let cartsCount = carts.count
        
        updateCartEntity(cartsCount,totalPrice)
        updateDishEntity(dishesInCart,cartsCount)
        updateRestaurantEntity(cartsCount)
        
        setDishQtyToZero()
        save()
    }
    
    
    //MARK: - CoreData Enitity Updation Methods
    
    /// Create Dish Object and populate its attributes with Dishes selected in Cart
    func updateCartEntity(_ cartsCount: Int, _ totalPrice: Int16){
        guard let cartEntity = NSEntityDescription.entity(forEntityName: entity.Cart, in:  managedObjectContext)
            else{
                fatalError("Could not find entity description!")
        }
        
        let cartObj = Cart(entity: cartEntity, insertInto: managedObjectContext)
        carts.append(cartObj)
        carts[cartsCount].id = Int16(cartsCount + 1)
        carts[cartsCount].totalPrice = totalPrice
    }
    
    /// Create Dish Object and populate its attributes with Dishes selected in Cart
    func updateDishEntity(_ dishesInCart: Int,_ cartsCount: Int){
        guard let dishEntity = NSEntityDescription.entity(forEntityName: entity.Dish, in:  managedObjectContext) else{
            fatalError("Could not find entity description!")
        }
        let dishCount = menuDishes.count
        for i in 0 ..< dishesInCart{
            
            let dishObj = Dish(entity: dishEntity, insertInto: managedObjectContext)
            menuDishes.append(dishObj)
            
            menuDishes[dishCount+i].name = dishes[i].name
            menuDishes[dishCount+i].cuisine = dishes[i].cuisine
            menuDishes[dishCount+i].price = dishes[i].price
            menuDishes[dishCount+i].id = Int16(dishCount + i)
            menuDishes[dishCount+i].dishType = dishType.added
            menuDishes[dishCount+i].quantity = dishes[i].quantity
            menuDishes[dishCount+i].cartsIn = carts[cartsCount]
            
        }
    }
    /// Create Restaurant Object and populate its attributes with Dishes selected in Cart
    func updateRestaurantEntity(_ cartsCount: Int){
        guard let restaurantEntity = NSEntityDescription.entity(forEntityName: "Restaurant", in:  managedObjectContext)
            else{
                fatalError("Could not find entity description!")
        }
        let resCount = restaurant.count
        let restaurantObj = Restaurant(entity: restaurantEntity, insertInto: managedObjectContext)
        restaurant.append(restaurantObj)
        restaurant[resCount].name = utils.resName
        restaurant[resCount].address = utils.resAddress
        restaurant[resCount].image = utils.resImage?.pngData() as Data?
        restaurant[resCount].owner = carts[cartsCount]
        
    }
    //MARK: - Supplementary Methods
    func calcCartTotal()->String{
        var cartTotal = 0
        dishes = fetchCartDishesWithSomeQuantity()
        for i in 0 ..< dishes.count{
            cartTotal = cartTotal + Int(dishes[i].quantity)*Int(dishes[i].price)
        }
        return String(cartTotal)
    }
    func setDishQtyToZero(){
        let qtyDishes = fetchDefaultDishes()
        for i in 0..<qtyDishes.count{
            qtyDishes[i].quantity = 0
        }
    }
}
